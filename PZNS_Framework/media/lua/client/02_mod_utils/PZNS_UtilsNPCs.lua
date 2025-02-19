--[[
    Cows: This file is intended for ALL functions related to the creation, deletion, load,
    and editing of NPCs' specified attribute(s) and inventory data.
--]]
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsNPCs = {};
--- Cows: Add a specified trait to the target npcSurvivor.
---@param npcSurvivor any
---@param traitName string
---@return any
function PZNS_UtilsNPCs.PZNS_AddNPCSurvivorTraits(npcSurvivor, traitName)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    npcIsoPlayer:getTraits():add(traitName);
    return npcSurvivor;
end

--- Cows: Level the target npcSurvivor's specified perk by the specified levels.
---@param npcSurvivor any
---@param perkName string
---@param levels number
---@return any
function PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, perkName, levels)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    -- Verify the perk exists and level it based on the levels number input.
    if (PerkFactory.getPerkFromName(perkName)) then
        for i = 1, levels do
            npcIsoPlayer:LevelPerk(Perks.FromString(perkName));
        end
    end

    return npcSurvivor;
end

--- Cows: Gets the target npcSurvivor's specified perk level
---@param npcSurvivor any
---@param perkName string
---@return any
function PZNS_UtilsNPCs.PZNS_GetNPCSurvivorPerkLevel(npcSurvivor, perkName)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    -- Verify the perk exists and level it based on the levels number input.
    if (PerkFactory.getPerkFromName(perkName)) then
        return npcIsoPlayer:getPerkLevel(Perks.FromString(perkName));
    end

    return 0;
end

--- Cows: Simple code to add item to npcSurvivor inventory.
---@param npcSurvivor any
---@param itemID string
function PZNS_UtilsNPCs.PZNS_AddItemToInventoryNPCSurvivor(npcSurvivor, itemID)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local item = instanceItem(itemID);
    --
    if (item ~= nil) then
        npcIsoPlayer:getInventory():AddItem(item);
    end
end

--- Cows: Simple code to remove item to npcSurvivor inventory.
---@param npcSurvivor any
---@param item Item
function PZNS_UtilsNPCs.PZNS_RemoveItemFromInventoryNPCSurvivor(npcSurvivor, item)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    -- WIP - Cows: Need to specify the amount? Item ID?
    npcIsoPlayer:getInventory():removeItemWithID(item);
end

--- Cows: Simple code to add clothingItem to npcSurvivor inventory and wear it.
---@param npcSurvivor any
---@param clothingID string
function PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, clothingID)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local clothingItem = instanceItem(clothingID);
    --
    if (clothingItem ~= nil) then
        npcIsoPlayer:getInventory():AddItem(clothingItem);
        local bodyPartLocation = clothingItem:getBodyLocation();
        --
        if (bodyPartLocation ~= nil) then
            npcIsoPlayer:setWornItem(bodyPartLocation, clothingItem);
        end
    end
end

--- Cows: Simple code to add weaponItem to npcSurvivor inventory and equip it.
---@param npcSurvivor any
---@param weaponID string
function PZNS_UtilsNPCs.PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, weaponID)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local weaponItem = instanceItem(weaponID);
    --
    if (weaponItem ~= nil) then
        npcIsoPlayer:getInventory():AddItem(weaponItem);
        npcIsoPlayer:setPrimaryHandItem(weaponItem);
        --
        local npcHandItem = npcIsoPlayer:getPrimaryHandItem();
        --
        if (npcHandItem:IsWeapon() == true) then
            --
            if (npcHandItem:isRanged() == true) then
                npcSurvivor.lastEquippedRangeWeapon = npcHandItem;
            else
                npcSurvivor.lastEquippedMeleeWeapon = npcHandItem;
            end
        end

        if (weaponItem:isRequiresEquippedBothHands() or weaponItem:isTwoHandWeapon()) then
            npcIsoPlayer:setSecondaryHandItem(weaponItem);
        end
    end
end

--- WIP - Cows: Simple code to equip the last weapon the npcSurvivor had.
---@param npcSurvivor any
function PZNS_UtilsNPCs.PZNS_EquipLastWeaponNPCSurvivor(npcSurvivor)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local weaponItem = instanceItem(npcSurvivor.lastEquippedRangeWeapon);
    --
    if (npcSurvivor.isMeleeOnly == true) then
        weaponItem = instanceItem(npcSurvivor.lastEquippedMeleeWeapon);
    end
    --
    if (weaponItem ~= nil) then
        npcIsoPlayer:getInventory():AddItem(weaponItem);
        npcIsoPlayer:setPrimaryHandItem(weaponItem);
        --
        local npcHandItem = npcIsoPlayer:getPrimaryHandItem();
        --
        if (npcHandItem:IsWeapon() == true) then
            --
            if (npcHandItem:isRanged() == true) then
                npcSurvivor.lastEquippedRangeWeapon = npcHandItem;
            else
                npcSurvivor.lastEquippedMeleeWeapon = npcHandItem;
            end
        end

        if (weaponItem:isRequiresEquippedBothHands() or weaponItem:isTwoHandWeapon()) then
            npcIsoPlayer:setSecondaryHandItem(weaponItem);
        end
    end
end

---comment
---@param npcSurvivor any
---@param r float
---@param g float
---@param b float
function PZNS_UtilsNPCs.PZNS_SetNPCHairColor(npcSurvivor, r, g, b)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local hairColor = ImmutableColor.new(r, g, b);
    npcIsoPlayer:getHumanVisual():setHairColor(hairColor);
end

---comment
---@param npcSurvivor any
---@param hairModelString string
function PZNS_UtilsNPCs.PZNS_SetNPCHairModel(npcSurvivor, hairModelString)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end

    npcIsoPlayer:getHumanVisual():setHairModel(hairModelString);
end

---comment
---@param npcSurvivor any
---@param r float
---@param g float
---@param b float
function PZNS_UtilsNPCs.PZNS_SetNPCSkinColor(npcSurvivor, r, g, b)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    local skinColor = ImmutableColor.new(r, g, b);
    npcIsoPlayer:getHumanVisual():setSkinColor(skinColor);
end

---comment
---@param npcSurvivor any
---@param idx number
function PZNS_UtilsNPCs.PZNS_SetNPCSkinTextureIndex(npcSurvivor, idx)
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    npcIsoPlayer:getHumanVisual():setSkinTextureIndex(idx);
end

---comment
---@param npcSurvivor any
---@param groupID string
function PZNS_UtilsNPCs.PZNS_SetNPCGroupID(npcSurvivor, groupID)
    npcSurvivor.groupID = groupID;
end

---comment
---@param npcSurvivor any
---@param jobName any
function PZNS_UtilsNPCs.PZNS_SetNPCJob(npcSurvivor, jobName)
    if (npcSurvivor == nil) then
        return;
    end

    if (jobName) then
        npcSurvivor.jobName = jobName;
    end
end

---comment
---@param npcSurvivor any
---@param targetID any
function PZNS_UtilsNPCs.PZNS_SetNPCFollowTargetID(npcSurvivor, targetID)
    if (npcSurvivor == nil) then
        return;
    end

    if (targetID) then
        npcSurvivor.followTargetID = targetID;
    end
end

--- Cows: Clears the queued ISTimedActionQueue
---@param npcSurvivor any
function PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor)
    if (npcSurvivor == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    -- Cows: Stop aiming and stop attacking
    npcIsoPlayer:NPCSetAiming(false);
    npcIsoPlayer:NPCSetAttack(false);
    ISTimedActionQueue.clear(npcIsoPlayer);
end

---comment
---@param npcSurvivor any
function PZNS_UtilsNPCs.PZNS_GetNPCActionsQueue(npcSurvivor)
    if (npcSurvivor == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local npcActionQueue = ISTimedActionQueue.getTimedActionQueue(npcIsoPlayer);

    return npcActionQueue;
end

---comment
---@param npcSurvivor any
---@return integer | nil
function PZNS_UtilsNPCs.PZNS_GetNPCActionsQueuedCount(npcSurvivor)
    if (npcSurvivor == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local npcActionQueue = ISTimedActionQueue.getTimedActionQueue(npcIsoPlayer);
    local actionsCount = 0;
    --
    for k1, v1 in pairs(npcActionQueue) do
        if (k1 == "queue") then
            for k2, v2 in pairs(v1) do
                actionsCount = actionsCount + 1;
            end
        end
    end

    return actionsCount;
end

--- WIP - Cows: Need to clean up the ISTimedActionQueue queues eventually...
---@param npcSurvivor any
---@param npcQueueAction any
function PZNS_UtilsNPCs.PZNS_AddNPCActionToQueue(npcSurvivor, npcQueueAction)
    if (npcSurvivor == nil or npcQueueAction == nil) then
        return;
    end
    -- Cows: Perhaps add a check for how many actions are in queue? Automatic cleanup and updates will keep the NPCs responsive.
    local actionsCount = PZNS_UtilsNPCs.PZNS_GetNPCActionsQueuedCount(npcSurvivor);
    local actionsQueueLimit = 30;

    if (actionsCount < actionsQueueLimit) then
        ISTimedActionQueue.add(npcQueueAction);
    else
        PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
    end
end

--- Cows Checks if NPC square is loaded, this is critical to ensure NPC IsoPlayer can act.
---@param npcSurvivor any
---@return boolean
function PZNS_UtilsNPCs.PZNS_GetIsNPCSquareLoaded(npcSurvivor)
    if (npcSurvivor == nil) then
        return false;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local npcSquare = npcIsoPlayer:getSquare();
    --
    if (npcSquare ~= nil) then
        return true;
    end
    return false;
end

---comment
---@param npcSurvivor any
---@return IsoGridSquare | nil
function PZNS_UtilsNPCs.PZNS_GetNPCIsoGridSquare(npcSurvivor)
    if (npcSurvivor == nil) then
        return;
    end
    ---@type IsoPlayer
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    local npcSquare = npcIsoPlayer:getSquare();
    --
    return npcSquare;
end

--- Cows: Checks if any of the ActiveNPCs have the specified jobName.
---@param jobName string
---@return boolean
function PZNS_UtilsNPCs.PZNS_CheckIfJobIsActive(jobName)
    local isJobActive = false;
    --
    local activeNPCs = PZNS_UtilsDataNPCs.PZNS_GetCreateActiveNPCsModData();
    --
    for survivorID, v in pairs(activeNPCs) do
        local npcSurvivor = activeNPCs[survivorID];
        --
        if (npcSurvivor.jobName == jobName) then
            if (PZNS_UtilsNPCs.PZNS_GetIsNPCSquareLoaded(npcSurvivor) == true) then
                isJobActive = true;
                break;
            end
        end
    end
    return isJobActive;
end

--- Cows: needType based on values in Java API
--- https://projectzomboid.com/modding/zombie/characters/Stats.html
---@param npcSurvivor any
---@param needType any
---@param needValue any
function PZNS_UtilsNPCs.PZNS_SetNPCNeedLevel(npcSurvivor, needType, needValue)
    if (npcSurvivor == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;

    if (needType == "Anger") then
        npcIsoPlayer:getStats():setAnger(needValue);
    elseif (needType == "Boredom") then
        npcIsoPlayer:getStats():setBoredom(needValue);
    elseif (needType == "Drunkenness") then
        npcIsoPlayer:getStats():setDrunkenness(needValue);
    elseif (needType == "Endurance") then
        npcIsoPlayer:getStats():setEndurance(needValue);
    elseif (needType == "Fatigue") then
        npcIsoPlayer:getStats():setFatigue(needValue);
    elseif (needType == "Fear") then
        npcIsoPlayer:getStats():setFear(needValue);
    elseif (needType == "Hunger") then
        npcIsoPlayer:getStats():setHunger(needValue);
    elseif (needType == "IdleBoredom") then
        npcIsoPlayer:getStats():setIdleboredom(needValue);
    elseif (needType == "Morale") then
        npcIsoPlayer:getStats():setMorale(needValue);
    elseif (needType == "Pain") then
        npcIsoPlayer:getStats():setPain(needValue);
    elseif (needType == "Panic") then
        npcIsoPlayer:getStats():setPanic(needValue);
    elseif (needType == "Sanity") then
        npcIsoPlayer:getStats():setSanity(needValue);
    elseif (needType == "Sickness") then
        npcIsoPlayer:getStats():setSickness(needValue);
    elseif (needType == "Stress") then
        npcIsoPlayer:getStats():setStress(needValue);
    elseif (needType == "StressFromCigarettes") then
        npcIsoPlayer:getStats():setStressFromCigarettes(needValue);
    elseif (needType == "Thirst") then
        npcIsoPlayer:getStats():setThirst(needValue);
    end
end

--- Cows: needType based on values in Java API
---@param npcSurvivor any
function PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(npcSurvivor)
    if (npcSurvivor == nil) then
        return;
    end
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    if (npcIsoPlayer == nil) then
        return;
    end
    --
    if (npcIsoPlayer:isAlive() == true) then
        npcIsoPlayer:getStats():setAnger(0.0);
        npcIsoPlayer:getStats():setBoredom(0.0);
        npcIsoPlayer:getStats():setDrunkenness(0.0);
        npcIsoPlayer:getStats():setEndurance(100.0);
        npcIsoPlayer:getStats():setFatigue(0.0);
        npcIsoPlayer:getStats():setFear(0.0);
        npcIsoPlayer:getStats():setHunger(0.0);
        npcIsoPlayer:getStats():setIdleboredom(0.0);
        npcIsoPlayer:getStats():setMorale(0.0);
        npcIsoPlayer:getStats():setPain(0.0);
        npcIsoPlayer:getStats():setPanic(0.0);
        npcIsoPlayer:getStats():setSanity(0.0);
        npcIsoPlayer:getStats():setSickness(0.0);
        npcIsoPlayer:getStats():setStress(0.0);
        npcIsoPlayer:getStats():setStressFromCigarettes(0.0);
        npcIsoPlayer:getStats():setThirst(0.0);
        npcIsoPlayer:getBodyDamage():AddGeneralHealth(25);
    end
end

--- Cows: Clears ALL npcs' needs on call.
function PZNS_UtilsNPCs.PZNS_ClearAllNPCsAllNeedsLevel()
    local activeNPCs = PZNS_UtilsDataNPCs.PZNS_GetCreateActiveNPCsModData();
    --
    for survivorID, v in pairs(activeNPCs) do
        local npcSurvivor = activeNPCs[survivorID];
        if (npcSurvivor.isAlive == true) then
            PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(npcSurvivor);
        end
    end
end

--- WIP - Cows: Check and update the npcSurvivor isStuckTicks (depending on the npcSurvivor currentAction?)
---@param npcSurvivor any
function PZNS_UtilsNPCs.PZNS_StuckNPCCheck(npcSurvivor)
    if (npcSurvivor.isStuckTicks == nil) then
        npcSurvivor.isStuckTicks = 0;
    end
    -- Cows: 50 Ticks per action on average... also need ticks for animations.
    if (npcSurvivor.isStuckTicks >= 150) then
        PZNS_NPCSpeak(npcSurvivor, "I was stuck...", "InfoOnly");
        PZNS_UtilsNPCs.PZNS_ClearQueuedNPCActions(npcSurvivor);
        npcSurvivor.currentAction = "";
        npcSurvivor.isStuckTicks = 0;
    else
        npcSurvivor.isStuckTicks = npcSurvivor.isStuckTicks + 1;
    end
    PZNS_NPCSpeak(npcSurvivor, "isStuckTicks: " .. tostring(npcSurvivor.isStuckTicks), "InfoOnly");
end

return PZNS_UtilsNPCs;
