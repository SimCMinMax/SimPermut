local MAJOR, MINOR = "PersoLib", 1
local PersoLib = LibStub:NewLibrary(MAJOR, MINOR)

if not PersoLib then return end

local ArtifactUI          	= _G.C_ArtifactUI
local HasArtifactEquipped 	= _G.HasArtifactEquipped
local SocketInventoryItem 	= _G.SocketInventoryItem
local extraData			

function PersoLib:Init(Datas)
	extraData=Datas
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
  local spec_role = extraData.RoleTable[spec_id]
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
  UIParent:UnregisterEvent("ARTIFACT_UPDATE");
  if not PersoLib:IsArtifactFrameOpen() then
    SocketInventoryItem(INVSLOT_MAINHAND)
  end

  local item_id = select(1, ArtifactUI.GetArtifactInfo())
  if item_id == nil or item_id == 0 then
    return nil
  end

  local artifact_id = extraData.artifactTable[item_id]
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