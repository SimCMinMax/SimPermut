local MAJOR, MINOR = "PersoLib", 1
local PersoLib = LibStub:NewLibrary(MAJOR, MINOR)

if not PersoLib then return end

local ArtifactUI          	= _G.C_ArtifactUI
local HasArtifactEquipped 	= _G.HasArtifactEquipped
local SocketInventoryItem 	= _G.SocketInventoryItem
local Timer               	= _G.C_Timer
local artifactTable 	  	= {
	-- Death Knight
	[128402] = 15,
	[128292] = 12,
	[128403] = 16,
	-- Demon Hunter
	[127829] = 3,
	[128832] = 60,
	-- Druid
	[128858] = 59,
	[128860] = 58,
	[128821] = 57,
	[128306] = 13,
	-- Hunter
	[128861] = 56,
	[128826] = 55,
	[128808] = 34,
	-- Mage
	[127857] = 4,
	[128820] = 54,
	[128862] = 53,
	-- Monk
	[128938] = 52,
	[128937] = 51,
	[128940] = 50,
	-- Paladin
	[128823] = 48,
	[128866] = 49,
	[120978] = 2,
	-- Priest
	[128868] = 46,
	[128825] = 45,
	[128827] = 47,
	-- Rogue
	[128870] = 43,
	[128872] = 44,
	[128476] = 17,
	-- Shaman
	[128935] = 40,
	[128819] = 41,
	[128911] = 32,
	-- Warlock
	[128942] = 39,
	[128943] = 37,
	[128941] = 38,
	-- Warrior
	[128910] = 36,
	[128908] = 35,
	[128289] = 11
}

local RoleTable={
  -- Death Knight
  [250] = 'tank',
  [251] = 'attack',
  [252] = 'attack',
  -- Demon Hunter
  [577] = 'attack',
  [581] = 'tank',
  -- Druid
  [102] = 'spell',
  [103] = 'attack',
  [104] = 'tank',
  [105] = 'heal',
  -- Hunter
  [253] = 'attack',
  [254] = 'attack',
  [255] = 'attack',
  -- Mage
  [62] = 'spell',
  [63] = 'spell',
  [64] = 'spell',
  -- Monk
  [268] = 'tank',
  [269] = 'attack',
  [270] = 'hybrid',
  -- Paladin
  [65] = 'heal',
  [66] = 'tank',
  [70] = 'attack',
  -- Priest
  [256] = 'spell',
  [257] = 'heal',
  [258] = 'spell',
  -- Rogue
  [259] = 'attack',
  [260] = 'attack',
  [261] = 'attack',
  -- Shaman
  [262] = 'spell',
  [263] = 'attack',
  [264] = 'heal',
  -- Warlock
  [265] = 'spell',
  [266] = 'spell',
  [267] = 'spell',
  -- Warrior
  [71] = 'attack',
  [72] = 'attack',
  [73] = 'attack'
}

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
															--print(tableToPermut[1][i1].." "..tableToPermut[2][i2].." "..tableToPermut[3][i3].." "..tableToPermut[4][i4].." "..tableToPermut[5][i5].." "..tableToPermut[6][i6].." "..tableToPermut[7][i7].." "..tableToPermut[8][i8].." "..tableToPermut[9][i9].." "..tableToPermut[10][i10].." "..tableToPermut[11][i11].." "..tableToPermut[12][i12])
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

  -- keep stuff we want, dumpster everything else
  -- local s = ""
  -- for i=1,str:len() do
    -- keep digits 0-9
    -- if str:byte(i) >= 48 and str:byte(i) <= 57 then
      -- s = s .. str:sub(i,i)
      -- keep lowercase letters
    -- elseif str:byte(i) >= 97 and str:byte(i) <= 122 then
      -- s = s .. str:sub(i,i)
      -- keep %, +, ., _
    -- elseif str:byte(i)==37 or str:byte(i)==43 or str:byte(i)==46 or str:byte(i)==95 then
      -- s = s .. str:sub(i,i)
    -- end
  -- end
  -- strip trailing spaces
  if string.sub(str, str:len())=='_' then
    str = string.sub(str, 0, str:len()-1)
  end
  return str
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
  local spec_role = RoleTable[spec_id]
  if spec_role ~= nil then
    return spec_role
  end
end

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

function PersoLib:getSpecID()
	local globalSpecID
	local specId = GetSpecialization()
	if specId then
		globalSpecID = GetSpecializationInfo(specId)
	end
	return globalSpecID
end

-- simc, Artifact Information
function PersoLib:IsArtifactFrameOpen()
  local ArtifactFrame 	  = _G.ArtifactFrame
  return ArtifactFrame and ArtifactFrame:IsShown() or false
end

-- simc, generates artifact string
function PersoLib:GetArtifactString()
  if not HasArtifactEquipped() then
    return nil
  end
    
  -- Unregister the events to prevent unwanted call. (thx Aethys :o)
  --UIParent:UnregisterEvent("ARTIFACT_UPDATE");
  UIParent:UnregisterEvent("ARTIFACT_UPDATE");
  if not PersoLib:IsArtifactFrameOpen() then
    SocketInventoryItem(INVSLOT_MAINHAND)
  end

  local item_id = select(1, ArtifactUI.GetArtifactInfo())
  if item_id == nil or item_id == 0 then
    return nil
  end

  local artifact_id = artifactTable[item_id]
  if artifact_id == nil then
    return nil
  end

  -- Note, relics are handled by the item string
  local str = 'artifact=' .. artifact_id .. ':0:0:0:0'

  local powers = ArtifactUI.GetPowers()
  for i = 1, #powers do
    local power_id = powers[i]
    local info = ArtifactUI.GetPowerInfo(power_id)
    if info.currentRank > 0 and info.currentRank - info.bonusRanks > 0 then
      str = str .. ':' .. power_id .. ':' .. (info.currentRank - info.bonusRanks)
    end
  end
  
  --ArtifactFrame:Hide()
  --CloseSocketInfo()
  UIParent:RegisterEvent("ARTIFACT_UPDATE");
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

	return itemSplit[1]
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
		ilvl = 815
	end
	
	return ilvl
end
