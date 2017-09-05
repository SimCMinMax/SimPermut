local _, SimPermut = ...

SimPermut = LibStub("AceAddon-3.0"):NewAddon(SimPermut, "SimPermut", "AceConsole-3.0", "AceEvent-3.0")

SimPermutVars={}

local OFFSET_ITEM_ID 	= 1
local OFFSET_ENCHANT_ID = 2
local OFFSET_GEM_ID_1 	= 3
local OFFSET_GEM_ID_2 	= 4
local OFFSET_GEM_ID_3 	= 5
local OFFSET_GEM_ID_4 	= 6
local OFFSET_SUFFIX_ID 	= 7
local OFFSET_FLAGS 		= 11
local OFFSET_BONUS_ID 	= 13
local TALENTS_MAX_COLUMN= 3
local TALENTS_MAX_ROW	= 7
local RELIC_MIN_ILVL	= 780
local RELIC_MAX_ILVL	= 999

-- Libs
local ArtifactUI          	= _G.C_ArtifactUI
local Clear                 = ArtifactUI.Clear
local HasArtifactEquipped 	= _G.HasArtifactEquipped
local SocketInventoryItem 	= _G.SocketInventoryItem
local Timer               	= _G.C_Timer
local AceGUI 			  	= LibStub("AceGUI-3.0")
local LAD					= LibStub("LibArtifactData-1.0")
local PersoLib			  	= LibStub("PersoLib")

--UI
local variablesLoaded=false
local mainframe 
local mainframeCreated=false
local stringframeCreated=false
local scroll1
local scroll2
local scroll3
local checkBoxForce
local actualEnchantNeck=0
local actualEnchantFinger=0
local actualEnchantBack=0
local actualGem=0
local actualForce=false
local editLegMin=0
local editLegMax=0
local actualLegMin=0
local actualLegMax=0
local actualSetsT19=0
local actualSetsT20=0
local actualSetsT21=0
local tableListItems={}
local tableTitres={}
local tableLabel={}
local tableCheckBoxes={}
local tableLinkPermut={}
local tableBaseLink={}
local tableBaseString={}
local tableNumberSelected={}
local labelCount
local selecteditems=0
local errorMessage=""
local artifactData={}
local artifactID
local resultBox
local fingerInf = false
local trinketInf = false
local classID=0
local equipedLegendaries=0
local ad=false
local tableTalentLabel={}
local tableTalentIcon={}
local tableTalentcheckbox={}
local tableTalentSpells={}
local tableTalentResults={}
local currentFrame=1
local mainGroup
local resultGroup
local tablePreCheck={}
local DropdownTrait1
local DropdownTrait2
local DropdownTrait3
local ilvlTrait1
local ilvlTrait2
local ilvlTrait3
local ilvlWeapon
local relicCopyCount=1
local relicString=""
local crucibleCopyCount=1
local crucibleString=""
local relicComparisonTypeValue=1
local CrucibleTypeTypeValue=1
local spacerTable={}
local dropdownTableCrucible={}
local epicGemUsed


-- Parameters
local ITEM_COUNT_THRESHOLD 		= 25
local COPY_THRESHOLD 			= 500
local defaultSettings={
	report_typeGear		= 2,
	report_typeTalents	= 2,
	report_typeRelics	= 2,
	report_typeCrucible	= 2,
	ilvl_thresholdMin 	= 800,
	ilvl_thresholdMax 	= 999,
	enchant_neck		= 0,
	enchant_back		= 0,	
	enchant_ring		= 0,		
	gems				= 0,	
	gemsEpic			= 0,
	setsT19				= 0,
	setsT20				= 0,
	setsT21				= 0,
	generateStart		= true,
	replaceEnchants		= false,
	replaceEnchantsBase	= false,
	ilvl_RelicMin		= 780,
	ilvl_RelicMax		= 999,
	addedItemsTable		= {},
	smallUI				= false,
	simcCommands		= ""
}
local actualSettings={}

-- load stuff from extras.lua
local ExtraData			= SimPermut.ExtraData

SLASH_SIMPERMUTSLASH1 = "/SimPermut"
SLASH_SIMPERMUTSLASHDEBUG1 = "/SimPermutDebug"

-------------Test-----------------
SLASH_SIMPERMUTSLASHTEST1 = "/Simtest"
SlashCmdList["SIMPERMUTSLASHTEST"] = function (arg)
end
-------------Test-----------------

-- Command UI
SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	if mainframeCreated and mainframe:IsShown() then
		mainframe:Hide()
	else
		if not variablesLoaded then
			if not SimPermutVars then SimPermutVars = {} end
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
			variablesLoaded=true
		end
	
		--handle commandline
		for i=1,#ExtraData.ListNames do
			if string.match(arg, ExtraData.ListNames[i]) then
				tablePreCheck[i]=true
			else
				tablePreCheck[i]=false
			end
		end
		SimPermut:BuildFrame()
		mainframeCreated=true
	end
end

SlashCmdList["SIMPERMUTSLASHDEBUG"] = function (arg)
	if ad then
		ad = false
		print("SimpPermut:Desactivated debug")
	else
		ad = true
		print("SimpPermut:Activated debug")
	end
end

function SimPermut:OnInitialize()
	SlashCmdList["SimPermut"] = handler;
end

function SimPermut:OnEnable()
end

function SimPermut:OnDisable()
end

----------------------------
----------- UI -------------
----------------------------
-- Main Frame construction
function SimPermut:BuildFrame()
	--Init Vars
	artifactID,artifactData = LAD:GetArtifactInfo() 
	
	if mainframe and mainframe:IsVisible() then
		mainframe:Release()
	end
	
	mainframe = AceGUI:Create("Frame")
	mainframe:SetTitle("SimPermut")
	mainframe:SetPoint("CENTER")
	mainframe:SetCallback("OnClose", function(widget) 
		if mainframe:IsVisible() then
			widget:Release()
		end
		if stringframeCreated and SimcCopyFrame:IsShown() then
			SimcCopyFrame:Hide()
		end
	end)
	mainframe:SetLayout("Flow")
	
	if actualSettings.smallUI then
		mainframe:SetWidth(1000)
		mainframe:SetHeight(710)
	else
		mainframe:SetWidth(1300)
		mainframe:SetHeight(810)
	end
	
	local frameDropdown = AceGUI:Create("Dropdown")
    frameDropdown:SetWidth(200)
	frameDropdown:SetList(ExtraData.FrameMenu)
	frameDropdown:SetLabel("")
	frameDropdown:SetValue(currentFrame)
	frameDropdown:SetCallback("OnValueChanged", function (this, event, item)
		currentFrame=item
		if mainframe:IsVisible() then
			mainframe:Release()
		end
		SimPermut:BuildFrame()
    end)
	mainframe:AddChild(frameDropdown)
	
	SimPermut:AddSpacer(mainframe,true)
	
	if currentFrame==1 then --gear
		currentFrame=1
		SimPermut:BuildGearFrame()
		SimPermut:BuildResultFrame(true)
		SimPermut:InitGearFrame()
	elseif currentFrame==2 then --talents
		currentFrame=2
		SimPermut:BuildTalentFrame()
		SimPermut:BuildResultFrame(false)
		SimPermut:GenerateTalents()
	elseif currentFrame==3 then --relics
		currentFrame=3
		SimPermut:BuildRelicFrame()
		SimPermut:BuildResultFrame(false)
	elseif currentFrame==4 then --NetherLight crucible
		currentFrame=4
		SimPermut:BuildNetherlightFrame()
		SimPermut:BuildResultFrame(false)
	elseif currentFrame==5 then --add items
		currentFrame=5
		SimPermut:BuildDungeonJournalFrame()
	elseif currentFrame==6 then --options
		currentFrame=6
		SimPermut:BuildOptionFrame()
	end
end

-- Field construction for gear Frame
function SimPermut:BuildGearFrame()
	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Flow")
    mainGroup:SetRelativeWidth(0.65)
	
	local scrollcontainer1 = AceGUI:Create("SimpleGroup")
	scrollcontainer1:SetRelativeWidth(0.5)
	if actualSettings.smallUI then
		scrollcontainer1:SetHeight(460)
	else
		scrollcontainer1:SetHeight(600)
	end
	scrollcontainer1:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer1)
	
	scroll1 = AceGUI:Create("ScrollFrame")
	scroll1:SetLayout("Flow")
	scrollcontainer1:AddChild(scroll1)
	
	local scrollcontainer2 = AceGUI:Create("SimpleGroup")
	scrollcontainer2:SetRelativeWidth(0.5)
	if actualSettings.smallUI then
		scrollcontainer2:SetHeight(460)
	else
		scrollcontainer2:SetHeight(600)
	end
	scrollcontainer2:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer2)
	
	scroll2 = AceGUI:Create("ScrollFrame")
	scroll2:SetLayout("Flow")
	scrollcontainer2:AddChild(scroll2)

	
	------ Items + param
	local labelEnchantNeck= AceGUI:Create("Label")
	labelEnchantNeck:SetText("Enchant Neck")
	labelEnchantNeck:SetWidth(80)
	mainGroup:AddChild(labelEnchantNeck)
	
	local dropdownEnchantNeck = AceGUI:Create("Dropdown")
	dropdownEnchantNeck:SetWidth(130)
	dropdownEnchantNeck:SetList(ExtraData.enchantNeck)
	dropdownEnchantNeck:SetValue(actualSettings.enchant_neck)
	dropdownEnchantNeck:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantNeck=item
    end)
	mainGroup:AddChild(dropdownEnchantNeck)
		
	local labelEnchantBack= AceGUI:Create("Label")
	labelEnchantBack:SetText("     Enchant Back")
	labelEnchantBack:SetWidth(95)
	mainGroup:AddChild(labelEnchantBack)
	
	local dropdownEnchantBack = AceGUI:Create("Dropdown")
	dropdownEnchantBack:SetWidth(110)
	dropdownEnchantBack:SetList(ExtraData.enchantCloak)
	dropdownEnchantBack:SetValue(actualSettings.enchant_back)
	dropdownEnchantBack:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantBack=item
    end)
	mainGroup:AddChild(dropdownEnchantBack)
	
	local labelEnchantFinger= AceGUI:Create("Label")
	labelEnchantFinger:SetText("     Enchant Ring")
	labelEnchantFinger:SetWidth(95)
	mainGroup:AddChild(labelEnchantFinger)
	
	local dropdownEnchantFinger = AceGUI:Create("Dropdown")
	dropdownEnchantFinger:SetWidth(110)
	dropdownEnchantFinger:SetList(ExtraData.enchantRing)
	dropdownEnchantFinger:SetValue(actualSettings.enchant_ring)
	dropdownEnchantFinger:SetCallback("OnValueChanged", function (this, event, item)
		actualEnchantFinger=item
    end)
	mainGroup:AddChild(dropdownEnchantFinger)
	
	local labelGem= AceGUI:Create("Label")
	labelGem:SetText("     Gem")
	labelGem:SetWidth(55)
	mainGroup:AddChild(labelGem)
	
	local dropdownGem = AceGUI:Create("Dropdown")
	dropdownGem:SetList(ExtraData.gemList)
	dropdownGem:SetWidth(110)
	dropdownGem:SetValue(actualSettings.gems)
	dropdownGem:SetCallback("OnValueChanged", function (this, event, item)
		actualGem=item
    end)
	mainGroup:AddChild(dropdownGem)
	
	checkBoxForce = AceGUI:Create("CheckBox")
	checkBoxForce:SetWidth(210)
	checkBoxForce:SetLabel("Replace current enchant/gems")
	checkBoxForce:SetValue(actualSettings.replaceEnchants)
	checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		actualForce=checkBoxForce:GetValue()
    end)
	mainGroup:AddChild(checkBoxForce)

	SimPermut:AddSpacer(mainGroup,false,15)
	
	local labelLeg= AceGUI:Create("Label")
	labelLeg:SetText(" Legendaries")
	labelLeg:SetWidth(80)
	mainGroup:AddChild(labelLeg)
	
	editLegMin= AceGUI:Create("EditBox")
	editLegMin:SetText("0")
	editLegMin:SetWidth(20)
	editLegMin:DisableButton(true)
	editLegMin:SetMaxLetters(1)
	editLegMin:SetCallback("OnTextChanged", function (this, event, item)
		editLegMin:SetText(string.match(item, '%d'))
		if editLegMin:GetText()=="" then
			editLegMin:SetText(0)
		end
    end)
	mainGroup:AddChild(editLegMin)
	
	editLegMax= AceGUI:Create("EditBox")
	editLegMax:SetText("2")
	editLegMax:SetWidth(20)
	editLegMax:DisableButton(true)
	editLegMax:SetMaxLetters(1)
	editLegMax:SetCallback("OnTextChanged", function (this, event, item)
		editLegMax:SetText(string.match(item, '%d'))
		if editLegMax:GetText()=="" then
			editLegMax:SetText(0)
		end
    end)
	mainGroup:AddChild(editLegMax)
	
	SimPermut:AddSpacer(mainGroup,false,89)

	local labelSetsT19= AceGUI:Create("Label")
	labelSetsT19:SetText("T19 (min)")
	labelSetsT19:SetWidth(76)
	mainGroup:AddChild(labelSetsT19)
	
	local dropdownSetsT19 = AceGUI:Create("Dropdown")
	dropdownSetsT19:SetList(ExtraData.SetsListT19)
	dropdownSetsT19:SetWidth(110)
	dropdownSetsT19:SetValue(actualSettings.setsT19)
	dropdownSetsT19:SetCallback("OnValueChanged", function (this, event, item)
		actualSetsT19=item
    end)
	mainGroup:AddChild(dropdownSetsT19)

	local labelSetsT20= AceGUI:Create("Label")
	labelSetsT20:SetText("T20 (min)")
	labelSetsT20:SetWidth(55)
	mainGroup:AddChild(labelSetsT20)

	local dropdownSetsT20 = AceGUI:Create("Dropdown")
	dropdownSetsT20:SetList(ExtraData.SetsListT20)
	dropdownSetsT20:SetWidth(110)
	dropdownSetsT20:SetValue(actualSettings.setsT20)
	dropdownSetsT20:SetCallback("OnValueChanged", function (this, event, item)
		actualSetsT20=item
    end)
	mainGroup:AddChild(dropdownSetsT20)
	
	SimPermut:AddSpacer(mainGroup,false,90)

	local labelreportTypeGear= AceGUI:Create("Label")
	labelreportTypeGear:SetText("Report Type : Gear")
	labelreportTypeGear:SetWidth(150)
	local ReportDropdownGear = AceGUI:Create("Dropdown")
    ReportDropdownGear:SetWidth(160)
	ReportDropdownGear:SetList(ExtraData.ReportTypeGear)
	ReportDropdownGear:SetLabel("Report Type")
	ReportDropdownGear:SetValue(actualSettings.report_typeGear)
	ReportDropdownGear:SetCallback("OnValueChanged", function (this, event, item)
		actualSettings.report_typeGear=item
    end)
	mainGroup:AddChild(ReportDropdownGear)

	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetWidth(165)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:Generate()
	end)
	mainGroup:AddChild(buttonGenerate)

	labelCount= AceGUI:Create("Label")
	labelCount:SetText(" ")
	labelCount:SetWidth(255)
	mainGroup:AddChild(labelCount)

	mainframe:AddChild(mainGroup)
end

-- Field construction for talent Frame
function SimPermut:BuildTalentFrame()
	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Flow")
    mainGroup:SetRelativeWidth(0.65)
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Talent Permutation")
	labeltitre1:SetFullWidth(true)
	mainGroup:AddChild(labeltitre1)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetRelativeWidth(0.3)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	mainGroup:AddChild(container1)
	
	local container2 = AceGUI:Create("SimpleGroup")
	container2:SetRelativeWidth(0.3)
	container2:SetHeight(600)
	container2:SetLayout("Flow")
	mainGroup:AddChild(container2)
	
	local container3 = AceGUI:Create("SimpleGroup")
	container3:SetRelativeWidth(0.3)
	container3:SetHeight(600)
	container3:SetLayout("Flow")
	mainGroup:AddChild(container3)
	
	for i=1,TALENTS_MAX_ROW do
		tableTalentcheckbox[i]={}
		tableTalentIcon[i]={}
		tableTalentLabel[i]={}
		tableTalentSpells[i]={}
		for j=1,TALENTS_MAX_COLUMN do
			local talentID, name, texture, selected, available, spellid=GetTalentInfo(i,j,GetActiveSpecGroup())
			tableTalentSpells[i][j]=spellid
			tableTalentcheckbox[i][j]=AceGUI:Create("CheckBox")
			tableTalentcheckbox[i][j]:SetLabel("")
			tableTalentcheckbox[i][j]:SetRelativeWidth(0.2)
			if selected then
				tableTalentcheckbox[i][j]:SetValue(true)
			end
			
			local _, _, Talenticon = GetSpellInfo(spellid)
			tableTalentIcon[i][j]=AceGUI:Create("Icon")
			tableTalentIcon[i][j]:SetImage(Talenticon)
			tableTalentIcon[i][j]:SetImageSize(40,40)
			tableTalentIcon[i][j]:SetRelativeWidth(0.3)
			tableTalentIcon[i][j]:SetCallback("OnEnter", function(widget)
				GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
				GameTooltip:SetSpellByID(tableTalentSpells[i][j])
				GameTooltip:Show()
			end)			
			tableTalentIcon[i][j]:SetCallback("OnLeave", function(widget)
				GameTooltip:Hide()
			end)
			
			tableTalentLabel[i][j]=AceGUI:Create("Label")
			tableTalentLabel[i][j]:SetText(name)
			tableTalentLabel[i][j]:SetRelativeWidth(0.5)
				
			if j==1 then
				container1:AddChild(tableTalentcheckbox[i][j])
				container1:AddChild(tableTalentIcon[i][j])
				container1:AddChild(tableTalentLabel[i][j])
			elseif j==2 then
				container2:AddChild(tableTalentcheckbox[i][j])
				container2:AddChild(tableTalentIcon[i][j])
				container2:AddChild(tableTalentLabel[i][j])
			else
				container3:AddChild(tableTalentcheckbox[i][j])
				container3:AddChild(tableTalentIcon[i][j])
				container3:AddChild(tableTalentLabel[i][j])
			end
		end
	end

	SimPermut:AddSpacer(mainGroup,false,0.2)
	
	local ReportDropdownTalents = AceGUI:Create("Dropdown")
    ReportDropdownTalents:SetWidth(160)
	ReportDropdownTalents:SetList(ExtraData.ReportTypeTalents)
	ReportDropdownTalents:SetLabel("Report Type")
	ReportDropdownTalents:SetValue(actualSettings.report_typeTalents)
	ReportDropdownTalents:SetCallback("OnValueChanged", function (this, event, item)
		actualSettings.report_typeTalents=item
    end)
	mainGroup:AddChild(ReportDropdownTalents)
	
	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetRelativeWidth(0.2)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:GenerateTalents()
	end)
	mainGroup:AddChild(buttonGenerate)
	
	mainframe:AddChild(mainGroup)
end

-- Field construction for Relic Frame
function SimPermut:BuildRelicFrame()
	--init Artifact
	SimPermut:GetArtifactString()

	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Fill")
	mainGroup:SetHeight(600)
    mainGroup:SetRelativeWidth(0.65)
	mainframe:AddChild(mainGroup)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	mainGroup:AddChild(container1)
	
	local artifactID,artifactData = LAD:GetArtifactInfo()
	if not ExtraData.ArtifactTableTraitsOrder[artifactID] or #ExtraData.ArtifactTableTraitsOrder[artifactID][1] == 0 then
		local labeltitre2= AceGUI:Create("Label")
		labeltitre2:SetText("Class/Spec Not yet implemented")
		labeltitre2:SetFullWidth(true)
		container1:AddChild(labeltitre2)
		do return end
	end
	
	local drawRelic1=false
	local drawRelic2=false
	local drawRelic3=false
	if artifactData.relics[1].type then drawRelic1=true end
	if artifactData.relics[2].type then drawRelic2=true end
	if artifactData.relics[3].type then drawRelic3=true end
	
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Artifact Generator")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local relictype = AceGUI:Create("Dropdown")
	relictype:SetWidth(150)
	relictype:SetList(ExtraData.RelicComparisonType)
	relictype:SetLabel("Relic comparison type")
	relictype:SetValue(relicComparisonTypeValue)
	relictype:SetCallback("OnValueChanged", function (this, event, item)
		relicComparisonTypeValue=item
		if mainframe:IsVisible() then
			mainframe:Release()
		end
		SimPermut:BuildFrame()
    end)
	container1:AddChild(relictype)
	
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,false,80)
	
	local itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
    if not itemLink then
		local labeltitre2= AceGUI:Create("Label")
		labeltitre2:SetText("Artifact not found")
		labeltitre2:SetFullWidth(true)
		container1:AddChild(labeltitre2)
		do return end
	end
	
	local itemName, itemLevel, itemTexture, artifactIcon
	itemName, _, _, itemLevel, _, _, _, _, _, itemTexture, _ = GetItemInfo(itemLink)
	artifactIcon=AceGUI:Create("Icon")
	if itemTexture then
		artifactIcon:SetImage(itemTexture)
	end
	artifactIcon:SetImageSize(40,40)
	artifactIcon:SetWidth(60)
	artifactIcon:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(itemLink)
		GameTooltip:Show()
	end)			
	artifactIcon:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	container1:AddChild(artifactIcon)
	
	if relicComparisonTypeValue==1 then
		local labelweaponLvl= AceGUI:Create("Label")
		labelweaponLvl:SetText(itemLevel)
		labelweaponLvl:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE, MONOCHROME")
		labelweaponLvl:SetWidth(50)
		container1:AddChild(labelweaponLvl)
	else
		ilvlWeapon= AceGUI:Create("EditBox")
		ilvlWeapon:SetWidth(70)
		ilvlWeapon:SetMaxLetters(3)
		ilvlWeapon:SetText(itemLevel)
		ilvlWeapon:SetCallback("OnEnterPressed", function (this, event, item)
			ilvlWeapon:SetText(string.match(item, '(%d+)'))
			if ilvlWeapon:GetText()~=nil and ilvlWeapon:GetText()~=""  then
				if tonumber(ilvlWeapon:GetText())<actualSettings.ilvl_RelicMin then
					ilvlWeapon:SetText(actualSettings.ilvl_RelicMin)
				elseif tonumber(ilvlWeapon:GetText())>actualSettings.ilvl_RelicMax then
					ilvlWeapon:SetText(actualSettings.ilvl_RelicMax)
				end
			else
				ilvlWeapon:SetText(actualSettings.ilvl_RelicMin)
			end
		end)
		container1:AddChild(ilvlWeapon)
	end
	
	local labelweaponName= AceGUI:Create("Label")
	labelweaponName:SetText("  "..itemName)
	labelweaponName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE, MONOCHROME")
	labelweaponName:SetWidth(400)
	container1:AddChild(labelweaponName)
	
	SimPermut:AddSpacer(container1,true)
	

	if drawRelic1 then
		local reliccontainer1 = AceGUI:Create("SimpleGroup")
		reliccontainer1:SetRelativeWidth(0.33)
		reliccontainer1:SetLayout("Flow")
		container1:AddChild(reliccontainer1)
		
		SimPermut:AddSpacer(reliccontainer1,false,0.42)
		local relicinfo1= AceGUI:Create("Label")
		relicinfo1:SetRelativeWidth(0.58)
		relicinfo1:SetColor(1,.82,0)
		relicinfo1:SetText(_G["RELIC_SLOT_TYPE_"..artifactData.relics[1].type:upper()])
		reliccontainer1:AddChild(relicinfo1)
		
		SimPermut:AddSpacer(reliccontainer1,false,0.4)
		_, _, _, itemLevel1, _, _, _, _, _, itemTexture1, _ = GetItemInfo(artifactData.relics[1].link)
		local artifactRelicIcon1=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon1:SetImage(itemTexture1)
		end
		artifactRelicIcon1:SetImageSize(35,35)
		artifactRelicIcon1:SetRelativeWidth(0.2)
		artifactRelicIcon1:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(artifactData.relics[1].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon1:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer1:AddChild(artifactRelicIcon1)
		
		SimPermut:AddSpacer(reliccontainer1,true)
		SimPermut:AddSpacer(reliccontainer1,false,0.1)
		DropdownTrait1 = AceGUI:Create("Dropdown")
		DropdownTrait1:SetRelativeWidth(0.8)
		DropdownTrait1:SetList(ExtraData.ArtifactTableTraits[artifactID][1],ExtraData.ArtifactTableTraitsOrder[artifactID][1])
		DropdownTrait1:SetLabel("")
		DropdownTrait1:SetValue(0)
		reliccontainer1:AddChild(DropdownTrait1)
		
		if relicComparisonTypeValue==1 then
			SimPermut:AddSpacer(reliccontainer1,false,0.3)
			ilvlTrait1= AceGUI:Create("EditBox")
			ilvlTrait1:SetRelativeWidth(0.4)
			ilvlTrait1:SetMaxLetters(3)
			ilvlTrait1:SetText(itemLevel1)
			ilvlTrait1:SetCallback("OnEnterPressed", function (this, event, item)
				ilvlTrait1:SetText(string.match(item, '(%d+)'))
				if ilvlTrait1:GetText()~=nil and ilvlTrait1:GetText()~=""  then
					if tonumber(ilvlTrait1:GetText())<actualSettings.ilvl_RelicMin then
						ilvlTrait1:SetText(actualSettings.ilvl_RelicMin)
					elseif tonumber(ilvlTrait1:GetText())>actualSettings.ilvl_RelicMax then
						ilvlTrait1:SetText(actualSettings.ilvl_RelicMax)
					end
				else
					ilvlTrait1:SetText(actualSettings.ilvl_RelicMin)
				end
			end)
			reliccontainer1:AddChild(ilvlTrait1)
		end
	end
	
	if drawRelic2 then
		local reliccontainer2 = AceGUI:Create("SimpleGroup")
		reliccontainer2:SetRelativeWidth(0.33)
		reliccontainer2:SetLayout("Flow")
		container1:AddChild(reliccontainer2)
	
		SimPermut:AddSpacer(reliccontainer2,false,0.42)
		local relicinfo2= AceGUI:Create("Label")
		relicinfo2:SetRelativeWidth(0.58)
		relicinfo2:SetColor(1,.82,0)
		relicinfo2:SetText(_G["RELIC_SLOT_TYPE_"..artifactData.relics[2].type:upper()])
		reliccontainer2:AddChild(relicinfo2)
		
		SimPermut:AddSpacer(reliccontainer2,false,0.4)
		_, _, _, itemLevel2, _, _, _, _, _, itemTexture2, _ = GetItemInfo(artifactData.relics[2].link)
		local artifactRelicIcon2=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon2:SetImage(itemTexture2)
		end
		artifactRelicIcon2:SetImageSize(35,35)
		artifactRelicIcon2:SetRelativeWidth(0.2)
		artifactRelicIcon2:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(artifactData.relics[2].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon2:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer2:AddChild(artifactRelicIcon2)
		
		SimPermut:AddSpacer(reliccontainer2,true)
		SimPermut:AddSpacer(reliccontainer2,false,0.1)
		DropdownTrait2 = AceGUI:Create("Dropdown")
		DropdownTrait2:SetRelativeWidth(0.8)
		DropdownTrait2:SetList(ExtraData.ArtifactTableTraits[artifactID][2],ExtraData.ArtifactTableTraitsOrder[artifactID][2])
		DropdownTrait2:SetLabel("")
		DropdownTrait2:SetValue(0)
		reliccontainer2:AddChild(DropdownTrait2)
		
		if relicComparisonTypeValue==1 then
			SimPermut:AddSpacer(reliccontainer2,false,0.3)
			ilvlTrait2= AceGUI:Create("EditBox")
			ilvlTrait2:SetRelativeWidth(0.4)
			ilvlTrait2:SetMaxLetters(3)
			ilvlTrait2:SetText(itemLevel2)
			ilvlTrait2:SetCallback("OnEnterPressed", function (this, event, item)
				ilvlTrait2:SetText(string.match(item, '(%d+)'))
				if ilvlTrait2:GetText()~=nil and ilvlTrait2:GetText()~="" then
					if tonumber(ilvlTrait2:GetText())<actualSettings.ilvl_RelicMin then
						ilvlTrait2:SetText(actualSettings.ilvl_RelicMin)
					elseif tonumber(ilvlTrait2:GetText())>actualSettings.ilvl_RelicMax then
						ilvlTrait2:SetText(actualSettings.ilvl_RelicMax)
					end
				else
					ilvlTrait2:SetText(actualSettings.ilvl_RelicMin)
				end
			end)
			reliccontainer2:AddChild(ilvlTrait2)
		end
	end
	
	if drawRelic3 then
		local reliccontainer3 = AceGUI:Create("SimpleGroup")
		reliccontainer3:SetRelativeWidth(0.33)
		reliccontainer3:SetLayout("Flow")
		container1:AddChild(reliccontainer3)
		
		SimPermut:AddSpacer(reliccontainer3,false,0.42)
		local relicinfo3= AceGUI:Create("Label")
		relicinfo3:SetRelativeWidth(0.58)
		relicinfo3:SetColor(1,.82,0)
		relicinfo3:SetText(_G["RELIC_SLOT_TYPE_"..artifactData.relics[3].type:upper()])
		reliccontainer3:AddChild(relicinfo3)
		
		SimPermut:AddSpacer(reliccontainer3,false,0.4)
		_, _, _, itemLevel3, _, _, _, _, _, itemTexture3, _ = GetItemInfo(artifactData.relics[3].link)
		local artifactRelicIcon3=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon3:SetImage(itemTexture3)
		end
		artifactRelicIcon3:SetImageSize(35,35)
		artifactRelicIcon3:SetRelativeWidth(0.2)
		artifactRelicIcon3:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(artifactData.relics[3].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon3:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer3:AddChild(artifactRelicIcon3)
		
		SimPermut:AddSpacer(reliccontainer3,true)
		SimPermut:AddSpacer(reliccontainer3,false,0.1)
		DropdownTrait3 = AceGUI:Create("Dropdown")
		DropdownTrait3:SetRelativeWidth(0.8)
		DropdownTrait3:SetList(ExtraData.ArtifactTableTraits[artifactID][3],ExtraData.ArtifactTableTraitsOrder[artifactID][3])
		DropdownTrait3:SetLabel("")
		DropdownTrait3:SetValue(0)
		reliccontainer3:AddChild(DropdownTrait3)
		
		if relicComparisonTypeValue==1 then
			if not artifactData.relics[3].isLocked then
				SimPermut:AddSpacer(reliccontainer3,false,0.3)
				ilvlTrait3= AceGUI:Create("EditBox")
				ilvlTrait3:SetRelativeWidth(0.4)
				ilvlTrait3:SetMaxLetters(3)
				ilvlTrait3:SetText(itemLevel3)
				ilvlTrait3:SetCallback("OnEnterPressed", function (this, event, item)
					ilvlTrait3:SetText(string.match(item, '(%d+)'))
					if ilvlTrait3:GetText()~=nil and ilvlTrait3:GetText()~="" then
						if tonumber(ilvlTrait3:GetText())<actualSettings.ilvl_RelicMin then
							ilvlTrait3:SetText(actualSettings.ilvl_RelicMin)
						elseif tonumber(ilvlTrait3:GetText())>actualSettings.ilvl_RelicMax then
							ilvlTrait3:SetText(actualSettings.ilvl_RelicMax)
						end
					else
						ilvlTrait3:SetText(actualSettings.ilvl_RelicMin)
					end
				end)
				reliccontainer3:AddChild(ilvlTrait3)
			end
		end
	end

	SimPermut:AddSpacer(container1,false,0.3)
	local ReportDropdownRelics = AceGUI:Create("Dropdown")
    ReportDropdownRelics:SetWidth(160)
	ReportDropdownRelics:SetList(ExtraData.ReportTypeRelics)
	ReportDropdownRelics:SetLabel("Report Type")
	ReportDropdownRelics:SetValue(actualSettings.report_typeRelics)
	ReportDropdownRelics:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeRelics=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownRelics)
	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetRelativeWidth(0.2)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:GenerateRelic()
	end)
	container1:AddChild(buttonGenerate)
end

-- Field construction for crucible Frame
function SimPermut:BuildNetherlightFrame()
	--init Artifact
	SimPermut:GetArtifactString()
	dropdownTableCrucible={}
	local trait={}
	
	local artifactID,artifactData = LAD:GetArtifactInfo()
	if not ExtraData.ArtifactTableTraitsOrder[artifactID] or #ExtraData.ArtifactTableTraitsOrder[artifactID][1] == 0 then
		local labeltitre2= AceGUI:Create("Label")
		labeltitre2:SetText("Class/Spec Not yet implemented")
		labeltitre2:SetFullWidth(true)
		container1:AddChild(labeltitre2)
		do return end
	end
	
	local T2 = math.huge
	for k,v in pairs(ExtraData.NetherlightData[2])do
		T2 = math.min(k, T2)
	end
	local T3 = math.huge
	for k,v in pairs(ExtraData.NetherlightData[3][artifactID])do
		T3 = math.min(k, T3)
	end
	
	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Fill")
	mainGroup:SetHeight(600)
    mainGroup:SetRelativeWidth(0.65)
	mainframe:AddChild(mainGroup)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	mainGroup:AddChild(container1)	
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Netherlight Crucible")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local crucibletypedropdown = AceGUI:Create("Dropdown")
	crucibletypedropdown:SetWidth(150)
	crucibletypedropdown:SetList(ExtraData.CrucibleType)
	crucibletypedropdown:SetLabel("Comparison type")
	crucibletypedropdown:SetValue(CrucibleTypeTypeValue)
	crucibletypedropdown:SetCallback("OnValueChanged", function (this, event, item)
		CrucibleTypeTypeValue=item
		if mainframe:IsVisible() then
			mainframe:Release()
		end
		SimPermut:BuildFrame()
    end)
	container1:AddChild(crucibletypedropdown)
	
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,false,80)
	
	local itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
    if not itemLink then
		local labeltitre2= AceGUI:Create("Label")
		labeltitre2:SetText("Artifact not found")
		labeltitre2:SetFullWidth(true)
		container1:AddChild(labeltitre2)
		do return end
	end
	
	local itemName, itemLevel, itemTexture, artifactIcon
	itemName, _, _, itemLevel, _, _, _, _, _, itemTexture, _ = GetItemInfo(itemLink)
	artifactIcon=AceGUI:Create("Icon")
	if itemTexture then
		artifactIcon:SetImage(itemTexture)
	end
	artifactIcon:SetImageSize(40,40)
	artifactIcon:SetWidth(60)
	artifactIcon:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(itemLink)
		GameTooltip:Show()
	end)			
	artifactIcon:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	container1:AddChild(artifactIcon)
	
	local labelweaponLvl= AceGUI:Create("Label")
	labelweaponLvl:SetText(itemLevel)
	labelweaponLvl:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE, MONOCHROME")
	labelweaponLvl:SetWidth(50)
	container1:AddChild(labelweaponLvl)
	
	local labelweaponName= AceGUI:Create("Label")
	labelweaponName:SetText("  "..itemName)
	labelweaponName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE, MONOCHROME")
	labelweaponName:SetWidth(400)
	container1:AddChild(labelweaponName)
	
	SimPermut:AddSpacer(container1,true)
	
	if CrucibleTypeTypeValue==2 then
		--add left panel
		local cruciblecontainerleft = AceGUI:Create("SimpleGroup")
		cruciblecontainerleft:SetRelativeWidth(0.33)
		cruciblecontainerleft:SetLayout("Flow")
		container1:AddChild(cruciblecontainerleft)
		
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.42)
		local relicinfo11= AceGUI:Create("Label")
		relicinfo11:SetRelativeWidth(0.58)
		relicinfo11:SetColor(1,.82,0)
		relicinfo11:SetText("Relic 1")
		cruciblecontainerleft:AddChild(relicinfo11)
		
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.42)
	
		local relicinfoleft= AceGUI:Create("Label")
		relicinfoleft:SetRelativeWidth(0.58)
		relicinfoleft:SetColor(1,.82,0)
		relicinfoleft:SetText("Tier 2 trait")
		cruciblecontainerleft:AddChild(relicinfoleft)
		
		SimPermut:AddSpacer(cruciblecontainerleft,true)
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.1)

		local  spellTextureleft, crucibleIconleft
		crucibleIconleft=AceGUI:Create("Icon")
		dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
		dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
		dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[2])
		dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
		dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T2)
		trait[1]=T2
		dropdownTableCrucible[#dropdownTableCrucible]:SetCallback("OnValueChanged", function (this, event, item)
			trait[1]=item
			_, _, spellTextureleft = GetSpellInfo(ExtraData.NetherlightSpellID[item])
			if spellTextureleft then
				crucibleIconleft:SetImage(spellTextureleft)
			end
		end)
		cruciblecontainerleft:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
		
		SimPermut:AddSpacer(cruciblecontainerleft,true)
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.4)
		
		_, _, spellTextureleft = GetSpellInfo(ExtraData.NetherlightSpellID[trait[1]])
		if spellTextureleft then
			crucibleIconleft:SetImage(spellTextureleft)
		end
		crucibleIconleft:SetImageSize(40,40)
		crucibleIconleft:SetWidth(60)
		crucibleIconleft:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink("spell:"..ExtraData.NetherlightSpellID[trait[1]])
			GameTooltip:Show()
		end)			
		crucibleIconleft:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		cruciblecontainerleft:AddChild(crucibleIconleft)
		
		SimPermut:AddSpacer(cruciblecontainerleft,true)
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.42)
		
		local relicinfo11left= AceGUI:Create("Label")
		relicinfo11left:SetRelativeWidth(0.58)
		relicinfo11left:SetColor(1,.82,0)
		relicinfo11left:SetText("Tier 3 relic trait")
		cruciblecontainerleft:AddChild(relicinfo11left)
		
		SimPermut:AddSpacer(cruciblecontainerleft,true)
		SimPermut:AddSpacer(cruciblecontainerleft,false,0.1)
		dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
		dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
		dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[3][artifactID])
		dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
		dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T3)
		cruciblecontainerleft:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
	else--spacer container
		local containerfiller = AceGUI:Create("SimpleGroup")
		containerfiller:SetRelativeWidth(0.33)
		containerfiller:SetLayout("Flow")
		container1:AddChild(containerfiller)
	end
	
	
	local cruciblecontainer = AceGUI:Create("SimpleGroup")
	cruciblecontainer:SetRelativeWidth(0.33)
	cruciblecontainer:SetLayout("Flow")
	container1:AddChild(cruciblecontainer)
	
	if CrucibleTypeTypeValue==2 then
		SimPermut:AddSpacer(cruciblecontainer,false,0.42)
		local relicinfo2= AceGUI:Create("Label")
		relicinfo2:SetRelativeWidth(0.58)
		relicinfo2:SetColor(1,.82,0)
		relicinfo2:SetText("Relic 2")
		cruciblecontainer:AddChild(relicinfo2)
	end
	
	SimPermut:AddSpacer(cruciblecontainer,false,0.42)
	
	local relicinfo1= AceGUI:Create("Label")
	relicinfo1:SetRelativeWidth(0.58)
	relicinfo1:SetColor(1,.82,0)
	relicinfo1:SetText("Tier 2 trait")
	cruciblecontainer:AddChild(relicinfo1)
	
	SimPermut:AddSpacer(cruciblecontainer,true)
	SimPermut:AddSpacer(cruciblecontainer,false,0.1)

	local  spellTexture, crucibleIcon
	crucibleIcon=AceGUI:Create("Icon")
	dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
	dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
	dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[2])
	dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
	dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T2)
	trait[2]=T2
	dropdownTableCrucible[#dropdownTableCrucible]:SetCallback("OnValueChanged", function (this, event, item)
		trait[2]=item
		_, _, spellTexture = GetSpellInfo(ExtraData.NetherlightSpellID[item])
		if spellTexture then
			crucibleIcon:SetImage(spellTexture)
		end
    end)
	cruciblecontainer:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
	
	SimPermut:AddSpacer(cruciblecontainer,true)
	SimPermut:AddSpacer(cruciblecontainer,false,0.4)
	
	_, _, spellTexture = GetSpellInfo(ExtraData.NetherlightSpellID[trait[2]])
	if spellTexture then
		crucibleIcon:SetImage(spellTexture)
	end
	crucibleIcon:SetImageSize(40,40)
	crucibleIcon:SetWidth(60)
	crucibleIcon:SetCallback("OnEnter", function(widget)
		GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink("spell:"..ExtraData.NetherlightSpellID[trait[2]])
		GameTooltip:Show()
	end)			
	crucibleIcon:SetCallback("OnLeave", function(widget)
		GameTooltip:Hide()
	end)
	cruciblecontainer:AddChild(crucibleIcon)
	
	SimPermut:AddSpacer(cruciblecontainer,true)
	SimPermut:AddSpacer(cruciblecontainer,false,0.42)
	
	local relicinfo11= AceGUI:Create("Label")
	relicinfo11:SetRelativeWidth(0.58)
	relicinfo11:SetColor(1,.82,0)
	relicinfo11:SetText("Tier 3 relic trait")
	cruciblecontainer:AddChild(relicinfo11)
	
	SimPermut:AddSpacer(cruciblecontainer,true)
	SimPermut:AddSpacer(cruciblecontainer,false,0.1)
	dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
	dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
	dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[3][artifactID])
	dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
	dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T3)
	cruciblecontainer:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
	
	if CrucibleTypeTypeValue==2 then
		--add left panel
		local cruciblecontainerright = AceGUI:Create("SimpleGroup")
		cruciblecontainerright:SetRelativeWidth(0.33)
		cruciblecontainerright:SetLayout("Flow")
		container1:AddChild(cruciblecontainerright)
		
		SimPermut:AddSpacer(cruciblecontainerright,false,0.42)
		local relicinfo2= AceGUI:Create("Label")
		relicinfo2:SetRelativeWidth(0.58)
		relicinfo2:SetColor(1,.82,0)
		relicinfo2:SetText("Relic 3")
		cruciblecontainerright:AddChild(relicinfo2)
		
		SimPermut:AddSpacer(cruciblecontainerright,false,0.42)
	
		local relicinforight= AceGUI:Create("Label")
		relicinforight:SetRelativeWidth(0.58)
		relicinforight:SetColor(1,.82,0)
		relicinforight:SetText("Tier 2 trait")
		cruciblecontainerright:AddChild(relicinforight)
		
		SimPermut:AddSpacer(cruciblecontainerright,true)
		SimPermut:AddSpacer(cruciblecontainerright,false,0.1)

		local  spellTextureright, crucibleIconright
		crucibleIconright=AceGUI:Create("Icon")
		dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
		dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
		dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[2])
		dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
		dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T2)
		trait[3]=T2
		dropdownTableCrucible[#dropdownTableCrucible]:SetCallback("OnValueChanged", function (this, event, item)
			trait[3]=item
			_, _, spellTextureright = GetSpellInfo(ExtraData.NetherlightSpellID[item])
			if spellTextureright then
				crucibleIconright:SetImage(spellTextureright)
			end
		end)
		cruciblecontainerright:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
		
		SimPermut:AddSpacer(cruciblecontainerright,true)
		SimPermut:AddSpacer(cruciblecontainerright,false,0.4)
		
		_, _, spellTextureright = GetSpellInfo(ExtraData.NetherlightSpellID[trait[3]])
		if spellTextureright then
			crucibleIconright:SetImage(spellTextureright)
		end
		crucibleIconright:SetImageSize(40,40)
		crucibleIconright:SetWidth(60)
		crucibleIconright:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink("spell:"..ExtraData.NetherlightSpellID[trait[3]])
			GameTooltip:Show()
		end)			
		crucibleIconright:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		cruciblecontainerright:AddChild(crucibleIconright)
		
		SimPermut:AddSpacer(cruciblecontainerright,true)
		SimPermut:AddSpacer(cruciblecontainerright,false,0.42)
		
		local relicinfo11right= AceGUI:Create("Label")
		relicinfo11right:SetRelativeWidth(0.58)
		relicinfo11right:SetColor(1,.82,0)
		relicinfo11right:SetText("Tier 3 relic trait")
		cruciblecontainerright:AddChild(relicinfo11right)
		
		SimPermut:AddSpacer(cruciblecontainerright,true)
		SimPermut:AddSpacer(cruciblecontainerright,false,0.1)
		dropdownTableCrucible[#dropdownTableCrucible+1] = AceGUI:Create("Dropdown")
		dropdownTableCrucible[#dropdownTableCrucible]:SetRelativeWidth(0.8)
		dropdownTableCrucible[#dropdownTableCrucible]:SetList(ExtraData.NetherlightData[3][artifactID])
		dropdownTableCrucible[#dropdownTableCrucible]:SetLabel("")
		dropdownTableCrucible[#dropdownTableCrucible]:SetValue(T3)
		cruciblecontainerright:AddChild(dropdownTableCrucible[#dropdownTableCrucible])
	else
		local containerfillerright2 = AceGUI:Create("SimpleGroup")
		containerfillerright2:SetRelativeWidth(0.33)
		containerfillerright2:SetLayout("Flow")
		container1:AddChild(containerfillerright2)
	end
	
	SimPermut:AddSpacer(container1,false,0.3)
	local ReportDropdownCruciblegen = AceGUI:Create("Dropdown")
    ReportDropdownCruciblegen:SetWidth(160)
	ReportDropdownCruciblegen:SetList(ExtraData.ReportTypeCrucible)
	ReportDropdownCruciblegen:SetLabel("Report Type")
	ReportDropdownCruciblegen:SetValue(actualSettings.report_typeCrucible)
	ReportDropdownCruciblegen:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeCrucible=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownCruciblegen)
	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetRelativeWidth(0.2)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:GenerateCrucible()
	end)
	container1:AddChild(buttonGenerate)
end

-- Field construction for Dungeon Journal Frame
function SimPermut:BuildDungeonJournalFrame()
	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Flow")
    mainGroup:SetRelativeWidth(1)
	mainframe:AddChild(mainGroup)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(100)
	container1:SetLayout("Flow")
	mainGroup:AddChild(container1)
	
	-- Add an item
	local editLink= AceGUI:Create("EditBox")
	editLink:SetRelativeWidth(0.5)
	editLink:SetText("")
	editLink:SetLabel("Link")
	editLink:DisableButton(true)
	container1:AddChild(editLink)
	
	local editLinkilvl= AceGUI:Create("EditBox")
	editLinkilvl:SetRelativeWidth(0.1)
	editLinkilvl:SetText("")
	editLinkilvl:SetMaxLetters(4)
	editLinkilvl:SetLabel("iLVL")
	editLinkilvl:DisableButton(true)
	container1:AddChild(editLinkilvl)
	
	local checkBoxSocket = AceGUI:Create("CheckBox")
	checkBoxSocket:SetRelativeWidth(0.1)
	checkBoxSocket:SetLabel("Socket")
	checkBoxSocket:SetValue(false)
	container1:AddChild(checkBoxSocket)
	
	local buttonAdd = AceGUI:Create("Button")
	buttonAdd:SetText("Add to List")
	buttonAdd:SetRelativeWidth(0.3)
	buttonAdd:SetCallback("OnClick", function(this, event, item)
		if SimPermut:AddItemLink(editLink:GetText(),editLinkilvl:GetText(),checkBoxSocket:GetValue()) then
			--raz if added
			SimPermut:BuildFrame()
		end
	end)
	container1:AddChild(buttonAdd)

	-- List of items	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Already Added items")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local scrollcontainer1 = AceGUI:Create("SimpleGroup")
	scrollcontainer1:SetRelativeWidth(0.5)
	scrollcontainer1:SetHeight(600)
	scrollcontainer1:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer1)
	
	scroll1 = AceGUI:Create("ScrollFrame")
	scroll1:SetLayout("Flow")
	scrollcontainer1:AddChild(scroll1)
	
	local scrollcontainer2 = AceGUI:Create("SimpleGroup")
	scrollcontainer2:SetRelativeWidth(0.5)
	scrollcontainer2:SetHeight(600)
	scrollcontainer2:SetLayout("Fill")
	mainGroup:AddChild(scrollcontainer2)
	
	scroll2 = AceGUI:Create("ScrollFrame")
	scroll2:SetLayout("Flow")
	scrollcontainer2:AddChild(scroll2)
	
	local socketString=""
	local ilvlString=""
	for j=1,#ExtraData.ListNames do
		tableTitres[j]=AceGUI:Create("Label")
		tableTitres[j]:SetText(PersoLib:firstToUpper(ExtraData.ListNames[j]))
		tableTitres[j]:SetFullWidth(true)
		if(j<7) then
			scroll1:AddChild(tableTitres[j])
		else
			scroll2:AddChild(tableTitres[j])
		end
		
		tableCheckBoxes[j]={}
		tableLabel[j]={}
		if SimPermutVars.addedItemsTable and SimPermutVars.addedItemsTable[j] then
			for i,_ in pairs(SimPermutVars.addedItemsTable[j]) do
				tableCheckBoxes[j][i]=AceGUI:Create("CheckBox")
				tableCheckBoxes[j][i]:SetLabel("")
				tableCheckBoxes[j][i]:SetRelativeWidth(0.05)
				tableCheckBoxes[j][i]:SetValue(false)
				if j<7 then
					scroll1:AddChild(tableCheckBoxes[j][i])
				else
					scroll2:AddChild(tableCheckBoxes[j][i])
				end
				
				if SimPermutVars.addedItemsTable[j][i][2] then 
					ilvlString=" "..SimPermutVars.addedItemsTable[j][i][2] 
				else
					ilvlString=""
				end
				if SimPermutVars.addedItemsTable[j][i][3] then 
					socketString="+S" 
				else
					socketString="" 
				end
				
				tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
				tableLabel[j][i]:SetText(SimPermutVars.addedItemsTable[j][i][1]..ilvlString..socketString)
				tableLabel[j][i]:SetRelativeWidth(0.95)
				tableLabel[j][i]:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
					GameTooltip:SetHyperlink(SimPermutVars.addedItemsTable[j][i][1])
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
		--end
	end
	
	local buttonAdd = AceGUI:Create("Button")
	buttonAdd:SetText("Delete Selected")
	buttonAdd:SetRelativeWidth(0.3)
	buttonAdd:SetCallback("OnClick", function(this, event, item)
		for j=1,#ExtraData.ListNames do
			if SimPermutVars.addedItemsTable and SimPermutVars.addedItemsTable[j] then
				for i,_ in pairs(SimPermutVars.addedItemsTable[j]) do
					if tableCheckBoxes[j][i]:GetValue() then
						SimPermutVars.addedItemsTable[j][i]=nil
					end
				end
			end
		end
		SimPermut:BuildFrame()
	end)
	mainGroup:AddChild(buttonAdd)
end

-- Field construction for option Frame
function SimPermut:BuildOptionFrame()
	mainGroup = AceGUI:Create("SimpleGroup")
    mainGroup:SetLayout("Fill")
    mainGroup:SetRelativeWidth(1)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	mainGroup:AddChild(container1)
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("General options")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local labelilvl= AceGUI:Create("Label")
	labelilvl:SetText("Gear ilvl")
	labelilvl:SetWidth(150)
	container1:AddChild(labelilvl)
	
	local ilvlMin= AceGUI:Create("EditBox")
	ilvlMin:SetText(actualSettings.ilvl_thresholdMin)
	ilvlMin:SetWidth(80)
	ilvlMin:SetLabel("Min")
	ilvlMin:SetMaxLetters(3)
	ilvlMin:SetCallback("OnEnterPressed", function (this, event, item)
		ilvlMin:SetText(string.match(item, '(%d+)'))
		if ilvlMin:GetText()=="" then
			ilvlMin:SetText(actualSettings.ilvl_thresholdMin)
		else
			SimPermutVars.ilvl_thresholdMin=tonumber(ilvlMin:GetText())
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
		end
    end)
	container1:AddChild(ilvlMin)
	
	local ilvlMax= AceGUI:Create("EditBox")
	ilvlMax:SetText(actualSettings.ilvl_thresholdMax)
	ilvlMax:SetWidth(80)
	ilvlMax:SetLabel("Max")
	ilvlMax:SetMaxLetters(3)
	ilvlMax:SetCallback("OnEnterPressed", function (this, event, item)
		ilvlMax:SetText(string.match(item, '(%d+)'))
		if ilvlMax:GetText()=="" then
			ilvlMax:SetText(actualSettings.ilvl_thresholdMax)
		else
			SimPermutVars.ilvl_thresholdMax=tonumber(ilvlMax:GetText())
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
		end
    end)
	container1:AddChild(ilvlMax)
	
	SimPermut:AddSpacer(container1,true)
	
	local labelilvlrelic= AceGUI:Create("Label")
	labelilvlrelic:SetText("Relics ilvl")
	labelilvlrelic:SetWidth(150)
	container1:AddChild(labelilvlrelic)
	
	local ilvlMinRelic= AceGUI:Create("EditBox")
	ilvlMinRelic:SetText(actualSettings.ilvl_RelicMin)
	ilvlMinRelic:SetWidth(80)
	ilvlMinRelic:SetLabel("Min")
	ilvlMinRelic:SetMaxLetters(3)
	ilvlMinRelic:SetCallback("OnEnterPressed", function (this, event, item)
		ilvlMinRelic:SetText(string.match(item, '(%d+)'))
		if ilvlMinRelic:GetText()=="" then
			ilvlMinRelic:SetText(actualSettings.ilvl_RelicMin)
		else
			SimPermutVars.ilvl_RelicMin=tonumber(ilvlMinRelic:GetText())
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
		end
    end)
	container1:AddChild(ilvlMinRelic)
	
	local ilvlMaxRelic= AceGUI:Create("EditBox")
	ilvlMaxRelic:SetText(actualSettings.ilvl_RelicMax)
	ilvlMaxRelic:SetWidth(80)
	ilvlMaxRelic:SetLabel("Max")
	ilvlMaxRelic:SetMaxLetters(3)
	ilvlMaxRelic:SetCallback("OnEnterPressed", function (this, event, item)
		ilvlMaxRelic:SetText(string.match(item, '(%d+)'))
		if ilvlMaxRelic:GetText()=="" then
			ilvlMaxRelic:SetText(actualSettings.ilvl_RelicMax)
		else
			SimPermutVars.ilvl_RelicMax=tonumber(ilvlMaxRelic:GetText())
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
		end
    end)
	container1:AddChild(ilvlMaxRelic)
	
	SimPermut:AddSpacer(container1,true)
	
	local labelreportTypeGear= AceGUI:Create("Label")
	labelreportTypeGear:SetText("Report Type")
	labelreportTypeGear:SetWidth(150)
	container1:AddChild(labelreportTypeGear)
	local ReportDropdownGear = AceGUI:Create("Dropdown")
    ReportDropdownGear:SetWidth(160)
	ReportDropdownGear:SetList(ExtraData.ReportTypeGear)
	ReportDropdownGear:SetLabel("Gear")
	ReportDropdownGear:SetValue(actualSettings.report_typeGear)
	ReportDropdownGear:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeGear=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownGear)

	local ReportDropdownTalents = AceGUI:Create("Dropdown")
    ReportDropdownTalents:SetWidth(160)
	ReportDropdownTalents:SetList(ExtraData.ReportTypeTalents)
	ReportDropdownTalents:SetLabel("Talents")
	ReportDropdownTalents:SetValue(actualSettings.report_typeTalents)
	ReportDropdownTalents:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeTalents=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownTalents)

	local ReportDropdownRelics = AceGUI:Create("Dropdown")
    ReportDropdownRelics:SetWidth(160)
	ReportDropdownRelics:SetList(ExtraData.ReportTypeRelics)
	ReportDropdownRelics:SetLabel("Artifact")
	ReportDropdownRelics:SetValue(actualSettings.report_typeRelics)
	ReportDropdownRelics:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeRelics=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownRelics)
	
	local ReportDropdownCrucible = AceGUI:Create("Dropdown")
    ReportDropdownCrucible:SetWidth(160)
	ReportDropdownCrucible:SetList(ExtraData.ReportTypeCrucible)
	ReportDropdownCrucible:SetLabel("Crucible")
	ReportDropdownCrucible:SetValue(actualSettings.report_typeCrucible)
	ReportDropdownCrucible:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.report_typeCrucible=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(ReportDropdownCrucible)
	
	SimPermut:AddSpacer(container1,true)
	
	local checkBoxgenerate = AceGUI:Create("CheckBox")
	checkBoxgenerate:SetWidth(400)
	checkBoxgenerate:SetLabel("Auto-generate when SimPermut opens")
	checkBoxgenerate:SetValue(actualSettings.generateStart)
	checkBoxgenerate:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.generateStart=checkBoxgenerate:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(checkBoxgenerate)
	
	SimPermut:AddSpacer(container1,true)
	
	local checkBoxForceDefault = AceGUI:Create("CheckBox")
	checkBoxForceDefault:SetWidth(400)
	checkBoxForceDefault:SetLabel("Replace current enchant/gems for equiped gear")
	checkBoxForceDefault:SetValue(actualSettings.replaceEnchantsBase)
	checkBoxForceDefault:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.replaceEnchantsBase=checkBoxForceDefault:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(checkBoxForceDefault)
	
	SimPermut:AddSpacer(container1,true)
	
	local checkBoxSmallUI = AceGUI:Create("CheckBox")
	checkBoxSmallUI:SetWidth(400)
	checkBoxSmallUI:SetLabel("Use Small UI")
	checkBoxSmallUI:SetValue(actualSettings.smallUI)
	checkBoxSmallUI:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.smallUI=checkBoxSmallUI:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(checkBoxSmallUI)
	
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,true)
	
	local labeltitre2= AceGUI:Create("Heading")
	labeltitre2:SetText("Default values")
	labeltitre2:SetFullWidth(true)
	container1:AddChild(labeltitre2)
	
	local labelEnchantNeck= AceGUI:Create("Label")
	labelEnchantNeck:SetText("Enchant Neck")
	labelEnchantNeck:SetWidth(80)
	container1:AddChild(labelEnchantNeck)
	
	local dropdownEnchantNeck = AceGUI:Create("Dropdown")
	dropdownEnchantNeck:SetWidth(130)
	dropdownEnchantNeck:SetList(ExtraData.enchantNeck)
	dropdownEnchantNeck:SetValue(actualSettings.enchant_neck)
	dropdownEnchantNeck:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.enchant_neck=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownEnchantNeck)
		
	local labelEnchantBack= AceGUI:Create("Label")
	labelEnchantBack:SetText("     Enchant Back")
	labelEnchantBack:SetWidth(95)
	container1:AddChild(labelEnchantBack)
	
	local dropdownEnchantBack = AceGUI:Create("Dropdown")
	dropdownEnchantBack:SetWidth(110)
	dropdownEnchantBack:SetList(ExtraData.enchantCloak)
	dropdownEnchantBack:SetValue(actualSettings.enchant_back)
	dropdownEnchantBack:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.enchant_back=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownEnchantBack)
	
	local labelEnchantFinger= AceGUI:Create("Label")
	labelEnchantFinger:SetText("     Enchant Ring")
	labelEnchantFinger:SetWidth(95)
	container1:AddChild(labelEnchantFinger)
	
	local dropdownEnchantFinger = AceGUI:Create("Dropdown")
	dropdownEnchantFinger:SetWidth(110)
	dropdownEnchantFinger:SetList(ExtraData.enchantRing)
	dropdownEnchantFinger:SetValue(actualSettings.enchant_ring)
	dropdownEnchantFinger:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.enchant_ring=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownEnchantFinger)
	
	local labelGem= AceGUI:Create("Label")
	labelGem:SetText("     Gem")
	labelGem:SetWidth(55)
	container1:AddChild(labelGem)
	
	local dropdownGem = AceGUI:Create("Dropdown")
	dropdownGem:SetList(ExtraData.gemList)
	dropdownGem:SetWidth(110)
	dropdownGem:SetValue(actualSettings.gems)
	dropdownGem:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.gems=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownGem)
	
	SimPermut:AddSpacer(container1,true)
	
	local checkBoxForce = AceGUI:Create("CheckBox")
	checkBoxForce:SetWidth(250)
	checkBoxForce:SetLabel("Replace current enchant/gems")
	checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.replaceEnchants=checkBoxForce:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(checkBoxForce)
	
	SimPermut:AddSpacer(container1,false,180)
	
	local labelSetsT19= AceGUI:Create("Label")
	labelSetsT19:SetText("T19 (min)")
	labelSetsT19:SetWidth(80)
	container1:AddChild(labelSetsT19)
	
	local dropdownSetsT19 = AceGUI:Create("Dropdown")
	dropdownSetsT19:SetList(ExtraData.SetsListT19)
	dropdownSetsT19:SetWidth(110)
	dropdownSetsT19:SetValue(actualSettings.setsT19)
	dropdownSetsT19:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.setsT19=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownSetsT19)
	
	local labelSetsT20= AceGUI:Create("Label")
	labelSetsT20:SetText("T20 (min)")
	labelSetsT20:SetWidth(55)
	container1:AddChild(labelSetsT20)
	
	local dropdownSetsT20 = AceGUI:Create("Dropdown")
	dropdownSetsT20:SetList(ExtraData.SetsListT20)
	dropdownSetsT20:SetWidth(110)
	dropdownSetsT20:SetValue(actualSettings.setsT20)
	dropdownSetsT20:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.setsT20=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownSetsT20)
	
	local labelSetsT21= AceGUI:Create("Label")
	labelSetsT21:SetText("T21 (min)")
	labelSetsT21:SetWidth(55)
	container1:AddChild(labelSetsT21)
	
	local dropdownSetsT21 = AceGUI:Create("Dropdown")
	dropdownSetsT21:SetList(ExtraData.SetsListT21)
	dropdownSetsT21:SetWidth(110)
	dropdownSetsT21:SetValue(actualSettings.setsT21)
	dropdownSetsT21:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.setsT21=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownSetsT21)
	SimPermut:AddSpacer(container1,true)
	
	local labelepicGem= AceGUI:Create("Label")
	labelepicGem:SetText("Use 1 Epic gem")
	labelepicGem:SetWidth(90)
	container1:AddChild(labelepicGem)
	
	local dropdownEpicGem = AceGUI:Create("Dropdown")
	dropdownEpicGem:SetList(ExtraData.gemListEpic)
	dropdownEpicGem:SetWidth(110)
	dropdownEpicGem:SetValue(actualSettings.gemsEpic)
	dropdownEpicGem:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.gemsEpic=item
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(dropdownEpicGem)
	
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,true)
	SimPermut:AddSpacer(container1,true)
	
	local labeltitre3= AceGUI:Create("Heading")
	labeltitre3:SetText("Simc parameters")
	labeltitre3:SetFullWidth(true)
	container1:AddChild(labeltitre3)
	
	local scrollcontainer3 = AceGUI:Create("SimpleGroup")
	scrollcontainer3:SetRelativeWidth(1)
	scrollcontainer3:SetHeight(200)
	scrollcontainer3:SetLayout("Fill")
	container1:AddChild(scrollcontainer3)
	
	local simcBox= AceGUI:Create("MultiLineEditBox")
	simcBox:SetText(actualSettings.simcCommands)
	simcBox:SetLabel("")
	simcBox:SetRelativeWidth(1)
	simcBox:SetCallback("OnEnterPressed", function (this, event, item)
		SimPermutVars.simcCommands=simcBox:GetText()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	scrollcontainer3:AddChild(simcBox)
	
	mainframe:AddChild(mainGroup)
end

-- Field construction for right Panel
function SimPermut:BuildResultFrame(autoSimcExportVisible)
	resultGroup = AceGUI:Create("SimpleGroup")
    resultGroup:SetLayout("Flow")
    resultGroup:SetRelativeWidth(0.35)
	
	local scrollcontainer3 = AceGUI:Create("SimpleGroup")
	scrollcontainer3:SetRelativeWidth(1)
	if actualSettings.smallUI then
		scrollcontainer3:SetHeight(560)
	else
		scrollcontainer3:SetHeight(600)
	end
	scrollcontainer3:SetLayout("Fill")
	resultGroup:AddChild(scrollcontainer3)
	
	resultBox= AceGUI:Create("MultiLineEditBox")
	resultBox:SetText("")
	resultBox:SetLabel("")
	resultBox:DisableButton(true)
	resultBox:SetRelativeWidth(1)
	scrollcontainer3:AddChild(resultBox)
	
	if autoSimcExportVisible then
		SimPermut:AddSpacer(resultGroup,false,0.7)
		
		local buttonGenerateRaw = AceGUI:Create("Button")
		buttonGenerateRaw:SetText("AutoSimc Export")
		buttonGenerateRaw:SetRelativeWidth(0.3)
		buttonGenerateRaw:SetCallback("OnClick", function()
			SimPermut:GenerateRaw()
		end)
		resultGroup:AddChild(buttonGenerateRaw)
	end
	
	mainframe:AddChild(resultGroup)
end

-- Init the frame for the first time
function SimPermut:InitGearFrame()
	tableTitres={}
	tableLabel={}
	tableCheckBoxes={}
	tableLinkPermut={}
	
	--init with default parameters
	actualEnchantNeck=actualSettings.enchant_neck
	actualEnchantFinger=actualSettings.enchant_ring
	actualEnchantBack=actualSettings.enchant_back
	actualGem=actualSettings.gems
	actualForce=actualSettings.replaceEnchants
	actualSetsT19=actualSettings.setsT19
	actualSetsT20=actualSettings.setsT20
	actualSetsT21=actualSettings.setsT21
	
	_,tableBaseLink=SimPermut:GetBaseString()
	
	editLegMin:SetText(equipedLegendaries)
	
	SimPermut:GetListItems()
	SimPermut:BuildItemFrame()
	SimPermut:GetSelectedCount()
	
	if actualSettings.generateStart then
		SimPermut:Generate()
	end
end

-- Load Item list
function SimPermut:BuildItemFrame()
	local socketString=""
	local ilvlString=""
	for j=1,#ExtraData.ListNames do
		tableTitres[j]=AceGUI:Create("Label")
		tableTitres[j]:SetText(PersoLib:firstToUpper(ExtraData.ListNames[j]))
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
			if SimPermut:isEquiped(tableListItems[j][i][1],j) or tablePreCheck[j] then
				tableCheckBoxes[j][i]:SetValue(true)
			else
				tableCheckBoxes[j][i]:SetValue(false)
			end
			tableCheckBoxes[j][i]:SetCallback("OnValueChanged", function(this, event, item)
				if tableCheckBoxes[j][i]:GetValue() then
					selecteditems=selecteditems+1
				else
					selecteditems=selecteditems-1
				end
				SimPermut:CheckItemCount()
			end)
			selecteditems=selecteditems+1
			if j<7 then
				scroll1:AddChild(tableCheckBoxes[j][i])
			else
				scroll2:AddChild(tableCheckBoxes[j][i])
			end
			
			if tableListItems[j][i][2] then 
				ilvlString=" "..tableListItems[j][i][2] 
			else
				ilvlString=""
			end
			if tableListItems[j][i][3] then 
				socketString="+S" 
			else
				socketString="" 
			end
			
			tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
			tableLabel[j][i]:SetText(tableListItems[j][i][1]..ilvlString..socketString)
			tableLabel[j][i]:SetRelativeWidth(0.95)
			tableLabel[j][i]:SetCallback("OnEnter", function(widget)
				GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
				GameTooltip:SetHyperlink(tableListItems[j][i][1])
				GameTooltip:Show()
			end)
			tableLabel[j][i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
			
			if (j>=11 and ad) then
				PersoLib:debugPrint(ExtraData.ListNames[j]..i.." : "..PersoLib:GetIDFromLink(tableListItems[j][i][1]),ad)
			end
			
			if(j<7) then
				scroll1:AddChild(tableLabel[j][i])
			else
				scroll2:AddChild(tableLabel[j][i])
			end
		end
	end
end

-- clic btn generate
function SimPermut:Generate()

	local permutString=""
	local baseString=""
	local finalString=""
	if SimPermut:GetTableLink() then
		PersoLib:debugPrint("--------------------",ad)
		PersoLib:debugPrint("Generating Gear string...",ad)
		SimPermut:GetSelectedCount()
		baseString,tableBaseLink=SimPermut:GetBaseString()
		permuttable=SimPermut:GetAllPermutations()
		SimPermut:PreparePermutations(permuttable)
		permutString=SimPermut:GetPermutationString(permuttable)
		finalString=SimPermut:GetFinalString(baseString,permutString)
		SimPermut:PrintPermut(finalString)
		
		
		PersoLib:debugPrint("End of generation",ad)
		PersoLib:debugPrint("--------------------",ad)
	else --error
		mainframe:SetStatusText(errorMessage)
	end
end

-- clic btn generate raw
function SimPermut:GenerateRaw()
	mainframe:SetStatusText("")
	
	local itemList=""
	local baseString=""
	local finalString=""
	local AutoSimcString=""
	
	if SimPermut:GetTableLink() then
		PersoLib:debugPrint("--------------------",ad)
		PersoLib:debugPrint("Generating string...",ad)
		baseString,tableBaseLink=SimPermut:GetBaseString()
		AutoSimcString=SimPermut:GetAutoSimcString()
		itemList=SimPermut:GetItemListString()
		finalString=SimPermut:GetFinalString(AutoSimcString,itemList)
		SimPermut:PrintPermut(finalString)
		PersoLib:debugPrint("End of generation",ad)
		PersoLib:debugPrint("--------------------",ad)
	end
end

-- clic btn generate Talent
function SimPermut:GenerateTalents()
	local permutString=""
	local baseString=""
	local finalString=""
	tableTalentResults={}
	
	PersoLib:debugPrint("--------------------",ad)
	PersoLib:debugPrint("Generating Talent String...",ad)
	SimPermut:GenerateTalentsRecursive(1,"")
	baseString=SimPermut:GetBaseString()
	permutString=SimPermut:GenerateTalentString()
	finalString=SimPermut:GetFinalString(baseString,permutString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",ad)
	PersoLib:debugPrint("--------------------",ad)
end

-- clic btn generate Relic
function SimPermut:GenerateRelic()
	local permutString=""
	local baseString=""
	local finalString=""

	PersoLib:debugPrint("--------------------",ad)
	PersoLib:debugPrint("Generating Relic String...",ad)
	baseString=SimPermut:GetBaseString(true)
	permutString=SimPermut:GenerateRelicString()
	relicString=relicString.."\n"..permutString
	finalString=SimPermut:GetFinalString(baseString,relicString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",ad)
	PersoLib:debugPrint("--------------------",ad)
end

-- clic btn generate Relic
function SimPermut:GenerateCrucible()
	local permutString=""
	local baseString=""
	local finalString=""
	local artifactID,artifactData = LAD:GetArtifactInfo()

	PersoLib:debugPrint("--------------------",ad)
	PersoLib:debugPrint("Generating crucible String...",ad)
	baseString=SimPermut:GetBaseString()
	permutString=SimPermut:GenerateCrucibleString()
	crucibleString=crucibleString.."\n"..permutString
	finalString=SimPermut:GetFinalString(baseString,crucibleString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",ad)
	PersoLib:debugPrint("--------------------",ad)
end

-- clic btn generate Talent recursion
function SimPermut:GenerateTalentsRecursive(stacks,str)
	local newstacks=stacks
	local newstr=str
	if newstacks > TALENTS_MAX_ROW then
		tableTalentResults[#tableTalentResults+1]=newstr
	else
		if tableTalentcheckbox[newstacks][1]:GetValue()==false and tableTalentcheckbox[newstacks][2]:GetValue()==false and tableTalentcheckbox[newstacks][3]:GetValue()==false then
			newstr=newstr.."0"
			SimPermut:GenerateTalentsRecursive(newstacks+1,newstr)
		else
			for i=1,TALENTS_MAX_COLUMN do
				if tableTalentcheckbox[newstacks][i]:GetValue() then
					newstr=str..""..i
					SimPermut:GenerateTalentsRecursive(newstacks+1,newstr)
				end
			end
		end
	end
end

-- Get the count of selected items
function SimPermut:GetSelectedCount()
	selecteditems = 0
	tableNumberSelected={}
	for i=1,#ExtraData.ListNames do
		tableNumberSelected[i]=0
		for j=1,#tableListItems[i] do
			if tableCheckBoxes[i][j]:GetValue() then
				selecteditems=selecteditems+1
				tableNumberSelected[i]=tableNumberSelected[i]+1
			end
		end
	end
	
	SimPermut:CheckItemCount()
end

-- Check if item count is not too high
function SimPermut:CheckItemCount()
	if selecteditems >= ITEM_COUNT_THRESHOLD then
		labelCount:SetText("     Warning : Too many items selected ("..selecteditems.."). Consider using AutoSimC Export")
	else
		labelCount:SetText("     ".. selecteditems.. " items selected")
	end
end

-- draw the frame and print the text
function SimPermut:PrintPermut(finalString)
	resultBox:SetText(finalString)
	resultBox:HighlightText()
	resultBox:SetFocus()
end

-- manage spacers
function SimPermut:AddSpacer(targetFrame,full,width,height)
	spacerTable[#spacerTable+1] = AceGUI:Create("Label")
	if full then
		spacerTable[#spacerTable]:SetFullWidth(true)
	else
		if width<=1 then
			spacerTable[#spacerTable]:SetRelativeWidth(width)
		else
			spacerTable[#spacerTable]:SetWidth(width)
		end
	end
	if height then
		spacerTable[#spacerTable]:SetHeight(height)
	end
	targetFrame:AddChild(spacerTable[#spacerTable])
end

----------------------------
-- Permutation Management --
----------------------------
-- get item string
function SimPermut:GetItemString(itemLink,itemType,base,forceilvl,forcegem)
	--itemLink 	: link of the item
	--itemType 	: item slot
	--base 		: true if item from equiped gear, false from inventory

	local itemSplit = PersoLib:LinkSplit(itemLink)
	local simcItemOptions = {}	
	local enchantID=""
	
	-- Item id
	local itemId = tonumber(itemSplit[OFFSET_ITEM_ID])
	simcItemOptions[#simcItemOptions + 1] = ',id=' .. itemId
	
	-- Enchant
	if base and not SimPermutVars.replaceEnchantsBase then 
		if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
			enchantID=itemSplit[OFFSET_ENCHANT_ID]
		end
	else
		if itemType=="neck" then
			if (actualForce or (base and SimPermutVars.replaceEnchantsBase)) and actualEnchantNeck~=0 then
				enchantID=actualEnchantNeck
			else	
				if actualEnchantNeck==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					enchantID=actualEnchantNeck
				end
			end
		elseif itemType=="back" then
			if (actualForce or (base and SimPermutVars.replaceEnchantsBase))  and actualEnchantBack~=0 then
				enchantID=actualEnchantBack
			else
				if actualEnchantBack==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					enchantID=actualEnchantBack
				end
			end
		elseif string.match(itemType, 'finger*') then
			if (actualForce or (base and SimPermutVars.replaceEnchantsBase))  and actualEnchantFinger~=0 then
				enchantID=actualEnchantFinger
			else
				if actualEnchantFinger==0 or tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[OFFSET_ENCHANT_ID]
					end
				else
					enchantID=actualEnchantFinger
				end
			end
		else
			if tonumber(itemSplit[OFFSET_ENCHANT_ID]) > 0 then
				enchantID=itemSplit[OFFSET_ENCHANT_ID]
			end
		end
	end
	
	if enchantID and enchantID ~= "" then
		simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. enchantID
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
        local n_bonus_ids = tonumber(itemSplit[rest_offset])
		if n_bonus_ids==1 then --unlocked traits field
			rest_offset = rest_offset + 1 
		end
        local relic_str = ''
        while rest_offset < #itemSplit do
          n_bonus_ids = tonumber(itemSplit[rest_offset])
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
	if itemType=="main_hand" or itemType=="off_hand" then --exception for relics
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
		local hasSocket=0
		local gemstring=""
		local stats = GetItemStats(itemLink)
		local _,_,itemRarity = GetItemInfo(itemLink)
		--for some reason, GetItemStats doesn't gives sockets to legendary neck and finger that have one by default
		if (stats and stats['EMPTY_SOCKET_PRISMATIC'] and stats['EMPTY_SOCKET_PRISMATIC']>=1) or (itemRarity== 5 and (itemType== 'neck' or itemType== 'finger1' or itemType== 'finger2')) or forcegem then
			if stats and stats['EMPTY_SOCKET_PRISMATIC'] then
				hasSocket=stats['EMPTY_SOCKET_PRISMATIC']
			else
				hasSocket=1
			end
		end
		if base and not SimPermutVars.replaceEnchantsBase then
			if tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0 then
				gemstring='gem_id='
				if (itemSplit[OFFSET_GEM_ID_1]~=0) then 
					gemstring=gemstring..itemSplit[OFFSET_GEM_ID_1]
					if (itemSplit[OFFSET_GEM_ID_2]~=0) then 
						gemstring=gemstring..itemSplit[OFFSET_GEM_ID_2]
						if (itemSplit[OFFSET_GEM_ID_3]~=0) then 
							gemstring=gemstring..itemSplit[OFFSET_GEM_ID_3]
							if (itemSplit[OFFSET_GEM_ID_4]~=0) then 
								gemstring=gemstring..itemSplit[OFFSET_GEM_ID_4]
							end
						end
					end
				end
				simcItemOptions[#simcItemOptions + 1] = gemstring
			end
		else
			if (actualForce or forcegem or (base and SimPermutVars.replaceEnchantsBase)) and actualGem~=0 then
				if actualGem and actualGem~=0 and (hasSocket>0 or tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0) then
					gemstring='gem_id='
					for i=1,hasSocket do
						if i>1 then 
							gemstring=gemstring.."/"
						end
						if actualSettings.gemsEpic>0 and not epicGemUsed then
							gemstring=gemstring..actualSettings.gemsEpic
							epicGemUsed=true
						else
							gemstring=gemstring..actualGem
						end
					end
					simcItemOptions[#simcItemOptions + 1] = gemstring
				end
			else
				if tonumber(itemSplit[OFFSET_GEM_ID_1]) ~= 0 then
					gemstring='gem_id='
					if (itemSplit[OFFSET_GEM_ID_1]~=0) then 
						gemstring=gemstring..itemSplit[OFFSET_GEM_ID_1]
						if (itemSplit[OFFSET_GEM_ID_2]~=0) then 
							gemstring=gemstring..itemSplit[OFFSET_GEM_ID_2]
							if (itemSplit[OFFSET_GEM_ID_3]~=0) then 
								gemstring=gemstring..itemSplit[OFFSET_GEM_ID_3]
								if (itemSplit[OFFSET_GEM_ID_4]~=0) then 
									gemstring=gemstring..itemSplit[OFFSET_GEM_ID_4]
								end
							end
						end
					end
					simcItemOptions[#simcItemOptions + 1] = gemstring
				else
					if actualGem and actualGem~=0 and hasSocket>0 then
						gemstring='gem_id='
						for i=1,hasSocket do
							if i>1 then 
								gemstring=gemstring.."/"
							end
							if actualSettings.gemsEpic>0 and not epicGemUsed then
							gemstring=gemstring..actualSettings.gemsEpic
							epicGemUsed=true
						else
							gemstring=gemstring..actualGem
						end
						end
						simcItemOptions[#simcItemOptions + 1] = gemstring
					end
				end
			end
		end
	end
	
	-- Some leveling quest items seem to use this, it'll include the drop level of the item
	if bit.band(flags, 0x200) == 0x200 then
		simcItemOptions[#simcItemOptions + 1] = 'drop_level=' .. itemSplit[rest_offset]
		rest_offset = rest_offset + 1
	end
	
	if not base and forceilvl then
		simcItemOptions[#simcItemOptions + 1]='ilevel='..forceilvl
	end
	
	return simcItemOptions
end

-- get all items equiped Strings
function SimPermut:GetItemStrings()
	local items = {}
	local itemsLinks = {}
	local slotId,itemLink
	local itemString = {}
	epicGemUsed=false
	
	equipedLegendaries = 0

	for slotNum=1, #ExtraData.PermutSlotNames do
		slotId = GetInventorySlotInfo(ExtraData.PermutSlotNames[slotNum])
		itemLink = GetInventoryItemLink('player', slotId) 

		-- if we don't have an item link, we don't care
		if itemLink then
			local _,_,itemRarity = GetItemInfo(itemLink)
			if itemRarity==5 then
				equipedLegendaries= equipedLegendaries+1
			end
			itemString=SimPermut:GetItemString(itemLink,ExtraData.PermutSimcNames[slotNum],true)
			tableBaseString[slotNum]=table.concat(itemString, ',')
			itemsLinks[slotNum]=itemLink
			items[slotNum] = ExtraData.PermutSimcNames[slotNum] .. "=" .. table.concat(itemString, ',')
		end
	end

	return items,itemsLinks
end

-- get the list of items of a slot
function SimPermut:GetListItem(strItem,itemLine)
	local texture, count, locked, quality, readable, lootable, isFiltered, hasNoValue, itemId, itemLink, itemstring, ilvl, name, itemRarity
	local permutTable={}
	local itemidTable={}
	local linkTable={}
	local equippableItems = {}
	local copyname

	local blizzardname,simcname,slotID,realSlot
	if strItem=="head" then
		slotID=1
		realSlot=1
	elseif strItem=="neck" then
		slotID=2
		realSlot=2
	elseif strItem=="shoulder" then
		slotID=3
		realSlot=3
	elseif strItem=="back" then
		slotID=4
		realSlot=4
	elseif strItem=="chest" then
		slotID=5
		realSlot=5
	elseif strItem=="wrist" then
		slotID=8
		realSlot=6
	elseif strItem=="hands" then
		slotID=9
		realSlot=7
	elseif strItem=="waist" then
		slotID=10
		realSlot=8
	elseif strItem=="legs" then
		slotID=11
		realSlot=9
	elseif strItem=="feet" then
		slotID=12
		realSlot=10
	elseif strItem=="finger" then
		slotID=13
		realSlot=11
	elseif strItem=="trinket" then
		slotID=15
		realSlot=13
	end
	blizzardname=ExtraData.SlotNames[slotID]
	simcname=ExtraData.SimcSlotNames[slotID]
	local id, _, _ = GetInventorySlotInfo(blizzardname)
	GetInventoryItemsForSlot(id, equippableItems)
	for locationBitstring, itemID in pairs(equippableItems) do
		local player, bank, bags, voidstorage, slot, bag = EquipmentManager_UnpackLocation(locationBitstring)
		if bags then
			_, _, _, _, _, _, itemLink, _, _, itemId = GetContainerItemInfo(bag, slot)
			if itemLink~=nil then
				_,_,itemRarity,ilvl = GetItemInfo(itemLink)
				ilvl = PersoLib:GetRealIlvl(itemLink)
				if (ilvl >= actualSettings.ilvl_thresholdMin and ilvl <= actualSettings.ilvl_thresholdMax) then
					linkTable[#linkTable+1]={itemLink,nil,nil}
				end
			end
		else
			itemLink = GetInventoryItemLink('player', slot)
			if itemLink~=nil then
				_,_,itemRarity,ilvl = GetItemInfo(itemLink)
				ilvl = PersoLib:GetRealIlvl(itemLink)
				if (ilvl >= actualSettings.ilvl_thresholdMin and ilvl <= actualSettings.ilvl_thresholdMax) or (SimPermut:isEquiped(itemLink,realSlot) or SimPermut:isEquiped(itemLink,realSlot+1)) then
					linkTable[#linkTable+1]={itemLink,nil,nil}
				end
			end
		end
	end
	
	return linkTable
end

-- get the list of items of all selected items from dropdown
function SimPermut:GetListItems()
	for i=1,#ExtraData.ListNames do
		tableListItems[i]={}
		tableListItems[i]=SimPermut:GetListItem(ExtraData.ListNames[i],i)
		
		--added items
		if SimPermutVars.addedItemsTable and SimPermutVars.addedItemsTable[i] then
			for j,_ in pairs(SimPermutVars.addedItemsTable[i]) do
				table.insert(tableListItems[i],SimPermutVars.addedItemsTable[i][j])
			end
		end
	end
end

-- generates tablelink to be ready for permuts
function SimPermut:GetTableLink()
	local returnvalue=true
	local slotid
	for i=1,#ExtraData.ListNames do
		tableLinkPermut[i]={}
		if tableListItems[i] and #tableListItems[i]>0 then
			for j=1,#tableListItems[i] do
				if tableCheckBoxes[i][j]:GetValue() then
					tableLinkPermut[i][#tableLinkPermut[i] + 1] = {tableListItems[i][j][1],tableListItems[i][j][2],tableListItems[i][j][3]}
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
			tableLinkPermut[i][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[slotid])),nil,nil}
		end
			
	end
	
	--manage fingers and trinkets
	if #tableLinkPermut[12]==0 then --if no trinket chosen, we take the equiped ones
		tableLinkPermut[13]={}
		tableLinkPermut[13][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[15])),nil,nil}
		tableLinkPermut[14]={}
		tableLinkPermut[14][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[16])),nil,nil}
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
		tableLinkPermut[11][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[13])),nil,nil}
		tableLinkPermut[12][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[14])),nil,nil}
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

-- generates a raw list of all selected items for autoSimc
function SimPermut:GetItemListString()
	local returnString=""
	local actualString
	for i=1,#tableLinkPermut do
		actualString=""
		for j=1,#tableLinkPermut[i] do
			local _,_,itemRarity = GetItemInfo(tableLinkPermut[i][j][1])
			local itemid = tonumber(PersoLib:GetIDFromLink(tableLinkPermut[i][j][1]))
			local itemString = SimPermut:GetItemString(tableLinkPermut[i][j][1],ExtraData.PermutSimcNames[i],false,tableLinkPermut[i][j][2],tableLinkPermut[i][j][3])
			actualString = actualString .. ((itemid == ExtraData.HasTierSets["T21"][classID][i]) and "T21" or "")..((itemid == ExtraData.HasTierSets["T20"][classID][i]) and "T20" or "").. ((itemid == ExtraData.HasTierSets["T19"][classID][i]) and "T19" or "").. ((itemRarity== 5) and "L" or "")..table.concat(itemString, ',').."|"
		end
		actualString=actualString:sub(1, -2)
		returnString = returnString..ExtraData.PermutSimcNames[i] .. "="..actualString.."\n"
		
	end
	
	--mainhand
    local itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
	local itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
		itemString=SimPermut:GetItemString(itemLink,'main_hand',true)
		returnString = returnString .. "main_hand=" .. table.concat(itemString, ',').. '\n'
    end
	
	--offhand
    itemLink = GetInventoryItemLink('player', INVSLOT_OFFHAND)
	itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
		itemString=SimPermut:GetItemString(itemLink,'off_hand',true)
		returnString = returnString .. "off_hand=" .. table.concat(itemString, ',').. '\n'
    end
	
	
	return returnString
--SimPermut:GetItemString(itemLink,itemType,base)
end

-- generates the init string from autosimc
function SimPermut:GetAutoSimcString()
	local autoSimcString=""
	autoSimcString=autoSimcString .. "[Profile]".."\n"
	autoSimcString=autoSimcString .. "profilename="..UnitName('player').."\n"
	autoSimcString=autoSimcString .. "profileid=1".."\n"
	local _, playerClass = UnitClass('player')
	autoSimcString=autoSimcString .. "class="..PersoLib:tokenize(playerClass) .."\n"
	autoSimcString=autoSimcString .. "race="..PersoLib:tokenize(PersoLib:getRace()).."\n"
	autoSimcString=autoSimcString .. "level="..UnitLevel('player').."\n"
	autoSimcString=autoSimcString .. "spec="..PersoLib:tokenize(ExtraData.SpecNames[ PersoLib:getSpecID() ]).."\n"
	autoSimcString=autoSimcString .. "role="..PersoLib:translateRole(PersoLib:getSpecID()).."\n"
	autoSimcString=autoSimcString .. "position=back".."\n"
	autoSimcString=autoSimcString .. "talents="..PersoLib:CreateSimcTalentString().."\n"
	local artStr=SimPermut:GetArtifactString()
	if artStr~="" then
		autoSimcString=autoSimcString .. "artifact="..SimPermut:GetArtifactString().."\n"
	end
	autoSimcString=autoSimcString .. actualSettings.simcCommands.. '\n'
	autoSimcString=autoSimcString .. "other=".."\n"
	autoSimcString=autoSimcString .. "\n".."[Gear]"
	
	return autoSimcString
end

-- generates all permutations for the tableLinkPermut
function SimPermut:GetAllPermutations()
	local returnTable={}

	returnTable=PersoLib:doCartesianALACON(tableLinkPermut)
	
	PersoLib:debugPrint("Nb of rings:"..tableNumberSelected[11],ad)
	PersoLib:debugPrint("Nb of trinkets:"..tableNumberSelected[12],ad)
	
	return returnTable
end

-- reorganize ring and trinket before print if only two
function SimPermut:ReorganizeEquip(tabletoPermut)
	local itemIdRing1,itemIdRing2
	local itemIdTrinket1,itemIdTrinket2 
	if tableNumberSelected[11]<=2 then
		PersoLib:debugPrint(tableNumberSelected[11].." rings. Re-organize",ad)
		itemIdRing1 = PersoLib:GetIDFromLink(tabletoPermut[11][1])
		itemIdRing2 = PersoLib:GetIDFromLink(tabletoPermut[12][1])
		PersoLib:debugPrint("fingerInf:"..tostring(fingerInf).."("..itemIdRing1.."-"..itemIdRing2..")",ad)
		if (fingerInf and itemIdRing1>itemIdRing2) or (not fingerInf and itemIdRing1<itemIdRing2) then
			local tempring = tabletoPermut[11]
			tabletoPermut[11] = tabletoPermut[12]
			tabletoPermut[12] = tempring
		end
	end
	if tableNumberSelected[12]<=2 then
		PersoLib:debugPrint(tableNumberSelected[12].." trinkets. Re-organize",ad)
		itemIdTrinket1 = PersoLib:GetIDFromLink(tabletoPermut[13][1])
		itemIdTrinket2 = PersoLib:GetIDFromLink(tabletoPermut[14][1])
		PersoLib:debugPrint("trinketInf:"..tostring(trinketInf).."("..itemIdTrinket1.."-"..itemIdTrinket2..")",ad)
		if (trinketInf and itemIdTrinket1>itemIdTrinket2) or (not trinketInf and itemIdTrinket1<itemIdTrinket2) then
			local temptrinket = tabletoPermut[13]
			tabletoPermut[13] = tabletoPermut[14]
			tabletoPermut[14] = temptrinket
		end
	end
	
	
end

-- prepare variables for permutations
function SimPermut:PreparePermutations(permuttable)
	local itemIdRing1,itemIdRing2
	local itemIdTrinket1,itemIdTrinket2 
	--preparing rings
	if (GetInventoryItemLink('player', INVSLOT_FINGER1)==permuttable[1][11][1] and GetInventoryItemLink('player', INVSLOT_FINGER2)==permuttable[1][12][1]) or 
		(GetInventoryItemLink('player', INVSLOT_FINGER1)==permuttable[1][12][1] and GetInventoryItemLink('player', INVSLOT_FINGER2)==permuttable[1][11][1]) then
		itemIdRing1 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_FINGER1))
		itemIdRing2 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_FINGER2))
	else
		itemIdRing1 = PersoLib:GetIDFromLink(permuttable[1][11][1])
		itemIdRing2 = PersoLib:GetIDFromLink(permuttable[1][12][1])
	end
	if itemIdRing1<itemIdRing2 then
		fingerInf=true
	end
	
	--prepare trinkets
	if (GetInventoryItemLink('player', INVSLOT_TRINKET1)==permuttable[1][13][1] and GetInventoryItemLink('player', INVSLOT_TRINKET2)==permuttable[1][14][1]) or 
		(GetInventoryItemLink('player', INVSLOT_TRINKET1)==permuttable[1][14][1] and GetInventoryItemLink('player', INVSLOT_TRINKET2)==permuttable[1][13][1]) then
		
		itemIdTrinket1 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_TRINKET1))
		itemIdTrinket2 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_TRINKET2))
	else
		itemIdTrinket1 = PersoLib:GetIDFromLink(permuttable[1][13][1])
		itemIdTrinket2 = PersoLib:GetIDFromLink(permuttable[1][14][1])
	end
	if itemIdTrinket1<itemIdTrinket2 then
		trinketInf=true
	end
	
	PersoLib:debugPrint("fingerInf:"..tostring(fingerInf).."("..itemIdRing1.."-"..itemIdRing2..")  ".."trinketInf:"..tostring(trinketInf).."("..itemIdTrinket1.."-"..itemIdTrinket2..")",ad)
		
end

-- generates the string of all permutations
function SimPermut:GetPermutationString(permuttable)
	local returnString="\n"
	local copynumber=1
	local itemString
	local itemStringFinal
	local itemString2
	local itemStringFinal2
	local currentString
	local nbLeg
	local itemRarity
	local nbitem
	local itemList
	local itemname
	local result
	local draw = true
	local str
	local T192p,T194p
	local T202p,T204p
	local T212p,T214p
	local notDrawn=0
	local okDrawn=0
	
	actualLegMin=tonumber(editLegMin:GetText())
	actualLegMax=tonumber(editLegMax:GetText())
	
	
	for i=1,#permuttable do
		T192p,T194p=SimPermut:HasTier("T19",permuttable[i])
		T202p,T204p=SimPermut:HasTier("T20",permuttable[i])
		T212p,T214p=SimPermut:HasTier("T21",permuttable[i])
		epicGemUsed=false
		SimPermut:ReorganizeEquip(permuttable[i])
		result=SimPermut:CheckUsability(permuttable[i],tableBaseLink)
		if result=="" or ad then
			currentString=""
			nbLeg=0
			nbitem=0
			itemList=""
			
			for j=1,#permuttable[i] do
				draw = true
				local _,_,itemRarity = GetItemInfo(permuttable[i][j][1])
				if(itemRarity==5) then 
					nbLeg=nbLeg+1
				end
				
				itemString=SimPermut:GetItemString(permuttable[i][j][1],ExtraData.PermutSimcNames[j],false,permuttable[i][j][2],permuttable[i][j][3])
				itemStringFinal=table.concat(itemString, ',')
				if (j>10) then
					if (j==11 or j==13) then
						itemString2 =SimPermut:GetItemString(permuttable[i][j+1][1],ExtraData.PermutSimcNames[j+1],false,permuttable[i][j][2],permuttable[i][j][3])
						itemStringFinal2 = table.concat(itemString2, ',')
						if(itemStringFinal==tableBaseString[j] or (itemStringFinal==tableBaseString[j+1] and itemStringFinal2==tableBaseString[j]))then
							draw=false
						else
							draw=true
						end
					else
						itemString2 =SimPermut:GetItemString(permuttable[i][j-1][1],ExtraData.PermutSimcNames[j-1],false,permuttable[i][j][2],permuttable[i][j][3])
						itemStringFinal2 = table.concat(itemString2, ',')
						if(itemStringFinal==tableBaseString[j] or (itemStringFinal==tableBaseString[j-1] and itemStringFinal2==tableBaseString[j]))then
							draw=false
						else
							draw=true
						end
					end
				else
					draw = (itemStringFinal ~= tableBaseString[j])
				end
				
				if draw or ad then
					local adString=""
					if ad and not draw then
						notDrawn=notDrawn+1
						adString=" # Debug not drawn : "
					end
					if not ad then
						okDrawn=okDrawn+1
					end
					currentString = currentString.. adString ..ExtraData.PermutSimcNames[j] .. "=" .. table.concat(itemString, ',').."\n"
					itemname = GetItemInfo(permuttable[i][j][1])
					nbitem=nbitem+1
					itemList=itemList..PersoLib:tokenize(itemname).."-"
				else
					PersoLib:debugPrint("Not printed: not drawn",ad)
					notDrawn=notDrawn+1
				end
				
			end
			
			itemList=itemList:sub(1, -2)
			
			if((nbLeg >=actualLegMin and nbLeg<=actualLegMax and nbitem>0 
				and (actualSetsT19==0 or (actualSetsT19==2 and T192p) or (actualSetsT19==4 and T194p)) 
				and (actualSetsT20==0 or (actualSetsT20==2 and T202p) or (actualSetsT20==4 and T204p))
				and (actualSetsT21==0 or (actualSetsT21==2 and T212p) or (actualSetsT21==4 and T214p))) 
				or ad) then
				local adString=""
				if ad then
					if result ~= "" then
						adString=" # Debug print : "..result.."\n"
					elseif(nbLeg>actualLegMax) then
						adString=" # Debug print : Not printed:Too much Leg ("..nbLeg..")\n"
					elseif(nbLeg<actualLegMin) then
						adString=" # Debug print : Not printed:Too few Leg ("..nbLeg..")\n"
					elseif(not T192p and actualSetsT19==2) then
						adString=" # Debug print : Not printed:No 2p T19\n"
					elseif(not T194p and actualSetsT19==4) then
						adString=" # Debug print : Not printed:No 4p T19\n"
					elseif(not T202p and actualSetsT20==2) then
						adString=" # Debug print : Not printed:No 2p T20\n"
					elseif(not T204p and actualSetsT20==4) then
						adString=" # Debug print : Not printed:No 4p T20\n"	
					elseif(not T212p and actualSetsT21==2) then
						adString=" # Debug print : Not printed:No 2p T21\n"
					elseif(not T214p and actualSetsT21==4) then
						adString=" # Debug print : Not printed:No 4p T21\n"	
					end
				end
				returnString =  returnString .. adString..SimPermut:GetCopyName(copynumber,nbitem,itemList,#permuttable,1) .. "\n".. currentString.."\n"
				copynumber=copynumber+1
			
			end
		else
			PersoLib:debugPrint("Not printed:"..result,ad)
		end
	end
	
	if copynumber > COPY_THRESHOLD then
		str="Large number of copy, you may not have every copy (frame limitation). Consider using AutoSimC Export"
		mainframe:SetStatusText(str)
		PersoLib:debugPrint(str,ad)
	end
	
	if notDrawn>0 and okDrawn==0 and selecteditems>14 then
		str="No copy generated because no other possible combination were found (outside boundaries legendaries, same ring/trinket, no 4P...)"
		mainframe:SetStatusText(str)
		PersoLib:debugPrint(str,ad)
	end
	
	return returnString
end

-- generates the string used for talents
function SimPermut:GenerateTalentString()
	local copynb
	local returnString=""
	for i=1,#tableTalentResults do
		if tableTalentResults[i]~=PersoLib:CreateSimcTalentString() then
			copynb = SimPermut:GetCopyName(i,nil,tableTalentResults[i],#tableTalentResults,2)
			returnString =  returnString.."\n" ..copynb .. "\n".. "talents="..tableTalentResults[i].."\n"
		end
	end
	return returnString
end

-- generates the string used for relics permut
function SimPermut:GenerateRelicString()
	
	local weaponString,itemLink
	local returnString=""
	local artifactID,artifactData = LAD:GetArtifactInfo() 
	local CopyString=""
	local artifactID,artifactData = LAD:GetArtifactInfo()
	local itemLevel1,itemLevel2,itemLevel3
	if not artifactData.relics[1].link or not artifactData.relics[2].link then
		return ""
	end
	_, _, _, itemLevel1 = GetItemInfo(artifactData.relics[1].link)
	_, _, _, itemLevel2 = GetItemInfo(artifactData.relics[2].link)
	
	if not artifactData.relics[3].isLocked then
		_, _, _, itemLevel3 = GetItemInfo(artifactData.relics[3].link)
	end
	
	itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
	if itemLink and (relicComparisonTypeValue==1 and ilvlTrait1:GetText() and ilvlTrait2:GetText() or (relicComparisonTypeValue==2 and ilvlWeapon:GetText())) then
			local relicid1,relicid2,relicid3,relicilvl1,relicilvl2,relicilvl3,weaponilvl
			
			if DropdownTrait1:GetValue()==0 then
				relicid1=artifactData.relics[1].itemID
			else
				relicid1=DropdownTrait1:GetValue()
			end
			
			if DropdownTrait2:GetValue()==0 then
				relicid2=artifactData.relics[2].itemID
			else
				relicid2=DropdownTrait2:GetValue()
			end
			if not artifactData.relics[3].isLocked then
				if DropdownTrait3:GetValue()==0 then
					relicid3=artifactData.relics[3].itemID
				else
					relicid3=DropdownTrait3:GetValue()
				end
			end
			if relicComparisonTypeValue==1 then
				relicilvl1=ilvlTrait1:GetText()
				relicilvl2=ilvlTrait2:GetText()
				if not artifactData.relics[3].isLocked then
					relicilvl3=ilvlTrait3:GetText()
				end
			else
				weaponilvl=ilvlWeapon:GetText()
			end
			
			--CopyName
			if relicComparisonTypeValue==2 then
				CopyString="Weapon-"..weaponilvl.."_"
			end
			if relicComparisonTypeValue==1 and tonumber(relicilvl1)~=itemLevel1 then
				CopyString=CopyString..relicilvl1.."-"
			end
			if DropdownTrait1:GetValue()==0 then
				CopyString=CopyString.."Current".."_"
			else
				CopyString=CopyString..ExtraData.ArtifactTableTraits[artifactID][1][relicid1].."_"
			end
			
			if relicComparisonTypeValue==1 and tonumber(relicilvl2)~=itemLevel2 then
				CopyString=CopyString..relicilvl2.."-"
			end
			if DropdownTrait2:GetValue()==0 then
				CopyString=CopyString.."Current".."_"
			else
				CopyString=CopyString..ExtraData.ArtifactTableTraits[artifactID][2][relicid2].."_"
			end
			
			if not artifactData.relics[3].isLocked then
				if relicComparisonTypeValue==1 and tonumber(relicilvl3)~=itemLevel3 then
					CopyString=CopyString..relicilvl3.."-"
				end
				if DropdownTrait3:GetValue()==0 then
					CopyString=CopyString.."Current"
				else
					CopyString=CopyString..ExtraData.ArtifactTableTraits[artifactID][3][relicid3]
				end
			end
			
			local copynb = SimPermut:GetCopyName(relicCopyCount,nil,CopyString,1,3)
			weaponString = SimPermut:OverrideWeapon(itemLink,relicid1,relicid2,relicid3,relicilvl1,relicilvl2,relicilvl3,weaponilvl)
			returnString =  returnString.."\n" ..copynb .. "\n".. "main_hand=" .. weaponString.. '\n'
			
			relicCopyCount=relicCopyCount+1
	end

	return returnString
end

-- Generate selected crucible traits
function SimPermut:GenerateCrucibleString()
	local str=""
	local artifactID,artifactData = LAD:GetArtifactInfo() 
	local CopyString=""
	local crucibleString
	local T1,_=next(ExtraData.NetherlightData[1],nil)
	
	local tabletraits={}
	for _,v in pairs(dropdownTableCrucible) do 
		if not tabletraits[v:GetValue()] then tabletraits[v:GetValue()]=0 end
		tabletraits[v:GetValue()]=tabletraits[v:GetValue()]+1
	end
	
	crucibleString = T1..":3"
	for k,v in pairs(tabletraits) do
		crucibleString = crucibleString..":"..k..":"..v
		if ExtraData.NetherlightData[2][k] then --crucible trait
			CopyString = CopyString..ExtraData.NetherlightData[2][k].."-"..v.."_"
		else --artifact trait
			CopyString = CopyString..ExtraData.NetherlightData[3][artifactID][k].."-"..v.."_"
		end
	end
	CopyString=CopyString:sub(1, -2)
	local copynb = SimPermut:GetCopyName(crucibleCopyCount,nil,CopyString,1,4)
	str =  "\n" ..copynb .. "\n".. "crucible=" .. crucibleString.. '\n'
		
	return str
end

-- Modify main hand relics
function SimPermut:OverrideWeapon(itemLink,relic1,relic2,relic3,ilvlRelic1,ilvlRelic2,ilvlRelic3,ilvlWeapon)
	local weaponString
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
	local bonuses = {}
	for index=1, tonumber(itemSplit[OFFSET_BONUS_ID]) do
		bonuses[#bonuses + 1] = itemSplit[OFFSET_BONUS_ID + index]
	end
	
	-- ,id=128827,bonus_id=740,relic_id=//,gem_id=137377/140819/137463,relic_ilevel=925/925/925
	weaponString=",id="..itemSplit[OFFSET_ITEM_ID]
	if #bonuses > 0 then
		weaponString = weaponString..",bonus_id=" .. table.concat(bonuses, '/')
	end
	if itemSplit[OFFSET_ENCHANT_ID] and itemSplit[OFFSET_ENCHANT_ID]~=0 then
		weaponString = weaponString..",enchant_id=" .. itemSplit[OFFSET_ENCHANT_ID]
	end
	weaponString=weaponString..",relic_id=//"
	weaponString=weaponString..",gem_id="..relic1.."/"..relic2.."/"
	if not artifactData.relics[3].isLocked then
		weaponString=weaponString..relic3
	end
	if relicComparisonTypeValue==1 then
		weaponString=weaponString..",relic_ilevel="..ilvlRelic1.."/"..ilvlRelic2.."/"
		if not artifactData.relics[3].isLocked then
		weaponString=weaponString..ilvlRelic3
	end
	else
		weaponString=weaponString..",ilevel="..ilvlWeapon
	end
	return weaponString
end

-- get copy's name
function SimPermut:GetCopyName(copynumber,nbitem,List,nbitems,typeReport)
	local returnString="copy="
	
	if (typeReport==1 and actualSettings.report_typeGear==1 and List) or (typeReport==2 and actualSettings.report_typeTalents==1) or (typeReport==3 and actualSettings.report_typeRelics==1) or (typeReport==4 and actualSettings.report_typeCrucible==1) then
		if typeReport==1 then
			returnString=returnString..List
		elseif typeReport==2 then
			returnString=returnString..List
		elseif typeReport==3 then
			returnString=returnString..string.gsub(List, " ", "-");
		elseif typeReport==4 then
			returnString=returnString..string.gsub(List, " ", "-");
		end
	else 
		local nbcopies = ''..nbitems
		local digits = string.len(nbcopies)
		local mask = '00000000000000000000000000000000000'
		local maskedProfileID=string.sub(mask..copynumber,-digits)
		returnString=returnString.."copy"..maskedProfileID
	end
	
	returnString=returnString..",Base"
	return returnString
end

-- generates the string for artifact, equiped gear and player info
function SimPermut:GetBaseString(nocrucible)
	if not nocrucible then nocrucible=false end
	local playerName = UnitName('player')
	local playerClass
	_, playerClass,classID = UnitClass('player')
	local playerLevel = UnitLevel('player')
	local playerRealm = GetRealmName()
	local playerRegion = ExtraData.RegionString[GetCurrentRegion()]
	local bPermut=false
	local slotId,itemLink
	local itemString = {}

	local playerRace = PersoLib:getRace()
	local playerTalents = PersoLib:CreateSimcTalentString()
	local playerArtifact,playerCrucible = SimPermut:GetArtifactString(nocrucible)
	local playerSpec = ExtraData.SpecNames[ PersoLib:getSpecID() ]

	-- Construct SimC-compatible strings from the basic information
	local player = ""
	playerClass = PersoLib:tokenize(playerClass) 
	player = playerClass .. '="' .. playerName .. '"'
	playerLevel = 'level=' .. playerLevel
	playerRace = 'race=' .. PersoLib:tokenize(playerRace)
	playerRole = 'role=' .. PersoLib:translateRole(PersoLib:getSpecID())
	playerSpec = 'spec=' .. PersoLib:tokenize(playerSpec)
	playerRealm = 'server=' .. PersoLib:tokenize(playerRealm)
	playerRegion = 'region=' .. PersoLib:tokenize(playerRegion)
	playerTalents = 'talents=' .. playerTalents	

	-- Build the output string for the player (not including gear)
	local SimPermutProfile = player .. '\n'
	SimPermutProfile = SimPermutProfile .. playerLevel .. '\n'
	SimPermutProfile = SimPermutProfile .. playerRace .. '\n'
	SimPermutProfile = SimPermutProfile .. playerRegion .. '\n'
	SimPermutProfile = SimPermutProfile .. playerRealm .. '\n'
	SimPermutProfile = SimPermutProfile .. playerRole .. '\n'
	SimPermutProfile = SimPermutProfile .. playerTalents .. '\n'
	SimPermutProfile = SimPermutProfile .. playerSpec .. '\n'
	if playerArtifact ~= "" then
		SimPermutProfile = SimPermutProfile .. "artifact=".. playerArtifact .. '\n'
	end
	if playerCrucible ~= "" then
		SimPermutProfile = SimPermutProfile .. "crucible=".. playerCrucible .. '\n'
	end

	--add custome simc parameters
	SimPermutProfile = SimPermutProfile .. actualSettings.simcCommands.. '\n'
	
	SimPermutProfile = SimPermutProfile .. '\n'
	
	-- Method that gets gear information
	local items,itemsLinks = SimPermut:GetItemStrings()

	SimPermutProfile = SimPermutProfile .. "name=Base \n"
	-- output gear
	for slotNum=1, #ExtraData.PermutSlotNames do
		if items[slotNum] then
			SimPermutProfile = SimPermutProfile .. items[slotNum] .. '\n'
		end
	end
	
	--add weapons
    itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
	itemString = {}

    -- if we don't have an item link, we don't care
    if itemLink then
		itemString=SimPermut:GetItemString(itemLink,'main_hand',true)
		SimPermutProfile = SimPermutProfile .. "main_hand=" .. table.concat(itemString, ',').. '\n'
    end
	
	--slotId = GetInventorySlotInfo("SecondaryHandSlot")
    itemLink = GetInventoryItemLink('player', INVSLOT_OFFHAND)
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

-- check if table is usefull to simulate (same ring, same trinket)
function SimPermut:CheckUsability(table1,table2)
	local duplicate = true
	local itemString 
	local itemSplit = {}
	local itemIdR111,itemIdR112
	local itemIdT111,itemIdT112
	
	--checking different size
	if #table1~=#table2 then
		return "Different size"
	end
	
	--checking same ring
	if table1[11][1]==table1[12][1] then
		return "Same ring "..table1[11][1]
	end

	
	--checking ring inf
	itemIdR111 = PersoLib:GetIDFromLink(table1[11][1])
	itemIdR112 = PersoLib:GetIDFromLink(table1[12][1])
	
	if fingerInf then
		if itemIdR111>itemIdR112 then
			return "Ring copy duplication ("..itemIdR111.."-"..itemIdR112.." /fi: "..tostring(fingerInf)..")"
		end
	else
		if itemIdR111<itemIdR112 then
			return "Ring copy duplication ("..itemIdR111.."-"..itemIdR112.." /fi: "..tostring(fingerInf)..")"
		end
	end
	
	--checking same trinket
	if table1[13][1]==table1[14][1] then
		return "Same trinket "..table1[13][1]
	end
	
	--checking trinket inf
	itemIdT111 = PersoLib:GetIDFromLink(table1[13][1])
	itemIdT112 = PersoLib:GetIDFromLink(table1[14][1])
	
	if trinketInf then
		if itemIdT111>itemIdT112 then
			return "Trinket copy duplication ("..itemIdT111.."-"..itemIdT112.." /ti: "..tostring(trinketInf)..") "
		end
	else
		if itemIdT111<itemIdT112 then
			return "Trinket copy duplication ("..itemIdT111.."-"..itemIdT112.." /ti: "..tostring(trinketInf)..")"
		end
	end

	
	--checking Duplicate
	for i=1,#table1 do
		if duplicate then
			if table1[i][1]~=table2[i] then
				duplicate=false
			end
		end
	end
	
	if duplicate then
		return "Duplicate from base"
	end

	return ""
end

-- get Simc artifact string
function SimPermut:GetArtifactString(nocrucible)
	
	SocketInventoryItem(INVSLOT_MAINHAND)
	if artifactID and ExtraData.ArtifactTable[artifactID] then
		local str = ExtraData.ArtifactTable[artifactID] .. ':0:0:0:0'
		local cruciblestr = ""
		local baseRanks = {}
		local crucibleRanks = {}

		local powers = ArtifactUI.GetPowers()
		for i = 1, #powers do
			local powerId, powerRank, relicRank, crucibleRank = SimPermut:GetPowerData(powers[i], false)

			if powerRank > 0 then
				baseRanks[#baseRanks + 1] = powerId
				baseRanks[#baseRanks + 1] = powerRank
			end

			if crucibleRank > 0 then
				crucibleRanks[#crucibleRanks + 1] = powerId
				crucibleRanks[#crucibleRanks + 1] = crucibleRank
			end
		end

		-- Grab 7.3 artifact trait information
		for _, powerId in ipairs(ExtraData.NetherlightData[1]) do
			local powerId, powerRank, relicRank, crucibleRank = SimPermut:GetPowerData(powerId, true)
			if crucibleRank > 0 then
			  crucibleRanks[#crucibleRanks + 1] = powerId
			  crucibleRanks[#crucibleRanks + 1] = crucibleRank
			end
		end
		for _, powerId in ipairs(ExtraData.NetherlightData[2]) do
			local powerId, powerRank, relicRank, crucibleRank = SimPermut:GetPowerData(powerId, true)
			if crucibleRank > 0 then
			  crucibleRanks[#crucibleRanks + 1] = powerId
			  crucibleRanks[#crucibleRanks + 1] = crucibleRank
			end
		end

	    if #baseRanks > 0 then
			str = str .. ':' .. table.concat(baseRanks, ':')
	    end

	    if #crucibleRanks > 0 and not nocrucible then
			cruciblestr = cruciblestr .. '\n'
			cruciblestr = cruciblestr .. 'crucible=' .. table.concat(crucibleRanks, ':')
	    end
		
		Clear()
		
		return str,cruciblestr
	end
	return "",""
end

-- check for Tier Sets
function SimPermut:HasTier(stier,tableEquip)
	if ExtraData.HasTierSets[stier][classID] then
      local Count = 0;
      local Item;
      for Slot, ItemID in pairs(ExtraData.HasTierSets[stier][classID]) do
        Item = tonumber(PersoLib:GetIDFromLink(tableEquip[Slot][1]));
        if Item and Item == ItemID then
          Count = Count + 1;
        end
      end
      return ExtraData.HasTierSets[stier][0](Count);
    else
      return false;
    end
end

-- add item to the list
function SimPermut:AddItemLink(itemLink,itemilvl,socket)
	
	name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink)
	if link then
		if ExtraData.GetItemInfoName[equipSlot] then
			local _,_,itemRarity = GetItemInfo(itemLink)
			if not SimPermutVars.addedItemsTable then 
				SimPermutVars.addedItemsTable={}
			end
			if not SimPermutVars.addedItemsTable[ExtraData.GetItemInfoName[equipSlot]] then 
				SimPermutVars.addedItemsTable[ExtraData.GetItemInfoName[equipSlot]]={}
			end
			if itemRarity==5 or (itemilvl and tonumber(itemilvl) and string.len(""..tonumber(itemilvl))>0) then
				local addedilvl=nil
				if itemilvl and tonumber(itemilvl) and string.len(""..tonumber(itemilvl))>0 then
					addedilvl=tonumber(itemilvl)
				end
				table.insert(SimPermutVars.addedItemsTable[ExtraData.GetItemInfoName[equipSlot]],{itemLink,addedilvl,socket})
				PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
				return true
			else
				print("Incorrect ilvl")
			end
		else
			print("Unknown itemslot")
		end
	else
		print("Not a proper item")
	end
	
	return false
end

-- Get data from artifact
function SimPermut:GetPowerData(powerId, isCrucible)
  if not powerId then
    return 0, 0, 0
  end

  local powerInfo = ArtifactUI.GetPowerInfo(powerId)
  if powerInfo == nil then
    return powerId, 0, 0
  end

  local relicRanks = 0
  local crucibleRanks = 0
  local purchasedRanks = powerInfo.currentRank
  -- A crucible (row 1 or 2)  trait
  if isCrucible then
    crucibleRanks = powerInfo.bonusRanks
  else
    relicRanks = powerInfo.bonusRanks
    purchasedRanks = purchasedRanks - relicRanks
	

    for ridx = 1, ArtifactUI.GetNumRelicSlots() do
      local link = select(4, ArtifactUI.GetRelicInfo(ridx))
      if link ~= nil then
        local relicData   = PersoLib:LinkSplit(link)
        local baseLink    = select(2, GetItemInfo(relicData[1]))
        local basePowers  = ArtifactUI.GetPowersAffectedByRelicItemLink(baseLink)
        local relicPowers = ArtifactUI.GetPowersAffectedByRelic(ridx)

        if type(basePowers) == 'number' then
          basePowers = { basePowers }
        end

        if type(relicPowers) == 'number' then
          relicPowers = { relicPowers }
        end

        -- For each power id that is not included in the base powers given for the relic, add one rank
        -- to crucible ranks, and subtract one from bonus ranks
        for rpidx=1, #relicPowers do
          local found = false
          for bpidx=1, #basePowers do
            if relicPowers[rpidx] == basePowers[bpidx] then
              found = true
              break
            end
          end

          if not found then
            crucibleRanks = crucibleRanks + 1
            relicRanks = relicRanks - 1
          end
        end
      end
    end
  end

  return powerId, purchasedRanks, relicRanks, crucibleRanks
end

-- check if the item is selected
function SimPermut:isEquiped(itemLink,slot)
	local returnValue=false
	if slot==11 then
		if tableBaseLink[11]==itemLink or tableBaseLink[12]==itemLink then
			returnValue=true
		end
	elseif slot==12 then
		if tableBaseLink[13]==itemLink or tableBaseLink[14]==itemLink then
			returnValue=true
		end
	else
		if tableBaseLink[slot]==itemLink then
			returnValue=true
		end
	end
	return returnValue
end