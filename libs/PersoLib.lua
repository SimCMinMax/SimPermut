local MAJOR, MINOR = "PersoLib", 1
local PersoLib = LibStub:NewLibrary(MAJOR, MINOR)

if not PersoLib then return end

local ArtifactUI          	= _G.C_ArtifactUI
local ArtifactRelicForgeUI  = _G.C_ArtifactRelicForgeUI
local ArtifactRelicForgeFrame = _G.ArtifactRelicForgeFrame
local HasArtifactEquipped 	= _G.HasArtifactEquipped
local SocketInventoryItem 	= _G.SocketInventoryItem
local ExtraData			

function PersoLib:Init(Datas)
	ExtraData=Datas
end

-- First letter in caps
function PersoLib:firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- permut item table
function PersoLib:doCartesianALACON(tableToPermut)
	local i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14
	local tableReturn={}
	
	for i1=1,#tableToPermut[1] do
		for i2=1,#tableToPermut[2] do
			for i3=1,#tableToPermut[3] do
				for i4=1,#tableToPermut[4] do
					for i5=1,#tableToPermut[5] do
						for i6=1,#tableToPermut[6] do
							for i7=1,#tableToPermut[7] do
								for i8=1,#tableToPermut[8] do
									for i9=1,#tableToPermut[9] do
										for i10=1,#tableToPermut[10] do
											for i11=1,#tableToPermut[11] do
												for i12=1,#tableToPermut[12] do
													for i13=1,#tableToPermut[13] do
														for i14=1,#tableToPermut[14] do
															tableReturn[#tableReturn+1]={}
															tableReturn[#tableReturn][1]=tableToPermut[1][i1]
															tableReturn[#tableReturn][2]=tableToPermut[2][i2]
															tableReturn[#tableReturn][3]=tableToPermut[3][i3]
															tableReturn[#tableReturn][4]=tableToPermut[4][i4]
															tableReturn[#tableReturn][5]=tableToPermut[5][i5]
															tableReturn[#tableReturn][6]=tableToPermut[6][i6]
															tableReturn[#tableReturn][7]=tableToPermut[7][i7]
															tableReturn[#tableReturn][8]=tableToPermut[8][i8]
															tableReturn[#tableReturn][9]=tableToPermut[9][i9]
															tableReturn[#tableReturn][10]=tableToPermut[10][i10]
															
															--ring
															tableReturn[#tableReturn][11]=tableToPermut[11][i11]
															tableReturn[#tableReturn][12]=tableToPermut[12][i12]
															
															--trinket
															tableReturn[#tableReturn][13]=tableToPermut[13][i13]
															tableReturn[#tableReturn][14]=tableToPermut[14][i14]
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	
	
	return tableReturn
end

-- SimC, tokenize function
function PersoLib:tokenize(str)
  str = str or ""
  -- convert to lowercase and remove spaces
  str = string.lower(str)
  str = string.gsub(str, ' ', '_')
  str = string.gsub(str, ',', '_')

  -- strip trailing spaces
  if string.sub(str, str:len())=='_' then
    str = string.sub(str, 0, str:len()-1)
  end
  return str
end

function PersoLib:Split(str, delim, maxNb)
   -- Eliminate bad cases...
   if string.find(str, delim) == nil then
      return { str }
   end
   if maxNb == nil or maxNb < 1 then
      maxNb = 0    -- No limit
   end
   local result = {}
   local pat = "(.-)" .. delim .. "()"
   local nb = 0
   local lastPos
   for part, pos in string.gmatch(str, pat) do
      nb = nb + 1
      result[nb] = part
      lastPos = pos
      if nb == maxNb then
         break
      end
   end
   -- Handle the last field
   if nb ~= maxNb then
      result[nb + 1] = string.sub(str, lastPos)
   end
   return result
end

-- simc, method for constructing the talent string
function PersoLib:CreateSimcTalentString()
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

  local str = ''
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
function PersoLib:translateRole(spec_id)
  local spec_role = ExtraData.RoleTable[spec_id]
  if spec_role ~= nil then
    return spec_role
  end
end

-- simc, function that reforulate race for simc
function PersoLib:getRace()
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
	
	return playerRace
end

-- simc, function that returns spec ID
function PersoLib:getSpecID()
	local globalSpecID
	local specId = GetSpecialization()
	if specId then
		globalSpecID = GetSpecializationInfo(specId)
	end
	return globalSpecID
end

function PersoLib:IsArtifactFrameOpen()
	local ArtifactFrame = _G.ArtifactFrame
	return ArtifactFrame and ArtifactFrame:IsShown() or false
end

function PersoLib:IsCrucibleFrameOpen()
	local ArtifactRelicForgeFrame = _G.ArtifactRelicForgeFrame
	return ArtifactRelicForgeFrame and ArtifactRelicForgeFrame:IsShown() or false
end

function PersoLib:GetPowerData(powerId)
	if not powerId then
		return 0, 0
	end

	local powerInfo = ArtifactUI.GetPowerInfo(powerId)
	if powerInfo == nil then
		return powerId, 0
	end

	return powerId, powerInfo.currentRank - powerInfo.bonusRanks
end

function PersoLib:OpenArtifact()
	if not HasArtifactEquipped() then
		return false, false, 0
	end

	local artifactFrameOpen = PersoLib:IsArtifactFrameOpen()
	if not artifactFrameOpen then
		SocketInventoryItem(INVSLOT_MAINHAND)
	end

	local ArtifactFrame = _G.ArtifactFrame

	local itemId = select(1, ArtifactUI.GetArtifactInfo())
	if itemId == nil or itemId == 0 then
		if not artifactFrameOpen then
			HideUIPanel(ArtifactFrame)
		end
		return false, false, 0
	end

	-- if not select(1, IsUsableItem(itemId)) then
		-- if not artifactFrameOpen then
			-- HideUIPanel(ArtifactFrame)
		-- end
		-- return false, false, 0
	-- end

	local mhId = select(1, GetInventoryItemID("player", GetInventorySlotInfo("MainHandSlot")))
	local ohId = select(1, GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot")))
	local correctArtifactOpen = (mhId ~= nil and mhId == itemId) or (ohId ~= nil and ohId == itemId)

	if not correctArtifactOpen then
		print("|cFFFF0000Warning, attempting to generate Simulationcraft artifact output for the wrong item (expected " .. (mhId or 0) .. " or " .. (ohId or 0) .. ", got " .. itemId .. ")")
		HideUIPanel(ArtifactFrame)
		SocketInventoryItem(INVSLOT_MAINHAND)
		itemId = select(1, ArtifactUI.GetArtifactInfo())
	end

	return artifactFrameOpen, correctArtifactOpen, itemId
end

function PersoLib:CloseArtifactFrame(wasOpen, correctOpen)
	local ArtifactFrame = _G.ArtifactFrame

	if ArtifactFrame and (not wasOpen or not correctOpen) then
		HideUIPanel(ArtifactFrame)
	end
end

-- simc, generates artifact string
function PersoLib:GetArtifactString()
	local artifactFrameOpen, correctArtifactOpen, itemId = self:OpenArtifact()

	if not itemId then
		self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		return nil
	end

	local artifactId = ExtraData.ArtifactTable[itemId]
	if artifactId == nil then
		self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		return nil
	end

	-- Note, relics are handled by the item string
	local str = artifactId .. ':0:0:0:0'

	local baseRanks = {}
	local crucibleRanks = {}

	local powers = ArtifactUI.GetPowers()
	for i = 1, #powers do
		local powerId, powerRank = PersoLib:GetPowerData(powers[i])

		if powerRank > 0 then
			baseRanks[#baseRanks + 1] = powerId
			baseRanks[#baseRanks + 1] = powerRank
		end
	end

	if #baseRanks > 0 then
		str = str .. ':' .. table.concat(baseRanks, ':')
	end

	self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)

	return str
end

-- simc, generates crucible string
function PersoLib:GetCrucibleString(RelicSlot)
	local artifactFrameOpen, correctArtifactOpen, itemId = self:OpenArtifact()

	if not itemId then
		self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		return nil
	end

	local artifactId = ExtraData.ArtifactTable[itemId]
	if artifactId == nil then
		self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		return nil
	end

  
	local crucibleData = {}
	for ridx = 1, ArtifactUI.GetNumRelicSlots() do
		crucibleData[ridx] = PersoLib:GetCrucibleStringForSlot(ridx)
	end

	local crucibleStrings = {}
	for ridx = 1, #crucibleData do
		crucibleStrings[ridx] = table.concat(crucibleData[ridx], ':')
	end

	self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)

	return table.concat(crucibleStrings, '/')
end

-- simc generates crucible string for a specific slot
function PersoLib:GetCrucibleStringForSlot(RelicSlot,ForceOpenArtifact)
	if ForceOpenArtifact then
		local artifactFrameOpen, correctArtifactOpen, itemId = self:OpenArtifact()

		if not itemId then
			self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
			return nil
		end

		local artifactId = ExtraData.ArtifactTable[itemId]
		if artifactId == nil then
			self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
			return nil
		end
	end

	local link = select(4, ArtifactUI.GetRelicInfo(RelicSlot))
	if link ~= nil then
		local relicSplit     = PersoLib:LinkSplit(link)
		local baseLink       = select(2, GetItemInfo(relicSplit[1]))
		local basePowers     = { ArtifactUI.GetPowersAffectedByRelicItemLink(baseLink) }
		local relicPowers    = { ArtifactUI.GetPowersAffectedByRelic(RelicSlot) }
		local cruciblePowers = {}

		for rpidx = 1, #relicPowers do
			local found = false
			for bpidx = 1, #basePowers do
				if relicPowers[rpidx] == basePowers[bpidx] then
					found = true
					break
				end
			end

			if not found then
				cruciblePowers[#cruciblePowers + 1] = relicPowers[rpidx]
			end
		end
		
		if ForceOpenArtifact then
			self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		end

		if #cruciblePowers == 0 then
			return { 0 }
		else
			return cruciblePowers
		end
	else
		if ForceOpenArtifact then
			self:CloseArtifactFrame(artifactFrameOpen, correctArtifactOpen)
		end
		return { 0 }
	end
end

function PersoLib:ExtractCurrentCrucibleTree()
	local currentTree={}
	if ArtifactRelicForgeUI.IsAtForge() then
		if _G.ArtifactRelicForgeFrame.relicSlot and _G.ArtifactRelicForgeFrame.relicSlot <=3 then--relic slot
			local treeData={}
			treeData = ArtifactRelicForgeUI.GetSocketedRelicTalents(_G.ArtifactRelicForgeFrame.relicSlot)
			for k,v in pairs(treeData) do
				if not currentTree[treeData[k].tier] then currentTree[treeData[k].tier]={} end
				table.insert(currentTree[treeData[k].tier],treeData[k].powerID)
			end
		else -- preview slot
			local treeData={}
			treeData = ArtifactRelicForgeUI.GetPreviewRelicTalents()
			for k,v in pairs(treeData) do
				if not currentTree[treeData[k].tier] then currentTree[treeData[k].tier]={} end
				table.insert(currentTree[treeData[k].tier],treeData[k].powerID)
			end
		end
	end
	return currentTree
end

-- get item id from link
function PersoLib:GetIDFromLink(itemLink)
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

	return tonumber(itemSplit[1])
end

-- get item id from link
function PersoLib:GetILVLFromLink(itemLink)
	local ilvl
	_,_,_,ilvl = GetItemInfo(itemLink)
	return ilvl
end

function PersoLib:debugPrint(str,affichedebug)
	if affichedebug then
		print(str)
	end
end

function PersoLib:MergeTables(tableDefault,tableVars,tablereception)
	for k,v in pairs(tableDefault) do
		if tableVars[k] == nil then
			tablereception[k]=v
		else
			tablereception[k]=tableVars[k]
		end
	end
	return tablereception
end

function PersoLib:GetRealIlvl(itemLink)
	local itemString = string.match(itemLink, "item:([%-?%d:]+)")
	local itemSplit = {}
	
	-- Split data into a table
	for _, v in ipairs({strsplit(":", itemString)}) do
		if v == "" then
		  itemSplit[#itemSplit + 1] = 0
		else
		  itemSplit[#itemSplit + 1] = tonumber(v)
		end
	end
	_,_,itemRarity,ilvl = GetItemInfo(itemLink)
	if itemRarity==7 then --heirloom
		ilvl = 815
	elseif tonumber(itemSplit[11])==512 and tonumber(itemSplit[12])==22 and tonumber(itemSplit[15])==110 then --timewalking
		ilvl = 850
		--todo : 895 if warforged
	end
	
	return ilvl
end

function PersoLib:LinkSplit(link)
  local itemString = string.match(link, "item:([%-?%d:]+)")
  local itemSplit = {}

  -- Split data into a table
  for _, v in ipairs({strsplit(":", itemString)}) do
    if v == "" then
      itemSplit[#itemSplit + 1] = 0
    else
      itemSplit[#itemSplit + 1] = tonumber(v)
    end
  end

  return itemSplit
end

function PersoLib:GetNameFromTraitID(traitID,artifactID)
	local name=""
	if ExtraData.NetherlightData[1][traitID] then --crucible trait
		name = ExtraData.NetherlightData[1][traitID]
	elseif  ExtraData.NetherlightData[2][traitID] then--artifact trait
		name = ExtraData.NetherlightData[2][traitID]
	elseif ExtraData.NetherlightData[3][artifactID][traitID] then
		name = ExtraData.NetherlightData[3][artifactID][traitID]
	else
		name = ""
	end
	
	return name
end

function PersoLib:DumpTable(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      PersoLib:DumpTable(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end
