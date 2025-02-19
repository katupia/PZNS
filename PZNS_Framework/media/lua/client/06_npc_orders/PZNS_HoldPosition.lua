---comment
---@param npcSurvivor any
---@param targetSquare IsoGridSquare
function PZNS_HoldPosition(npcSurvivor, targetSquare)
    --
    if (npcSurvivor == nil) then
        return;
    end
    --
    local npcIsoPlayer = npcSurvivor.npcIsoPlayerObject;
    npcSurvivor.aimTarget = nil;
    npcSurvivor.isHoldingInPlace = true;
    --
    local npcSquareX = npcIsoPlayer:getX();
    local npcSquareY = npcIsoPlayer:getY();
    local npcSquareZ = npcIsoPlayer:getZ();
    --
    local targetX = targetSquare:getX();
    local targetY = targetSquare:getY();
    local targetZ = targetSquare:getZ();
    -- Cows: If any of the square do not match, move the NPC to the targetSquare.
    if (
            npcSquareX ~= targetX
            or npcSquareY ~= targetY
            or npcSquareZ ~= targetZ
        )
    then
        PZNS_RunToSquareXYZ(npcSurvivor, targetX, targetY, targetZ); -- WIP - Cows: NPCs don't actually run... still only walks for whatever reason.
    end
end
