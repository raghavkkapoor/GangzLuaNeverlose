
local Lua_build = "[Beta] - 9//24//23"

local killsays = {
  " GANGZ reigns supreme!",
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
  "GANGZ: Taking down enemies one byte at a time.",
}



-- clear console and print script welcome message :)

-- loading some great libraries from marketplace. Credit(MonixLITE)

local clipboard = require ("neverlose/clipboard")
local gradient = require("neverlose/gradient")
local pui = require("neverlose/pui") 
--local base64 = require("neverlose/base64") 

--mtools.FileSystem.CreateDir("nl\\scripts\\GANGZ\\fonts")
--mtools.Network.Download("https://fonts.cdnfonts.com/s/98875/JetBrainsMonoRegular.woff", "nl\\scripts\\GANGZ\\fonts\\thisfont.otf", true, 97)]]
--mtools.Network.Download("https://drive.google.com/file/d/1pNXRUekjhmdvRLN6quYq4b9jVzNZsz5u/view?usp=sharing", "nl\\scripts\\GANGZ\\sounds\\awp.WAV", true, 97)


-- definitions
local ffi = require("ffi")
ffi.cdef[[
    typedef void* HWND;
    HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
    int FlashWindow(HWND hWnd, int bInvert);
    void *GetModuleHandleA(const char *lpModuleName);
]]



-- rage - dormancy
local CHEAT_CONFIDENCE = "Dormant - Cheat 100% confidence"
local SOUNDS = "Dormant - Sounds"
local DATA_EXPIRED = "Dormant - Data expired"

-- aa - states
local STAND = ui.get_icon("person") .. " Standing"
local WALK = ui.get_icon("person-walking") .. " Walk"
local RUN = ui.get_icon("person-running") .. " Run"
local CROUCH = ui.get_icon("person-seat") .. " Crouch"
local AIR_CROUCH = ui.get_icon("paper-plane") .. " " .. ui.get_icon("person-seat") .. " Air Crouch"
local AIR = ui.get_icon("paper-plane") .. " Air"


local definitions = {
    lua_name = "♦️ GANGZ ♦️",

    -- client
    localplayer = entity.get_local_player(),
    screen_size = render.screen_size(),-- always use this
    username = common.get_username(),
    date_time = common.get_system_time(),
    -- colors for all loging
    light_red = "\aFF7A7AFF",
    light_green = "\a7AFF7AFF",
    light_blue = "\a7A7AFFFF",
    white = "\aFFFFFFFF",

    netchannel = utils.net_channel(),

    -- hitboxes
    hitboxes = {[0] = 'GENERIC','HEAD', 'CHEST', 'STOMACH','LEFT ARM', 'RIGHT ARM','LEFT LEG', 'RIGHT LEG','NECK', 'GENERIC', 'GEAR'},
    jitter_side = 1,
    target,
    i_shot,
    aimbot_shot_to_enemy = true,
    alreadypulledtaser = 0,
    clantag = {
        "♦️",
        "♦️ G",
        "♦️ GA ",
        "♦️ GAN",
        "♦️ GANG",
        "♦️ GANGZ",
    },
    clantag_index = 0,


    player_dormancies = {
    CHEAT_CONFIDENCE,
    SOUNDS,
    DATA_EXPIRED
    },


    player_states = {
    STAND,
    WALK,
    RUN,
    CROUCH,
    AIR_CROUCH,
    AIR
    },


    enemy_states = {
    STAND,
    WALK,
    RUN,
    CROUCH,
    AIR_CROUCH,
    AIR
    }



}

local definitions_indicators = {
    crosshair_pos = vector(definitions.screen_size.x / 2, definitions.screen_size.y / 2)
}


if definitions.localplayer then
    local getoldname = definitions.localplayer:get_name()
end

local cheatmenu = {
    
    -- Ragebot
    rage_main = ui.find("Aimbot", "Ragebot", "Main", "Enabled"),
    Hide_shot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    Double_tap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    Double_tap_lag_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    Double_tap_FLlimit = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
    SSG_hitboxes = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hitboxes"),
    SSG_multipoint = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Multipoint"),
    SSG_multipoint_head = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Multipoint", "Head Scale"),
    SSG_multipoint_body = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Multipoint", "Body Scale"),
    SSG_hitchance = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    SSG_mindmg = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage"),
    SSG_mindmg_delay_shot = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage", "Delay Shot"),
    SSG_baim_mode = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim"),
    SSG_baim_mode_disablers = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim", "Disablers"),
    SSG_baim_mode_force_on_peek = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Body Aim", "Force on Peek"),
    SSG_safepoints = ui.find("Aimbot", "Ragebot", "Safety", "SSG-08", "Safe Points"),
    get_autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    get_autopeek_style = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style"),
    get_autopeek_mode = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode"),
    mindmg = ui.find("Aimbot", "Ragebot", "Selection", "Global", "Min. Damage"),


    -- Anti Aim
    get_antiaim = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    get_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),

    get_yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),

    get_yawbase_angle = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),

    get_yawbase_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    get_avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    get_hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    get_yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    get_yaw_mod_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    get_fakeangles_enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    leftlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    rightlimit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    get_fakeangles_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    get_freestanding_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    get_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    get_freestanding_disable_yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    get_freestanding_body_freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    get_extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    get_extended_angles_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    get_extended_angles_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
    get_fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    get_fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    get_fakelag_variability = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
    get_fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    get_slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    get_legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    -- Misc
    bhop = ui.find("Miscellaneous", "Main", "Movement", "Bunny Hop"),
    air_strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    air_duck = ui.find("Miscellaneous", "Main", "Movement", "Air Duck"),
    air_duck_mode = ui.find("Miscellaneous", "Main", "Movement", "Air Duck", "Mode"),
    windows = ui.find("Miscellaneous", "Main", "Other", "Windows"),
    fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),


    clantag_nl = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"),


}

-- MENU   

local theme1 = color(137, 130, 255)
local theme2 = color(255, 130, 130)



local icon_color = gradient.text_animate(ui.get_icon("diamond"), -3, {
    theme1,
    theme2
})


local sidebar_color = gradient.text_animate("GANGZ", -3, {
    theme1,
    theme2
})

local welcome_label = gradient.text_animate(ui.get_icon("hand-wave") .. " WELCOME " .. string.upper(definitions.username), -3, {
    theme1,
    theme2
})

local base_label = gradient.text_animate(ui.get_icon("diamond") .. "  GANGZ LUA FOR NEVERLOSE.CC  " .. ui.get_icon("diamond"), -3, {
    theme1,
    theme2
})

local build_label = gradient.text_animate(ui.get_icon("circle-exclamation") .. "  " .. Lua_build .. "  " .. ui.get_icon("circle-exclamation"), -3, {
    theme1,
    theme2
})

local home_tab_color = gradient.text_animate(ui.get_icon("house") .. " Home", -3, {
    theme1,
    theme2
})

local rage_tab_color = gradient.text_animate(ui.get_icon("person-rifle") .. " Aimbot", -3, {
    theme1,
    theme2
})

local defensive_tab_color = gradient.text_animate(ui.get_icon("shield-check") .. " Defensive", -3, {
    theme1,
    theme2
})


local defensive_tab_color_autopull = gradient.text_animate(ui.get_icon("shield-check") .. " Defensive", -3, {
    theme1,
    theme2
})


local exploit_tab_color = gradient.text_animate(ui.get_icon("triangle-exclamation") .. " Exploits", -3, {
    theme1,
    theme2
})
local aa_tab_color = gradient.text_animate(ui.get_icon("user-shield") .. " Anti Aim", -3, {
    theme1,
    theme2
})

local misc_tab_color = gradient.text_animate(ui.get_icon("memo-circle-info") .. " Information", -3, {
    theme1,
    theme2
})

local cfg_tab_color = gradient.text_animate(ui.get_icon("gear") .. " Configuration", -3, {
    theme1,
    theme2
})

common.add_notify(welcome_label:get_animated_text(), "Glad you joined our clan.")


ui.sidebar(sidebar_color:get_animated_text(), ui.get_icon("diamond"))
main_label_group = pui.create(home_tab_color:get_animated_text(), "ㅤ",1)
group_home = pui.create(home_tab_color:get_animated_text(), "ㅤ", 2)
group_adaptive_rage = pui.create(rage_tab_color:get_animated_text(), "ㅤ", 1)
group_adaptive_antiaim = pui.create(aa_tab_color:get_animated_text(),"ㅤ", 1)
group_adaptive_antiaim_cond = pui.create(aa_tab_color:get_animated_text(),"Conditonal", 2)

group_defensive = pui.create(defensive_tab_color:get_animated_text(), ui.get_icon("football-helmet") .. " DEFENSIVE ANTI AIM", 1)
group_defensive_autopull = pui.create(defensive_tab_color:get_animated_text(), ui.get_icon("arrow-right-arrow-left").. " Auto Swap", 2)

group_EXPLOITS = pui.create(exploit_tab_color:get_animated_text(), "BREAKING BAD LC", 1)
group_EXPLOITS_dt = pui.create(exploit_tab_color:get_animated_text(), "Double Tap Settings", 2)

--group_visuals_crosshair = pui.create("👀 Indicators","➕ Under Crosshair", 1)
--group_visuals_general = pui.create("👀 Indicators","💎 General Info", 1)
group_Information = pui.create(misc_tab_color:get_animated_text(),"ㅤ", 1)
group_steps_configs = pui.create(cfg_tab_color:get_animated_text(),"ㅤ", 1)
group_saveload_configs = pui.create(cfg_tab_color:get_animated_text(),"ㅤ", 2)




--local my_image = render.load_image_from_file("nl\\scripts\\goodlogo.jpg", vector(400, 400))



local menuitems = {
    -- home
    lua_notice = main_label_group:label(base_label:get_animated_text()),

    notice_build = main_label_group:label(build_label:get_animated_text()),

	join_discord = main_label_group:button(ui.get_icon("discord").." Discord", function()
        require("neverlose/mtools").Panorama:OpenLink("https://discord.gg/z26eYB9aJE")
    end),

    --cute = main_label_group:texture(my_image, 5),




    save_label = group_steps_configs:label("Save your current lua settings by pressing the 'Save Config' button which copies a text. On your PC, create a new text file using notepad or other text editors, and paste this copied text in there and save. Anytime you want to load your config just copy that text and press the 'Load config' button."),
    
    save_button = group_saveload_configs:button(ui.get_icon("floppy-disk") .. " Export Config", function()
        local config = pui.save()
        clipboard.set(json.stringify(config))
    end),

    load_button = group_saveload_configs:button(ui.get_icon("disc-drive") .. " Import Config", function()
        local config = clipboard.get()
        pui.load(json.parse(config))
    end),
	
    flashCSGO = group_home:switch(ui.get_icon("eye") .. " Flash CS:GO icon on round start", false),
    clan_taga = group_home:switch(ui.get_icon("diamond") .. " GANGZ ClanTag", false),

    nade_fix = group_home:switch(ui.get_icon("bomb") .. " Nade Throw Fix", false),


    exploit_l1 = group_EXPLOITS:label("Perfectly break LC. Jump with Double Tap enabled. Won't work on servers with fake duck disabled."),
	exploit_tutorial = group_EXPLOITS:button(ui.get_icon("youtube") .." Exploit Showcase", function()
        require("neverlose/mtools").Panorama:OpenLink("https://www.youtube.com/watch?v=2d27e3bQAxY")
    end),
    ourexploit = group_EXPLOITS:switch(ui.get_icon("face-laugh-wink") .. " Lag Shift (BIND THIS)", false),


    counter_defensive = group_adaptive_rage:switch(ui.get_icon("magnifying-glass") .. " Resolve Defensive AA", false),

    defensive_aa = group_defensive:switch("Enable", false),
    defensive_aa_options = group_defensive:listable(ui.get_icon("toggle-on") .. " Triggers", {ui.get_icon("paper-plane") .. " In air", ui.get_icon("triangle-exclamation") .. " On Threat (recommended)"}),

    defensive_aa_add_yaw = group_defensive:list(ui.get_icon("rotate") .. " Yaw Rotation", {ui.get_icon("angle-90") .. " 90 Degree", ui.get_icon("shuffle") .. " Randomize"}),



    switch_safe_taser = group_defensive_autopull:switch("Enable", false),
    switch_safe_taser_weapons = group_defensive_autopull:list(ui.get_icon("gun") .. " Item to swap to", {ui.get_icon("bolt") .. " Taser", ui.get_icon("gun") .. " Next Avialable (Secondary)"}),
    switch_safe_taser_distance = group_defensive_autopull:slider(ui.get_icon("radar") .." Range", 10, 2500, 700, 1),


    killsay_enable = group_Information:switch(ui.get_icon("face-angry") .. " Kill Say", false),

    logging_shot = group_Information:switch(ui.get_icon("crosshairs") .. " Aimbot Logs"),
    logging_death = group_Information:switch(ui.get_icon("tombstone-blank") .. " Death Logs", false),
    logging_loc = group_Information:listable("Type", {ui.get_icon("bars-sort") .. " Top-Left Event", ui.get_icon("bars") .. " CS:GO Console"}),


    
    --under_crosshair = group_visuals_crosshair:listable("Indicators", {"Exploits", "Lag Shift", "Desync", "Yaw Modifiers", "Auto Swap", "Player Velocity"}),
    --general = group_visuals_general:listable("General Info", {"Watermark", "Lua Info",}),

    instant_charge = group_EXPLOITS_dt:switch("Double Fire Instant Recharge", false),
    instant_charge_weapons = group_EXPLOITS_dt:listable(ui.get_icon("face-zany") .. " Select Weapons", {ui.get_icon("gun") .. " Auto Snipers", ui.get_icon("gun") .. " Deagle"}),
    instant_charge_aftershots = group_EXPLOITS_dt:slider(ui.get_icon("timer") .. " Recharge After Shots", 1, 4, 2, 1),


    yallah_yallah = group_EXPLOITS_dt:switch("Hide Shots Ideal Tick", false),



    --manual_aa = group_adaptive_antiaim:switch(ui.get_icon("keyboard") .. " Manual Anti Aim", false),
    --manual_aa_left = group_adaptive_antiaim:switch(ui.get_icon("square-arrow-left").." LEFT (BIND)", false),
    --manual_aa_right = group_adaptive_antiaim:switch(ui.get_icon("square-arrow-right").. " RIGHT (BIND)", false),


    leg_fucker = group_adaptive_antiaim:switch(ui.get_icon("face-eyes-xmarks").." Leg Breaker", false),


    enable_conditional_aa = group_adaptive_antiaim_cond:switch("[+] MasterSwitch Conditional Anti Aim", false),
    select_aa_state = group_adaptive_antiaim_cond:combo(ui.get_icon("person-walking-with-cane") .. " Player State", {STAND, WALK, RUN, CROUCH, AIR_CROUCH, AIR}),
    _builder_aa = {},


    dormant_aimbot = group_adaptive_rage:switch(ui.get_icon("location-crosshairs-slash") .. " Adaptive Dormancy", false),

    dormant_aimbot_dmg = group_adaptive_rage:slider("Minimum Dmg", 0, 130, 101, 1),

    --dormant_aimbot_autostop = group_adaptive_rage:selectable("[Normal]", {"Early", "In Air", "Full Stop", "Move Between Shots"}),
    --dormant_aimbot_autostop_dt = group_adaptive_rage:selectable("[DoubleTap] Auto Stop", {"Early", "Full Stop", "Move Between Shots"}),

    dormant_aimbot_baim = group_adaptive_rage:combo(ui.get_icon("vest") .. " Body Aim", {"Default", "Prefer", "Force"}),   
    
}


local logging_shot_color = menuitems.logging_shot:color_picker(theme1)
local logging_death_color = menuitems.logging_death:color_picker(theme2)




-- aa builder
for _, state_aa in ipairs(definitions.player_states) do
        
        state_aa_group = pui.create(aa_tab_color:get_animated_text(), tostring(state_aa), 2)


        menuitems._builder_aa[state_aa] = {
            Pitch = state_aa_group:combo("Pitch", {"Disabled", "Down", "Fake Down", "Fake Up"}),
            Yaw_base = state_aa_group:combo("Yaw Base", {"Disabled", "Backward", "Static"}),
            Yaw_direction = state_aa_group:combo("Yaw Direction", {"Local View", "At Target"}),
            Yaw = state_aa_group:slider("Yaw Offset", -180, 180, 0, 1),
            Yaw_mod = state_aa_group:combo("Jitter Type", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}),
            jitter_range = state_aa_group:slider("Range", -180, 180, 0, 1),
            Desync = state_aa_group:switch("Desync", false),
            Inverter = state_aa_group:switch("Inverter", false),
            left_limit = state_aa_group:slider("Left Desync Angle", 0, 60, 60, 1),
            right_limit = state_aa_group:slider("Right Desync Angle", 0, 60, 60, 1),
            Options = state_aa_group:selectable("Desync Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}),
            Freestand = state_aa_group:combo("Freestanding Options", {"Off", "Peek Fake", "Peek Real"})
        }
        --pui.setup(menuitems._builder_aa[state_aa])
end



local cogforexploit = menuitems.ourexploit:create()
local static_aa = cogforexploit:switch("Recommended Anti Aim", false),

menuitems.flashCSGO:tooltip("When tabbed out, CS:GO icon in the taskbar will flash indicating a round's beginning.")
menuitems.counter_defensive:tooltip("Attempts to resolve defensive (pitch/yaw flick) anti-aim users by delaying shot until a suitable pitch is found. For example 89 which is facing down.")
pui.setup(menuitems)



--------------------------------- RECODE STARTS HERE ---------------------------------
-- Flash the CSGO window when round starts
function flashCSGOWindow()
    if not menuitems.flashCSGO:get() then return end
    local className = "Valve001"
    local windowName = "Counter-Strike: Global Offensive - Direct3D 9"

    -- Find the CSGO window
    local csgoWindow = ffi.C.FindWindowA(className, windowName)
    if csgoWindow == nil then
        print("CSGO window not found!")
        return
    end

    -- Flash the window indicating round start
    ffi.C.FlashWindow(csgoWindow, 1)
end

-- getting closest enemy function
function getclosestenemy()
    local camera_position = render.camera_position()
	local camera_angles = render.camera_angles()
	local direction = vector():angles(camera_angles)

    local closest_distance, closest_enemy = math.huge
    for _, enemy in ipairs(entity.get_players(true)) do
        local ray_distance = enemy:get_hitbox_position(1):dist_to_ray(camera_position, direction)
        if ray_distance < closest_distance then
                closest_distance = ray_distance
                closest_enemy = enemy
        end
    end
    return closest_enemy
end

function get_player_state(player)
    -- enemy data we need for our anti aim and ragebot
    e_onground = player:get_anim_state().on_ground
    e_crouching = player:get_anim_state().anim_duck_amount
    e_landing = player:get_anim_state().landing
    e_feet_crossed = player:get_anim_state().feet_crossed
    e_velocity = math.floor(player:get_anim_state().speed_as_portion_of_run_top_speed * 10) -- this at least gives us stand, walk and run velocity
    e_eye_pitch = player:get_anim_state().eye_pitch
    e_eye_yaw = player:get_anim_state().eye_yaw



    if (e_onground) and (e_velocity < 2) and not (e_velocity >= 9) and not (e_velocity == 3) and (e_crouching == 0) then get_state_render = STAND
    elseif e_onground and e_crouching > 0 then get_state_render = CROUCH
    elseif not e_onground and e_crouching == 1 then get_state_render = AIR_CROUCH
    elseif not e_onground and e_crouching < 1 then get_state_render = AIR
    elseif cheatmenu.get_slowwalk:get() then get_state_render = WALK -- 3
    elseif e_onground and e_velocity > 3 then get_state_render = RUN -- > 9
    end

    return get_state_render 
end

function get_network_state(player)
    if not player then return end
    local _player_dormancy
    if player:get_network_state() == 0 then
        _player_dormancy = NOT_DORMANT
    elseif player:get_network_state() == 1 then
        _player_dormancy = CHEAT_CONFIDENCE
    elseif player:get_network_state() == 2 then
        _player_dormancy = SHARED_ESP
    elseif player:get_network_state() == 3 then
        _player_dormancy = SOUNDS
    elseif player:get_network_state() == 4 then
        _player_dormancy = NOT_UPDATED
    elseif player:get_network_state() == 5 then
        _player_dormancy = DATA_EXPIRED
    end

    return _player_dormancy
end


function get_weapon_name(player)
    if not player:get_player_weapon() then return end
    I_weapon = player:get_player_weapon():get_weapon_info().weapon_name
    return I_weapon
end



--[[events.render_glow:set(function(ctx)
    ctx:render(vector(definitions.localplayer:get_origin().x, definitions.localplayer:get_origin().y, definitions.localplayer:get_origin().z), vector(getclosestenemy():get_origin().x, getclosestenemy():get_origin().y, getclosestenemy():get_origin().z), 0.1, "lw", color(255))
end)]]


local set_it = true
events.render:set(function()



    for im2, pissed2 in pairs(menuitems._builder_aa) do
        if menuitems.select_aa_state:get() == im2 then
            pissed2.Pitch:visibility(true)
            pissed2.Yaw_base:visibility(true)
            pissed2.Yaw_direction:visibility(true)
            pissed2.Yaw:visibility(true)

            pissed2.Yaw_mod:visibility(true)

            pissed2.jitter_range:visibility(true)

            pissed2.Desync:visibility(true)
            pissed2.Inverter:visibility(true)

            pissed2.left_limit:visibility(true)
            pissed2.right_limit:visibility(true)

            pissed2.Options:visibility(true)
            pissed2.Freestand:visibility(true)
        else

            pissed2.Pitch:visibility(false)
            pissed2.Yaw_base:visibility(false)
            pissed2.Yaw_direction:visibility(false)

            pissed2.Yaw:visibility(false)

            pissed2.Yaw_mod:visibility(false)

            pissed2.jitter_range:visibility(false)

            pissed2.Desync:visibility(false)
            pissed2.Inverter:visibility(false)

            pissed2.left_limit:visibility(false)
            pissed2.right_limit:visibility(false)

            pissed2.Options:visibility(false)
            pissed2.Freestand:visibility(false)
        end
    end

    if not definitions.localplayer then return end




    --local out_trace = utils.trace_line(vector(definitions.localplayer:get_origin().x, definitions.localplayer:get_origin().y, definitions.localplayer:get_origin().z), vector(getclosestenemy():get_origin().x, getclosestenemy():get_origin().y, getclosestenemy():get_origin().z), 2)




    if menuitems.clan_taga:get() then
        cheatmenu.clantag_nl:override(false)

        if globals.tickcount % 30 == 0 then

            if set_it then
                definitions.clantag_index = definitions.clantag_index + 1
                if definitions.clantag_index > #definitions.clantag then
                    definitions.clantag_index = 1
                end
                common.set_clan_tag(tostring(definitions.clantag[definitions.clantag_index]))
                set_it = false
            end
        else
            set_it = true
        end
    else
        cheatmenu.clantag_nl:override()
        set_it = true
    end


    -- SAFETY SWAP GUN

    if menuitems.switch_safe_taser:get() and getclosestenemy() and definitions.localplayer then
        local my_origin = definitions.localplayer:get_origin()
        closest_enemy_origin = getclosestenemy():get_hitbox_position(1)

        --render.circle_3d(my_origin, color(255), menuitems.switch_safe_taser_distance:get(), 0, 1)

        if closest_enemy_origin:dist(my_origin) < menuitems.switch_safe_taser_distance:get() and getclosestenemy():is_alive() then
            if getclosestenemy():get_player_weapon() == nil then return end

            if getclosestenemy():get_player_weapon():get_weapon_info().weapon_name == "weapon_taser" then
                render.text(1, vector(definitions.screen_size.x/2, definitions.screen_size.y/2 + 30), color(255, 255, 255, 255), "c", getclosestenemy():get_name() .. " Safety Triggered")

                definitions.alreadypulledtaser = definitions.alreadypulledtaser + 1
                if definitions.alreadypulledtaser > 1 then return end

                if menuitems.switch_safe_taser_weapons:get() == 1 then
                    utils.console_exec("use weapon_taser")
                elseif menuitems.switch_safe_taser_weapons:get()==2 then
                    utils.console_exec("INVNEXTGUN")
                end
                

            end

        else
            definitions.alreadypulledtaser = 0
        end
    end


    --f not getclosestenemy() then return end
    --render.text(1, vector(definitions.screen_size.x/2, definitions.screen_size.y/2 + 30), color(255, 255, 255, 255), "c", getclosestenemy():get_name() .. " State | " .. definitions.light_red .. get_player_state(getclosestenemy()))

            --render.text(1, vector(definitions.screen_size.x/2, definitions.screen_size.y/2 + 30), color(255, 255, 255, 255), "c",  definitions.light_red .. current_min_dmg:get_override() .. definitions.white .. " | " .. get_network_state(getclosestenemy()))


end)

local shot = 1

local shot_fired = 0

local leg_jitter = 1


local allow_tp = true


events.round_start:set(function()
    shot = 1
end)


instant_charge = function()
    if shot_fired >= menuitems.instant_charge_aftershots:get() then
        rage.exploit:force_charge()
        shot_fired = 0
    end
end




local pitch_cycle = {"Fake Up", "Disabled"}

local _allowtp = true


local Aimbot_shot = false
local _stored_pos
local _allow_store_pos = true
local _allow_fallback = true


events.createmove:set(function(cmd)
    
    if not definitions.localplayer then return end

	------------------------------- RECODE

    -- BREAK LC
    local prop = definitions.localplayer["m_fFlags"]
    local in_air = (prop == 256 or prop == 262)



    
    if menuitems.ourexploit:get() and cheatmenu.Double_tap:get() and in_air then
        if globals.tickcount % 1.2 == 0.000 then
            cheatmenu.get_fakeduck:override(true)
        else
            cheatmenu.get_fakeduck:override()
        end
    else

         cheatmenu.get_fakeduck:override()   
    end

    -- auto tp

    if not menuitems.ourexploit:get() and in_air and entity.get_threat(true) then
        if _allowtp then
            rage.exploit.force_teleport()
            _allowtp = false
        end
    else
        _allowtp = true
    end

    if static_aa:get() and menuitems.ourexploit:get() then
        cheatmenu.get_fakeangles_enabled:override(true)
        cheatmenu.get_yawbase_offset:override(0)
        cheatmenu.get_yaw_mod:override("3-Way")
        cheatmenu.get_yaw_mod_degree:override(8)
        cheatmenu.rightlimit:override(math.random(20, 60))
        cheatmenu.leftlimit:override(math.random(20, 60))
        cheatmenu.get_fakeangles_options:override("Jitter")
    else
        cheatmenu.get_fakeangles_enabled:override()
        cheatmenu.get_yaw_mod:override()
        cheatmenu.get_yawbase_offset:override()
        cheatmenu.get_yaw_mod_degree:override()
        cheatmenu.rightlimit:override()
        cheatmenu.leftlimit:override()
        cheatmenu.get_fakeangles_options:override()

    end

    -- COUNTER DEFENSIVE 

    if menuitems.counter_defensive:get() then
        if not getclosestenemy() then return end
        threat = getclosestenemy()
        -- Delay shot when pitch is neither down (89.9) nor up (- 89.9)
        if (threat:get_anim_state().eye_pitch > 85) then
            cheatmenu.SSG_mindmg_delay_shot:override()
        elseif (threat:get_anim_state().eye_pitch < -85) then
            cheatmenu.SSG_mindmg_delay_shot:override()
        else
            cheatmenu.SSG_mindmg_delay_shot:override(true)
        end
    end

    --print_dev(math.floor(definitions.localplayer:get_anim_state().speed_as_portion_of_run_top_speed * 10) )

    -- FOLLOW BOT

    --[[for _, player in ipairs(entity.get_players()) do

    
        if menuitems.GANGZ:get() and string.lower(player:get_name()) == string.lower(menuitems.GANGZ_player:get()) then
            if not player:is_enemy() and not player:is_bot() and player:is_alive() then
                -- player name check for who we cant to follow
                local my_pos = definitions.localplayer:get_origin() -- Get the current camera origin
                local enemyOrigin = player:get_origin() -- get the current enemy origin
                our_distance = my_pos:dist(enemyOrigin)
                -- return if user pressed W A S D keys
                if (common.is_button_down(0x57) or common.is_button_down(0x41) or common.is_button_down(0x53) or common.is_button_down(0x44)) or our_distance >= menuitems.GANGZ_player_range:get() then return end
                local eyepos = vector(definitions.localplayer:get_eye_position())

                -- for making the bots follow your shots (bad)
                
                events.bullet_impact:set(function(w)
                    --if definitions.aimbot_shot_to_enemy then return end -- if aimbot shot then dont execute
                    userid_i_shot = w['userid']
                    name = entity.get(userid_i_shot,
                    true):get_name()
                    if name == player:get_name() then -- if leader shot
                        --print_dev(shot)
                        shot_x = vector(w.x, w.y, w.z)

                        if shot_x:dist(enemyOrigin) < 20 or shot_x:dist(enemyOrigin) < 20 or shot_x:dist(enemyOrigin) < 20 then return end
                        -- get bullet impact coords
                        if definitions.aimbot_shot_to_enemy then
                            shot = shot * -1
                            definitions.aimbot_shot_to_enemy = false
                        end

                    end

                end)

                definitions.aimbot_shot_to_enemy = true


                if shot == -1 then
                    definitions.target = shot_x
                elseif shot == 1 then
                    definitions.target = enemyOrigin

                    -- set it back to leader
                end
                
                definitions.target = enemyOrigin

                pitch, yaw = eyepos:to(definitions.target):angles() 

                angle_to_target = (definitions.target - my_pos):angles()

                if my_pos:dist(definitions.target) <= 10 then return end

                cmd.move_yaw = angle_to_target.y
                --cmd.forwardmove = math.cos(math.rad((render.camera_angles() - vector(angle_to_target))).x) * 450
                --cmd.sidemove = math.sin(math.rad((render.camera_angles() - vector(angle_to_target))).x) * 450
            end
        end
    end]]

        -- better slowwalk
    --[[if cheatmenu.get_slowwalk:get() then
        if common.is_button_down(0x57) then

            cmd.forwardmove = 10
        end 
        if common.is_button_down(0x53) then
            cmd.forwardmove = -10
        end 
        if common.is_button_down(0x41) then
            cmd.sidemove = -10
        end
        if common.is_button_down(0x44) then
            cmd.sidemove = 10

        end
    end]]
        

    -- nade fix

    if menuitems.nade_fix:get() then

        if get_weapon_name(definitions.localplayer) == "weapon_smokegrenade" or get_weapon_name(definitions.localplayer) == "weapon_hegrenade" or get_weapon_name(definitions.localplayer) == "weapon_flashgrenade" or get_weapon_name(definitions.localplayer) == "weapon_incgrenade" or get_weapon_name(definitions.localplayer) == "weapon_molotov" then
            cheatmenu.Double_tap:override(false)
            cheatmenu.Double_tap:override(false)
        else
            cheatmenu.Hide_shot:override(nil)
            cheatmenu.Double_tap:override(nil)
        end
    end
 

    -- manual AA

    --[[if menuitems.manual_aa:get() then
        if menuitems.manual_aa_left:get() then
            cheatmenu.get_yawbase_offset:override(cheatmenu.get_yawbase_offset:get() - 90)
        elseif menuitems.manual_aa_right:get() then
            cheatmenu.get_yawbase_offset:override(cheatmenu.get_yawbase_offset:get() + 90)
        end
    end]]


    -- leg breaker

    if menuitems.leg_fucker:get() then
        if globals.tickcount % 4 < 1 then
            leg_jitter = leg_jitter * -1
            cheatmenu.get_legmovement:override(leg_jitter > 0 and "Sliding" or "Walking")
        end
    else
        cheatmenu.get_legmovement:override()
    end


    -- instant double fire recharge (selectable)

    if menuitems.instant_charge:get() and menuitems.instant_charge_weapons:get(1) then
        if get_weapon_name(definitions.localplayer) == ("weapon_scar20" or "weapon_g3sg1") then
            instant_charge()
        end
    end

    if menuitems.instant_charge:get() and menuitems.instant_charge_weapons:get(2) then
        if get_weapon_name(definitions.localplayer) == "weapon_deagle" then
            instant_charge()
        end
    end




    if menuitems.dormant_aimbot:get() then

        if get_weapon_name(definitions.localplayer) == nil then
            -- do nothing
        else
            if (get_weapon_name(definitions.localplayer) == ("weapon_scar20" or "weapon_g3sg1")) then
                name = "AutoSnipers"

            elseif (get_weapon_name(definitions.localplayer) == "weapon_deagle") then
                name = "Desert Eagle"

            elseif (get_weapon_name(definitions.localplayer) == "weapon_awp") then
                name = "AWP"
            elseif (get_weapon_name(definitions.localplayer) == "weapon_ssg08") then
                name = "SSG-08"
            else
                name = nil
            end

            if name == nil then return end

            current_held_gun_mindmg = ui.find("Aimbot", "Ragebot", "Selection", name, "Min. Damage")
            current_held_gun_autostop = ui.find("Aimbot", "Ragebot", "Accuracy", name, "Auto Stop", "Options")
            current_held_gun_autostop_dt = ui.find("Aimbot", "Ragebot", "Accuracy", name, "Auto Stop", "Double Tap")

            current_held_gun_baim = ui.find("Aimbot", "Ragebot", "Safety", name, "Body Aim")

            -- dormant with confidence
            if get_network_state(getclosestenemy()) == (SOUNDS or DATA_EXPIRED or SHARED_ESP) then
                current_held_gun_mindmg:override(menuitems.dormant_aimbot_dmg:get())

                if menuitems.dormant_aimbot_baim:get() == "Default" then
                    current_held_gun_baim:override("Default")
                elseif menuitems.dormant_aimbot_baim:get() == "Prefer" then
                    current_held_gun_baim:override("Prefer")
                elseif menuitems.dormant_aimbot_baim:get() == "Force" then
                    current_held_gun_baim:override("Force")
                end

            else
                current_held_gun_mindmg:override()
                current_held_gun_baim:override()
            end
        end
    end



    -- conditional aa
    if menuitems.enable_conditional_aa:get() then

            for im2, pissed2 in pairs(menuitems._builder_aa) do
                if get_player_state(definitions.localplayer) == im2 then

                    cheatmenu.get_pitch:override(pissed2.Pitch:get())

                    cheatmenu.get_yawbase:override(pissed2.Yaw_direction:get())
                    cheatmenu.get_yawbase_angle:override(pissed2.Yaw_base:get())


                    cheatmenu.get_yawbase_offset:override(pissed2.Yaw:get())

                    cheatmenu.get_yaw_mod:override(pissed2.Yaw_mod:get())

                    cheatmenu.get_yaw_mod_degree:override(pissed2.jitter_range:get())

                    cheatmenu.get_fakeangles_enabled:override(pissed2.Desync:get())

                    cheatmenu.inverter:override(pissed2.Inverter:get())

                    cheatmenu.leftlimit:override(pissed2.left_limit:get())

                    cheatmenu.rightlimit:override(pissed2.right_limit:get())

                    cheatmenu.get_fakeangles_options:override(pissed2.Options:get())

                    cheatmenu.get_freestanding_options:override(pissed2.Freestand:get())

                end
            end
    else
        cheatmenu.get_pitch:override()
        cheatmenu.get_yawbase:override()
        cheatmenu.get_yawbase_angle:override()
        cheatmenu.get_yawbase_offset:override()

        cheatmenu.get_yaw_mod:override()

        cheatmenu.get_yaw_mod_degree:override()

        cheatmenu.get_fakeangles_enabled:override()

        cheatmenu.inverter:override()

        cheatmenu.leftlimit:override()

        cheatmenu.rightlimit:override()

        cheatmenu.get_fakeangles_options:override()

        cheatmenu.get_freestanding_options:override()
    end

    --defensive aa

    defensive_condition = menuitems.defensive_aa:get() == true

    if menuitems.defensive_aa:get() and (menuitems.defensive_aa_options:get(1) or menuitems.defensive_aa_options:get(2)) then
        if menuitems.defensive_aa_options:get(1) then
            if not in_air then return end
        end

        if menuitems.defensive_aa_options:get(2) then
            if not entity.get_threat(true) then return end
        end

        if globals.tickcount % 4 < 3 then
            cheatmenu.get_pitch:override(pitch_cycle[math.random(#pitch_cycle)])

            if menuitems.defensive_aa_add_yaw:get() == 1 then
                definitions.jitter_side = definitions.jitter_side * -1
                cheatmenu.get_yawbase_offset:override(definitions.jitter_side > 0 and 90 or -90)
            end
            if menuitems.defensive_aa_add_yaw:get() == 2 then
                cheatmenu.get_yawbase_offset:override(math.random(-120, 120))
            end
        else
            cheatmenu.get_yawbase_offset:override()
            cheatmenu.get_pitch:override()

        end

    else
        cheatmenu.get_yawbase_offset:override()
        cheatmenu.get_pitch:override()
    end

end)


local shot_hitbox
events.aim_ack:set(function(e)


    -- killsay
    if menuitems.killsay_enable:get() then
        if e.target["m_iHealth"] == (0 or nil) then
            utils.console_exec("say " .. killsays[math.random(#killsays)])
        end
    end

    -- hideshots ideal tick XP
    if menuitems.yallah_yallah:get() and cheatmenu.Hide_shot:get() and cheatmenu.get_autopeek:get() then
        rage.exploit:force_teleport()
        cheatmenu.Double_tap:override(false)
    else
        cheatmenu.Double_tap:override()
    end

    -- for dt recharge
    shot_fired = shot_fired + 1

    if menuitems.logging_shot:get() then

        -- logging here
        Aimbot_shot = true

        shot_entity = e.target
        shot_entity_health_remaining = e.target["m_iHealth"]
        shot_dmg = e.damage
        shot_hitchance = e.hitchance



        shot_BT = e.backtrack
        shot_position = e.aim
        shot_wanted_damage = e.wanted_damage
        shot_wanted_hitgroup = e.wanted_hitgroup
        miss_reason = e.state

        if string.len(shot_entity:get_name()) >= 15 then
            toolong_logname = string.sub(shot_entity:get_name(), 1, 15) .. "..."
        else
            toolong_logname = shot_entity:get_name()
        end


        shot_hitbox = definitions.hitboxes[e.hitgroup]

        if shot_hitbox == nil then
            shot_hitbox = "???"
        end

        if miss_reason == nil then ----------------------------- HIT
            -- set hit/miss var to hit
            hit_miss = "HIT "

            -- adding the rest of the log if shot is hit
            hit_miss_continue = definitions.white .. " For " .. "\a" .. logging_shot_color:get():to_hex() .. shot_dmg .. definitions.white .. " | Wanted Damage: " .. "\a" .. logging_shot_color:get():to_hex() .. shot_wanted_damage .. definitions.white .. " | HC: " .. "\a" .. logging_shot_color:get():to_hex() .. shot_hitchance .. "%" .. definitions.white .. " | Backtrack: " .. "\a" .. logging_shot_color:get():to_hex() .. shot_BT .. " TICKS" .. definitions.white .. " | " .. "\a" .. logging_shot_color:get():to_hex() .. shot_entity_health_remaining .. definitions.white .." Health."

            if menuitems.logging_loc:get(1) then
                common.add_event("\a" .. logging_shot_color:get():to_hex() .. hit_miss ..definitions.white.. toolong_logname .. "'s ".. "\a" .. logging_shot_color:get():to_hex() .. shot_hitbox .. tostring(hit_miss_continue))
            end

            if menuitems.logging_loc:get(2) then
                print_raw("\a" .. logging_shot_color:get():to_hex() .. hit_miss ..definitions.white.. toolong_logname .. "'s ".. "\a" .. logging_shot_color:get():to_hex() .. shot_hitbox .. tostring(hit_miss_continue))
            end

        else --------------------------------- MISSED

            hit_miss = "MISSED "

            if miss_reason == "correction" then
                miss_reason = "resolver"
            elseif miss_reason == "player death" then
                miss_reason = "enemy death"
            elseif miss_reason == "death" then
                miss_reason = "latency or local death"
            end
            
            hit_miss_continue = definitions.white .. " due to " .. "\a" .. logging_death_color:get():to_hex() .. string.upper(miss_reason) .. definitions.white ..  " | " .. "\a" .. logging_shot_color:get():to_hex() .. " HC: " .. shot_hitchance .. "%."
            if menuitems.logging_loc:get(2) then
                print_raw("\a" .. logging_shot_color:get():to_hex() .. hit_miss .. definitions.white .. "shot" .. tostring(hit_miss_continue))
            end 

            if menuitems.logging_loc:get(1) then
                common.add_event("\a" .. logging_shot_color:get():to_hex() .. hit_miss .. definitions.white .. "shot" .. tostring(hit_miss_continue))
            end
        end


        -- spacing
        print_raw("")
        print_raw("")
    end
end)



local function draw_death_logs(g)

    if not definitions.localplayer then return end

    if menuitems.logging_death:get() then


        local event_info = {
            MYuserid = definitions.localplayer:get_player_info()['userid'],
            died_userid = g['userid'],
            -------------------------
            attacker = g['attacker'],
            weapon_used_to_kill = g['weapon'],
            was_headshot = g['headshot'],
            penetration = g['penetrated'],
            distance_to_me = g['distance'] -- distance to victim. -- this case it's localplayer
        }

        -- enemy info
        local enemy = entity.get(event_info.attacker, true)
        if enemy == nil then return end
        local enemy_info = {
            enemy_name = enemy:get_name(),
            enemy_anim_state = enemy:get_anim_state(), -- VERY IMPORTANT -- table
            enemy_anim_overlay = enemy:get_anim_overlay(), -- table
            enemy_steam_avatar = enemy:get_steam_avatar(),
            enemy_origin = enemy:get_origin()
        }
        -- anti aim logs
        -- checking for enemy's name to not be too long.
        if string.len(enemy_info.enemy_name) >= 16 then
            toolong_logname_death = string.sub(enemy_info.enemy_name, 1, 16) .. "..."
        else
            toolong_logname_death = enemy_info.enemy_name
        end


        --- the actual LOGGING ---
        if event_info.died_userid == event_info.MYuserid then -- main local death condition
            if event_info.was_headshot then
                    str_hs_baim = "Headshoting"
            else
                    str_hs_baim = "Baiming"
            end


            -- pre defining our log string here

            str_log = "\a" .. "\a" .. logging_death_color:get():to_hex() .. "DEATH " ..definitions.white.. "from "  .. definitions.white .. toolong_logname_death .. "\a" .. "\a" .. logging_death_color:get():to_hex() .. " " .. str_hs_baim  .. definitions.white .." you with " .. string.upper(event_info.weapon_used_to_kill) .. " from " .. math.floor(event_info.distance_to_me) .." meters away."
            if menuitems.logging_loc:get(1) then
                common.add_event(str_log)
            end
            if menuitems.logging_loc:get(2) then

                print_raw(str_log)
            end
            -- spacing
            print_raw("")
            print_raw("")
        end
    end
end
-- killsay
events.player_death:set(function(g, h)
    draw_death_logs(g)
end)
events.round_start:set(function()

    flashCSGOWindow()
end)

events.shutdown:set(function(cmd)
    common.set_clan_tag("")
    cheatmenu.clantag_nl:override()
    cvar.sv_maxusrcmdprocessticks:int(15)

end)