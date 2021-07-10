-- E:\World of Warcraft\_classic_\WTF\Account\***REMOVED***\Earthfury\Zypth\SavedVariables
-- E:\World of Warcraft\_classic_\WTF\Account\***REMOVED***\SavedVariables
-- saved variable, table name: SANDBOXSV1
-- refs: https://wowpedia.fandom.com/wiki/Global_functions/Classic
HELLOWORLD_DB = {ADDON_NAME = "HelloWorld", ["test"] = 1}
HELLOWORLD_CHARACTER_DB = {["QUESTS_COMPLETED"] = {}}
SLOTS = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot",
    "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot",
    "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot",
    "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot"
}
-- stat ids
STAT_ID_STRENGTH = 1
STAT_ID_AGILITY = 2
STAT_ID_STAMINA = 3
STAT_ID_INTELLECT = 4
STAT_ID_SPIRIT = 5
-- spell tree globals
SPELL_TREE_ID_PHYSICAL = 1
SPELL_TREE_ID_HOLY = 2
SPELL_TREE_ID_FIRE = 3
SPELL_TREE_ID_NATURE = 4
SPELL_TREE_ID_FROST = 5
SPELL_TREE_ID_SHADOW = 6
SPELL_TREE_ID_ARCANE = 7
-- combat rating globals
CR_UNUSED_1 = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_CORRUPTION = 12;
CR_CORRUPTION_RESISTANCE = 13;
CR_SPEED = 14;
COMBAT_RATING_RESILIENCE_CRIT_TAKEN = 15;
COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
CR_LIFESTEAL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_AVOIDANCE = 21;
CR_UNUSED_2 = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
CR_ARMOR_PENETRATION = 25;
CR_MASTERY = 26;
CR_UNUSED_3 = 27;
CR_UNUSED_4 = 28;
CR_VERSATILITY_DAMAGE_DONE = 29;
CR_VERSATILITY_DAMAGE_TAKEN = 31;
COMBAT_RATINGS = {
    [1] = "CR_UNUSED_1",
    [2] = "CR_DEFENSE_SKILL",
    [3] = "CR_DODGE",
    [4] = "CR_PARRY",
    [5] = "CR_BLOCK",
    [6] = "CR_HIT_MELEE",
    [7] = "CR_HIT_RANGED",
    [8] = "CR_HIT_SPELL",
    [9] = "CR_CRIT_MELEE",
    [10] = "CR_CRIT_RANGED",
    [11] = "CR_CRIT_SPELL",
    [12] = "CR_CORRUPTION",
    [13] = "CR_CORRUPTION_RESISTANCE",
    [14] = "CR_SPEED",
    [15] = "COMBAT_RATING_RESILIENCE_CRIT_TAKEN",
    [16] = "COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN",
    [17] = "CR_LIFESTEAL",
    [18] = "CR_HASTE_MELEE",
    [19] = "CR_HASTE_RANGED",
    [20] = "CR_HASTE_SPELL",
    [21] = "CR_AVOIDANCE",
    [22] = "CR_UNUSED_2",
    [23] = "CR_WEAPON_SKILL_RANGED",
    [24] = "CR_EXPERTISE",
    [25] = "CR_ARMOR_PENETRATION",
    [26] = "CR_MASTERY",
    [27] = "CR_UNUSED_3",
    [28] = "CR_UNUSED_4",
    [29] = "CR_VERSATILITY_DAMAGE_DONE",
    [30] = "CR_VERSATILITY_DAMAGE_TAKEN"
}

function HelloWorldEditBox_Show(text)
    if not HelloWorldEditBox then
        local f = CreateFrame("Frame", "HelloWorldEditBox", UIParent,
                              "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(600, 500)

        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = {left = 8, right = 6, top = 8, bottom = 8}
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue

        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then self:StartMoving() end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)

        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "HelloWorldEditBoxScrollFrame",
                               HelloWorldEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", HelloWorldEditBoxButton, "TOP", 0, 0)

        -- EditBox
        local eb = CreateFrame("EditBox", "HelloWorldEditBoxEditBox",
                               HelloWorldEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)

        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)

        local rb = CreateFrame("Button", "HelloWorldEditBoxResizeButton",
                               HelloWorldEditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)

        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture(
            "Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end

    if text then HelloWorldEditBoxEditBox:SetText(text) end
    HelloWorldEditBox:Show()
end

function TestHelloWorld(t)
    t = t and wipe(t) or {}
    for i = 1, 10 do
        print(i)
        tinsert(t, strjoin(";", i, i, i))
    end
    print("test complete")
    return t
end

-- /run GetAvailableQuests(HELLOWORLD_DB)
function GetAvailableQuests(t)
    t = t and wipe(t) or {}
    for id in pairs(GetQuestsCompleted()) do
        local name = C_QuestLog.GetQuestInfo(id)
        print(id, name)
    end
end

-- /run GetCharacterInfo()
function GetCharacterInfo()
    local character = {}
    local name, _ = UnitName("player")
    local realm = GetRealmName()

    character.name = name
    character.realm = realm
    character.race = 	UnitRace("player")
    character.equipment = GetEquipmentInfo()
    character.stats = GetStats()
    character.availableQuests = GetAvailableQusts()
    character.level = UnitLevel("player")
    character.class = {}
    character.class.name, character.class.filename, character.class.id =
        UnitClass("player")
    character.power = {}
    character.power.type, character.power.token, _, _, _ = UnitPowerType(
                                                               "player");
    character.power.max = UnitPowerMax("player")

    HelloWorldEditBox_Show(json.encode(character))
end

function GetStats()
    local stats = {}
    -- overall, equipped = GetAverageItemLevel() -- fn does not exit
    stats.maxHealth = UnitHealthMax("player")

    -- base
    stats.base = {
      strength = {},
      agility = {},
      stamina = {},
      intellect = {},
      spirit = {}
    }
    stats.base.strength.base, stats.base.strength.stat, stats.base.strength.posBuff, stats.base.strength.negBuff = UnitStat("player", STAT_ID_STRENGTH)
    stats.base.agility.base, stats.base.agility.stat, stats.base.agility.posBuff, stats.base.agility.negBuff = UnitStat("player", STAT_ID_AGILITY)
    stats.base.stamina.base, stats.base.stamina.stat, stats.base.stamina.posBuff, stats.base.stamina.negBuff = UnitStat("player", STAT_ID_STAMINA)
    stats.base.intellect.base, stats.base.intellect.stat, stats.base.intellect.posBuff, stats.base.intellect.negBuff = UnitStat("player", STAT_ID_INTELLECT)
    stats.base.spirit.base, stats.base.spirit.stat, stats.base.spirit.posBuff, stats.base.spirit.negBuff = UnitStat("player", STAT_ID_SPIRIT)
    stats.base.armor, _, _, _, _ = UnitArmor("player")
    -- defenses
    stats.defenses = {}
    stats.defenses.armor, _, _, _, _ = UnitArmor("player")
    stats.defenses.defense = {}
    stats.defenses.defense.baseDefense, stats.defenses.defense.armorDefense =
        UnitDefense("player");
    stats.defenses.defense.rating = GetCombatRating(16)
    stats.defenses.dodgeChance = GetDodgeChance()
    stats.defenses.blockChance = GetBlockChance()
    stats.defenses.parryChance = GetParryChance()
    -- melee
    local attackPower, _, _ = UnitAttackPower("player");
    stats.melee = {}
    stats.melee.attack = {}
    stats.melee.attack.power = attackPower
    stats.melee.attack.mainSpeed, stats.melee.attack.offSpeed = UnitAttackSpeed(
                                                                    "player");
    stats.melee.damage = {}
    stats.melee.speed = {}
    stats.melee.speed.haste = GetMeleeHaste()
    stats.melee.damage.lowDmg, stats.melee.damage.hiDmg, stats.melee.damage
        .offlowDmg, stats.melee.damage.offhiDmg, stats.melee.damage.posBuff, stats.melee
        .damage.negBuff, stats.melee.damage.percentmod = UnitDamage("player");
    stats.melee.hit = GetHitModifier()
    stats.melee.expertise = {}
    stats.melee.expertise.main, stats.melee.expertise.offhand =
        GetExpertisePercent();
    -- ranged
    stats.ranged = {}
    stats.ranged.damage = {}
    stats.ranged.speed = {}
    stats.ranged.speed.haste = GetRangedHaste()
    stats.ranged.speed.attack, stats.ranged.damage.lowDmg, stats.ranged.damage
        .hiDmg, _, _, stats.ranged.damage.percent = UnitRangedDamage("player");
    stats.ranged.power, stats.ranged.posBuff, stats.ranged.negBuff =
        UnitRangedAttackPower("player");
    stats.ranged.attack, stats.ranged.attackModifier =
        UnitRangedAttack("player")
    -- spell
    stats.spell = {}
    stats.spell.bonusDamage = {
        ["physical"] = GetSpellBonusDamage(SPELL_TREE_ID_PHYSICAL),
        ["holy"] = GetSpellBonusDamage(SPELL_TREE_ID_HOLY),
        ["fire"] = GetSpellBonusDamage(SPELL_TREE_ID_FIRE),
        ["nature"] = GetSpellBonusDamage(SPELL_TREE_ID_NATURE),
        ["frost"] = GetSpellBonusDamage(SPELL_TREE_ID_FROST),
        ["shadow"] = GetSpellBonusDamage(SPELL_TREE_ID_SHADOW),
        ["arcane"] = GetSpellBonusDamage(SPELL_TREE_ID_ARCANE)
    }
    stats.spell.bonusHealing = GetSpellBonusHealing();
    stats.spell.hit = GetSpellHitModifier()
    stats.spell.crit = {
        ["physical"] = GetSpellCritChance(SPELL_TREE_ID_PHYSICAL),
        ["holy"] = GetSpellCritChance(SPELL_TREE_ID_HOLY),
        ["fire"] = GetSpellCritChance(SPELL_TREE_ID_FIRE),
        ["nature"] = GetSpellCritChance(SPELL_TREE_ID_NATURE),
        ["frost"] = GetSpellCritChance(SPELL_TREE_ID_FROST),
        ["shadow"] = GetSpellCritChance(SPELL_TREE_ID_SHADOW),
        ["arcane"] = GetSpellCritChance(SPELL_TREE_ID_ARCANE)
    }
    stats.spell.haste = GetRangedHaste()
    stats.spell.manaRegen = {}
    stats.spell.manaRegen.base, stats.spell.manaRegen.casting = GetManaRegen()
    -- combat ratings
    stats.combatRatings = {}
    for k, v in pairs(COMBAT_RATINGS) do
        stats.combatRatings[v] = GetCombatRating(k)
    end
    --   stats.combatRating = {}
    --   for var=1,31 do
    --     stats.combatRating[tostring(var)] = GetCombatRating(var)
    --  end
    return stats
end

function GetAvailableQusts()
    t = {}
    for id in pairs(GetQuestsCompleted()) do
        local quest = C_QuestLog.GetQuestInfo(id)
        t[tostring(id)] = quest
    end
    return t
end

-- /run SetAvailableQuests(HELLOWORLD_DB)
-- /run SetAvailableQuests(HELLOWORLD_CHARACTER_DB)
function SetAvailableQuests()
    HELLOWORLD_CHARACTER_DB["QUESTS_COMPLETED"] = {}
    for id in pairs(GetQuestsCompleted()) do
        local quest = C_QuestLog.GetQuestInfo(id)
        local name = quest
        print(id, name)
        HELLOWORLD_CHARACTER_DB["QUESTS_COMPLETED"][id] = quest
        -- tinsert(t, id, quest)
    end
end

function Temp() print("Hello World!") end

MyEventFrame = CreateFrame("Frame", "MyEventFrame", UIParent)
MyEventFrame:RegisterEvent("INSPECT_READY")

function MyCombatFrame_OnEvent(self, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        print("Leaving combat...")
    elseif event == "PLAYER_REGEN_DISABLED" then
        print("Entering combat!")
    elseif event == "INSPECT_READY" then
        print("Inspect is ready!!!")
    end
end
-- MyCombatFrame:SetScript("OnEvent", MyCombatFrame_OnEvent)
MyEventFrame:SetScript("OnEvent", MyCombatFrame_OnEvent)

function TestInpect()
    if CanInspect(unit) then
        if InspectFrame then
            if not InspectFrame:IsShown() then
                InspectFrame.unit = "player"
                NotifyInspect(unit)
            end
        else
            NotifyInspect(unit)
        end
    end
end

-- /run GetHeadSlotInfo()
function GetHeadSlotInfo()
    -- local headslotLink = GetInventoryItemLink("player", GetInventorySlotInfo("HEADSLOT"))
    local slotId = GetInventorySlotInfo("HEADSLOT")
    local link = GetInventoryItemLink("player", slotId)
    -- see: https://wowwiki-archive.fandom.com/wiki/API_GetItemInfo
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
          itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
        GetItemInfo(link)
    local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix,
          Unique, LinkLvl, Name = string.find(itemLink,
                                              "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    print("itemName: ", itemName)
    -- itemLink can be parsed: https://wowpedia.fandom.com/wiki/ItemLink
    print("itemLink: ", itemLink)
    print("\t Color: ", Color)
    print("\t Ltype: ", Ltype)
    print("\t Id: ", Id)
    print("\t Enchant: ", Enchant)
    print("\t Gem1: ", Gem1)
    print("\t Gem2: ", Gem2)
    print("\t Gem3: ", Gem3)
    print("\t Gem4: ", Gem4)
    print("\t Suffix: ", Suffix)
    print("\t Unique: ", Unique)
    print("\t LinkLvl: ", LinkLvl)
    print("\t Name: ", Name)
    print("itemRarity: ", itemRarity)
    print("itemLevel: ", itemLevel)
    print("itemMinLevel: ", itemMinLevel)
    print("itemType: ", itemType)
    print("itemSubType: ", itemSubType)
    print("itemStackCount: ", itemStackCount)
    print("itemEquipLoc: ", itemEquipLoc)
    print("itemTexture: ", itemTexture)
    print("itemSellPrice: ", itemSellPrice)
    print("----")
    print(enchantId)
    print(gem1)
    print(gem2)
    print(gem3)
    print(gem4)
    print(itemType)
end

-- /run GetSlotInfo(slot)
function GetSlotInfo(slot)
    local item = {}
    -- local headslotLink = GetInventoryItemLink("player", GetInventorySlotInfo("HEADSLOT"))
    local slotId = GetInventorySlotInfo(slot)
    local link = GetInventoryItemLink("player", slotId)
    -- if there is a link, we can get data
    if link then
        -- see: https://wowwiki-archive.fandom.com/wiki/ItemLink#Printing_links_for_debug
        linkText = gsub(link, "\124", "\124\124");
        -- see: https://wowwiki-archive.fandom.com/wiki/API_GetItemInfo
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
              itemSubType, itemStackCount, itemEquipLoc, itemTexture,
              itemSellPrice = GetItemInfo(link)
        local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix,
              Unique, LinkLvl, Name = string.find(itemLink,
                                                  "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

        item.name = itemName
        item.color = Color
        item.level = itemLevel
        item.minLevel = itemMinLevel
        item.rarity = itemRarity
        item.id = Id
        item.link = itemLink
        item.linkText = linkText
        item.linkLevel = LinkLvl
        item.ltype = Ltype
        item.enchant = Enchant
        item.gems = {}
        item.gems = {[1] = Gem1, [2] = Gem2, [3] = Gem3, [4] = Gem4}
        item.suffix = Suffix
        item.unique = Unique
        item.type = itemType
        item.subtype = itemSubType
        item.stackCount = item.stackCount
        item.equipLoc = itemEquipLoc
        item.texture = itemTexture
        item.sellPrice = itemSellPrice
    else
        print("no item equiped in this slot!")
    end
    return item
end

-- /run GetEquipmentInfo()
function GetEquipmentInfo()
    equipment = {}
    for k, v in pairs(SLOTS) do equipment[k] = GetSlotInfo(v) end
    return equipment
end
