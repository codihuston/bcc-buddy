-- refs: https://wowpedia.fandom.com/wiki/Global_functions/Classic
local LibDeflate
if LibStub then -- You are using LibDeflate as WoW addon
    LibDeflate = LibStub:GetLibrary("LibDeflate")
else
    LibDeflate = require("LibDeflate")
end

local example_input = "12123123412345123456123456712345678123456789"

--- Compress using raw deflate format
local compress_deflate = LibDeflate:CompressDeflate(example_input)
print("compresS", compress_deflate)

-- decompress
local decompress_deflate = LibDeflate:DecompressDeflate(compress_deflate)
print("decomporess", decompress_deflate)

-- Check if the first return value of DecompressXXXX is non-nil to know if the
-- decompression succeeds.
if decompress_deflate == nil then
    error("Decompression fails.")
else
    -- Decompression succeeds.
    assert(example_input == decompress_deflate)
end

function BCCBuddyEditBox_Show(text)
    if not BCCBuddyEditBox then
        local f = CreateFrame("Frame", "BCCBuddyEditBox", UIParent,
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
        local sf = CreateFrame("ScrollFrame", "BCCBuddyEditBoxScrollFrame",
                               BCCBuddyEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", BCCBuddyEditBoxButton, "TOP", 0, 0)

        -- EditBox
        local eb = CreateFrame("EditBox", "BCCBuddyEditBoxEditBox",
                               BCCBuddyEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)

        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)

        local rb = CreateFrame("Button", "BCCBuddyEditBoxResizeButton",
                               BCCBuddyEditBox)
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

    if text then BCCBuddyEditBoxEditBox:SetText(text) end
    BCCBuddyEditBox:Show()
end

-- /run GetCharacterInfo(true)
-- /run GetCharacterInfo(false)
function GetCharacterInfo(compress)
    local character = {}
    local name, _ = UnitName("player")
    local realm = GetRealmName()

    character.name = name
    character.realm = realm
    character.race = UnitRace("player")
    character.equipment = GetEquipmentInfo()
    character.stats = GetStats()
    character.completedQuests = GetCompletedQuests()
    character.talents = GetPlayerTalentInfo()
    character.level = UnitLevel("player")
    character.class = {}
    character.class.name, character.class.filename, character.class.id =
        UnitClass("player")
    character.power = {}
    character.power.type, character.power.token, _, _, _ = UnitPowerType(
                                                               "player");
    character.power.max = UnitPowerMax("player")

    local input = json.encode(character)

    if compress then
        local printable_compressed = LibDeflate:EncodeForPrint(input)
        BCCBuddyEditBox_Show(printable_compressed)
    else
        BCCBuddyEditBox_Show(input)
    end
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
    stats.base.strength.base, stats.base.strength.stat, stats.base.strength
        .posBuff, stats.base.strength.negBuff = UnitStat("player",
                                                         STAT_ID_STRENGTH)
    stats.base.agility.base, stats.base.agility.stat, stats.base.agility.posBuff, stats.base
        .agility.negBuff = UnitStat("player", STAT_ID_AGILITY)
    stats.base.stamina.base, stats.base.stamina.stat, stats.base.stamina.posBuff, stats.base
        .stamina.negBuff = UnitStat("player", STAT_ID_STAMINA)
    stats.base.intellect.base, stats.base.intellect.stat, stats.base.intellect
        .posBuff, stats.base.intellect.negBuff = UnitStat("player",
                                                          STAT_ID_INTELLECT)
    stats.base.spirit.base, stats.base.spirit.stat, stats.base.spirit.posBuff, stats.base
        .spirit.negBuff = UnitStat("player", STAT_ID_SPIRIT)
    stats.base.armor, _, _, _, _ = UnitArmor("player")
    -- defenses
    stats.defenses = {}
    stats.defenses.armor, _, _, _, _ = UnitArmor("player")
    stats.defenses.defense = {}
    stats.defenses.defense.base, stats.defenses.defense.armor = UnitDefense(
                                                                    "player");
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
    return stats
end

function GetCompletedQuests()
    quests = {}
    for id in pairs(GetQuestsCompleted()) do
        local name = C_QuestLog.GetQuestInfo(id)
        quests[tostring(id)] = name
    end
    return quests
end

-- /run GetPlayerTalentInfo()
function GetPlayerTalentInfo()
    talents = {}

    for tabIndex = 1, GetNumTalentTabs() do
        talentTab = {}
        talentTab.talents = {}

        talentTab.id, talentTab.name, talentTab.total, talentTab.iconTexture, talentTab.pointsSpent, talentTab.background, talentTab.previewPointsSpent, talentTab.isUnlocked =
            GetTalentTabInfo(tabIndex)

        for talentIndex = 1, GetNumTalents(tabIndex) do
            talent = {}
            talent.name, talent.icon, talent.tier, talent.column, talent.currRank, talent.maxRank =
                GetTalentInfo(tabIndex, talentIndex);
            talentTab.talents[talentIndex] = talent
        end

        talents[tabIndex] = talentTab
    end

    return talents
end

-- /run SetAvailableQuests(BCCBuddy_CHARACTER_DB)
function SetAvailableQuests()
    BCCBuddy_CHARACTER_DB["QUESTS_COMPLETED"] = {}
    for id in pairs(GetQuestsCompleted()) do
        local quest = C_QuestLog.GetQuestInfo(id)
        local name = quest
        print(id, name)
        BCCBuddy_CHARACTER_DB["QUESTS_COMPLETED"][id] = quest
        -- tinsert(t, id, quest)
    end
end

-- /run GetEquipmentInfo()
function GetEquipmentInfo()
    equipment = {}
    for k, v in pairs(SLOTS) do equipment[k] = GetSlotInfo(v) end
    return equipment
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
        -- print("no item equiped in this slot!")
    end
    return item
end
