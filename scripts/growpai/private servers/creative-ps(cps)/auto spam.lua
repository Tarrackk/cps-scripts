
--general variables
local TEXT_TO_SPAM = "test" --Enter spam text here
local COOLDOWN_BETWEEN_TEXT = 5000 -- enter to what you want. (don't recommend under 4000-5000)
local x = 0 -- can set manually or by /setpos
local y = 0 -- can set manualy or by /setpos
local world = "" -- can set manually or by /setworld
local DCED = false -- dont touch
local userID; -- dont touch
local start = false -- dont touch
function Split(inputstr, sep)
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function TeleToPos()
    if start == true then
        FindPath(x,y)
        log("`9Teleported to spot")
    end
end
local function Join()
SendPacket(3, "action|join_request\nname|"..world)
log("`9Rejoining `1"..world)
end

local function Spam()
    if start == true then
    RunThread(function ()
        log("`9Started")
        while DCED == false and start == true do
        SendPacket(2, "action|input\ntext|"..TEXT_TO_SPAM)
        Sleep(COOLDOWN_BETWEEN_TEXT)
        end
    end)
end
end
local function pack(type ,packet)
	local args = Split(packet:gsub("action|input\n|text|", ""), " ")
	local command = string.lower(args[1])
    local localPlayer = GetLocal()
    if command=="/setpos" then
        x = math.floor((localPlayer.pos_x)/32)
        y = math.floor((localPlayer.pos_y)/32)
        log("`9Set Coordinates to: `1X:"..x.." Y:"..y)
        return true
    end
    if command =="/setworld" then
        world = localPlayer.world
        log("`9World has been set to `1"..world)
        return true
    end
    
    if command =="/start" then
        DCED = false
        start = true
        RunThread(function ()
            Sleep(100)
            TeleToPos()
            Sleep(1000)
            Spam()
        end)
        return true
    end
    if command == "/stop" then
        start = false;
        log("`9stopped the script")
        return true
    end
end
local function hookVarlist(varlist)
    if varlist[0] == "OnRequestWorldSelectMenu" and start==true then
        RunThread(function ()
            Sleep(2000)
            DCED = true
            Join()
        end)
    end
    if varlist[0] == "OnSpawn" and varlist[1]:find("userID|"..userID) and DCED == true and start==true then
        RunThread(function ()
            
            Sleep(3000)
            TeleToPos()
            Sleep(1000)
            Spam()
            DCED = false
        end)
        
    end
end
AddCallback("Handle Commands", "OnPacket", pack)
AddCallback("varlist", "OnVarlist", hookVarlist)
userID = tostring(GetLocal().userid)
userID = userID:gsub(".0", "")
log("`9Set userID to:`5"..userID)
