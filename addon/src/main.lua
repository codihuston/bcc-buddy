-- E:\World of Warcraft\_classic_\WTF\Account\***REMOVED***\Earthfury\Zypth\SavedVariables
-- E:\World of Warcraft\_classic_\WTF\Account\***REMOVED***\SavedVariables
-- saved variable, table name: SANDBOXSV1
HELLOWORLD_DB = {ADDON_NAME = "HelloWorld", ["test"] = 1}
HELLOWORLD_CHARACTER_DB = {["QUESTS_COMPLETED"] = {}}
SLOTS = {
  "HeadSlot",
  "NeckSlot",
  "ShoulderSlot",
  "BackSlot",
  "ChestSlot",
  "ShirtSlot",
  "TabardSlot",
  "WristSlot",
  "HandsSlot",
  "WaistSlot",
  "LegsSlot",
  "FeetSlot",
  "Finger0Slot",
  "Finger1Slot",
  "Trinket0Slot",
  "Trinket1Slot",
  "MainHandSlot",
  "SecondaryHandSlot",
}

function HelloWorld_OnLoad(self) print("HelloWorld loaded!") end

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
    local name, _ = UnitName("player")
    local realm = GetRealmName()
    print("Unit Name: ", name)
    print("Realm Name:", realm)
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
  -- local headslotLink = GetInventoryItemLink("player", GetInventorySlotInfo("HEADSLOT"))
  local slotId = GetInventorySlotInfo(slot)
  local link = GetInventoryItemLink("player", slotId)
  -- if there is a link, we can get data
  if link then
    print("QQQ link", link)
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
  else
    print("no item equiped in this slot!")
  end
end

-- /run GetEquipmentInfo()
function GetEquipmentInfo()
  for k,v in pairs(SLOTS) do 
    print("--- start get slot info", k, v)
    GetSlotInfo(v)
    print("--- end get slot info", k, v)
  end
end