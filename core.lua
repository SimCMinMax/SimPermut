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
local ITEM_COUNT_THRESHOLD = 25

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
local stringframe
local tableDropDown={}
local scroll
local multiLineEditBox		  
--local dropdownEnchantNeck
--local dropdownEnchantFinger
--local dropdownEnchantBack
local dropdownGem
local checkBoxForce
local actualSlot=""
local actualEnchantNeck=0
local actualEnchantFinger=0
local actualEnchantBack=0
local actualGem=0
local actualForce=false
local labelCount
local labelError
local tableListItems={}
local tableLabel={}
local tableTitres={}
local tableCheckBoxes={}
local tableLinkPermut={}
local selecteditems=0
local errorMessage=""

-- load stuff from extras.lua
local slotNames     	= SimPermut.slotNames
local simcSlotNames 	= SimPermut.simcSlotNames
local listNames 		= SimPermut.listNames
local specNames     	= SimPermut.SpecNames
local profNames     	= SimPermut.ProfNames
local PermutSimcNames   = SimPermut.PermutSimcNames
local regionString  	= SimPermut.RegionString
local artifactTable 	= SimPermut.ArtifactTable
local gemList 			= SimPermut.gemList
local enchantRing 		= SimPermut.enchantRing
local enchantCloak 		= SimPermut.enchantCloak
local enchantNeck 		= SimPermut.enchantNeck

SLASH_SIMPERMUTSLASH1 = "/SimPermut"
SLASH_SIMPERMUTSLASHTEST1 = "/Simtest"

SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	local argL = strlower(arg)
	if string.len(arg) == 0 then 
		if mainframeCreated then
			--print()
			if mainframe:IsShown() then
				mainframe:Hide()
			else
				SimPermut:BuildFrame()
			end
		else
			SimPermut:BuildFrame()
			mainframeCreated=true
		end
	else
		SimPermut:PrintCompare(argL,false)
	end
end

SlashCmdList["SIMPERMUTSLASHTEST"] = function (arg)
	local t = {}
	for word in arg:gmatch("%w+") do table.insert(t, word) end
	local testTable={}
	local returnvalue={}
	local elements=27
	--[[for i=1,t[1] do
		testTable[i]={}
		for j=1,t[2] do
			testTable[i][j]=i*10+j
			--print(testTable[i][j])
			elements=i*j
		end
	end]]--
	
	testTable[1]={10,11,12}
	testTable[2]={20,21,22}
	testTable[3]={}
	testTable[4]={}
	testTable[5]={}
	testTable[6]={}
	testTable[7]={}
	testTable[8]={}
	testTable[9]={}
	testTable[10]={42}
	testTable[11]={110}
	testTable[12]={120,121}
	testTable[13]={130,42}
	testTable[14]={140}
	
	local start_time1 = time()
	--returnvalue=PersoLib:doCartesianALACON(testTable)
	local end_time1 = time()
	local elapsed_time1 = difftime(end_time1-start_time1)
	
	local start_time2 = time()
	--returnvalue=Cartesian(testTable)
	local end_time2 = time()
	local elapsed_time2 = difftime(end_time2-start_time2)
	--for i=1,#returnvalue do
	--	print(unpack(returnvalue[i]))
	--end
	--print(SimPermut:GetBaseString())
	--print("Elapsed time ALACON : "..t[1].."x"..t[2].."(".. elements.." elements) : "..elapsed_time1)
	--print("Elapsed time BOGOSS : "..t[1].."x"..t[2].."(".. elements.." elements) : "..elapsed_time2)
end

function SimPermut:OnInitialize()
	SlashCmdList["SimPermut"] = handler;
end

function SimPermut:OnEnable()
  SimPermutTooltip:SetOwner(_G.UIParent,"ANCHOR_LEFT")
end

function SimPermut:OnDisable()
end

-- Main Frame construction
function SimPermut:BuildFrame()
	mainframe = AceGUI:Create("Frame")
	mainframe:SetTitle("SimPermut")
	mainframe:SetPoint("CENTER",-150,0)
	mainframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
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
	
	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetHeight(500)
	scrollcontainer:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer)
	
	scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)

	local labelEnchantNeck= AceGUI:Create("Label")
	labelEnchantNeck:SetText("Enchant Neck")
	labelEnchantNeck:SetWidth(100)
	
	local dropdownEnchantNeck = AceGUI:Create("Dropdown")
	--dropdownEnchantNeck:SetDisabled(true)
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
	--dropdownEnchantBack:SetDisabled(true)
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
	--dropdownEnchantFinger:SetDisabled(true)
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
	--dropdownGem:SetDisabled(true)
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
	--checkBoxForce:SetDisabled(true)
	checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		actualForce=checkBoxForce:GetValue()
    end)
	
	local labelSpacer3= AceGUI:Create("Label")
	labelSpacer3:SetText(" ")
	labelSpacer3:SetWidth(80)

	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	--buttonGenerate:SetDisabled(true)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:Generate()
		--SimPermut:PrintCompare(actualSlot,true) 
	end)
	
	labelCount= AceGUI:Create("Label")
	labelCount:SetText(" ")
	labelCount:SetWidth(150)
	
	local labelSpacer4= AceGUI:Create("Label")
	labelSpacer4:SetText(" ")
	labelSpacer4:SetFullWidth(true)
	
	labelError= AceGUI:Create("Label")
	labelError:SetText(" ")
	labelError:SetFullWidth(true) 
	labelError:SetColor(252, 22, 22)
	--local Path, Size, Flags = labelError:GetFont()
	--labelError:SetFont(Path,myFontSize+4,Flags);
	
	
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
	--mainGroup:AddChild(labelSpacer4)
	--mainGroup:AddChild(labelError)
	
	mainframe:AddChild(mainGroup)
	
	
	--[[stringframe = AceGUI:Create("Frame", "SimPermutPopup", UIParent)
	stringframe:SetTitle("SimPermut String")
	--stringframe:SetPoint("CENTER",150,0)
	stringframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	stringframe:SetLayout("Flow")
	stringframe:SetWidth(200)
	stringframe:SetHeight(200)
	stringframe:SetPoint("TOPLEFT", mainframe, "TOPRIGHT", 0, 0)]]--
end

-- Load Item list
function SimPermut:BuildItemFrame()

	for j=1,#listNames do
		--print(j,listNames[j],tableDropDown[j])
		
		if tableDropDown[j] then
			
			tableTitres[j]=AceGUI:Create("Label")
			tableTitres[j]:SetText(PersoLib:firstToUpper(listNames[j]))
			tableTitres[j]:SetFullWidth(true)
			scroll:AddChild(tableTitres[j])
			
			--[[print(j,listNames[j])
			if tableCheckBoxes[j] and #tableCheckBoxes[j]>0 then
				print("-",tableCheckBoxes[j],#tableCheckBoxes[j],#tableCheckBoxes[j][1])
				for i=1 ,#tableListItems[j] do
					scroll:AddChild(tableCheckBoxes[j][i])
					scroll:AddChild(tableLabel[j][i])
				end
			else]]--
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
					scroll:AddChild(tableCheckBoxes[j][i])
					--print("added ",tableCheckBoxes[j][i])
					
					
					tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
					tableLabel[j][i]:SetText(tableListItems[j][i])
					tableLabel[j][i]:SetRelativeWidth(0.95)
					tableLabel[j][i]:SetCallback("OnEnter", function(widget)
						GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
						GameTooltip:SetHyperlink(tableListItems[j][i])
						GameTooltip:Show()
					end)
					tableLabel[j][i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
					
					scroll:AddChild(tableLabel[j][i])
				end
			--end
		end
		--print(#tableCheckBoxes[j])
	end
end

-- clic btn generate
function SimPermut:Generate()
	--labelError:SetText("")
	--errorMessage=""
	mainframe:SetStatusText("")
	local permuttable={}
	local permutString=""
	local baseString=""
	local finalString=""
	if SimPermut:GetTableLink() then
		permuttable=SimPermut:GetAllPermutations()
		permutString=SimPermut:GetPermutationString(permuttable)
		baseString=SimPermut:GetBaseString()
		finalString=SimPermut:GetFinalString(baseString,permutString)
		SimPermut:PrintPermut(finalString)
	else --error
		mainframe:SetStatusText(errorMessage)
		--labelError:SetText(errorMessage)
	end
end

-- Slot Dropdown manager
function SimPermut:CallDropDown(selected)
	tableDropDown[selected] = not tableDropDown[selected]
	--tableCheckBoxes[selected] = {}

	scroll:ReleaseChildren()
	tableTitres={}
	tableLabel={}
	tableCheckBoxes={}
	tableLinkPermut={}
	SimPermut:GetListItems()
	SimPermut:BuildItemFrame()
	
	SimPermut:GetSelectedCount()
	--SimPermut:LoadPermut()
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

-- Load dropdown (not used)
function SimPermut:LoadPermut(item)
	dropdownGem:SetDisabled(false)
	
	if actualGem==0 then
		dropdownGem:SetValue(0)
		actualGem=0
	end
	
	if item == "back" then
		--dropdownEnchant:SetDisabled(false)
		
		--actualEnchant=0
	elseif item == "finger" then
		--dropdownEnchant:SetDisabled(false)
		--dropdownEnchant:SetList(enchantRing)
		--dropdownEnchant:SetValue(0)
		--actualEnchant=0
	elseif item == "neck" then
		--dropdownEnchant:SetDisabled(false)
		--dropdownEnchant:SetList(enchantNeck)
		--dropdownEnchant:SetValue(0)
		--actualEnchant=0
	else
		--dropdownEnchant:SetDisabled(true)
		--dropdownEnchant:SetValue("Untouched")
		--actualEnchant=0
	end
	
end

-- simc, method for constructing the talent string
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

-- simc, function that translates between the game's role values and ours
local function translateRole(str)
  if str == 'TANK' then
    return PersoLib:tokenize(str)
  elseif str == 'DAMAGER' then
    return 'attack'
  elseif str == 'HEALER' then
    return 'healer'
  else
    return ''
  end
end

-- simc, Artifact Information
local function IsArtifactFrameOpen()
  local ArtifactFrame 	  = _G.ArtifactFrame
  return ArtifactFrame and ArtifactFrame:IsShown() or false
end

-- generates artifact string
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

-- Generates the name of the copy for trinket and finger comparison
function SimPermut:GetCopyName(tableID,item1,item2)
	local name,ilvl
	name,_,_,ilvl=GetItemInfo(tableID[item1])
	local itemname1 = PersoLib:tokenize(name)..'_'..ilvl
	name,_,_,ilvl=GetItemInfo(tableID[item2])
	local itemname2 = PersoLib:tokenize(name)..'_'..ilvl
	
	return itemname1.."_"..itemname2
end

-- get item id from link
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
		--itemType=="finger1" or itemType=="finger2" or itemType=="finger")then
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
	--_,_,_,ilvl = GetItemInfo(itemLink)
	--if ilvl ~= nil then
	--	simcItemOptions[#simcItemOptions + 1] = 'ilvl=' .. ilvl
	--end
	
	return simcItemOptions
end

-- get all items equiped Strings
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

-- generates simc string for all permutations of a particular slot (not used)
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
			permut= permut .. "copy=" .. PersoLib:tokenize(name)..'_'..ilvl .. '\n'
			permut= permut .. simcname.."=" .. table.concat(permutTable[i], ',') .. '\n'
		end
			
	end
	
	return permut
end

-- generates simc string for all permutations of a table (not used)
function SimPermut:GetPermutationsFromList(strItem)
	local permutTable={}
	local itemidTable={}
	local permut=""
	
	if strItem=="trinket" then
		for i=1, #tableLinkPermut do
			for j=i+1,#tableLinkPermut do
				name1,_,_,ilvl1=GetItemInfo(tableLinkPermut[i])
				name2,_,_,ilvl2=GetItemInfo(tableLinkPermut[j])
				permut= permut .. "copy=" .. PersoLib:tokenize(name1)..'_'..ilvl1.."_"..PersoLib:tokenize(name2)..'_'..ilvl2 .. '\n'
				permut= permut .. "trinket1=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[i],strItem,false), ',') .. '\n'
				permut= permut .. "trinket2=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[j],strItem,false), ',') .. '\n'
			end
		end
	elseif strItem=="finger" then
		for i=1, #tableLinkPermut do
			for j=i+1,#tableLinkPermut do
				name1,_,_,ilvl1=GetItemInfo(tableLinkPermut[i])
				name2,_,_,ilvl2=GetItemInfo(tableLinkPermut[j])
				permut= permut .. "copy=" .. PersoLib:tokenize(name1)..'_'..ilvl1.."_"..PersoLib:tokenize(name2)..'_'..ilvl2 .. '\n'
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
			permut= permut .. "copy=" .. PersoLib:tokenize(name)..'_'..ilvl.. '\n'
			permut= permut .. simcname.."=" .. table.concat(SimPermut:GetItemString(tableLinkPermut[i],strItem,false), ',') .. '\n'
		end
	end
	
	
	return permut
end

-- choose the function depending if we comme from UI or chat
function SimPermut:WhichFunctionUse(strItem,fromInterface)
	if fromInterface then
		return SimPermut:GetPermutationsFromList(strItem)
	else
		return SimPermut:GetPermutations(strItem)
	end
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

-- get the list of items of all selected items from dropdown
function SimPermut:GetListItems()
	for i=1,#listNames do
		tableListItems[i]={}
		--si l'item est sélectionné
		if tableDropDown[i] then
			--print("add "..listNames[i])
			tableListItems[i]=SimPermut:GetListItem(listNames[i])
		end
	end
end

-- generates tablelink to be ready for permuts
function SimPermut:GetTableLink()
	local returnvalue=true
	local slotid
	for i=1,#listNames do
		--print(i,listNames[i],#tableCheckBoxes[i])
		tableLinkPermut[i]={}
		if tableListItems[i] and #tableListItems[i]>0 then
			for j=1,#tableListItems[i] do
				if tableCheckBoxes[i][j]:GetValue() then
					tableLinkPermut[i][#tableLinkPermut[i] + 1] = tableListItems[i][j]
					--print("added : ",tableListItems[i][j])
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
			--print("added (default) : ",slotid,tableLinkPermut[i][1])
		end
			
	end
	
	--manage fingers and trinkets
	--print (#tableLinkPermut[12])
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
			--print(#tableLinkPermut[13])
			--print(#tableLinkPermut[14])
		else
			tableLinkPermut[13]=tableLinkPermut[12]
			tableLinkPermut[14]=tableLinkPermut[13]
			tableLinkPermut[12]={}
		end
	end
	
	--print (#tableLinkPermut[11])
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
			--tableLinkPermut[11][2]=nil
			--print(#tableLinkPermut[11])
			--print(#tableLinkPermut[12])
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

	
	for i=1,#permuttable do
		returnString =  returnString.."copy=copy"..i.."\n"
		--print(#permuttable[i])
		for j=1,#permuttable[i] do
			local itemString=SimPermut:GetItemString(permuttable[i][j],PermutSimcNames[j],false)
			--print(table.concat(itemString, ','))
			returnString = returnString..PermutSimcNames[j] .. "=" .. table.concat(itemString, ',').."\n"
		end
		--print(unpack(permuttable[i]))
		
		returnString =  returnString.."\n"
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
	playerRole = 'role=' .. translateRole(role)
	playerSpec = 'spec=' .. PersoLib:tokenize(playerSpec)
	playerRealm = 'server=' .. PersoLib:tokenize(playerRealm)
	playerRegion = 'region=' .. PersoLib:tokenize(playerRegion)

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

	return SimPermutProfile
end

-- generates the string of base + permutations
function SimPermut:GetFinalString(basestring,permutstring)
	return basestring..'\n\n'..permutstring
end

-- draw the frame and print the text
function SimPermut:PrintPermut(finalString)
	SimcCopyFrame:Show()
	SimcCopyFrame:SetPoint("RIGHT")
	SimcCopyFrameScroll:Show()
	SimcCopyFrameScrollText:Show()
	SimcCopyFrameScrollText:SetText(finalString)
	SimcCopyFrameScrollText:HighlightText()
end

-- generates simc string if asked from chat
function SimPermut:PrintCompare(arg,fromInterface)

  --Prep affichage
  OpenAllBags()
  if not CharacterFrame:IsShown() then 
	ToggleCharacter("PaperDollFrame") 
  end
  
  local SimPermutProfile=SimPermut:GetBaseString()
  
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
  SimPermut:PrintPermut(SimPermutProfile)

end
