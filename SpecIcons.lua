SPEC_ICONS = {}

function SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
    
    local specs = {}

    if playerClass == "WARRIOR" then
        specs = {
            { name = "Arms", icon = "Interface\\Icons\\Ability_Rogue_Eviscerate" },
            { name = "Fury", icon = "Interface\\Icons\\Ability_Warrior_InnerRage" },
            { name = "Protection", icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance" }
        }
    elseif playerClass == "PALADIN" then
        specs = {
            { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_HolyBolt" },
            { name = "Protection", icon = "Interface\\Icons\\Ability_Paladin_ShieldoftheTemplar" },
            { name = "Retribution", icon = "Interface\\Icons\\Spell_Holy_AuraOfLight" }
        }
    elseif playerClass == "HUNTER" then
        specs = {
            { name = "Beast Mastery", icon = "Interface\\Icons\\Ability_Hunter_BeastTaming" },
            { name = "Marksmanship", icon = "Interface\\Icons\\Ability_Marksmanship" },
            { name = "Survival", icon = "Interface\\Icons\\Ability_Hunter_SwiftStrike" }
        }
    elseif playerClass == "ROGUE" then
        specs = {
            { name = "Assassination", icon = "Interface\\Icons\\Ability_Rogue_Eviscerate" },
            { name = "Combat", icon = "Interface\\Icons\\Ability_BackStab" },
            { name = "Subtlety", icon = "Interface\\Icons\\Ability_Stealth" }
        }
    elseif playerClass == "PRIEST" then
        specs = {
            { name = "Discipline", icon = "Interface\\Icons\\Spell_Holy_WordFortitude" },
            { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_GuardianSpirit" },
            { name = "Shadow", icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain" }
        }
    elseif playerClass == "DEATHKNIGHT" then
        specs = {
            { name = "Blood", icon = "Interface\\Icons\\Spell_Deathknight_BloodPresence" },
            { name = "Frost", icon = "Interface\\Icons\\Spell_Deathknight_FrostPresence" },
            { name = "Unholy", icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence" }
        }
    elseif playerClass == "SHAMAN" then
        specs = {
            { name = "Elemental", icon = "Interface\\Icons\\Spell_Nature_Lightning" },
            { name = "Enhancement", icon = "Interface\\Icons\\Spell_Nature_LightningShield" },
            { name = "Restoration", icon = "Interface\\Icons\\Spell_Nature_MagicImmunity" }
        }
    elseif playerClass == "MAGE" then
        specs = {
            { name = "Arcane", icon = "Interface\\Icons\\Spell_Holy_MagicalSentry" },
            { name = "Fire", icon = "Interface\\Icons\\Spell_Fire_FireBolt02" },
            { name = "Frost", icon = "Interface\\Icons\\Spell_Frost_FrostBolt02" }
        }
    elseif playerClass == "WARLOCK" then
        specs = {
            { name = "Affliction", icon = "Interface\\Icons\\Spell_Shadow_DeathCoil" },
            { name = "Demonology", icon = "Interface\\Icons\\Spell_Shadow_Metamorphosis" },
            { name = "Destruction", icon = "Interface\\Icons\\Spell_Shadow_RainOfFire" }
        }
    elseif playerClass == "DRUID" then
        specs = {
            { name = "Balance", icon = "Interface\\Icons\\Spell_Nature_StarFall" },
            { name = "Feral Combat", icon = "Interface\\Icons\\Ability_Druid_CatForm" },
            { name = "Restoration", icon = "Interface\\Icons\\Spell_Nature_HealingTouch" }
        }
    end

    return specs
end

function SPEC_ICONS.GetActiveSpec()
    local _, playerClass = UnitClass("player")
    if not playerClass then return nil end

    -- Variables to track the most points spent in a talent tree
    local maxPoints = 0
    local activeSpecIndex = 0

    -- Iterate over the three talent trees
    for i = 1, 3 do
        local name, _, pointsSpent = GetTalentTabInfo(i)
        if pointsSpent > maxPoints then
            maxPoints = pointsSpent
            activeSpecIndex = i
        end
    end

    -- Map the active spec index to the appropriate spec name and icon
    local specs = SPEC_ICONS.GetPlayerSpecsAndIcons(playerClass)
    local activeSpec = specs[activeSpecIndex]

    return activeSpec
end
function SPEC_ICONS.GetActiveSpecIndex()
    local _, playerClass = UnitClass("player")
    if not playerClass then return nil end

    -- Variables to track the most points spent in a talent tree
    local maxPoints = 0
    local activeSpecIndex = 0

    -- Iterate over the three talent trees
    for i = 1, 3 do
        local name, _, pointsSpent = GetTalentTabInfo(i)
        if pointsSpent > maxPoints then
            maxPoints = pointsSpent
            activeSpecIndex = i
        end
    end


    return activeSpecIndex
end