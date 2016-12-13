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
local ITEM_COUNT_THRESHOLD = 21
local COPY_THRESHOLD = 136

-- Libs
local ArtifactUI          = _G.C_ArtifactUI
local HasArtifactEquipped = _G.HasArtifactEquipped
local SocketInventoryItem = _G.SocketInventoryItem
local Timer               = _G.C_Timer
local AceGUI 			  = LibStub("AceGUI-3.0")
local PersoLib			  = LibStub("PersoLib")

--UI
local mainframe 
local mainframeCreated=false
local stringframeCreated=false
local tableDropDown={}
local scroll1
local scroll2
local multiLineEditBox		  
local dropdownGem
local checkBoxForce
local actualSlot=""
local actualEnchantNeck=0
local actualEnchantFinger=0
local actualEnchantBack=0
local actualGem=0
local actualForce=false
local labelCount
local tableListItems={}
local tableLabel={}
local tableTitres={}
local tableCheckBoxes={}
local tableLinkPermut={}
local tableBaseLink={}
local selecteditems=0
local errorMessage=""

-- load stuff from extras.lua
local slotNames     	= SimPermut.slotNames
local simcSlotNames 	= SimPermut.simcSlotNames
local listNames 		= SimPermut.listNames
local specNames     	= SimPermut.SpecNames
local profNames     	= SimPermut.ProfNames
local PermutSimcNames   = SimPermut.PermutSimcNames
local PermutSlotNames   = SimPermut.PermutSlotNames
local regionString  	= SimPermut.RegionString
local artifactTable 	= SimPermut.ArtifactTable
local gemList 			= SimPermut.gemList
local enchantRing 		= SimPermut.enchantRing
local enchantCloak 		= SimPermut.enchantCloak
local enchantNeck 		= SimPermut.enchantNeck

SLASH_SIMPERMUTSLASH1 = "/SimPermut"

-------------Test-----------------
SLASH_SIMPERMUTSLASHTEST1 = "/Simtest"
SlashCmdList["SIMPERMUTSLASHTEST"] = function (arg)
	local t = {}
	for word in arg:gmatch("%w+") do table.insert(t, word) end
	local stats = {}
	stats = GetItemStats(GetInventoryItemLink("player", t[1]))
	print(GetInventoryItemLink("player", t[1]))
	for stat, value in pairs(stats) do print( stat,value) end
end
-------------Test-----------------

-- Command UI
SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	if mainframeCreated then
		if mainframe:IsShown() then
			mainframe:Hide()
		else
			SimPermut:BuildFrame()
		end
	else
		SimPermut:BuildFrame()
		mainframeCreated=true
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


----------------------------
----------- UI -------------
----------------------------
-- Main Frame construction
function SimPermut:BuildFrame()
	mainframe = AceGUI:Create("Frame")
	mainframe:SetTitle("SimPermut")
	mainframe:SetPoint("CENTER",-150,0)
	mainframe:SetCallback("OnClose", function(widget) 
		AceGUI:Release(widget) 
		if stringframeCreated and SimcCopyFrame:IsShown() then
			SimcCopyFrame:Hide()
		end
	end)
	mainframe:SetLayout("Flow")
	mainframe:SetWidth(1000)
	mainframe:SetHeight(750)
	
	local dd = AceGUI:Create("Dropdown")
	dd:SetMultiselect(true)
	dd:SetList(listNames)
	
	for i=1,#listNames do
		tableDropDown[i]=false
	end
	
	dd:SetCallback("OnValueChanged",function (this, event, item)
		SimPermut:CallDropDown(item)
    end)
	mainframe:AddChild(dd)
	
	local labelSpacer1= AceGUI:Create("Label")
	labelSpacer1:SetFullWidth(true)
	labelSpacer1:SetText(" ")
	mainframe:AddChild(labelSpacer1)
	
	local mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetFullWidth(true)
    mainGroup:SetLayout("Flow")
    mainGroup:SetWidth(200)
	
	local scrollcontainer1 = AceGUI:Create("SimpleGroup")
	scrollcontainer1:SetRelativeWidth(0.5)
	scrollcontainer1:SetHeight(500)
	scrollcontainer1:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer1)
	
	scroll1 = AceGUI:Create("ScrollFrame")
	scroll1:SetLayout("Flow")
	scrollcontainer1:AddChild(scroll1)
	
	local scrollcontainer2 = AceGUI:Create("SimpleGroup")
	scrollcontainer2:SetRelativeWidth(0.5)
	scrollcontainer2:SetHeight(500)
	scrollcontainer2:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer2)
	
	scroll2 = AceGUI:Create("ScrollFrame")
	scroll2:SetLayout("Flow")
	scrollcontainer2:AddChild(scroll2)

	local labelEnchantNeck= AceGUI:Create("Label")
	labelEnchantNeck:SetText("Enchant Neck")
	labelEnchantNeck:SetWidth(100)
	
	local dropdownEnchantNeck = AceGUI:Create("Dropdown")
	dropdownEnchantNeck:SetWidth(160)
	dropdownEnchantNeck:SetList(enchantNeck)
	dropdownEnchantNeck:SetValue(0)
	dropdownEnchantNeck:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantNeck=item
    end)
		
	local labelEnchantBack= AceGUI:Create("Label")
	labelEnchantBack:SetText("      Enchant Back")
	labelEnchantBack:SetWidth(100)
	
	local dropdownEnchantBack = AceGUI:Create("Dropdown")
	dropdownEnchantBack:SetWidth(160)
	dropdownEnchantBack:SetList(enchantCloak)
	dropdownEnchantBack:SetValue(0)
	dropdownEnchantBack:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantBack=item
    end)
	
	local labelEnchantFinger= AceGUI:Create("Label")
	labelEnchantFinger:SetText("      Enchant Ring")
	labelEnchantFinger:SetWidth(100)
	
	local dropdownEnchantFinger = AceGUI:Create("Dropdown")
	dropdownEnchantFinger:SetWidth(160)
	dropdownEnchantFinger:SetList(enchantRing)
	dropdownEnchantFinger:SetValue(0)
	dropdownEnchantFinger:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantFinger=item
    end)
	
	local labelSpacerFull= AceGUI:Create("Label")
	labelSpacerFull:SetText(" ")
	labelSpacerFull:SetFullWidth(true)
	
	local labelGem= AceGUI:Create("Label")
	labelGem:SetText("Gem")
	labelGem:SetWidth(80)
	
	dropdownGem = AceGUI:Create("Dropdown")
	dropdownGem:SetList(gemList)
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
	checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		actualForce=checkBoxForce:GetValue()
    end)
	
	local labelSpacer3= AceGUI:Create("Label")
	labelSpacer3:SetText(" ")
	labelSpacer3:SetWidth(80)

	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:Generate()
	end)
	
	labelCount= AceGUI:Create("Label")
	labelCount:SetText(" ")
	labelCount:SetWidth(250)
	
	mainGroup:AddChild(labelEnchantNeck)
	mainGroup:AddChild(dropdownEnchantNeck)
	mainGroup:AddChild(labelEnchantBack)
	mainGroup:AddChild(dropdownEnchantBack)
	mainGroup:AddChild(labelEnchantFinger)
	mainGroup:AddChild(dropdownEnchantFinger)
	mainGroup:AddChild(labelSpacerFull)
	mainGroup:AddChild(labelGem)
	mainGroup:AddChild(dropdownGem)
	mainGroup:AddChild(labelSpacer2)
	mainGroup:AddChild(checkBoxForce)
	mainGroup:AddChild(labelSpacer3)
	mainGroup:AddChild(buttonGenerate)
	mainGroup:AddChild(labelCount)
	
	mainframe:AddChild(mainGroup)
end

-- Load Item list
function SimPermut:BuildItemFrame()
	for j=1,#listNames do
		if tableDropDown[j] then
			tableTitres[j]=AceGUI:Create("Label")
			tableTitres[j]:SetText(PersoLib:firstToUpper(listNames[j]))
			tableTitres[j]:SetFullWidth(true)
			if(j<7) then
				scroll1:AddChild(tableTitres[j])
			else
				scroll2:AddChild(tableTitres[j])
			end
			
			
			tableCheckBoxes[j]={}
			tableLabel[j]={}
			for i=1 ,#tableListItems[j] do
				tableCheckBoxes[j][i]=AceGUI:Create("CheckBox")
				tableCheckBoxes[j][i]:SetLabel("")
				tableCheckBoxes[j][i]:SetRelativeWidth(0.05)
				tableCheckBoxes[j][i]:SetValue(true)
				tableCheckBoxes[j][i]:SetCallback("OnValueChanged", function(this, event, item)
					if tableCheckBoxes[j][i]:GetValue() then
						selecteditems=selecteditems+1
					else
						selecteditems=selecteditems-1
					end
					SimPermut:CheckItemCount()
				end)
				selecteditems=selecteditems+1
				if(j<7) then
					scroll1:AddChild(tableCheckBoxes[j][i])
				else
					scroll2:AddChild(tableCheckBoxes[j][i])
				end
				
				tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
				tableLabel[j][i]:SetText(tableListItems[j][i])
				tableLabel[j][i]:SetRelativeWidth(0.95)
				tableLabel[j][i]:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
					GameTooltip:SetHyperlink(tableListItems[j][i])
					GameTooltip:Show()
				end)
				tableLabel[j][i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
				
				if(j<7) then
					scroll1:AddChild(tableLabel[j][i])
				else
					scroll2:AddChild(tableLabel[j][i])
				end
			end
		end
	end
end

-- clic btn generate
function SimPermut:Generate()
	mainframe:SetStatusText("")
	local permuttable={}
	local permutString=""
	local baseString=""
	local finalString=""
	if SimPermut:GetTableLink() then
		baseString,tableBaseLink=SimPermut:GetBaseString()
		permuttable=SimPermut:GetAllPermutations()
		permutString=SimPermut:GetPermutationString(permuttable)
		finalString=SimPermut:GetFinalString(baseString,permutString)
		SimPermut:PrintPermut(finalString)
	else --error
		mainframe:SetStatusText(errorMessage)
	end
end

-- Slot Dropdown manager
function SimPermut:CallDropDown(selected)
	tableDropDown[selected] = not tableDropDown[selected]

	scroll1:ReleaseChildren()
	scroll2:ReleaseChildren()
	tableTitres={}
	tableLabel={}
	tableCheckBoxes={}
	tableLinkPermut={}
	SimPermut:GetListItems()
	SimPermut:BuildItemFrame()
	SimPermut:GetSelectedCount()
end

-- Get the count of selected items
function SimPermut:GetSelectedCount()
	selecteditems = 0
	for i=1,#listNames do
		for j=1,#tableListItems[i] do
			if tableCheckBoxes[i][j]:GetValue() then
				selecteditems=selecteditems+1
			end
		end
	end
	
	SimPermut:CheckItemCount()
end

-- Check if item count is not too high
function SimPermut:CheckItemCount()
	if selecteditems >= ITEM_COUNT_THRESHOLD then
		labelCount:SetText("   Warning : Too many items selected ("..selecteditems..")")
	else
		labelCount:SetText("   ".. selecteditems.. " items selected")
	end
end

-- draw the frame and print the text
function SimPermut:PrintPermut(finalString)
	SimcCopyFrame:Show()
	SimcCopyFrame:SetPoint("RIGHT")
	stringframeCreated=true
	SimcCopyFrameScroll:Show()
	SimcCopyFrameScrollText:Show()
	SimcCopyFrameScrollText:SetText(finalString)
	SimcCopyFrameScrollText:HighlightText()
end

----------------------------
-- Permutation Management --
----------------------------
-- get item string
function SimPermut:GetItemString(itemLink,itemType,base)
	--itemLink 	: link of the item
	--itemType 	: item slot
	--base 		: true if item from equiped gear, false from inventory

	local itemString = string.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}
	local simcItemOptions = {}
	local ilvl
	local hasGem=false
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
	if base then 
		if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
			simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
		end
	else
		if itemType=="neck" then
			if actualForce and actualEnchantNeck~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantNeck
			else	
				if actualEnchantNeck==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantNeck
				end
			end
		elseif itemType=="back" then
			if actualForce and actualEnchantBack~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantBack
			else
				if actualEnchantBack==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantBack
				end
			end
		elseif string.match(itemType, 'finger*') then
			if actualForce and actualEnchantFinger~=0 then
				simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantFinger
			else
				if actualEnchantFinger==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. actualEnchantFinger
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
	if itemType=="main_hand" then --exception for relics
		local gems = {}
		for i=1, 4 do -- hardcoded here to just grab all 4 sockets
			local _,gemLink = GetItemGem(itemLink, i)
			if gemLink then
				local gemDetail = string.match(gemLink, "item[%-?%d:]+")
				gems[#gems + 1] = string.match(gemDetail, "item:(%d+):" )
			elseif flags == 256 then
				gems[#gems + 1] = "0"
			end
		end
		if #gems > 0 then
			simcItemOptions[#simcItemOptions + 1] = 'gem_id=' .. table.concat(gems, '/')
		end
	else
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
	end
	
	return simcItemOptions
end

-- get all items equiped Strings
function SimPermut:GetItemStrings()
  local items = {}
  local itemsLinks = {}
  local slotId,itemLink
  local itemString = {}
  
  for slotNum=1, #PermutSlotNames do
    slotId = GetInventorySlotInfo(PermutSlotNames[slotNum])
    itemLink = GetInventoryItemLink('player', slotId)

    -- if we don't have an item link, we don't care
    if itemLink then
	  itemString=SimPermut:GetItemString(itemLink,PermutSimcNames[slotNum],true)
	  itemsLinks[slotNum]=itemLink
      items[slotNum] = PermutSimcNames[slotNum] .. "=" .. table.concat(itemString, ',')
    end
  end

  return items,itemsLinks
end

-- get the list of items of a slot
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

-- get the list of items of all selected items from dropdown
function SimPermut:GetListItems()
	for i=1,#listNames do
		tableListItems[i]={}
		--si l'item est sélectionné
		if tableDropDown[i] then
			tableListItems[i]=SimPermut:GetListItem(listNames[i])
		end
	end
end

-- generates tablelink to be ready for permuts
function SimPermut:GetTableLink()
	local returnvalue=true
	local slotid
	for i=1,#listNames do
		tableLinkPermut[i]={}
		if tableListItems[i] and #tableListItems[i]>0 then
			for j=1,#tableListItems[i] do
				if tableCheckBoxes[i][j]:GetValue() then
					tableLinkPermut[i][#tableLinkPermut[i] + 1] = tableListItems[i][j]
				end
			end
		end
		
		--if we have no items, we take the equiped one. exception for finger and trinket
		if #tableLinkPermut[i] == 0 and i<11 then
			if(i>=6) then
				slotid=i+2
			else
				slotid=i
			end
			tableLinkPermut[i][1]=GetInventoryItemLink('player', GetInventorySlotInfo(slotNames[slotid]))
		end
			
	end
	
	--manage fingers and trinkets
	if #tableLinkPermut[12]==0 then --if no trinket chosen, we take the equiped ones
		tableLinkPermut[13]={}
		tableLinkPermut[13][1]=GetInventoryItemLink('player', GetInventorySlotInfo(slotNames[15]))
		tableLinkPermut[14]={}
		tableLinkPermut[14][1]=GetInventoryItemLink('player', GetInventorySlotInfo(slotNames[16]))
	else --else we copy the selected ones on the second slot and reposition the slot in the good position
		if #tableLinkPermut[12]==1 then
			errorMessage="Can't permut with only one trinket"
			returnvalue=false
		elseif #tableLinkPermut[12]==2 then
			tableLinkPermut[13]={}
			tableLinkPermut[13][1]=tableLinkPermut[12][1]
			tableLinkPermut[14]={}
			tableLinkPermut[14][1]=tableLinkPermut[12][2]
			tableLinkPermut[12]={}
		else
			tableLinkPermut[13]=tableLinkPermut[12]
			tableLinkPermut[14]=tableLinkPermut[13]
			tableLinkPermut[12]={}
		end
	end
	
	if #tableLinkPermut[11]==0 then --if no finger chosen, we take the equiped ones
		tableLinkPermut[11][1]=GetInventoryItemLink('player', GetInventorySlotInfo(slotNames[13]))
		tableLinkPermut[12][1]=GetInventoryItemLink('player', GetInventorySlotInfo(slotNames[14]))
	else --else we copy the selected ones on the second slot
		if #tableLinkPermut[11]==1 then
			errorMessage="Can't permut with only one ring"
			returnvalue=false
		elseif #tableLinkPermut[11]==2 then
			local temptable={}
			temptable[1]=tableLinkPermut[11]
			tableLinkPermut[11]={}
			tableLinkPermut[11][1]=temptable[1][1]
			tableLinkPermut[12][1]=temptable[1][2]
		else
			tableLinkPermut[12]=tableLinkPermut[11]
		end
	end
		
	
	return returnvalue
end

-- generates all permutations for the tableLinkPermut
function SimPermut:GetAllPermutations()
	local returnTable={}

	returnTable=PersoLib:doCartesianALACON(tableLinkPermut)
	
	return returnTable
end

-- generates the string of all permutations
function SimPermut:GetPermutationString(permuttable)
	local returnString="\n"
	local copynumber=1

	for i=1,#permuttable do
		if SimPermut:CheckUsability(permuttable[i],tableBaseLink) then
			returnString =  returnString.."copy=copy"..copynumber.."\n"
			for j=1,#permuttable[i] do
				local itemString=SimPermut:GetItemString(permuttable[i][j],PermutSimcNames[j],false)
				returnString = returnString..PermutSimcNames[j] .. "=" .. table.concat(itemString, ',').."\n"
			end
			
			returnString =  returnString.."\n"
			copynumber=copynumber+1
		end
	end
	
	if copynumber > COPY_THRESHOLD then
		mainframe:SetStatusText("Large number of copy, you may not have every copy (frame limitation).")
	end
	
	return returnString
end

-- generates the string for artifact, equiped gear and player info
function SimPermut:GetBaseString()
	local playerName = UnitName('player')
	local _, playerClass = UnitClass('player')
	local playerLevel = UnitLevel('player')
	local playerRealm = GetRealmName()
	local playerRegion = regionString[GetCurrentRegion()]
	local bPermut=false
	local slotId,itemLink
	local itemString = {}

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
			playerProfessions = playerProfessions..PersoLib:tokenize(firstProf)..'='..tostring(firstProfRank)..'/'
		end
		if pid2 then
			playerProfessions = playerProfessions..PersoLib:tokenize(secondProf)..'='..tostring(secondProfRank)
		end
	else
		playerProfessions = ''
	end

	-- Construct SimC-compatible strings from the basic information
	local player = PersoLib:tokenize(playerClass) .. '="' .. playerName .. '"'
	playerLevel = 'level=' .. playerLevel
	playerRace = 'race=' .. PersoLib:tokenize(playerRace)
	playerRole = 'role=' .. PersoLib:translateRole(role)
	playerSpec = 'spec=' .. PersoLib:tokenize(playerSpec)
	playerRealm = 'server=' .. PersoLib:tokenize(playerRealm)
	playerRegion = 'region=' .. PersoLib:tokenize(playerRegion)

	-- Talents are more involved - method to handle them
	local playerTalents = PersoLib:CreateSimcTalentString()
	local playerArtifact = PersoLib:GetArtifactString()

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
	local items,itemsLinks = SimPermut:GetItemStrings()

	SimPermutProfile = SimPermutProfile .. "name=Base \n"
	-- output gear
	for slotNum=1, #PermutSlotNames do
		if items[slotNum] then
			SimPermutProfile = SimPermutProfile .. items[slotNum] .. '\n'
		end
	end
	
	--add weapons
	slotId = GetInventorySlotInfo("MainHandSlot")
    itemLink = GetInventoryItemLink('player', slotId)
	itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
	  itemString=SimPermut:GetItemString(itemLink,'main_hand',true)
      SimPermutProfile = SimPermutProfile .. "main_hand=" .. table.concat(itemString, ',').. '\n'
    end
	
	slotId = GetInventorySlotInfo("SecondaryHandSlot")
    itemLink = GetInventoryItemLink('player', slotId)
	itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
	  itemString=SimPermut:GetItemString(itemLink,'off_hand',true)
      SimPermutProfile = SimPermutProfile .. "off_hand=" .. table.concat(itemString, ',').. '\n'
    end

	return SimPermutProfile,itemsLinks
end

-- generates the string of base + permutations
function SimPermut:GetFinalString(basestring,permutstring)
	return basestring..'\n'..permutstring
end

-- check if table is usefull to simulate (same ring, same trinket, dupplicate from base)
function SimPermut:CheckUsability(table1,table2)
	local returnvalue = true
	local duplicate = true
	
	--checking different size
	if returnvalue then
		if #table1~=#table2 then
			returnvalue=false
		end
	end
	
	--checking same ring
	if returnvalue then
		if table1[11]==table1[12] then
			returnvalue=false
		end
	end
	
	--checking same trinket
	if returnvalue then
		if table1[13]==table1[14] then
			returnvalue=false
		end
	end
	
	--checking Duplicate
	if returnvalue then
		for i=1,#table1 do
			if duplicate then
				if table1[i]~=table2[i] then
					duplicate=false
				end
			end
		end
		
		if duplicate then
			returnvalue=false
		end
	end

	return returnvalue
end