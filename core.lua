local _, SimPermut = ...

SimPermut = LibStub("AceAddon-3.0"):NewAddon(SimPermut, "SimPermut", "AceConsole-3.0", "AceEvent-3.0")

local OFFSET_ITEM_ID 	= 1
local OFFSET_ENCHANT_ID = 2
local OFFSET_GEM_ID_1 	= 3
local OFFSET_GEM_ID_2 	= 4
local OFFSET_GEM_ID_3 	= 5
local OFFSET_GEM_ID_4 	= 6
local OFFSET_SUFFIX_ID 	= 7
local OFFSET_FLAGS 		= 11
local OFFSET_BONUS_ID 	= 13
local ITEM_THRESHOLD 	= 800

-- Artifact stuff (adapted from LibArtifactData [https://www.wowace.com/addons/libartifactdata-1-0/], thanks!)
local ArtifactUI          = _G.C_ArtifactUI
local HasArtifactEquipped = _G.HasArtifactEquipped
local SocketInventoryItem = _G.SocketInventoryItem
local Timer               = _G.C_Timer
local AceGUI 			  = LibStub("AceGUI-3.0")

--UI
local mainFrame 
local scroll
local multiLineEditBox		  
local dropdownEnchant
local dropdownGem
local checkBoxForce
local actualSlot=""
local actualEnchant=0
local actualGem=0
local actualForce=false
local tableLabel={}
local tableCheckBoxes={}
local tableLinkPermut={}

-- load stuff from extras.lua
local slotNames     = SimPermut.slotNames
local simcSlotNames = SimPermut.simcSlotNames
local listNames 	= SimPermut.listNames
local specNames     = SimPermut.SpecNames
local profNames     = SimPermut.ProfNames
local regionString  = SimPermut.RegionString
local artifactTable = SimPermut.ArtifactTable
local gemList 		= SimPermut.gemList
local enchantRing 	= SimPermut.enchantRing
local enchantCloak 	= SimPermut.enchantCloak
local enchantNeck 	= SimPermut.enchantNeck

SLASH_SIMPERMUTSLASH1 = "/SimPermut"

SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	local argL = strlower(arg)
	if string.len(arg) == 0 then 
		SimPermut:BuildFrame()
	else
		SimPermut:PrintCompare(argL,false)
	end
end

function SimPermut:OnInitialize()
	SlashCmdList["SimPermut"] = handler;
end

function SimPermut:OnEnable()
  SimPermutTooltip:SetOwner(_G.UIParent,"ANCHOR_LEFT")
end

function SimPermut:OnDisable()

end

function SimPermut:BuildFrame()
	local buttonGetItems
	local buttonGenerate
	local linkTable={}
	
	
	mainframe = AceGUI:Create("Frame")
	mainframe:SetTitle("SimPermut")
	mainframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	mainframe:SetLayout("Flow")
	mainframe:SetWidth(1000)
	mainframe:SetHeight(750)
	
	local ddg = AceGUI:Create("DropdownGroup")
    ddg:SetFullWidth(true)
    ddg:SetLayout("Flow")
    ddg:SetDropdownWidth(120)
    ddg:SetGroupList(listNames)
    local selfref = self
    ddg:SetCallback("OnGroupSelected",function (this, event, item)
		actualSlot=listNames[item]
		buttonGenerate:SetDisabled(false)
		checkBoxForce:SetDisabled(false)
		scroll:ReleaseChildren()
		tableLabel={}
		tableCheckBoxes={}
		tableLinkPermut={}
		linkTable = SimPermut:GetListItem(actualSlot)
		SimPermut:BuildItemFrame(linkTable)
		SimPermut:LoadPermut(actualSlot)
		
    end)
	
	local labelSpacer1= AceGUI:Create("Label")
	labelSpacer1:SetFullWidth(true)
	labelSpacer1:SetText(" ")
	ddg:AddChild(labelSpacer1)
	
	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetHeight(500)
	scrollcontainer:SetLayout("Fill")
	ddg:AddChild(scrollcontainer)
	
	scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)

	local labelEnchant= AceGUI:Create("Label")
	labelEnchant:SetText("Enchant")
	labelEnchant:SetWidth(100)
	
	dropdownEnchant = AceGUI:Create("Dropdown")
	dropdownEnchant:SetDisabled(true)
	dropdownEnchant:SetWidth(160)
	dropdownEnchant:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchant=item
    end)
	dropdownEnchant:SetValue("")
	
	local labelGem= AceGUI:Create("Label")
	labelGem:SetText("      Gem")
	labelGem:SetWidth(80)
	
	dropdownGem = AceGUI:Create("Dropdown")
	dropdownGem:SetList(gemList)
	dropdownGem:SetDisabled(true)
	dropdownGem:SetWidth(160)
	dropdownGem:SetCallback("OnValueChanged", function (this, event, item)
		actualGem=item
    end)
	dropdownGem:SetValue("")
	
	local labelSpacer2= AceGUI:Create("Label")
	labelSpacer2:SetText(" ")
	labelSpacer2:SetWidth(20)
	
	checkBoxForce = AceGUI:Create("CheckBox")
	checkBoxForce:SetWidth(100)
	checkBoxForce:SetLabel("Force")
	checkBoxForce:SetDisabled(true)
	checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		actualForce=checkBoxForce:GetValue()
    end)
	
	local labelSpacer3= AceGUI:Create("Label")
	labelSpacer3:SetText(" ")
	labelSpacer3:SetWidth(80)

	buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetDisabled(true)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:GetTableLink(linkTable)
		SimPermut:PrintCompare(actualSlot,true) 
	end)
	
	ddg:AddChild(labelEnchant)
	ddg:AddChild(dropdownEnchant)
	ddg:AddChild(labelGem)
	ddg:AddChild(dropdownGem)
	ddg:AddChild(labelSpacer2)
	ddg:AddChild(checkBoxForce)
	ddg:AddChild(labelSpacer3)
	ddg:AddChild(buttonGenerate)
	
	mainframe:AddChild(ddg)
end

function SimPermut:BuildItemFrame(linkTable)
	for i=1 ,#linkTable do
		--print(i)
		tableCheckBoxes[i]=AceGUI:Create("CheckBox")
		tableCheckBoxes[i]:SetLabel("")
		tableCheckBoxes[i]:SetRelativeWidth(0.05)
		tableCheckBoxes[i]:SetValue(true)
		scroll:AddChild(tableCheckBoxes[i])
		
		tableLabel[i]=AceGUI:Create("InteractiveLabel")
		tableLabel[i]:SetText(linkTable[i])
		tableLabel[i]:SetRelativeWidth(0.95)
		--tableLabel[i]:SetFullWidth(true)
		tableLabel[i]:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetHyperlink(linkTable[i])
			GameTooltip:Show()
		end)
		tableLabel[i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
		scroll:AddChild(tableLabel[i])
		--multiLineEditBox:SetText(multiLineEditBox:GetText()..'\n'..linkTable[i])
	end
end

-- Load items and dropdown
function SimPermut:LoadPermut(item)
	dropdownGem:SetDisabled(false)
	
	if actualGem==0 then
		dropdownGem:SetValue(0)
		actualGem=0
	end
	
	if item == "back" then
		dropdownEnchant:SetDisabled(false)
		dropdownEnchant:SetList(enchantCloak)
		dropdownEnchant:SetValue(0)
		actualEnchant=0
	elseif item == "finger" then
		dropdownEnchant:SetDisabled(false)
		dropdownEnchant:SetList(enchantRing)
		dropdownEnchant:SetValue(0)
		actualEnchant=0
	elseif item == "neck" then
		dropdownEnchant:SetDisabled(false)
		dropdownEnchant:SetList(enchantNeck)
		dropdownEnchant:SetValue(0)
		actualEnchant=0
	else
		dropdownEnchant:SetDisabled(true)
		dropdownEnchant:SetValue("Untouched")
		actualEnchant=0
	end
	
end

-- SimC tokenize function
local function tokenize(str)
  str = str or ""
  -- convert to lowercase and remove spaces
  str = string.lower(str)
  str = string.gsub(str, ' ', '_')

  -- keep stuff we want, dumpster everything else
  local s = ""
  for i=1,str:len() do
    -- keep digits 0-9
    if str:byte(i) >= 48 and str:byte(i) <= 57 then
      s = s .. str:sub(i,i)
      -- keep lowercase letters
    elseif str:byte(i) >= 97 and str:byte(i) <= 122 then
      s = s .. str:sub(i,i)
      -- keep %, +, ., _
    elseif str:byte(i)==37 or str:byte(i)==43 or str:byte(i)==46 or str:byte(i)==95 then
      s = s .. str:sub(i,i)
    end
  end
  -- strip trailing spaces
  if string.sub(s, s:len())=='_' then
    s = string.sub(s, 0, s:len()-1)
  end
  return s
end

-- method for constructing the talent string
local function CreateSimcTalentString()
  local talentInfo = {}
  local maxTiers = 7
  local maxColumns = 3
  for tier = 1, maxTiers do
    for column = 1, maxColumns do
      local talentID, name, iconTexture, selected, available = GetTalentInfo(tier, column, GetActiveSpecGroup())
      if selected then
        talentInfo[tier] = column
      end
    end
  end

  local str = 'talents='
  for i = 1, maxTiers do
    if talentInfo[i] then
      str = str .. talentInfo[i]
    else
      str = str .. '0'
    end
  end

  return str
end

-- function that translates between the game's role values and ours
local function translateRole(str)
  if str == 'TANK' then
    return tokenize(str)
  elseif str == 'DAMAGER' then
    return 'attack'
  elseif str == 'HEALER' then
    return 'healer'
  else
    return ''
  end
end

-- Artifact Information
local function IsArtifactFrameOpen()
  local ArtifactFrame 	  = _G.ArtifactFrame
  return ArtifactFrame and ArtifactFrame:IsShown() or false
end

-- recupere la string de l'artefact
local function GetArtifactString()
  
  if not HasArtifactEquipped() then
    return nil
  end
  
  --local ArtifactFrame = _G.ArtifactFrame
  
  -- Unregister the events to prevent unwanted call. (thx Aethys :o)
  UIParent:UnregisterEvent("ARTIFACT_UPDATE");
  
  if not IsArtifactFrameOpen() then
    SocketInventoryItem(INVSLOT_MAINHAND)
  end

  local item_id = select(1, ArtifactUI.GetArtifactInfo())
  --print(item_id)
  if item_id == nil or item_id == 0 then
    return nil
  end

  local artifact_id = SimPermut.ArtifactTable[item_id]
  --print(artifact_id)
  if artifact_id == nil then
    return nil
  end

  -- Note, relics are handled by the item string
  local str = 'artifact=' .. artifact_id .. ':0:0:0:0'

  local powers = ArtifactUI.GetPowers()
  --print(powers)
  for i = 1, #powers do
    local power_id = powers[i]
    local _, _, currentRank, _, bonusRanks = ArtifactUI.GetPowerInfo(power_id)
    if currentRank > 0 and currentRank - bonusRanks > 0 then
      str = str .. ':' .. power_id .. ':' .. (currentRank - bonusRanks)
    end
  end
  --print(str)
  
  --if ArtifactFrame:IsShown() then
	--HideUIPanel(ArtifactFrame)
  --end
  
  UIParent:RegisterEvent("ARTIFACT_UPDATE");

  return str
end

-- donne le nom de la permutation
function SimPermut:GetCopyName(tableID,item1,item2)
	local name,ilvl
	name,_,_,ilvl=GetItemInfo(tableID[item1])
	local itemname1 = tokenize(name)..'('..ilvl..')'
	name,_,_,ilvl=GetItemInfo(tableID[item2])
	local itemname2 = tokenize(name)..'('..ilvl..')'
	
	return itemname1.."_"..itemname2
end

-- retire espace et tout et tout
function SimPermut:CleanString(str)
	--print(str)
	str = string.gsub(str, " ", "_")
	str = string.gsub(str, "'", "_")
	str = string.gsub(str, ":", "_")
	str = string.gsub(str, ",", "_")
	return str
end

-- recupere l'id a partir du lien de l'item
function SimPermut:GetIDFromLink(itemLink)
	local itemString = string.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}

	-- Split data into a table
	for v in string.gmatch(itemString, "(%d*:?)") do
		if v == ":" then
		  itemSplit[#itemSplit + 1] = 0
		else
		  itemSplit[#itemSplit + 1] = string.gsub(v, ':', '')
		end
	end

	return itemSplit[OFFSET_ITEM_ID]
end

-- recupere la string d'un lien item
function SimPermut:GetItemString(itemLink,itemType,base)
	local itemString = string.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}
	local simcItemOptions = {}
	local ilvl
	local hasGem=false
	--print(itemString)
	-- Split data into a table
	for v in string.gmatch(itemString, "(%d*:?)") do
		if v == ":" then
		  itemSplit[#itemSplit + 1] = 0
		else
		  itemSplit[#itemSplit + 1] = string.gsub(v, ':', '')
		end
	end
	
	-- Item id
	local itemId = itemSplit[OFFSET_ITEM_ID]
	simcItemOptions[#simcItemOptions + 1] = ',id=' .. itemId

	-- Enchant
	--print(base,itemType,actualForce,actualEnchant)
	if base then 
		if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
			simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
		end
	else
		if itemType=="neck" then
			if actualForce and actualEnchant~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
			else	
				if actualEnchant==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
				end
			end
		elseif itemType=="back" then
			if actualForce and actualEnchant~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
			else
				if actualEnchant==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
				end
			end
		elseif string.match(itemType, 'finger*') then
		--itemType=="finger1" or itemType=="finger2" or itemType=="finger")then
			if actualForce and actualEnchant~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
			else
				if actualEnchant==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchant
				end
			end
		else
			if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
			end
		end
	end

	-- New style item suffix, old suffix style not supported
	if tonumber(itemSplit[OFFSET_SUFFIX_ID]) ~= 0 then
		simcItemOptions[#simcItemOptions + 1] = 'suffix=' .. itemSplit[OFFSET_SUFFIX_ID]
	end

	local flags = tonumber(itemSplit[OFFSET_FLAGS])

	local bonuses = {}

	for index=1, tonumber(itemSplit[OFFSET_BONUS_ID]) do
		if tonumber(itemSplit[OFFSET_BONUS_ID + index])== 1808 then
			hasGem=true
		end
		bonuses[#bonuses + 1] = itemSplit[OFFSET_BONUS_ID + index]
	end

	if #bonuses > 0 then
		simcItemOptions[#simcItemOptions + 1] = 'bonus_id=' .. table.concat(bonuses, '/')
	end

	local rest_offset = OFFSET_BONUS_ID + #bonuses + 1


	-- Artifacts use this
	if bit.band(flags, 256) == 256 then
		rest_offset = rest_offset + 1 -- An unknown field
		local relic_str = ''
		while rest_offset < #itemSplit do
		  local n_bonus_ids = tonumber(itemSplit[rest_offset])
		  rest_offset = rest_offset + 1

		  if n_bonus_ids == 0 then
			relic_str = relic_str .. 0
		  else
			for rbid = 1, n_bonus_ids do
			  relic_str = relic_str .. itemSplit[rest_offset]
			  if rbid < n_bonus_ids then
				relic_str = relic_str .. ':'
			  end
			  rest_offset = rest_offset + 1
			end
		  end

		  if rest_offset < #itemSplit then
			relic_str = relic_str .. '/'
		  end
		end

		if relic_str ~= '' then
		  simcItemOptions[#simcItemOptions + 1] = 'relic_id=' .. relic_str
		end
	end

	-- Gems
	if base then
		if tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0 then
			simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. itemSplit[OFFSET_GEM_ID_1]
		end
	else
		if actualForce and actualGem~=0 then
			if actualGem~=0 and (hasGem or tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0) then
				simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. actualGem
			end
		else
			if tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0 then
				simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. itemSplit[OFFSET_GEM_ID_1]
			else
				if actualGem~=0 and hasGem then
					simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. actualGem
				end
			end
		end
	end
	
	--ilvl
	_,_,_,ilvl = GetItemInfo(itemLink)
	if ilvl ~= nil then
		simcItemOptions[#simcItemOptions + 1] = 'ilvl=' .. ilvl
	end
	
	return simcItemOptions
end

-- recupere la string de tous les items
function SimPermut:GetItemStrings()
  local items = {}
  
  
  for slotNum=1, #slotNames do
    local slotId = GetInventorySlotInfo(slotNames[slotNum])

    local itemLink = GetInventoryItemLink('player', slotId)
	local itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
	  local itemString=SimPermut:GetItemString(itemLink,simcSlotNames[slotNum],true)	
      items[slotNum] = simcSlotNames[slotNum] .. "=" .. table.concat(itemString, ',')
    end
  end

  return items
end

-- recupere les permutations de chaque item dans l'inventaire
function SimPermut:GetPermutations(strItem)
	local texture, count, locked, quality, readable, lootable, isFiltered, hasNoValue, itemId, itemLink, itemstring, permut, ilvl, name
	local permutTable={}
	local itemidTable={}
	local equippableItems = {}
	local copyname
	permut=""
	
	if strItem=="trinket" then
		local id, texture, checkRelic = GetInventorySlotInfo("Trinket1Slot")
		GetInventoryItemsForSlot(id, equippableItems)
		for locationBitstring, itemID in pairs(equippableItems) do
			local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
			if bags then
				texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemId = GetContainerItemInfo(bag, slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=itemId
					end
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
					end
				end
			end
		end
		
		for i=1 ,#permutTable do
			for j=i+1,#permutTable do
				copyname=SimPermut:GetCopyName(itemidTable,i,j)
				permut= permut .. "copy=" .. copyname .. '\n'
				permut= permut .. "trinket1=" .. table.concat(permutTable[i], ',') .. '\n'
				permut= permut .. "trinket2=" .. table.concat(permutTable[j], ',') .. '\n'
			end
		end
	elseif strItem=="finger" then
		local id, texture, checkRelic = GetInventorySlotInfo("Finger1Slot")
		GetInventoryItemsForSlot(id, equippableItems)
		for locationBitstring, itemID in pairs(equippableItems) do
			local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
			if bags then
				texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemId = GetContainerItemInfo(bag, slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=itemId
					end
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
					end
				end
			end
		end
		
		for i=1 ,#permutTable do
			for j=i+1,#permutTable do
				copyname=SimPermut:GetCopyName(itemidTable,i,j)
				permut= permut .. "copy=" .. copyname .. '\n'
				permut= permut .. "finger1=" .. table.concat(permutTable[i], ',') .. '\n'
				permut= permut .. "finger2=" .. table.concat(permutTable[j], ',') .. '\n'
			end
		end
	else
		local blizzardname,simcname,slotID
		if strItem=="head" then
			slotID=1
		elseif strItem=="neck" then
			slotID=2
		elseif strItem=="shoulder" then
			slotID=3
		elseif strItem=="back" then
			slotID=4
		elseif strItem=="chest" then
			slotID=5
		elseif strItem=="wrist" then
			slotID=8
		elseif strItem=="hands" then
			slotID=9
		elseif strItem=="waist" then
			slotID=10
		elseif strItem=="legs" then
			slotID=11
		elseif strItem=="feet" then
			slotID=12
		end
		blizzardname=SimPermut.slotNames[slotID]
		simcname=simcSlotNames[slotID]
		
		local id, texture, checkRelic = GetInventorySlotInfo(blizzardname)
		GetInventoryItemsForSlot(id, equippableItems)
		for locationBitstring, itemID in pairs(equippableItems) do
			local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
			if bags then
				texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemId = GetContainerItemInfo(bag, slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=itemId
					end
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					_,_,_,ilvl = GetItemInfo(itemLink)
					if ilvl>= ITEM_THRESHOLD then
						permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink,strItem,false)
						itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
					end
				end
			end
		end
		
		for i=1 ,#permutTable do
			name,_,_,ilvl=GetItemInfo(itemidTable[i])
			permut= permut .. "copy=" .. tokenize(name)..'('..ilvl..')' .. '\n'
			permut= permut .. simcname.."=" .. table.concat(permutTable[i], ',') .. '\n'
		end
			
	end
	
	return permut
end

-- récupère les permutations des items dans la tablelink
function SimPermut:GetPermutationsFromList(strItem)
	local permutTable={}
	local itemidTable={}
	local permut=""
	
	if strItem=="trinket" then
		for i=1, #tableLinkPermut do
			for j=i+1,#tableLinkPermut do
				name1,_,_,ilvl1=GetItemInfo(tableLinkPermut[i])
				name2,_,_,ilvl2=GetItemInfo(tableLinkPermut[j])
				permut= permut .. "copy=" .. tokenize(name1)..'('..ilvl1..')'.."_"..tokenize(name2)..'('..ilvl2..')' .. '\n'
				permut= permut .. "finger1=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[i],strItem,false), ',') .. '\n'
				permut= permut .. "finger2=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[j],strItem,false), ',') .. '\n'
			end
		end
	elseif strItem=="finger" then
		for i=1, #tableLinkPermut do
			for j=i+1,#tableLinkPermut do
				name1,_,_,ilvl1=GetItemInfo(tableLinkPermut[i])
				name2,_,_,ilvl2=GetItemInfo(tableLinkPermut[j])
				permut= permut .. "copy=" .. tokenize(name1)..'('..ilvl1..')'.."_"..tokenize(name2)..'('..ilvl2..')' .. '\n'
				permut= permut .. "finger1=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[i],strItem,false), ',') .. '\n'
				permut= permut .. "finger2=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[j],strItem,false), ',') .. '\n'
			end
		end
	else
		local blizzardname,simcname,slotID
		if strItem=="head" then
			slotID=1
		elseif strItem=="neck" then
			slotID=2
		elseif strItem=="shoulder" then
			slotID=3
		elseif strItem=="back" then
			slotID=4
		elseif strItem=="chest" then
			slotID=5
		elseif strItem=="wrist" then
			slotID=8
		elseif strItem=="hands" then
			slotID=9
		elseif strItem=="waist" then
			slotID=10
		elseif strItem=="legs" then
			slotID=11
		elseif strItem=="feet" then
			slotID=12
		end
		blizzardname=SimPermut.slotNames[slotID]
		simcname=simcSlotNames[slotID]
		
		for i=1, #tableLinkPermut do
			name,_,_,ilvl=GetItemInfo(tableLinkPermut[i])
			permut= permut .. "copy=" .. tokenize(name)..'('..ilvl..')' .. '\n'
			permut= permut .. simcname.."=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[i],strItem,false), ',') .. '\n'
		end
	end
	
	
	return permut
end

-- utilise la bonne fonction en fonction de si on utilise l'interface ou non
function SimPermut:WhichFunctionUse(strItem,fromInterface)
	if fromInterface then
		return SimPermut:GetPermutationsFromList(strItem)
	else
		return SimPermut:GetPermutations(strItem)
	end
end

-- recupere la liste des items pour l'afficher dans la multieditBox
function SimPermut:GetListItem(strItem)
	local texture, count, locked, quality, readable, lootable, isFiltered, hasNoValue, itemId, itemLink, itemstring, ilvl, name
	local permutTable={}
	local itemidTable={}
	local linkTable={}
	local equippableItems = {}
	local copyname
	
	local blizzardname,simcname,slotID
	if strItem=="head" then
		slotID=1
	elseif strItem=="neck" then
		slotID=2
	elseif strItem=="shoulder" then
		slotID=3
	elseif strItem=="back" then
		slotID=4
	elseif strItem=="chest" then
		slotID=5
	elseif strItem=="wrist" then
		slotID=8
	elseif strItem=="hands" then
		slotID=9
	elseif strItem=="waist" then
		slotID=10
	elseif strItem=="legs" then
		slotID=11
	elseif strItem=="feet" then
		slotID=12
	elseif strItem=="finger" then
		slotID=13
	elseif strItem=="trinket" then
		slotID=15
	end
	blizzardname=SimPermut.slotNames[slotID]
	simcname=simcSlotNames[slotID]
	--print(strItem,blizzardname,simcname)
	local id, texture, checkRelic = GetInventorySlotInfo(blizzardname)
	GetInventoryItemsForSlot(id, equippableItems)
	for locationBitstring, itemID in pairs(equippableItems) do
		local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
		if bags then
			texture, count, locked, quality, readable, lootable, itemLink, isFiltered, hasNoValue, itemId = GetContainerItemInfo(bag, slot)
			if itemLink~=nil then
				_,_,_,ilvl = GetItemInfo(itemLink)
				if ilvl>= ITEM_THRESHOLD then
					linkTable[#linkTable+1]=itemLink
				end
			end
		else
			itemLink = GetInventoryItemLink('player', slot)
			if itemLink~=nil then
				_,_,_,ilvl = GetItemInfo(itemLink)
				if ilvl>= ITEM_THRESHOLD then
					linkTable[#linkTable+1]=itemLink
				end
			end
		end
	end
	
	return linkTable
end

-- génère la table link a permutter
function SimPermut:GetTableLink(linkTable)
	tableLinkPermut={}
	
	for i=1,#linkTable do
		if tableCheckBoxes[i]:GetValue() then
			--print (linkTable[i])
			tableLinkPermut[#tableLinkPermut + 1] = linkTable[i]
		end
	end
end

-- fonction d'impression
function SimPermut:PrintCompare(arg,fromInterface)
  local playerName = UnitName('player')
  local _, playerClass = UnitClass('player')
  local playerLevel = UnitLevel('player')
  local playerRealm = GetRealmName()
  local playerRegion = regionString[GetCurrentRegion()]
  local bPermut=false

  --Prep affichage
  OpenAllBags()
  if not CharacterFrame:IsShown() then 
	ToggleCharacter("PaperDollFrame") 
  end
  
  -- Race info
  local _, playerRace = UnitRace('player')
  -- fix some races to match SimC format
  if playerRace == 'BloodElf' then
    playerRace = 'Blood Elf'
  elseif playerRace == 'NightElf' then
    playerRace = 'Night Elf'
  elseif playerRace == 'Scourge' then
    playerRace = 'Undead'
  end

  -- Spec info
  local role, globalSpecID
  local specId = GetSpecialization()
  if specId then
    globalSpecID,_,_,_,_,role = GetSpecializationInfo(specId)
  end
  local playerSpec = specNames[ globalSpecID ]

  -- Professions
  local pid1, pid2 = GetProfessions()
  local firstProf, firstProfRank, secondProf, secondProfRank, profOneId, profTwoId
  if pid1 then
    _,_,firstProfRank,_,_,_,profOneId = GetProfessionInfo(pid1)
  end
  if pid2 then
    secondProf,_,secondProfRank,_,_,_,profTwoId = GetProfessionInfo(pid2)
  end

  firstProf = profNames[ profOneId ]
  secondProf = profNames[ profTwoId ]

  local playerProfessions = ''
  if pid1 or pid2 then
    playerProfessions = 'professions='
    if pid1 then
      playerProfessions = playerProfessions..tokenize(firstProf)..'='..tostring(firstProfRank)..'/'
    end
    if pid2 then
      playerProfessions = playerProfessions..tokenize(secondProf)..'='..tostring(secondProfRank)
    end
  else
    playerProfessions = ''
  end

  -- Construct SimC-compatible strings from the basic information
  local player = tokenize(playerClass) .. '="' .. playerName .. '"'
  playerLevel = 'level=' .. playerLevel
  playerRace = 'race=' .. tokenize(playerRace)
  playerRole = 'role=' .. translateRole(role)
  playerSpec = 'spec=' .. tokenize(playerSpec)
  playerRealm = 'server=' .. tokenize(playerRealm)
  playerRegion = 'region=' .. tokenize(playerRegion)

  -- Talents are more involved - method to handle them
  local playerTalents = CreateSimcTalentString()
  local playerArtifact = GetArtifactString()

  -- Build the output string for the player (not including gear)
  local SimPermutProfile = player .. '\n'
  SimPermutProfile = SimPermutProfile .. playerLevel .. '\n'
  SimPermutProfile = SimPermutProfile .. playerRace .. '\n'
  SimPermutProfile = SimPermutProfile .. playerRegion .. '\n'
  SimPermutProfile = SimPermutProfile .. playerRealm .. '\n'
  SimPermutProfile = SimPermutProfile .. playerRole .. '\n'
  SimPermutProfile = SimPermutProfile .. playerProfessions .. '\n'
  SimPermutProfile = SimPermutProfile .. playerTalents .. '\n'
  SimPermutProfile = SimPermutProfile .. playerSpec .. '\n'
  if playerArtifact ~= nil then
    SimPermutProfile = SimPermutProfile .. playerArtifact .. '\n'
  end
  SimPermutProfile = SimPermutProfile .. '\n'

  -- Method that gets gear information
  local items = SimPermut:GetItemStrings()

  SimPermutProfile = SimPermutProfile .. "name=Base \n"
  -- output gear
  for slotNum=1, #slotNames do
    if items[slotNum] then
      SimPermutProfile = SimPermutProfile .. items[slotNum] .. '\n'
    end
  end
  
  --permutations
  if string.len(arg) ~= 0 then
	local permutations=""
	if arg=="trinket" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="finger" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="head" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="neck" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="shoulder" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="back" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="chest" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="wrist" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="hands" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="waist" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="legs" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	elseif arg=="feet" then
		permutations=SimPermut:WhichFunctionUse(arg,fromInterface)
		bPermut=true
	else
		SimPermutProfile = "Error: Items to compare not found!"
		bPermut=false
	end
	
	if bPermut then
		SimPermutProfile = SimPermutProfile .. permutations
	end
  end
  
  -- sanity checks - if there's anything that makes the output completely invalid, punt!
  if specId==nil then
    SimPermutProfile = "Error: You need to pick a spec!"
  end
  
  CloseAllBags()
  ToggleCharacter("PaperDollFrame")

  -- show the appropriate frames
  SimcCopyFrame:Show()
  SimcCopyFrameScroll:Show()
  SimcCopyFrameScrollText:Show()
  SimcCopyFrameScrollText:SetText(SimPermutProfile)
  SimcCopyFrameScrollText:HighlightText()
end
