local _, SimPermut = ...

SimPermut = LibStub("AceAddon-3.0"):NewAddon(SimPermut, "SimPermut", "AceConsole-3.0", "AceEvent-3.0")

local OFFSET_ITEM_ID = 1
local OFFSET_ENCHANT_ID = 2
local OFFSET_GEM_ID_1 = 3
local OFFSET_GEM_ID_2 = 4
local OFFSET_GEM_ID_3 = 5
local OFFSET_GEM_ID_4 = 6
local OFFSET_SUFFIX_ID = 7
local OFFSET_FLAGS = 11
local OFFSET_BONUS_ID = 13

-- Artifact stuff (adapted from LibArtifactData [https://www.wowace.com/addons/libartifactdata-1-0/], thanks!)
local ArtifactUI          = _G.C_ArtifactUI
local HasArtifactEquipped = _G.HasArtifactEquipped
local SocketInventoryItem = _G.SocketInventoryItem
local Timer               = _G.C_Timer


-- load stuff from extras.lua
local slotNames     = SimPermut.slotNames
local simcSlotNames = SimPermut.simcSlotNames
local specNames     = SimPermut.SpecNames
local profNames     = SimPermut.ProfNames
local regionString  = SimPermut.RegionString
local artifactTable = SimPermut.ArtifactTable

SLASH_SIMPERMUTSLASH1 = "/SimPermut"

-- Most of the guts of this addon were based on a variety of other ones, including
-- Statslog, AskMrRobot, and BonusScanner. And a bunch of hacking around with AceGUI.
-- Many thanks to the authors of those addons, and to reia for fixing my awful amateur
-- coding mistakes regarding objects and namespaces.

SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	local argL = strlower(arg)
	OpenAllBags()
	if not CharacterFrame:IsShown() then 
	  ToggleCharacter("PaperDollFrame") 
	end
	SimPermut:PrintCompare(argL)
	CloseAllBags()
	ToggleCharacter("PaperDollFrame")
end

function SimPermut:OnInitialize()
	SlashCmdList["SimPermut"] = handler;
end

function SimPermut:OnEnable()
  SimPermutTooltip:SetOwner(_G["UIParent"],"ANCHOR_NONE")
end

function SimPermut:OnDisable()

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
  print(item_id)
  if item_id == nil or item_id == 0 then
    return nil
  end

  local artifact_id = SimPermut.ArtifactTable[item_id]
  print(artifact_id)
  if artifact_id == nil then
    return nil
  end

  -- Note, relics are handled by the item string
  local str = 'artifact=' .. artifact_id .. ':0:0:0:0'

  local powers = ArtifactUI.GetPowers()
  print(powers)
  for i = 1, #powers do
    local power_id = powers[i]
    local _, _, currentRank, _, bonusRanks = ArtifactUI.GetPowerInfo(power_id)
    if currentRank > 0 and currentRank - bonusRanks > 0 then
      str = str .. ':' .. power_id .. ':' .. (currentRank - bonusRanks)
    end
  end
  print(str)
  
  --if ArtifactFrame:IsShown() then
	--HideUIPanel(ArtifactFrame)
  --end
  
  UIParent:RegisterEvent("ARTIFACT_UPDATE");

  return str
end

-- donne le nom de la permutation
function SimPermut:GetCopyName(tableID,item1,item2)
	local itemname1 = GetItemInfo(tableID[item1])
	local itemname2 = GetItemInfo(tableID[item2])
	
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
function SimPermut:GetItemString(itemLink)
	local itemString = string.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}
	local simcItemOptions = {}

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
	if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
		simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. itemSplit[OFFSET_ENCHANT_ID]
	end

	-- New style item suffix, old suffix style not supported
	if tonumber(itemSplit[OFFSET_SUFFIX_ID]) ~= 0 then
		simcItemOptions[#simcItemOptions + 1] = 'suffix=' .. itemSplit[OFFSET_SUFFIX_ID]
	end

	local flags = tonumber(itemSplit[OFFSET_FLAGS])

	local bonuses = {}

	for index=1, tonumber(itemSplit[OFFSET_BONUS_ID]) do
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

	-- Some leveling quest items seem to use this, it'll include the drop level of the item
	if bit.band(flags, 512) == 512 then
		simcItemOptions[#simcItemOptions + 1] = 'drop_level=' .. itemSplit[rest_offset]
		rest_offset = rest_offset + 1
	end

	-- Gems
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
	  local itemString=SimPermut:GetItemString(itemLink)	
      items[slotNum] = simcSlotNames[slotNum] .. "=" .. table.concat(itemString, ',')
    end
  end

  return items
end

-- recupere les permutations de chaque item dans l'inventaire
function SimPermut:GetPermutations(strItem)
	local texture, count, locked, quality, readable, lootable, isFiltered, hasNoValue, itemId, itemLink, itemstring, permut
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
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=itemId
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
				end
			end
		end
		
		for i=1 ,#permutTable do
			for j=i+1,#permutTable do
				copyname=SimPermut:CleanString(SimPermut:GetCopyName(itemidTable,i,j))
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
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=itemId
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
				end
			end
		end
		
		for i=1 ,#permutTable do
			for j=i+1,#permutTable do
				copyname=SimPermut:CleanString(SimPermut:GetCopyName(itemidTable,i,j))
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
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=itemId
				end
			else
				itemLink = GetInventoryItemLink('player', slot)
				if itemLink~=nil then
					permutTable[#permutTable+1]=SimPermut:GetItemString(itemLink)
					itemidTable[#itemidTable+1]=SimPermut:GetIDFromLink(itemLink)
				end
			end
		end
		
		for i=1 ,#permutTable do
			permut= permut .. "copy=" .. SimPermut:CleanString(GetItemInfo(itemidTable[i])) .. '\n'
			permut= permut .. simcname.."=" .. table.concat(permutTable[i], ',') .. '\n'
		end
			
	end
	
	return permut
end

-- fonction d'impression
function SimPermut:PrintCompare(arg)
  local playerName = UnitName('player')
  local _, playerClass = UnitClass('player')
  local playerLevel = UnitLevel('player')
  local playerRealm = GetRealmName()
  local playerRegion = regionString[GetCurrentRegion()]
  local bPermut=true

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
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="finger" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="head" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="neck" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="shoulder" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="back" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="chest" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="wrist" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="hands" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="waist" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="legs" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	elseif arg=="feet" then
		permutations=SimPermut:GetPermutations(arg)
		bPermut=false
	else
		print("items to compare not found")
		bPermut=false
	end
	
	if bPermut then
		SimPermutProfile = permutations
	else
		SimPermutProfile = SimPermutProfile .. permutations
	end
  end
  
  -- sanity checks - if there's anything that makes the output completely invalid, punt!
  if specId==nil then
    SimPermutProfile = "Error: You need to pick a spec!"
  end

  -- show the appropriate frames
  SimcCopyFrame:Show()
  SimcCopyFrameScroll:Show()
  SimcCopyFrameScrollText:Show()
  SimcCopyFrameScrollText:SetText(SimPermutProfile)
  SimcCopyFrameScrollText:HighlightText()
end
