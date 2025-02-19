local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");

---comment
---@param groupID any
---@param parentContextMenu any
function PZNS_CreateJobNPCsMenu(parentContextMenu, mpPlayerID, groupID, jobName)
    local activeNPCs = PZNS_UtilsDataNPCs.PZNS_GetCreateActiveNPCsModData();
    local groupMembers = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local followTargetID = "Player" .. mpPlayerID;
    --
    -- Cows: Stop if there are no active npcs. or groupMembers
    if (activeNPCs == nil or groupMembers == nil) then
        return;
    end

    for survivorID, v in pairs(groupMembers) do
        local npcSurvivor = activeNPCs[survivorID];
        -- Cows: conditionally set the callback function for the context menu option.
        local callbackFunction = function()
            if (jobName == "Companion") then
                PZNS_JobCompanion(npcSurvivor, followTargetID);
            end
            PZNS_UtilsNPCs.PZNS_SetNPCJob(npcSurvivor, jobName);
        end
        --
        if (npcSurvivor ~= nil) then
            local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
            local isNPCSquareLoaded = PZNS_UtilsNPCs.PZNS_GetIsNPCSquareLoaded(npcSurvivor);
            -- Cows: Check and make sure the NPC is both alive and loaded in the current game world. 
            if (npcIsoPlayer:isAlive()  and isNPCSquareLoaded == true) then
                parentContextMenu:addOption(
                    getText(npcSurvivor.survivorName),
                    nil,
                    callbackFunction
                );
            end
        end
    end
    return parentContextMenu;
end

---comment
---@param mpPlayerID number
---@param context any
---@param worldobjects any
function PZNS_ContextMenuJobs(mpPlayerID, context, worldobjects)
    local jobsSubMenu_1 = context:getNew(context);
    local jobsSubMenu_1_Option = context:addOption(
        getText("PZNS_Jobs"),
        worldobjects,
        nil
    );
    context:addSubMenu(jobsSubMenu_1_Option, jobsSubMenu_1);
    --
    local playerGroupID = "Player" .. tostring(mpPlayerID) .. "Group";
    --
    for jobKey, jobText in pairs(PZNS_JobsText) do
        local jobSubMenu_2 = jobsSubMenu_1:getNew(context);
        local jobSubMenu_2_Option = jobsSubMenu_1:addOption(
            getText(jobText),
            worldobjects,
            nil
        );
        local npcSubMenu_3 = jobSubMenu_2:getNew(context);
        PZNS_CreateJobNPCsMenu(npcSubMenu_3, mpPlayerID, playerGroupID, jobText);
        --
        jobsSubMenu_1:addSubMenu(jobSubMenu_2_Option, jobSubMenu_2);
        jobSubMenu_2:addSubMenu(jobSubMenu_2_Option, npcSubMenu_3);
    end
end
