HyperAlerts = HyperAlerts or {}
local function registerPseudoEffectEvent(abilityID, data)
    EVENT_MANAGER:RegisterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, function(_, result, _, abilityName, abilityGraphic,
                                                                                   _, sourceName, _, targetName, targetType, hitValue, _, _, _, _, _, _)

        local previousStacks = 0
        if HyperAlerts.pseudoEffects[abilityID] then
            previousStacks = HyperAlerts.pseudoEffects[abilityID].stackCount or 0
            if HyperAlerts.pseudoEffects[abilityID].timeEnding < GetGameTimeSeconds() then
                previousStacks = 0
            end
        end

        HyperAlerts.pseudoEffects[abilityID] = {
            effectName = abilityName,
            timeStarted = GetGameTimeSeconds(),
            timeEnding = GetGameTimeSeconds()+data.duration,
            iconFilename = GetAbilityIcon(abilityID),
            stackCount = previousStacks + 1,
            castByPlayer = true,
            timer = 5,
            abilityId = abilityID,
        }


    end)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DAMAGE)
    EVENT_MANAGER:AddFilterForEvent("HyperAlerts.RegisterPseudoEffectEvent" .. abilityID, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
end

HyperAlerts.pseudoEffectData = {
    --ASYLUM SANCTORIUM
    [98356] = {duration = 1.1}, --Poison AoE

    --ROCKGROVE
    [152515] = {duration = 5}, --Melee Trash Poison AoE
    [150002] = {duration = 5}, --Abo Slam AoE
}

function HyperAlerts.RegisterPseudoEffectEvents()
    for k,v in pairs(HyperAlerts.pseudoEffectData) do
        registerPseudoEffectEvent(k,v)
    end
end