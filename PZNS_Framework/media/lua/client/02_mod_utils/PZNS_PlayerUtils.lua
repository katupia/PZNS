local PZNS_PlayerUtils = {};
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");

--- Cows: Add LocalPlayer "0" to group.
function PZNS_LocalPlayerGroupCreation()
    local mpPlayerID = 0;
    local playerGroupID = "Player" .. tostring(mpPlayerID) .. "Group";
    local playerGroup = PZNS_NPCGroupsManager.getGroupByID(playerGroupID);
    getSpecificPlayer(mpPlayerID):getModData().survivorID = "Player" .. tostring(mpPlayerID);
    --
    if (playerGroup == nil) then
        playerGroup = PZNS_NPCGroupsManager.createGroup(playerGroupID);
        PZNS_PlayerUtils.PZNS_AddPlayerToGroup(mpPlayerID, playerGroupID);
    end
end

--- Cows: Placeholder, Apparently, all the MP player IDs in PZ Java are numbers only...
--- Cows: So this function is to ensure a set number of IDs are reserved.
--- Cows: Probably unnecessary if the mod uses it own ID tables...
---@param inputNumber number
---@param reservedNumber number
---@return boolean
function PZNS_PlayerUtils.PZNS_IsSurvivorIDReserved(inputNumber, reservedNumber)
    if (inputNumber <= reservedNumber) then
        return true;
    end
    return false;
end

--- Cows: Add a specified player to a specified group
---@param mpPlayerID number
---@param groupID any
function PZNS_PlayerUtils.PZNS_AddPlayerToGroup(mpPlayerID, groupID)
    local group = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local stringID = "player" .. tostring(mpPlayerID);
    --
    if (group ~= nil) then
        group[stringID] = stringID;
    end
end

--- Cows: Remove the  specified player from the specified group
---@param mpPlayerID number
---@param groupID any
function PZNS_PlayerUtils.PZNS_RemovePlayerFromGroup(mpPlayerID, groupID)
    local group = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local stringID = "player" .. tostring(mpPlayerID);
    --
    if (group ~= nil) then
        group[stringID] = nil;
    end
end

---comment
---@param mpPlayerID number
---@return IsoGridSquare
function PZNS_PlayerUtils.PZNS_GetPlayerCellGridSquare(mpPlayerID)
    local localPlayerID = 0;
    --
    if (mpPlayerID ~= nil) then
        localPlayerID = mpPlayerID;
    end
    --
    local gridSquare = getCell():getGridSquare(
        getSpecificPlayer(localPlayerID):getX(),
        getSpecificPlayer(localPlayerID):getY(),
        getSpecificPlayer(localPlayerID):getZ()
    );
    return gridSquare;
end

--- Cows: Based on Superb Survivors GetMouseSquare(), the calculation seems to be off by almost 1...
---@param mpPlayerID integer
---@return IsoGridSquare
function PZNS_PlayerUtils.PZNS_GetPlayerMouseGridSquare(mpPlayerID)
    local sw = (128 / getCore():getZoom(0));
    local sh = (64 / getCore():getZoom(0));

    local playerSurvivor = getSpecificPlayer(mpPlayerID);
    local mapx = playerSurvivor:getX();
    local mapy = playerSurvivor:getY();
    local mousex = getMouseX() - (getCore():getScreenWidth() / 2);
    local mousey = getMouseY() - (getCore():getScreenHeight() / 2);

    local squareX = mapx + (mousex / (sw / 2) + mousey / (sh / 2)) / 2;
    local squareY = mapy + (mousey / (sh / 2) - (mousex / (sw / 2))) / 2;
    local squareZ = playerSurvivor:getZ();

    local square = getCell():getGridSquare(squareX, squareY, squareZ);
    return square;
end

---comment
function PZNS_PlayerUtils.PZNS_ClearPlayerAllNeeds()
    local playerSurvivor = getSpecificPlayer(0);

    playerSurvivor:getStats():setAnger(0.0);
    playerSurvivor:getStats():setBoredom(0.0);
    playerSurvivor:getStats():setDrunkenness(0.0);
    playerSurvivor:getStats():setEndurance(100.0);
    playerSurvivor:getStats():setFatigue(0.0);
    playerSurvivor:getStats():setFear(0.0);
    playerSurvivor:getStats():setHunger(0.0);
    playerSurvivor:getStats():setIdleboredom(0.0);
    playerSurvivor:getStats():setMorale(0.0);
    playerSurvivor:getStats():setPain(0.0);
    playerSurvivor:getStats():setPanic(0.0);
    playerSurvivor:getStats():setSanity(0.0);
    playerSurvivor:getStats():setSickness(0.0);
    playerSurvivor:getStats():setStress(0.0);
    playerSurvivor:getStats():setStressFromCigarettes(0.0);
    playerSurvivor:getStats():setThirst(0.0);
end

return PZNS_PlayerUtils;
