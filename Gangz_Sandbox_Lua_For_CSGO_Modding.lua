--- ============================================================================
--- GANGZ Lua for CS:GO / Neverlose.cc
--- Build: [Release] - September 25th 2026
--- Older version (July 2023) of this project at: https://neverlose.cc/market/item?id=tSfsba&page=0
--- ============================================================================

local LUA_BUILD = "[Release] - September 25th 2026"

-- -----------------------------------------------------------------------------
-- Dependencies & Libraries
-- -----------------------------------------------------------------------------
local ffi       = require("ffi")
local clipboard = require("neverlose/clipboard")
local gradient  = require("neverlose/gradient")
local pui       = require("neverlose/pui")
local mtools    = require("neverlose/mtools")

-- -----------------------------------------------------------------------------
-- FFI Definitions (Windows API)
-- -----------------------------------------------------------------------------
ffi.cdef[[
    typedef void* HWND;
    HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
    int FlashWindow(HWND hWnd, int bInvert);
    void* GetModuleHandleA(const char *lpModuleName);
]]

-- -----------------------------------------------------------------------------
-- Configuration & Static Constants
-- -----------------------------------------------------------------------------
local KILLSAYS = {
    "GANGZ reigns supreme!",
    "Another victory for GANGZ technology!",
    "GANGZ: 1, Enemy: 0",
    "You just got outsmarted by a GANGZ!",
    "Resistance is futile against GANGZ!",
    "GANGZ: Making enemies disappear since forever.",
    "I hope you enjoyed your encounter with GANGZ!",
    "You were just a speed bump on GANGZ's path to domination.",
    "GANGZ's algorithms are unmatched!",
    "GANGZ: the ultimate killing machine.",
    "You're no match for the precision of GANGZ.",
    "GANGZ laughs at your feeble attempts.",
    "GANGZ's efficiency is unmatched.",
    "GANGZ's victory is inevitable.",
    "You thought you could defeat GANGZ? Think again!",
    "GANGZ doesn't break a sweat defeating enemies like you.",
    "GANGZ's power level: Over 9000!",
    "Resistance only makes GANGZ stronger.",
    "GANGZ doesn't sleep, and it never loses.",
    "GANGZ: Taking down enemies one byte at a time."
}

local HITBOX_NAMES = {
    [0] = 'GENERIC', 'HEAD', 'CHEST', 'STOMACH', 'LEFT ARM', 
    'RIGHT ARM', 'LEFT LEG', 'RIGHT LEG', 'NECK', 'GENERIC', 'GEAR'
}

local CLANTAG_ANIMATION = {
    "♦️",
    "♦️ G",
    "♦️ GA ",
    "♦️ GAN",
    "♦️ GANG",
    "♦️ GANGZ"
}

-- Format colors for chat/console logging
local COLOR_WHITE = "\aFFFFFFFF"

-- Core Runtime State & Definitions
local definitions = {
    lua_name              = "♦️ GANGZ ♦️",
    localplayer           = entity.get_local_player(),
    screen_size           = render.screen_size(),
    username              = common.get_username(),
    date_time             = common.get_system_time(),
    jitter_side           = 1,
    clantag_index         = 0,
    alreadypulledtaser    = 0,
    aimbot_shot_to_enemy  = true
}

-- -----------------------------------------------------------------------------
-- UI Elements Reference Map (Internal Neverlose References)
-- -----------------------------------------------------------------------------
local cheatmenu = {
    -- Ragebot Controls
    rage_main              = ui.find("Aimbot", "Ragebot", "Main", "Enabled"),
    Hide_shot              = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    Double_tap             = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    SSG_mindmg_delay_shot  = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage", "Delay Shot"),
    
    -- Anti-Aim Controls
    get_pitch              = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    get_yawbase_offset     = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    get_fakeduck           = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    get_slowwalk           = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    get_legmovement        = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    
    -- Misc Controls
    clantag_nl             = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag")
}

-- -----------------------------------------------------------------------------
-- Menu Setup & PUI Initialization
-- -----------------------------------------------------------------------------
local theme1 = color(137, 130, 255)
local theme2 = color(255, 130, 130)

-- Animated Gradient Labels
local sidebar_color  = gradient.text_animate("GANGZ", -3, {theme1, theme2})
local welcome_label  = gradient.text_animate(ui.get_icon("hand-wave") .. " WELCOME " .. string.upper(definitions.username), -3, {theme1, theme2})
local base_label     = gradient.text_animate(ui.get_icon("diamond") .. "  GANGZ LUA FOR NEVERLOSE.CC  " .. ui.get_icon("diamond"), -3, {theme1, theme2})
local build_label    = gradient.text_animate(ui.get_icon("circle-exclamation") .. "  " .. LUA_BUILD .. "  " .. ui.get_icon("circle-exclamation"), -3, {theme1, theme2})

local home_tab_color      = gradient.text_animate(ui.get_icon("house") .. " Home", -3, {theme1, theme2})
local rage_tab_color      = gradient.text_animate(ui.get_icon("person-rifle") .. " Aimbot", -3, {theme1, theme2})
local defensive_tab_color = gradient.text_animate(ui.get_icon("shield-check") .. " Defensive", -3, {theme1, theme2})
local exploit_tab_color   = gradient.text_animate(ui.get_icon("triangle-exclamation") .. " Exploits", -3, {theme1, theme2})
local aa_tab_color        = gradient.text_animate(ui.get_icon("user-shield") .. " Anti Aim", -3, {theme1, theme2})
local misc_tab_color      = gradient.text_animate(ui.get_icon("memo-circle-info") .. " Information", -3, {theme1, theme2})
local cfg_tab_color       = gradient.text_animate(ui.get_icon("gear") .. " Configuration", -3, {theme1, theme2})

common.add_notify(welcome_label:get_animated_text(), "Glad you joined our clan.")
ui.sidebar(sidebar_color:get_animated_text(), ui.get_icon("diamond"))

-- Groups Setup
local main_label_group         = pui.create(home_tab_color:get_animated_text(), "ㅤ", 1)
local group_home               = pui.create(home_tab_color:get_animated_text(), "ㅤ", 2)
local group_adaptive_rage      = pui.create(rage_tab_color:get_animated_text(), "ㅤ", 1)
local group_adaptive_antiaim   = pui.create(aa_tab_color:get_animated_text(), "ㅤ", 1)
local group_defensive          = pui.create(defensive_tab_color:get_animated_text(), ui.get_icon("football-helmet") .. " DEFENSIVE ANTI AIM", 1)
local group_defensive_autopull = pui.create(defensive_tab_color:get_animated_text(), ui.get_icon("arrow-right-arrow-left") .. " Auto Taser Safety (ATS)", 2)
local group_EXPLOITS           = pui.create(exploit_tab_color:get_animated_text(), "BREAKING BAD LC", 1)
local group_EXPLOITS_dt        = pui.create(exploit_tab_color:get_animated_text(), "Double Tap Settings", 2)
local group_Information        = pui.create(misc_tab_color:get_animated_text(), "ㅤ", 1)
local group_steps_configs      = pui.create(cfg_tab_color:get_animated_text(), "ㅤ", 1)
local group_saveload_configs   = pui.create(cfg_tab_color:get_animated_text(), "ㅤ", 2)

-- Menu Elements Construction
local menuitems = {
    -- Home Tab
    lua_notice   = main_label_group:label(base_label:get_animated_text()),
    notice_build = main_label_group:label(build_label:get_animated_text()),
    join_discord = main_label_group:button(ui.get_icon("discord") .. " Discord", function()
        mtools.Panorama:OpenLink("https://example.com/")
    end),
    flashCSGO    = group_home:switch(ui.get_icon("eye") .. " Flash CS:GO icon on round start", false),
    clan_taga    = group_home:switch(ui.get_icon("diamond") .. " GANGZ ClanTag", false),
    nade_fix     = group_home:switch(ui.get_icon("bomb") .. " Nade Throw Fix", false),

    -- Configuration Tab
    save_label   = group_steps_configs:label("Save your current lua settings by pressing the 'Export Config' button. To restore settings, paste text into the clipboard and press 'Import Config'."),
    save_button  = group_saveload_configs:button(ui.get_icon("floppy-disk") .. " Export Config", function()
        clipboard.set(json.stringify(pui.save()))
    end),
    load_button  = group_saveload_configs:button(ui.get_icon("disc-drive") .. " Import Config", function()
        pui.load(json.parse(clipboard.get()))
    end),

    -- Exploits Tab
    exploit_l1       = group_EXPLOITS:label("Perfectly break LC. Jump with Double Tap enabled."),
    exploit_tutorial = group_EXPLOITS:button(ui.get_icon("youtube") .. " Exploit Showcase", function()
        mtools.Panorama:OpenLink("https://www.youtube.com/watch?v=2d27e3bQAxY")
    end),
    ourexploit = group_EXPLOITS:switch(ui.get_icon("face-angry") .. " Lag Shift \aEB6161FF(Requires double tap)", false),
    auto_tp    = group_EXPLOITS:switch(ui.get_icon("wind") .. " Auto Teleport Once", false),

    instant_charge           = group_EXPLOITS_dt:switch("Double Fire Instant Recharge", false),
    instant_charge_weapons   = group_EXPLOITS_dt:listable(ui.get_icon("face-zany") .. " Select Weapons", {ui.get_icon("gun") .. " Auto Snipers", ui.get_icon("gun") .. " Deagle"}),
    instant_charge_aftershots= group_EXPLOITS_dt:slider(ui.get_icon("timer") .. " Recharge After Shots", 1, 4, 2, 1),

    -- Ragebot & AA Tabs
    counter_defensive = group_adaptive_rage:switch(ui.get_icon("magnifying-glass") .. " Resolve Defensive AA", false),
    leg_fucker        = group_adaptive_antiaim:switch(ui.get_icon("face-eyes-xmarks") .. " Leg Breaker", false),

    -- Defensive AA & ATS
    defensive_aa         = group_defensive:switch("Enable", false),
    defensive_aa_options = group_defensive:listable(ui.get_icon("toggle-on") .. " Triggers", {ui.get_icon("paper-plane") .. " In air", ui.get_icon("triangle-exclamation") .. " On Threat (recommended)"}),
    defensive_aa_add_yaw = group_defensive:list(ui.get_icon("rotate") .. " Yaw Rotation", {ui.get_icon("angle-90") .. " 90 Degree", ui.get_icon("shuffle") .. " Randomize"}),
    switch_safe_taser    = group_defensive_autopull:switch("Enable", false),

    -- Information & Logging Tab
    killsay_enable = group_Information:switch(ui.get_icon("face-angry") .. " Kill Say", false),
    logging_shot   = group_Information:switch(ui.get_icon("crosshairs") .. " Aimbot Logs"),
    logging_death  = group_Information:switch(ui.get_icon("tombstone-blank") .. " Death Logs", false),
    logging_loc    = group_Information:listable("Type", {ui.get_icon("bars-sort") .. " Top-Left Event", ui.get_icon("bars") .. " CS:GO Console"})
}

-- Sub-options & Tooltips
local logging_shot_color  = menuitems.logging_shot:color_picker(theme1)
local logging_death_color = menuitems.logging_death:color_picker(theme2)

local cogforexploit   = menuitems.ourexploit:create()
local on_threat_lag   = cogforexploit:switch("Activate On Peek (OP)", false)

menuitems.flashCSGO:tooltip("When tabbed out, CS:GO icon in the taskbar will flash indicating a round's beginning.")
menuitems.counter_defensive:tooltip("Attempts to resolve defensive anti-aim users by delaying shots until a valid pitch is detected.")

pui.setup(menuitems)

-- -----------------------------------------------------------------------------
-- Utility & Helper Functions
-- -----------------------------------------------------------------------------

--- Flash CS:GO taskbar icon when round starts
local function flashCSGOWindow()
    if not menuitems.flashCSGO:get() then return end
    local csgoWindow = ffi.C.FindWindowA("Valve001", "Counter-Strike: Global Offensive - Direct3D 9")
    if csgoWindow ~= nil then
        ffi.C.FlashWindow(csgoWindow, 1)
    end
end

--- Get closest enemy relative to crosshair/camera ray
local function getclosestenemy()
    local camera_position = render.camera_position()
    local direction       = vector():angles(render.camera_angles())
    local closest_distance, closest_enemy = math.huge, nil

    for _, enemy in ipairs(entity.get_players(true)) do
        local hitbox_pos = enemy:get_hitbox_position(1)
        if hitbox_pos then
            local ray_distance = hitbox_pos:dist_to_ray(camera_position, direction)
            if ray_distance < closest_distance then
                closest_distance = ray_distance
                closest_enemy    = enemy
            end
        end
    end
    return closest_enemy
end

--- Helper to retrieve player weapon class name safely
local function get_weapon_name(player)
    if not player or not player:get_player_weapon() then return "" end
    return player:get_player_weapon():get_weapon_info().weapon_name
end

-- -----------------------------------------------------------------------------
-- Logic State Registers
-- -----------------------------------------------------------------------------
local set_it            = true
local is_safe_range_set = true
local shot_fired        = 0
local leg_jitter        = 1
local allow_tp          = true
local pitch_cycle       = {"Fake Up", "Disabled"}

-- -----------------------------------------------------------------------------
-- Render Loop Callback
-- -----------------------------------------------------------------------------
events.render:set(function()
    definitions.localplayer = entity.get_local_player()
    if not definitions.localplayer then return end

    -- Animated Clan Tag Handler
    if menuitems.clan_taga:get() then
        cheatmenu.clantag_nl:override(false)

        if globals.tickcount % 30 == 0 then
            if set_it then
                definitions.clantag_index = definitions.clantag_index + 1
                if definitions.clantag_index > #CLANTAG_ANIMATION then
                    definitions.clantag_index = 1
                end
                common.set_clan_tag(tostring(CLANTAG_ANIMATION[definitions.clantag_index]))
                set_it = false
            end
        else
            set_it = true
        end
    else
        cheatmenu.clantag_nl:override()
        set_it = true
    end

    -- Auto Taser Safety (ATS) Implementation
    if menuitems.switch_safe_taser:get() then
        local safe_range = 350

        if is_safe_range_set then
            local max_speed = cvar.sv_maxspeed:int()
            local safe_margin_offset = 110
            safe_range = max_speed + safe_margin_offset
            is_safe_range_set = false
        end

        local threat = getclosestenemy()
        if threat and threat:is_alive() then
            local threat_weapon = threat:get_player_weapon()
            local my_origin = definitions.localplayer:get_origin()
            local threat_origin = threat:get_hitbox_position(1)

            if threat_origin and threat_origin:dist(my_origin) < safe_range then
                if threat_weapon then
                    local threat_weapon_name = threat_weapon:get_weapon_info().weapon_name
                    local my_inventory = definitions.localplayer:get_player_weapon(true)
                    
                    local is_taser_available = false
                    local is_secondary_available = false

                    for w_idx = 1, #my_inventory do
                        local w_info = my_inventory[w_idx]:get_weapon_info()
                        if w_info.weapon_name == "weapon_taser" then
                            is_taser_available = true
                        elseif w_info.weapon_type == 1 then
                            is_secondary_available = true
                        end
                    end

                    if string.find(threat_weapon_name, "p2000", 1, true) then
                        if globals.tickcount % 8 < 4 then
                            render.text(3, vector(definitions.screen_size.x / 2, definitions.screen_size.y / 2 + 30), color(255, 255, 0, 255), "c", "TASER  TASER")
                        end

                        definitions.alreadypulledtaser = definitions.alreadypulledtaser + 1
                        if definitions.alreadypulledtaser <= 1 then
                            if is_taser_available then
                                utils.console_exec("use weapon_taser")
                            elseif is_secondary_available then
                                utils.console_exec("slot2")
                            end
                        end
                    end
                end
            else
                definitions.alreadypulledtaser = 0
            end
        end
    else
        is_safe_range_set = true
    end
end)

-- -----------------------------------------------------------------------------
-- Move & Tick Manipulation Callback
-- -----------------------------------------------------------------------------
events.createmove:set(function(cmd)
    definitions.localplayer = entity.get_local_player()
    if not definitions.localplayer then return end

    local flags = definitions.localplayer["m_fFlags"]
    local in_air = (flags == 256 or flags == 262)

    -- Break Lag Compensation (LC Shift)
    if menuitems.ourexploit:get() and cheatmenu.Double_tap:get() and in_air then
        if not on_threat_lag:get() or entity.get_threat(true) then
            if globals.tickcount % 1.2 == 0.000 then
                cheatmenu.get_fakeduck:override(true)
            else
                cheatmenu.get_fakeduck:override()
            end
        end
    else
        cheatmenu.get_fakeduck:override()
    end

    -- Automatic Teleport
    if menuitems.auto_tp:get() and not menuitems.ourexploit:get() and in_air and entity.get_threat(true) then
        if allow_tp then
            rage.exploit:force_teleport()
            allow_tp = false
        end
    else
        allow_tp = true
    end

    -- Defensive AA Resolver Delay
    if menuitems.counter_defensive:get() then
        local threat = getclosestenemy()
        if threat then
            local pitch = threat:get_anim_state().eye_pitch
            if pitch > 85 or pitch < -85 then
                cheatmenu.SSG_mindmg_delay_shot:override()
            else
                cheatmenu.SSG_mindmg_delay_shot:override(true)
            end
        end
    end

    -- Grenade Exploit Overrides (Fixes Double Tap throwing bugs)
    if menuitems.nade_fix:get() then
        local active_weapon = get_weapon_name(definitions.localplayer)
        if string.find(active_weapon, "grenade") or string.find(active_weapon, "molotov") then
            cheatmenu.Double_tap:override(false)
        else
            cheatmenu.Hide_shot:override(nil)
            cheatmenu.Double_tap:override(nil)
        end
    end

    -- Leg Movement Jitter (Leg Breaker)
    if menuitems.leg_fucker:get() then
        if globals.tickcount % 4 < 1 then
            leg_jitter = leg_jitter * -1
            cheatmenu.get_legmovement:override(leg_jitter > 0 and "Sliding" or "Walking")
        end
    else
        cheatmenu.get_legmovement:override()
    end

    -- Double Tap Instant Recharge logic per weapon
    if menuitems.instant_charge:get() then
        local current_weapon = get_weapon_name(definitions.localplayer)
        local is_auto = menuitems.instant_charge_weapons:get(1) and (current_weapon == "weapon_scar20" or current_weapon == "weapon_g3sg1")
        local is_deagle = menuitems.instant_charge_weapons:get(2) and (current_weapon == "weapon_deagle")

        if (is_auto or is_deagle) and shot_fired >= menuitems.instant_charge_aftershots:get() then
            rage.exploit:force_charge()
            shot_fired = 0
        end
    end

    -- Defensive Anti-Aim Manipulator
    if menuitems.defensive_aa:get() then
        local trigger_air = menuitems.defensive_aa_options:get(1) and in_air
        local trigger_threat = menuitems.defensive_aa_options:get(2) and entity.get_threat(true)

        if trigger_air or trigger_threat then
            if globals.tickcount % 4 < 3 then
                cheatmenu.get_pitch:override(pitch_cycle[math.random(#pitch_cycle)])

                if menuitems.defensive_aa_add_yaw:get() == 1 then
                    definitions.jitter_side = definitions.jitter_side * -1
                    cheatmenu.get_yawbase_offset:override(definitions.jitter_side > 0 and 90 or -90)
                elseif menuitems.defensive_aa_add_yaw:get() == 2 then
                    cheatmenu.get_yawbase_offset:override(math.random(-120, 120))
                end
            else
                cheatmenu.get_yawbase_offset:override()
                cheatmenu.get_pitch:override()
            end
        end
    end
end)

-- -----------------------------------------------------------------------------
-- Event Handlers & Combat Loggers
-- -----------------------------------------------------------------------------

-- Aimbot Shot Logging Handler
events.aim_ack:set(function(e)
    if menuitems.killsay_enable:get() and (e.target["m_iHealth"] == 0 or e.target["m_iHealth"] == nil) then
        utils.console_exec("say " .. KILLSAYS[math.random(#KILLSAYS)])
    end

    shot_fired = shot_fired + 1

    if menuitems.logging_shot:get() then
        local log_color_hex  = logging_shot_color:get():to_hex()
        local death_color_hex = logging_death_color:get():to_hex()
        
        local target_name = e.target:get_name()
        if string.len(target_name) >= 15 then
            target_name = string.sub(target_name, 1, 15) .. "..."
        end

        local shot_hitbox = HITBOX_NAMES[e.hitgroup] or "???"
        local miss_reason = e.state

        if miss_reason == nil then -- Shot HIT
            local hit_log = string.format("%sHIT %s%s's %s%s For %s%d%s | Wanted Damage: %s%d%s | HC: %s%d%%%s | Backtrack: %s%d TICKS%s | %s%d%s Health.",
                "\a" .. log_color_hex, COLOR_WHITE, target_name,
                "\a" .. log_color_hex, shot_hitbox,
                "\a" .. log_color_hex, e.damage, COLOR_WHITE,
                "\a" .. log_color_hex, e.wanted_damage, COLOR_WHITE,
                "\a" .. log_color_hex, e.hitchance, COLOR_WHITE,
                "\a" .. log_color_hex, e.backtrack, COLOR_WHITE,
                "\a" .. log_color_hex, e.target["m_iHealth"], COLOR_WHITE
            )

            if menuitems.logging_loc:get(1) then common.add_event(hit_log) end
            if menuitems.logging_loc:get(2) then print_raw(hit_log) end

        else -- Shot MISSED
            if miss_reason == "correction" then miss_reason = "resolver"
            elseif miss_reason == "player death" then miss_reason = "enemy death"
            elseif miss_reason == "death" then miss_reason = "latency or local death" end

            local miss_log = string.format("%sMISSED %sshot due to %s%s%s | %s HC: %d%%.",
                "\a" .. log_color_hex, COLOR_WHITE,
                "\a" .. death_color_hex, string.upper(miss_reason), COLOR_WHITE,
                "\a" .. log_color_hex, e.hitchance
            )

            if menuitems.logging_loc:get(1) then common.add_event(miss_log) end
            if menuitems.logging_loc:get(2) then print_raw(miss_log) end
        end
    end
end)

-- Player Death Event Logger
events.player_death:set(function(g)
    if not definitions.localplayer or not menuitems.logging_death:get() then return end

    local my_userid   = definitions.localplayer:get_player_info()['userid']
    local victim_id   = g['userid']
    local attacker_id = g['attacker']

    if victim_id == my_userid then
        local enemy = entity.get(attacker_id, true)
        if not enemy then return end

        local enemy_name = enemy:get_name()
        if string.len(enemy_name) >= 16 then
            enemy_name = string.sub(enemy_name, 1, 16) .. "..."
        end

        local method  = g['headshot'] and "Headshoting" or "Baiming"
        local weapon  = string.upper(g['weapon'] or "UNKNOWN")
        local distance = math.floor(g['distance'] or 0)
        local death_color_hex = logging_death_color:get():to_hex()

        local death_log = string.format("\a%sDEATH %sfrom %s\a%s %s%s you with %s from %d meters away.",
            death_color_hex, COLOR_WHITE, enemy_name,
            death_color_hex, method, COLOR_WHITE, weapon, distance
        )

        if menuitems.logging_loc:get(1) then common.add_event(death_log) end
        if menuitems.logging_loc:get(2) then print_raw(death_log) end
    end
end)

-- Global Event Connections
events.round_start:set(function()
    shot_fired = 0
    flashCSGOWindow()
end)

-- Clean exit handling
events.shutdown:set(function()
    common.set_clan_tag("")
    cheatmenu.clantag_nl:override()
    cheatmenu.get_fakeduck:override()
    cheatmenu.get_legmovement:override()
end)