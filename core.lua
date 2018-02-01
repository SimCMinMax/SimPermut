local _, SimPermut = ...

SimPermut = LibStub("AceAddon-3.0"):NewAddon(SimPermut, "SimPermut", "AceConsole-3.0", "AceEvent-3.0")

SimPermutVars={}

-- Libs
local ArtifactUI          	= _G.C_ArtifactUI
local Clear                 = ArtifactUI.Clear
local SocketInventoryItem 	= _G.SocketInventoryItem
local AceGUI 			  	= LibStub("AceGUI-3.0")
local LAD					= LibStub("LibArtifactData-1.0")
local PersoLib			  	= LibStub("PersoLib")
local ArtifactRelicForgeUI  = _G.C_ArtifactRelicForgeUI

-- Data
local ExtraData			= SimPermut.ExtraData

-- UI
local UIParameters={
	--Consts
	OFFSET_ITEM_ID 		= 1,
	OFFSET_ENCHANT_ID 	= 2,
	OFFSET_GEM_ID_1 	= 3,
	OFFSET_GEM_ID_2 	= 4,
	OFFSET_GEM_ID_3 	= 5,
	OFFSET_GEM_ID_4 	= 6,
	OFFSET_SUFFIX_ID 	= 7,
	OFFSET_FLAGS 		= 11,
	OFFSET_BONUS_ID 	= 13,
	TALENTS_MAX_COLUMN	= 3,
	TALENTS_MAX_ROW		= 7,
	RELIC_MIN_ILVL		= 780,
	RELIC_MAX_ILVL		= 1000,
	ITEM_COUNT_THRESHOLD = 25,
	COPY_THRESHOLD 		= 500,
	
	mainframeCreated=false,
	classID,
	artifactID,
	artifactData,
	selecteditems=0,
	labelCount,
	errorMessage="",
	currentFrame=1,
	relicComparisonTypeValue=1,
	CrucibleComparisonTypeValue=1,
	CrucibleComparisonTypeValue_old=1,
	relicCopyCount=1,
	relicString="",
	crucibleCopyCount=1,
	crucibleString="",
	
	actualEnchantNeck=0,
	actualEnchantFinger=0,
	actualEnchantBack=0,
	actualGem=0,
	actualForce=false,
	actualLegMin=0,
	actualLegMax=0,
	actualSetsT19=0,
	actualSetsT20=0,
	actualSetsT21=0,
	equipedLegendaries=0,
	epicGemUsed,
	fingerInf = false,
	trinketInf = false,
	ad=false,
	PosX=0,
	PosY=0,
	profileName = ""
	
}
local UIElements={
	mainframe,
	scroll1,
	scroll2,
	scroll3,
	checkBoxForce,
	resultBox,
	mainGroup,
	resultGroup,
	tableListItems={},
	tableTitres={},
	tableLabel={},
	tableCheckBoxes={},
	spacerTable={},
	dropdownTableCrucible={},
	tableTalentLabel={},
	tableTalentIcon={},
	tableTalentcheckbox={},
	tableTalentSpells={},
	tableTalentResults={},
	tableCrucibleResults={},
	tablePreCheck={},
	tableNumberSelected={},
	DropdownTrait1,
	DropdownTrait2,
	DropdownTrait3,
	ilvlTrait1,
	ilvlTrait2,
	ilvlTrait3,
	ilvlWeapon,
	editLegMin,
	editLegMax,
	tableLinkPermut={},
	tableBaseLink={},
	tableBaseString={}
}

-- Config
local variablesLoaded=false
local defaultSettings={
	report_typeGear		= 2,
	report_typeTalents	= 2,
	report_typeRelics	= 2,
	report_typeCrucible	= 2,
	ilvl_thresholdMin 	= 800,
	ilvl_thresholdMax 	= 1000,
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
	ilvl_RelicMax		= 1000,
	addedItemsTable		= {},
	smallUI				= false,
	simcCommands		= "",
	NCKeepBase			= false,
	NCPreviewType		= 0,
	NCPreviewReplace	= false
}
local actualSettings={}

SLASH_SIMPERMUTSLASH1 = "/SimPermut"
SLASH_SIMPERMUTSLASHDEBUG1 = "/SimPermutDebug"

-------------Test-----------------
SLASH_SIMPERMUTSLASHTEST1 = "/Simtest"
SlashCmdList["SIMPERMUTSLASHTEST"] = function (arg)
	local link = ArtifactRelicForgeUI.GetPreviewRelicItemLink()
	local split = PersoLib:LinkSplit(link)
	PersoLib:DumpTable(split)
end
-------------Test-----------------

-- Command UI
SlashCmdList["SIMPERMUTSLASH"] = function (arg)
	if UIParameters.mainframeCreated and UIElements.mainframe:IsShown() then
		UIElements.mainframe:Hide()
	else
		if not variablesLoaded then
			if not SimPermutVars then SimPermutVars = {} end
			PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
			variablesLoaded=true
		end
	
		--handle commandline
		if string.match(arg, "fastAccess") then
			local stringSplitarg = PersoLib:Split(arg, "=")
			local stringSplitargval = PersoLib:Split(stringSplitarg[2], "-")
			UIParameters.currentFrame = tonumber(stringSplitargval[1])
			if tonumber(stringSplitargval[1])==3 then
				if stringSplitargval[2] then
					UIParameters.relicComparisonTypeValue=tonumber(stringSplitargval[2])
				end
			elseif tonumber(stringSplitargval[1])==4 then
				if stringSplitargval[2] then
					UIParameters.CrucibleComparisonTypeValue=tonumber(stringSplitargval[2])
				end
			end
		else
			for i=1,#ExtraData.ListNames do
				if string.match(arg, ExtraData.ListNames[i]) then
					UIElements.tablePreCheck[i]=true
				else
					UIElements.tablePreCheck[i]=false
				end
			end
		end
		
		
		SimPermut:BuildFrame()
		UIParameters.mainframeCreated=true
	end
end

SlashCmdList["SIMPERMUTSLASHDEBUG"] = function (arg)
	if UIParameters.ad then
		UIParameters.ad = false
		print("SimpPermut:Desactivated debug")
	else
		UIParameters.ad = true
		print("SimpPermut:Activated debug")
	end
end

function SimPermut:OnInitialize()
	SlashCmdList["SimPermut"] = handler;
	PersoLib:Init(ExtraData)
  if SimPermutVars.ilvl_thresholdMax==999 then
    SimPermutVars.ilvl_thresholdMax=1000
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
  end
end

----------------------------
----------- UI -------------
----------------------------
-- Main Frame construction
function SimPermut:BuildFrame()
	--Init Vars
	UIParameters.artifactID,UIParameters.artifactData = LAD:GetArtifactInfo() 
	
	--replace fram if already opened
	if UIElements.mainframe and UIElements.mainframe:IsVisible() then
		UIElements.mainframe:Release()
	end
	UIElements.mainframe = AceGUI:Create("Frame")
	UIElements.mainframe:SetTitle("SimPermut")
	UIElements.mainframe:SetPoint("CENTER",UIParameters.PosX, UIParameters.PosY)
	UIElements.mainframe:SetCallback("OnClose", function(widget) 
		if UIElements.mainframe:IsVisible() then
			widget:Release()
		end
	end)
	UIElements.mainframe:SetCallback("OnRelease", function(widget) 
		--update position
		_, _, _, UIParameters.PosX, UIParameters.PosY = UIElements.mainframe:GetPoint()
	end)
	UIElements.mainframe:SetLayout("Flow")
	
	if actualSettings.smallUI then
		UIElements.mainframe:SetWidth(1000)
		UIElements.mainframe:SetHeight(710)
	else
		UIElements.mainframe:SetWidth(1300)
		UIElements.mainframe:SetHeight(810)
	end
	
	local frameDropdown = AceGUI:Create("Dropdown")
    frameDropdown:SetWidth(200)
	frameDropdown:SetList(ExtraData.FrameMenu)
	frameDropdown:SetLabel("")
	frameDropdown:SetValue(UIParameters.currentFrame)
	frameDropdown:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.currentFrame=item
		if UIElements.mainframe:IsVisible() then
			UIElements.mainframe:Release()
		end
		SimPermut:BuildFrame()
    end)
	UIElements.mainframe:AddChild(frameDropdown)
	
	SimPermut:AddSpacer(UIElements.mainframe,true)
	
	if UIParameters.currentFrame==1 then --gear
		SimPermut:BuildGearFrame()
		SimPermut:BuildResultFrame(true)
		SimPermut:InitGearFrame()
	elseif UIParameters.currentFrame==2 then --talents
		SimPermut:BuildTalentFrame()
		SimPermut:BuildResultFrame(false)
		SimPermut:GenerateTalents()
	elseif UIParameters.currentFrame==3 then --relics
		SimPermut:BuildRelicFrame()
	elseif UIParameters.currentFrame==4 then --NetherLight crucible
		SimPermut:BuildNetherlightFrame()
	elseif UIParameters.currentFrame==5 then --add items
		SimPermut:BuildDungeonJournalFrame()
	elseif UIParameters.currentFrame==6 then --options
		SimPermut:BuildOptionFrame()
	end
end

-- Field construction for gear Frame
function SimPermut:BuildGearFrame()
	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Flow")
    UIElements.mainGroup:SetRelativeWidth(0.65)
	
	local scrollcontainer1 = AceGUI:Create("SimpleGroup")
	scrollcontainer1:SetRelativeWidth(0.5)
	if actualSettings.smallUI then
		scrollcontainer1:SetHeight(460)
	else
		scrollcontainer1:SetHeight(600)
	end
	scrollcontainer1:SetLayout("Fill")
	UIElements.mainGroup:AddChild(scrollcontainer1)
	
	UIElements.scroll1 = AceGUI:Create("ScrollFrame")
	UIElements.scroll1:SetLayout("Flow")
	scrollcontainer1:AddChild(UIElements.scroll1)
	
	local scrollcontainer2 = AceGUI:Create("SimpleGroup")
	scrollcontainer2:SetRelativeWidth(0.5)
	if actualSettings.smallUI then
		scrollcontainer2:SetHeight(460)
	else
		scrollcontainer2:SetHeight(600)
	end
	scrollcontainer2:SetLayout("Fill")
	UIElements.mainGroup:AddChild(scrollcontainer2)
	
	UIElements.scroll2 = AceGUI:Create("ScrollFrame")
	UIElements.scroll2:SetLayout("Flow")
	scrollcontainer2:AddChild(UIElements.scroll2)

	
	------ Items + param
	local labelEnchantNeck= AceGUI:Create("Label")
	labelEnchantNeck:SetText("Enchant Neck")
	labelEnchantNeck:SetWidth(80)
	UIElements.mainGroup:AddChild(labelEnchantNeck)
	
	local dropdownEnchantNeck = AceGUI:Create("Dropdown")
	dropdownEnchantNeck:SetWidth(130)
	dropdownEnchantNeck:SetList(ExtraData.enchantNeck)
	dropdownEnchantNeck:SetValue(actualSettings.enchant_neck)
	dropdownEnchantNeck:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualEnchantNeck=item
    end)
	UIElements.mainGroup:AddChild(dropdownEnchantNeck)
		
	local labelEnchantBack= AceGUI:Create("Label")
	labelEnchantBack:SetText("     Enchant Back")
	labelEnchantBack:SetWidth(95)
	UIElements.mainGroup:AddChild(labelEnchantBack)
	
	local dropdownEnchantBack = AceGUI:Create("Dropdown")
	dropdownEnchantBack:SetWidth(110)
	dropdownEnchantBack:SetList(ExtraData.enchantCloak)
	dropdownEnchantBack:SetValue(actualSettings.enchant_back)
	dropdownEnchantBack:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualEnchantBack=item
    end)
	UIElements.mainGroup:AddChild(dropdownEnchantBack)
	
	local labelEnchantFinger= AceGUI:Create("Label")
	labelEnchantFinger:SetText("     Enchant Ring")
	labelEnchantFinger:SetWidth(95)
	UIElements.mainGroup:AddChild(labelEnchantFinger)
	
	local dropdownEnchantFinger = AceGUI:Create("Dropdown")
	dropdownEnchantFinger:SetWidth(110)
	dropdownEnchantFinger:SetList(ExtraData.enchantRing)
	dropdownEnchantFinger:SetValue(actualSettings.enchant_ring)
	dropdownEnchantFinger:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualEnchantFinger=item
    end)
	UIElements.mainGroup:AddChild(dropdownEnchantFinger)
	
	local labelGem= AceGUI:Create("Label")
	labelGem:SetText("     Gem")
	labelGem:SetWidth(55)
	UIElements.mainGroup:AddChild(labelGem)
	
	local dropdownGem = AceGUI:Create("Dropdown")
	dropdownGem:SetList(ExtraData.gemList)
	dropdownGem:SetWidth(110)
	dropdownGem:SetValue(actualSettings.gems)
	dropdownGem:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualGem=item
    end)
	UIElements.mainGroup:AddChild(dropdownGem)
	
	UIElements.checkBoxForce = AceGUI:Create("CheckBox")
	UIElements.checkBoxForce:SetWidth(210)
	UIElements.checkBoxForce:SetLabel("Replace current enchant/gems")
	UIElements.checkBoxForce:SetValue(actualSettings.replaceEnchants)
	UIElements.checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualForce=UIElements.checkBoxForce:GetValue()
    end)
	UIElements.mainGroup:AddChild(UIElements.checkBoxForce)

	SimPermut:AddSpacer(UIElements.mainGroup,false,15)
	
	local labelLeg= AceGUI:Create("Label")
	labelLeg:SetText(" Legendaries")
	labelLeg:SetWidth(80)
	UIElements.mainGroup:AddChild(labelLeg)
	
	UIElements.editLegMin= AceGUI:Create("EditBox")
	UIElements.editLegMin:SetText("0")
	UIElements.editLegMin:SetWidth(20)
	UIElements.editLegMin:DisableButton(true)
	UIElements.editLegMin:SetMaxLetters(1)
	UIElements.editLegMin:SetCallback("OnTextChanged", function (this, event, item)
		UIElements.editLegMin:SetText(string.match(item, '%d'))
		if UIElements.editLegMin:GetText()=="" then
			UIElements.editLegMin:SetText(0)
		end
    end)
	UIElements.mainGroup:AddChild(UIElements.editLegMin)
	
	UIElements.editLegMax= AceGUI:Create("EditBox")
	UIElements.editLegMax:SetText("2")
	UIElements.editLegMax:SetWidth(20)
	UIElements.editLegMax:DisableButton(true)
	UIElements.editLegMax:SetMaxLetters(1)
	UIElements.editLegMax:SetCallback("OnTextChanged", function (this, event, item)
		UIElements.editLegMax:SetText(string.match(item, '%d'))
		if UIElements.editLegMax:GetText()=="" then
			UIElements.editLegMax:SetText(0)
		end
    end)
	UIElements.mainGroup:AddChild(UIElements.editLegMax)
	
	SimPermut:AddSpacer(UIElements.mainGroup,false,89)

	local labelSetsT20= AceGUI:Create("Label")
	labelSetsT20:SetText("T20 (min)")
	labelSetsT20:SetWidth(76)
	UIElements.mainGroup:AddChild(labelSetsT20)
	
	local dropdownSetsT20 = AceGUI:Create("Dropdown")
	dropdownSetsT20:SetList(ExtraData.SetsListT20)
	dropdownSetsT20:SetWidth(110)
	dropdownSetsT20:SetValue(actualSettings.setsT20)
	dropdownSetsT20:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualSetsT20=item
    end)
	UIElements.mainGroup:AddChild(dropdownSetsT20)

	local labelSetsT21= AceGUI:Create("Label")
	labelSetsT21:SetText("T21 (min)")
	labelSetsT21:SetWidth(55)
	UIElements.mainGroup:AddChild(labelSetsT21)

	local dropdownSetsT21 = AceGUI:Create("Dropdown")
	dropdownSetsT21:SetList(ExtraData.SetsListT21)
	dropdownSetsT21:SetWidth(110)
	dropdownSetsT21:SetValue(actualSettings.setsT21)
	dropdownSetsT21:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualSetsT21=item
    end)
	UIElements.mainGroup:AddChild(dropdownSetsT21)
	
	SimPermut:AddSpacer(UIElements.mainGroup,false,90)

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
	UIElements.mainGroup:AddChild(ReportDropdownGear)

	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetWidth(165)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:Generate()
	end)
	UIElements.mainGroup:AddChild(buttonGenerate)

	UIParameters.labelCount= AceGUI:Create("Label")
	UIParameters.labelCount:SetText(" ")
	UIParameters.labelCount:SetWidth(255)
	UIElements.mainGroup:AddChild(UIParameters.labelCount)

	UIElements.mainframe:AddChild(UIElements.mainGroup)
end

-- Field construction for talent Frame
function SimPermut:BuildTalentFrame()
	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Flow")
    UIElements.mainGroup:SetRelativeWidth(0.65)
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Talent Permutation")
	labeltitre1:SetFullWidth(true)
	UIElements.mainGroup:AddChild(labeltitre1)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetRelativeWidth(0.3)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container1)
	
	local container2 = AceGUI:Create("SimpleGroup")
	container2:SetRelativeWidth(0.3)
	container2:SetHeight(600)
	container2:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container2)
	
	local container3 = AceGUI:Create("SimpleGroup")
	container3:SetRelativeWidth(0.3)
	container3:SetHeight(600)
	container3:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container3)
	
	for i=1,UIParameters.TALENTS_MAX_ROW do
		UIElements.tableTalentcheckbox[i]={}
		UIElements.tableTalentIcon[i]={}
		UIElements.tableTalentLabel[i]={}
		UIElements.tableTalentSpells[i]={}
		for j=1,UIParameters.TALENTS_MAX_COLUMN do
			local talentID, name, texture, selected, available, spellid=GetTalentInfo(i,j,GetActiveSpecGroup())
			UIElements.tableTalentSpells[i][j]=spellid
			UIElements.tableTalentcheckbox[i][j]=AceGUI:Create("CheckBox")
			UIElements.tableTalentcheckbox[i][j]:SetLabel("")
			UIElements.tableTalentcheckbox[i][j]:SetRelativeWidth(0.2)
			if selected then
				UIElements.tableTalentcheckbox[i][j]:SetValue(true)
			end
			
			local _, _, Talenticon = GetSpellInfo(spellid)
			UIElements.tableTalentIcon[i][j]=AceGUI:Create("Icon")
			UIElements.tableTalentIcon[i][j]:SetImage(Talenticon)
			UIElements.tableTalentIcon[i][j]:SetImageSize(40,40)
			UIElements.tableTalentIcon[i][j]:SetRelativeWidth(0.3)
			UIElements.tableTalentIcon[i][j]:SetCallback("OnEnter", function(widget)
				GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
				GameTooltip:SetSpellByID(UIElements.tableTalentSpells[i][j])
				GameTooltip:Show()
			end)			
			UIElements.tableTalentIcon[i][j]:SetCallback("OnLeave", function(widget)
				GameTooltip:Hide()
			end)
			
			UIElements.tableTalentLabel[i][j]=AceGUI:Create("Label")
			UIElements.tableTalentLabel[i][j]:SetText(name)
			UIElements.tableTalentLabel[i][j]:SetRelativeWidth(0.5)
				
			if j==1 then
				container1:AddChild(UIElements.tableTalentcheckbox[i][j])
				container1:AddChild(UIElements.tableTalentIcon[i][j])
				container1:AddChild(UIElements.tableTalentLabel[i][j])
			elseif j==2 then
				container2:AddChild(UIElements.tableTalentcheckbox[i][j])
				container2:AddChild(UIElements.tableTalentIcon[i][j])
				container2:AddChild(UIElements.tableTalentLabel[i][j])
			else
				container3:AddChild(UIElements.tableTalentcheckbox[i][j])
				container3:AddChild(UIElements.tableTalentIcon[i][j])
				container3:AddChild(UIElements.tableTalentLabel[i][j])
			end
		end
	end

	SimPermut:AddSpacer(UIElements.mainGroup,false,0.2)
	
	local ReportDropdownTalents = AceGUI:Create("Dropdown")
    ReportDropdownTalents:SetWidth(160)
	ReportDropdownTalents:SetList(ExtraData.ReportTypeTalents)
	ReportDropdownTalents:SetLabel("Report Type")
	ReportDropdownTalents:SetValue(actualSettings.report_typeTalents)
	ReportDropdownTalents:SetCallback("OnValueChanged", function (this, event, item)
		actualSettings.report_typeTalents=item
    end)
	UIElements.mainGroup:AddChild(ReportDropdownTalents)
	
	local buttonGenerate = AceGUI:Create("Button")
	buttonGenerate:SetText("Generate")
	buttonGenerate:SetRelativeWidth(0.2)
	buttonGenerate:SetCallback("OnClick", function()
		SimPermut:GenerateTalents()
	end)
	UIElements.mainGroup:AddChild(buttonGenerate)
	
	UIElements.mainframe:AddChild(UIElements.mainGroup)
end

-- Field construction for Relic Frame
function SimPermut:BuildRelicFrame()
	--init Artifact
	SimPermut:GetArtifactString()

	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Fill")
	UIElements.mainGroup:SetHeight(600)
    UIElements.mainGroup:SetRelativeWidth(0.65)
	UIElements.mainframe:AddChild(UIElements.mainGroup)
	
	SimPermut:BuildResultFrame(false)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container1)
	
	if not ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID] or #ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID][1] == 0 then
		local labeltitre2= AceGUI:Create("Label")
		labeltitre2:SetText("Class/Spec Not yet implemented")
		labeltitre2:SetFullWidth(true)
		container1:AddChild(labeltitre2)
		do return end
	end
	
	local drawRelic1=false
	local drawRelic2=false
	local drawRelic3=false
	if UIParameters.artifactData.relics[1].type then drawRelic1=true end
	if UIParameters.artifactData.relics[2].type then drawRelic2=true end
	if UIParameters.artifactData.relics[3].type then drawRelic3=true end
	
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Artifact Generator")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local relictype = AceGUI:Create("Dropdown")
	relictype:SetWidth(150)
	relictype:SetList(ExtraData.RelicComparisonType)
	relictype:SetLabel("Relic comparison type")
	relictype:SetValue(UIParameters.relicComparisonTypeValue)
	relictype:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.relicComparisonTypeValue=item
		if UIElements.mainframe:IsVisible() then
			UIElements.mainframe:Release()
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
	
	if UIParameters.relicComparisonTypeValue==1 then
		local labelweaponLvl= AceGUI:Create("Label")
		labelweaponLvl:SetText(itemLevel)
		labelweaponLvl:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE, MONOCHROME")
		labelweaponLvl:SetWidth(50)
		container1:AddChild(labelweaponLvl)
	else
		UIElements.ilvlWeapon= AceGUI:Create("EditBox")
		UIElements.ilvlWeapon:SetWidth(70)
		UIElements.ilvlWeapon:SetMaxLetters(4)
		UIElements.ilvlWeapon:SetText(itemLevel)
		UIElements.ilvlWeapon:SetCallback("OnEnterPressed", function (this, event, item)
			UIElements.ilvlWeapon:SetText(string.match(item, '(%d+)'))
			if UIElements.ilvlWeapon:GetText()~=nil and UIElements.ilvlWeapon:GetText()~=""  then
				if tonumber(UIElements.ilvlWeapon:GetText())<actualSettings.ilvl_RelicMin then
					UIElements.ilvlWeapon:SetText(actualSettings.ilvl_RelicMin)
				elseif tonumber(UIElements.ilvlWeapon:GetText())>actualSettings.ilvl_RelicMax then
					UIElements.ilvlWeapon:SetText(actualSettings.ilvl_RelicMax)
				end
			else
				UIElements.ilvlWeapon:SetText(actualSettings.ilvl_RelicMin)
			end
		end)
		container1:AddChild(UIElements.ilvlWeapon)
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
		relicinfo1:SetText(_G["RELIC_SLOT_TYPE_"..UIParameters.artifactData.relics[1].type:upper()])
		reliccontainer1:AddChild(relicinfo1)
		
		SimPermut:AddSpacer(reliccontainer1,false,0.4)
		_, _, _, itemLevel1, _, _, _, _, _, itemTexture1, _ = GetItemInfo(UIParameters.artifactData.relics[1].link)
		local artifactRelicIcon1=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon1:SetImage(itemTexture1)
		end
		artifactRelicIcon1:SetImageSize(35,35)
		artifactRelicIcon1:SetRelativeWidth(0.2)
		artifactRelicIcon1:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(UIParameters.artifactData.relics[1].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon1:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer1:AddChild(artifactRelicIcon1)
		
		SimPermut:AddSpacer(reliccontainer1,true)
		SimPermut:AddSpacer(reliccontainer1,false,0.1)
		UIElements.DropdownTrait1 = AceGUI:Create("Dropdown")
		UIElements.DropdownTrait1:SetRelativeWidth(0.8)
		UIElements.DropdownTrait1:SetList(ExtraData.ArtifactTableTraits[UIParameters.artifactID][1],ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID][1])
		UIElements.DropdownTrait1:SetLabel("")
		UIElements.DropdownTrait1:SetValue(0)
		reliccontainer1:AddChild(UIElements.DropdownTrait1)
		
		if UIParameters.relicComparisonTypeValue==1 then
			SimPermut:AddSpacer(reliccontainer1,false,0.3)
			UIElements.ilvlTrait1= AceGUI:Create("EditBox")
			UIElements.ilvlTrait1:SetRelativeWidth(0.4)
			UIElements.ilvlTrait1:SetMaxLetters(4)
			UIElements.ilvlTrait1:SetText(itemLevel1)
			UIElements.ilvlTrait1:SetCallback("OnEnterPressed", function (this, event, item)
				UIElements.ilvlTrait1:SetText(string.match(item, '(%d+)'))
				if UIElements.ilvlTrait1:GetText()~=nil and UIElements.ilvlTrait1:GetText()~=""  then
					if tonumber(UIElements.ilvlTrait1:GetText())<actualSettings.ilvl_RelicMin then
						UIElements.ilvlTrait1:SetText(actualSettings.ilvl_RelicMin)
					elseif tonumber(UIElements.ilvlTrait1:GetText())>actualSettings.ilvl_RelicMax then
						UIElements.ilvlTrait1:SetText(actualSettings.ilvl_RelicMax)
					end
				else
					UIElements.ilvlTrait1:SetText(actualSettings.ilvl_RelicMin)
				end
			end)
			reliccontainer1:AddChild(UIElements.ilvlTrait1)
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
		relicinfo2:SetText(_G["RELIC_SLOT_TYPE_"..UIParameters.artifactData.relics[2].type:upper()])
		reliccontainer2:AddChild(relicinfo2)
		
		SimPermut:AddSpacer(reliccontainer2,false,0.4)
		_, _, _, itemLevel2, _, _, _, _, _, itemTexture2, _ = GetItemInfo(UIParameters.artifactData.relics[2].link)
		local artifactRelicIcon2=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon2:SetImage(itemTexture2)
		end
		artifactRelicIcon2:SetImageSize(35,35)
		artifactRelicIcon2:SetRelativeWidth(0.2)
		artifactRelicIcon2:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(UIParameters.artifactData.relics[2].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon2:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer2:AddChild(artifactRelicIcon2)
		
		SimPermut:AddSpacer(reliccontainer2,true)
		SimPermut:AddSpacer(reliccontainer2,false,0.1)
		UIElements.DropdownTrait2 = AceGUI:Create("Dropdown")
		UIElements.DropdownTrait2:SetRelativeWidth(0.8)
		UIElements.DropdownTrait2:SetList(ExtraData.ArtifactTableTraits[UIParameters.artifactID][2],ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID][2])
		UIElements.DropdownTrait2:SetLabel("")
		UIElements.DropdownTrait2:SetValue(0)
		reliccontainer2:AddChild(UIElements.DropdownTrait2)
		
		if UIParameters.relicComparisonTypeValue==1 then
			SimPermut:AddSpacer(reliccontainer2,false,0.3)
			UIElements.ilvlTrait2= AceGUI:Create("EditBox")
			UIElements.ilvlTrait2:SetRelativeWidth(0.4)
			UIElements.ilvlTrait2:SetMaxLetters(4)
			UIElements.ilvlTrait2:SetText(itemLevel2)
			UIElements.ilvlTrait2:SetCallback("OnEnterPressed", function (this, event, item)
				UIElements.ilvlTrait2:SetText(string.match(item, '(%d+)'))
				if UIElements.ilvlTrait2:GetText()~=nil and UIElements.ilvlTrait2:GetText()~="" then
					if tonumber(UIElements.ilvlTrait2:GetText())<actualSettings.ilvl_RelicMin then
						UIElements.ilvlTrait2:SetText(actualSettings.ilvl_RelicMin)
					elseif tonumber(UIElements.ilvlTrait2:GetText())>actualSettings.ilvl_RelicMax then
						UIElements.ilvlTrait2:SetText(actualSettings.ilvl_RelicMax)
					end
				else
					UIElements.ilvlTrait2:SetText(actualSettings.ilvl_RelicMin)
				end
			end)
			reliccontainer2:AddChild(UIElements.ilvlTrait2)
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
		relicinfo3:SetText(_G["RELIC_SLOT_TYPE_"..UIParameters.artifactData.relics[3].type:upper()])
		reliccontainer3:AddChild(relicinfo3)
		
		SimPermut:AddSpacer(reliccontainer3,false,0.4)
		_, _, _, itemLevel3, _, _, _, _, _, itemTexture3, _ = GetItemInfo(UIParameters.artifactData.relics[3].link)
		local artifactRelicIcon3=AceGUI:Create("Icon")
		if itemTexture then
			artifactRelicIcon3:SetImage(itemTexture3)
		end
		artifactRelicIcon3:SetImageSize(35,35)
		artifactRelicIcon3:SetRelativeWidth(0.2)
		artifactRelicIcon3:SetCallback("OnEnter", function(widget)
			GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
			GameTooltip:SetHyperlink(UIParameters.artifactData.relics[3].link)
			GameTooltip:Show()
		end)			
		artifactRelicIcon3:SetCallback("OnLeave", function(widget)
			GameTooltip:Hide()
		end)
		reliccontainer3:AddChild(artifactRelicIcon3)
		
		SimPermut:AddSpacer(reliccontainer3,true)
		SimPermut:AddSpacer(reliccontainer3,false,0.1)
		UIElements.DropdownTrait3 = AceGUI:Create("Dropdown")
		UIElements.DropdownTrait3:SetRelativeWidth(0.8)
		UIElements.DropdownTrait3:SetList(ExtraData.ArtifactTableTraits[UIParameters.artifactID][3],ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID][3])
		UIElements.DropdownTrait3:SetLabel("")
		UIElements.DropdownTrait3:SetValue(0)
		reliccontainer3:AddChild(UIElements.DropdownTrait3)
		
		if UIParameters.relicComparisonTypeValue==1 then
			if not UIParameters.artifactData.relics[3].isLocked then
				SimPermut:AddSpacer(reliccontainer3,false,0.3)
				UIElements.ilvlTrait3= AceGUI:Create("EditBox")
				UIElements.ilvlTrait3:SetRelativeWidth(0.4)
				UIElements.ilvlTrait3:SetMaxLetters(4)
				UIElements.ilvlTrait3:SetText(itemLevel3)
				UIElements.ilvlTrait3:SetCallback("OnEnterPressed", function (this, event, item)
					UIElements.ilvlTrait3:SetText(string.match(item, '(%d+)'))
					if UIElements.ilvlTrait3:GetText()~=nil and UIElements.ilvlTrait3:GetText()~="" then
						if tonumber(UIElements.ilvlTrait3:GetText())<actualSettings.ilvl_RelicMin then
							UIElements.ilvlTrait3:SetText(actualSettings.ilvl_RelicMin)
						elseif tonumber(UIElements.ilvlTrait3:GetText())>actualSettings.ilvl_RelicMax then
							UIElements.ilvlTrait3:SetText(actualSettings.ilvl_RelicMax)
						end
					else
						UIElements.ilvlTrait3:SetText(actualSettings.ilvl_RelicMin)
					end
				end)
				reliccontainer3:AddChild(UIElements.ilvlTrait3)
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
	UIElements.dropdownTableCrucible={}
	local trait={}
	
	if not ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID] or #ExtraData.ArtifactTableTraitsOrder[UIParameters.artifactID][1] == 0 then
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
	for k,v in pairs(ExtraData.NetherlightData[3][UIParameters.artifactID])do
		T3 = math.min(k, T3)
	end
	
	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Fill")
	UIElements.mainGroup:SetHeight(600)
    UIElements.mainGroup:SetRelativeWidth(0.65)
	UIElements.mainframe:AddChild(UIElements.mainGroup)
	
	SimPermut:BuildResultFrame(false)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container1)	
	
	local labeltitre1= AceGUI:Create("Heading")
	labeltitre1:SetText("Netherlight Crucible")
	labeltitre1:SetFullWidth(true)
	container1:AddChild(labeltitre1)
	
	local crucibletypedropdown = AceGUI:Create("Dropdown")
	crucibletypedropdown:SetWidth(200)
	crucibletypedropdown:SetList(ExtraData.CrucibleComparisonType)
	crucibletypedropdown:SetLabel("Comparison type")
	crucibletypedropdown:SetValue(UIParameters.CrucibleComparisonTypeValue)
	crucibletypedropdown:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.CrucibleComparisonTypeValue_old=UIParameters.CrucibleComparisonTypeValue
		UIParameters.CrucibleComparisonTypeValue=item
		--reset count and string
		UIParameters.crucibleString=""
		UIParameters.crucibleCopyCount=1
		if UIElements.mainframe:IsVisible() then
			UIElements.mainframe:Release()
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
	
	if UIParameters.CrucibleComparisonTypeValue==1 or UIParameters.CrucibleComparisonTypeValue==2 then
		if UIParameters.CrucibleComparisonTypeValue==2 then
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
			UIElements.dropdownTableCrucible[1]={}
			UIElements.dropdownTableCrucible[1][2] = AceGUI:Create("Dropdown")
			UIElements.dropdownTableCrucible[1][2]:SetRelativeWidth(0.8)
			UIElements.dropdownTableCrucible[1][2]:SetList(ExtraData.NetherlightData[2])
			UIElements.dropdownTableCrucible[1][2]:SetLabel("")
			UIElements.dropdownTableCrucible[1][2]:SetValue(T2)
			trait[1]=T2
			UIElements.dropdownTableCrucible[1][2]:SetCallback("OnValueChanged", function (this, event, item)
				trait[1]=item
				_, _, spellTextureleft = GetSpellInfo(ExtraData.NetherlightSpellID[item])
				if spellTextureleft then
					crucibleIconleft:SetImage(spellTextureleft)
				end
			end)
			cruciblecontainerleft:AddChild(UIElements.dropdownTableCrucible[1][2])
			
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
			UIElements.dropdownTableCrucible[1][3] = AceGUI:Create("Dropdown")
			UIElements.dropdownTableCrucible[1][3]:SetRelativeWidth(0.8)
			UIElements.dropdownTableCrucible[1][3]:SetList(ExtraData.NetherlightData[3][UIParameters.artifactID])
			UIElements.dropdownTableCrucible[1][3]:SetLabel("")
			UIElements.dropdownTableCrucible[1][3]:SetValue(T3)
			cruciblecontainerleft:AddChild(UIElements.dropdownTableCrucible[1][3])
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
		
		if UIParameters.CrucibleComparisonTypeValue==2 then
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
		UIElements.dropdownTableCrucible[2]={}
		UIElements.dropdownTableCrucible[2][2] = AceGUI:Create("Dropdown")
		UIElements.dropdownTableCrucible[2][2]:SetRelativeWidth(0.8)
		UIElements.dropdownTableCrucible[2][2]:SetList(ExtraData.NetherlightData[2])
		UIElements.dropdownTableCrucible[2][2]:SetLabel("")
		UIElements.dropdownTableCrucible[2][2]:SetValue(T2)
		trait[2]=T2
		UIElements.dropdownTableCrucible[2][2]:SetCallback("OnValueChanged", function (this, event, item)
			trait[2]=item
			_, _, spellTexture = GetSpellInfo(ExtraData.NetherlightSpellID[item])
			if spellTexture then
				crucibleIcon:SetImage(spellTexture)
			end
		end)
		cruciblecontainer:AddChild(UIElements.dropdownTableCrucible[2][2])
		
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
		UIElements.dropdownTableCrucible[2][3] = AceGUI:Create("Dropdown")
		UIElements.dropdownTableCrucible[2][3]:SetRelativeWidth(0.8)
		UIElements.dropdownTableCrucible[2][3]:SetList(ExtraData.NetherlightData[3][UIParameters.artifactID])
		UIElements.dropdownTableCrucible[2][3]:SetLabel("")
		UIElements.dropdownTableCrucible[2][3]:SetValue(T3)
		cruciblecontainer:AddChild(UIElements.dropdownTableCrucible[2][3])
		
		if UIParameters.CrucibleComparisonTypeValue==2 then
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
			UIElements.dropdownTableCrucible[3]={}
			UIElements.dropdownTableCrucible[3][2] = AceGUI:Create("Dropdown")
			UIElements.dropdownTableCrucible[3][2]:SetRelativeWidth(0.8)
			UIElements.dropdownTableCrucible[3][2]:SetList(ExtraData.NetherlightData[2])
			UIElements.dropdownTableCrucible[3][2]:SetLabel("")
			UIElements.dropdownTableCrucible[3][2]:SetValue(T2)
			trait[3]=T2
			UIElements.dropdownTableCrucible[3][2]:SetCallback("OnValueChanged", function (this, event, item)
				trait[3]=item
				_, _, spellTextureright = GetSpellInfo(ExtraData.NetherlightSpellID[item])
				if spellTextureright then
					crucibleIconright:SetImage(spellTextureright)
				end
			end)
			cruciblecontainerright:AddChild(UIElements.dropdownTableCrucible[3][2])
			
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
			UIElements.dropdownTableCrucible[3][3] = AceGUI:Create("Dropdown")
			UIElements.dropdownTableCrucible[3][3]:SetRelativeWidth(0.8)
			UIElements.dropdownTableCrucible[3][3]:SetList(ExtraData.NetherlightData[3][UIParameters.artifactID])
			UIElements.dropdownTableCrucible[3][3]:SetLabel("")
			UIElements.dropdownTableCrucible[3][3]:SetValue(T3)
			cruciblecontainerright:AddChild(UIElements.dropdownTableCrucible[3][3])
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
	else --Shown tree
		if not ArtifactRelicForgeUI.IsAtForge() then
			print("Netherlight crucible must be open")
			UIParameters.CrucibleComparisonTypeValue=UIParameters.CrucibleComparisonTypeValue_old
			if UIElements.mainframe:IsVisible() then
				UIElements.mainframe:Release()
			end
			SimPermut:BuildFrame()
		else
			local currentTree = PersoLib:ExtractCurrentCrucibleTree()
			
			local containerPermuteNC = AceGUI:Create("SimpleGroup")
			containerPermuteNC:SetFullWidth(true)
			containerPermuteNC:SetLayout("Flow")
			container1:AddChild(containerPermuteNC)
			
			local buttonRefresh = AceGUI:Create("Button")
			buttonRefresh:SetText("Refresh current relic")
			buttonRefresh:SetRelativeWidth(0.2)
			buttonRefresh:SetCallback("OnClick", function()
				if UIElements.mainframe:IsVisible() then
					UIElements.mainframe:Release()
				end
				SimPermut:BuildFrame()
			end)
			containerPermuteNC:AddChild(buttonRefresh)
			
			local relicinfo11= AceGUI:Create("Label")
			relicinfo11:SetFullWidth(true)
			relicinfo11:SetText("Current Relic : "..PersoLib:GetNameFromTraitID(currentTree[2][1],UIParameters.artifactID).." - "..PersoLib:GetNameFromTraitID(currentTree[2][2],UIParameters.artifactID).." / "..PersoLib:GetNameFromTraitID(currentTree[3][1],UIParameters.artifactID).." - "..PersoLib:GetNameFromTraitID(currentTree[3][2],UIParameters.artifactID).." - "..PersoLib:GetNameFromTraitID(currentTree[3][3],UIParameters.artifactID))
			containerPermuteNC:AddChild(relicinfo11)
			
			SimPermut:AddSpacer(containerPermuteNC,true)
			if _G.ArtifactRelicForgeFrame.relicSlot and _G.ArtifactRelicForgeFrame.relicSlot <=3 then --not possible if preview
				local checkBoxkeepBase = AceGUI:Create("CheckBox")
				checkBoxkeepBase:SetFullWidth(true)
				checkBoxkeepBase:SetLabel("Keep other relic crucible from base")
				checkBoxkeepBase:SetValue(actualSettings.NCKeepBase)
				checkBoxkeepBase:SetCallback("OnValueChanged", function (this, event, item)
					SimPermutVars.NCKeepBase=checkBoxkeepBase:GetValue()
					PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
				end)
				containerPermuteNC:AddChild(checkBoxkeepBase)
			else
				local PreviewTypeDropdownCruciblegen = AceGUI:Create("Dropdown")
				PreviewTypeDropdownCruciblegen:SetWidth(160)
				PreviewTypeDropdownCruciblegen:SetList(ExtraData.CrucibleExtractPreviewType)
				PreviewTypeDropdownCruciblegen:SetLabel("Export type for preview")
				PreviewTypeDropdownCruciblegen:SetValue(actualSettings.NCPreviewType)
				PreviewTypeDropdownCruciblegen:SetCallback("OnValueChanged", function (this, event, item)
					SimPermutVars.NCPreviewType=item
					PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
					if UIElements.mainframe:IsVisible() then
						UIElements.mainframe:Release()
					end
					SimPermut:BuildFrame()
				end)
				containerPermuteNC:AddChild(PreviewTypeDropdownCruciblegen)
				
				if SimPermutVars.NCPreviewType > 0 then
					SimPermut:AddSpacer(containerPermuteNC,true)
					local checkBoxreplacePreview = AceGUI:Create("CheckBox")
					checkBoxreplacePreview:SetFullWidth(true)
					checkBoxreplacePreview:SetLabel("Replace Relic trait")
					checkBoxreplacePreview:SetValue(actualSettings.NCPreviewReplace)
					checkBoxreplacePreview:SetCallback("OnValueChanged", function (this, event, item)
						SimPermutVars.NCPreviewReplace=checkBoxreplacePreview:GetValue()
						PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
					end)
					containerPermuteNC:AddChild(checkBoxreplacePreview)
				end
			end
			
			SimPermut:AddSpacer(containerPermuteNC,true)
			local ReportDropdownCruciblegen = AceGUI:Create("Dropdown")
			ReportDropdownCruciblegen:SetWidth(160)
			ReportDropdownCruciblegen:SetList(ExtraData.ReportTypeCrucible)
			ReportDropdownCruciblegen:SetLabel("Report Type")
			ReportDropdownCruciblegen:SetValue(actualSettings.report_typeCrucible)
			ReportDropdownCruciblegen:SetCallback("OnValueChanged", function (this, event, item)
				SimPermutVars.report_typeCrucible=item
				PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
			end)
			containerPermuteNC:AddChild(ReportDropdownCruciblegen)
			
			local buttonGenerate = AceGUI:Create("Button")
			buttonGenerate:SetText("Generate")
			buttonGenerate:SetRelativeWidth(0.2)
			buttonGenerate:SetCallback("OnClick", function()
				SimPermut:GenerateCruciblePermutation(currentTree)
			end)
			containerPermuteNC:AddChild(buttonGenerate)
		end
	end

end

-- Field construction for Dungeon Journal Frame
function SimPermut:BuildDungeonJournalFrame()
	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Flow")
    UIElements.mainGroup:SetRelativeWidth(1)
	UIElements.mainframe:AddChild(UIElements.mainGroup)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(100)
	container1:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container1)
	
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
	UIElements.mainGroup:AddChild(scrollcontainer1)
	
	UIElements.scroll1 = AceGUI:Create("ScrollFrame")
	UIElements.scroll1:SetLayout("Flow")
	scrollcontainer1:AddChild(UIElements.scroll1)
	
	local scrollcontainer2 = AceGUI:Create("SimpleGroup")
	scrollcontainer2:SetRelativeWidth(0.5)
	scrollcontainer2:SetHeight(600)
	scrollcontainer2:SetLayout("Fill")
	UIElements.mainGroup:AddChild(scrollcontainer2)
	
	UIElements.scroll2 = AceGUI:Create("ScrollFrame")
	UIElements.scroll2:SetLayout("Flow")
	scrollcontainer2:AddChild(UIElements.scroll2)
	
	local socketString=""
	local ilvlString=""
	for j=1,#ExtraData.ListNames do
		UIElements.tableTitres[j]=AceGUI:Create("Label")
		UIElements.tableTitres[j]:SetText(PersoLib:firstToUpper(ExtraData.ListNames[j]))
		UIElements.tableTitres[j]:SetFullWidth(true)
		if(j<7) then
			UIElements.scroll1:AddChild(UIElements.tableTitres[j])
		else
			UIElements.scroll2:AddChild(UIElements.tableTitres[j])
		end
		
		UIElements.tableCheckBoxes[j]={}
		UIElements.tableLabel[j]={}
		if SimPermutVars.addedItemsTable and SimPermutVars.addedItemsTable[j] then
			for i,_ in pairs(SimPermutVars.addedItemsTable[j]) do
				UIElements.tableCheckBoxes[j][i]=AceGUI:Create("CheckBox")
				UIElements.tableCheckBoxes[j][i]:SetLabel("")
				UIElements.tableCheckBoxes[j][i]:SetRelativeWidth(0.05)
				UIElements.tableCheckBoxes[j][i]:SetValue(false)
				if j<7 then
					UIElements.scroll1:AddChild(UIElements.tableCheckBoxes[j][i])
				else
					UIElements.scroll2:AddChild(UIElements.tableCheckBoxes[j][i])
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
				
				UIElements.tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
				UIElements.tableLabel[j][i]:SetText(SimPermutVars.addedItemsTable[j][i][1]..ilvlString..socketString)
				UIElements.tableLabel[j][i]:SetRelativeWidth(0.95)
				UIElements.tableLabel[j][i]:SetCallback("OnEnter", function(widget)
					GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
					GameTooltip:SetHyperlink(SimPermutVars.addedItemsTable[j][i][1])
					GameTooltip:Show()
				end)
				UIElements.tableLabel[j][i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
				
				if(j<7) then
					UIElements.scroll1:AddChild(UIElements.tableLabel[j][i])
				else
					UIElements.scroll2:AddChild(UIElements.tableLabel[j][i])
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
					if UIElements.tableCheckBoxes[j][i]:GetValue() then
						SimPermutVars.addedItemsTable[j][i]=nil
					end
				end
			end
		end
		SimPermut:BuildFrame()
	end)
	UIElements.mainGroup:AddChild(buttonAdd)
end

-- Field construction for option Frame
function SimPermut:BuildOptionFrame()
	UIElements.mainGroup = AceGUI:Create("SimpleGroup")
    UIElements.mainGroup:SetLayout("Fill")
    UIElements.mainGroup:SetRelativeWidth(1)
	
	local container1 = AceGUI:Create("SimpleGroup")
	container1:SetFullWidth(true)
	container1:SetHeight(600)
	container1:SetLayout("Flow")
	UIElements.mainGroup:AddChild(container1)
	
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
	ilvlMin:SetMaxLetters(4)
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
	ilvlMax:SetMaxLetters(4)
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
	ilvlMinRelic:SetMaxLetters(4)
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
	ilvlMaxRelic:SetMaxLetters(4)
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
		SimPermut:BuildFrame()
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
	
	UIElements.checkBoxForce = AceGUI:Create("CheckBox")
	UIElements.checkBoxForce:SetWidth(250)
	UIElements.checkBoxForce:SetLabel("Replace current enchant/gems")
	UIElements.checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.replaceEnchants=UIElements.checkBoxForce:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(UIElements.checkBoxForce)
	
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
	
	UIElements.mainframe:AddChild(UIElements.mainGroup)
end

-- Field construction for right Panel
function SimPermut:BuildResultFrame(autoSimcExportVisible)
	UIElements.resultGroup = AceGUI:Create("SimpleGroup")
    UIElements.resultGroup:SetLayout("Flow")
    UIElements.resultGroup:SetRelativeWidth(0.35)
	
	local scrollcontainer3 = AceGUI:Create("SimpleGroup")
	scrollcontainer3:SetRelativeWidth(1)
	if actualSettings.smallUI then
		scrollcontainer3:SetHeight(560)
	else
		scrollcontainer3:SetHeight(600)
	end
	scrollcontainer3:SetLayout("Fill")
	UIElements.resultGroup:AddChild(scrollcontainer3)
	
	UIElements.resultBox= AceGUI:Create("MultiLineEditBox")
	UIElements.resultBox:SetText("")
	UIElements.resultBox:SetLabel("")
	UIElements.resultBox:DisableButton(true)
	UIElements.resultBox:SetRelativeWidth(1)
	scrollcontainer3:AddChild(UIElements.resultBox)
	
	if autoSimcExportVisible then
		SimPermut:AddSpacer(UIElements.resultGroup,false,0.7)
		
		local buttonGenerateRaw = AceGUI:Create("Button")
		buttonGenerateRaw:SetText("AutoSimc Export")
		buttonGenerateRaw:SetRelativeWidth(0.3)
		buttonGenerateRaw:SetCallback("OnClick", function()
			SimPermut:GenerateRaw()
		end)
		UIElements.resultGroup:AddChild(buttonGenerateRaw)
	end
	
	UIElements.mainframe:AddChild(UIElements.resultGroup)
end

-- Init the frame for the first time
function SimPermut:InitGearFrame()
	UIElements.tableTitres={}
	UIElements.tableLabel={}
	UIElements.tableCheckBoxes={}
	UIElements.tableLinkPermut={}
	
	--init with default parameters
	UIParameters.actualEnchantNeck=actualSettings.enchant_neck
	UIParameters.actualEnchantFinger=actualSettings.enchant_ring
	UIParameters.actualEnchantBack=actualSettings.enchant_back
	UIParameters.actualGem=actualSettings.gems
	UIParameters.actualForce=actualSettings.replaceEnchants
	UIParameters.actualSetsT19=actualSettings.setsT19
	UIParameters.actualSetsT20=actualSettings.setsT20
	UIParameters.actualSetsT21=actualSettings.setsT21
	
	_,UIElements.tableBaseLink=SimPermut:GetBaseString()
	
	UIElements.editLegMin:SetText(UIParameters.equipedLegendaries)
	
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
		UIElements.tableTitres[j]=AceGUI:Create("Label")
		UIElements.tableTitres[j]:SetText(PersoLib:firstToUpper(ExtraData.ListNames[j]))
		UIElements.tableTitres[j]:SetFullWidth(true)
		if(j<7) then
			UIElements.scroll1:AddChild(UIElements.tableTitres[j])
		else
			UIElements.scroll2:AddChild(UIElements.tableTitres[j])
		end
		
		UIElements.tableCheckBoxes[j]={}
		UIElements.tableLabel[j]={}
		for i=1 ,#UIElements.tableListItems[j] do
			UIElements.tableCheckBoxes[j][i]=AceGUI:Create("CheckBox")
			UIElements.tableCheckBoxes[j][i]:SetLabel("")
			UIElements.tableCheckBoxes[j][i]:SetRelativeWidth(0.05)
			if SimPermut:isEquiped(UIElements.tableListItems[j][i][1],j) or UIElements.tablePreCheck[j] then
				UIElements.tableCheckBoxes[j][i]:SetValue(true)
			else
				UIElements.tableCheckBoxes[j][i]:SetValue(false)
			end
			UIElements.tableCheckBoxes[j][i]:SetCallback("OnValueChanged", function(this, event, item)
				if UIElements.tableCheckBoxes[j][i]:GetValue() then
					UIParameters.selecteditems=UIParameters.selecteditems+1
				else
					UIParameters.selecteditems=UIParameters.selecteditems-1
				end
				SimPermut:CheckItemCount()
			end)
			UIParameters.selecteditems=UIParameters.selecteditems+1
			if j<7 then
				UIElements.scroll1:AddChild(UIElements.tableCheckBoxes[j][i])
			else
				UIElements.scroll2:AddChild(UIElements.tableCheckBoxes[j][i])
			end
			
			if UIElements.tableListItems[j][i][2] then 
				ilvlString=" "..UIElements.tableListItems[j][i][2] 
			else
				ilvlString=""
			end
			if UIElements.tableListItems[j][i][3] then 
				socketString="+S" 
			else
				socketString="" 
			end
			
			UIElements.tableLabel[j][i]=AceGUI:Create("InteractiveLabel")
			UIElements.tableLabel[j][i]:SetText(UIElements.tableListItems[j][i][1]..ilvlString..socketString)
			UIElements.tableLabel[j][i]:SetRelativeWidth(0.95)
			UIElements.tableLabel[j][i]:SetCallback("OnEnter", function(widget)
				GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMLEFT")
				GameTooltip:SetHyperlink(UIElements.tableListItems[j][i][1])
				GameTooltip:Show()
			end)
			UIElements.tableLabel[j][i]:SetCallback("OnLeave", function() GameTooltip:Hide()  end)
			
			if (j>=11 and UIParameters.ad) then
				PersoLib:debugPrint(ExtraData.ListNames[j]..i.." : "..PersoLib:GetIDFromLink(UIElements.tableListItems[j][i][1]),UIParameters.ad)
			end
			
			if(j<7) then
				UIElements.scroll1:AddChild(UIElements.tableLabel[j][i])
			else
				UIElements.scroll2:AddChild(UIElements.tableLabel[j][i])
			end
		end
	end
end

-- clic btn generate
function SimPermut:Generate()

	local permutString=""
	local baseString=""
	local finalString=""
	local permuttable={}
	if SimPermut:GetTableLink() then
		PersoLib:debugPrint("--------------------",UIParameters.ad)
		PersoLib:debugPrint("Generating Gear string...",UIParameters.ad)
		SimPermut:GetSelectedCount()
		baseString,UIElements.tableBaseLink=SimPermut:GetBaseString()
		permuttable=SimPermut:GetAllPermutations()
		SimPermut:PreparePermutations(permuttable)
		permutString=SimPermut:GetPermutationString(permuttable)
		finalString=SimPermut:GetFinalString(baseString,permutString)
		SimPermut:PrintPermut(finalString)
		PersoLib:debugPrint("End of generation",UIParameters.ad)
		PersoLib:debugPrint("--------------------",UIParameters.ad)
	else --error
		UIElements.mainframe:SetStatusText(UIParameters.errorMessage)
	end
end

-- clic btn generate raw
function SimPermut:GenerateRaw()
	UIElements.mainframe:SetStatusText("")
	
	local itemList=""
	local baseString=""
	local finalString=""
	local AutoSimcString=""
	
	if SimPermut:GetTableLink() then
		PersoLib:debugPrint("--------------------",UIParameters.ad)
		PersoLib:debugPrint("Generating string...",UIParameters.ad)
		baseString,UIElements.tableBaseLink=SimPermut:GetBaseString()
		AutoSimcString=SimPermut:GetAutoSimcString()
		itemList=SimPermut:GetItemListString()
		finalString=SimPermut:GetFinalString(AutoSimcString,itemList)
		SimPermut:PrintPermut(finalString)
		PersoLib:debugPrint("End of generation",UIParameters.ad)
		PersoLib:debugPrint("--------------------",UIParameters.ad)
	end
end

-- clic btn generate Talent
function SimPermut:GenerateTalents()
	local permutString=""
	local baseString=""
	local finalString=""
	UIElements.tableTalentResults={}
	
	PersoLib:debugPrint("--------------------",UIParameters.ad)
	PersoLib:debugPrint("Generating Talent String...",UIParameters.ad)
	SimPermut:GenerateTalentsRecursive(1,"")
	baseString=SimPermut:GetBaseString()
	permutString=SimPermut:GenerateTalentString()
	finalString=SimPermut:GetFinalString(baseString,permutString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",UIParameters.ad)
	PersoLib:debugPrint("--------------------",UIParameters.ad)
end

-- clic btn generate Relic
function SimPermut:GenerateRelic()
	local permutString=""
	local baseString=""
	local finalString=""

	PersoLib:debugPrint("--------------------",UIParameters.ad)
	PersoLib:debugPrint("Generating Relic String...",UIParameters.ad)
	baseString=SimPermut:GetBaseString(true)
	permutString=SimPermut:GenerateRelicString()
	UIParameters.relicString=UIParameters.relicString.."\n"..permutString
	finalString=SimPermut:GetFinalString(baseString,UIParameters.relicString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",UIParameters.ad)
	PersoLib:debugPrint("--------------------",UIParameters.ad)
end

-- clic btn generate Crucible
function SimPermut:GenerateCrucible()
	local permutString=""
	local baseString=""
	local finalString=""

	PersoLib:debugPrint("--------------------",UIParameters.ad)
	PersoLib:debugPrint("Generating crucible String...",UIParameters.ad)
	baseString=SimPermut:GetBaseString()
	permutString=SimPermut:GenerateCrucibleString()
	UIParameters.crucibleString=UIParameters.crucibleString.."\n"..permutString
	finalString=SimPermut:GetFinalString(baseString,UIParameters.crucibleString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",UIParameters.ad)
	PersoLib:debugPrint("--------------------",UIParameters.ad)
end

-- clic btn generate Crucible with permutation
function SimPermut:GenerateCruciblePermutation(currentTree)
	local permutString=""
	local baseString=""
	local finalString=""
	local permuttable={}

	PersoLib:debugPrint("--------------------",UIParameters.ad)
	PersoLib:debugPrint("Generating crucible String with permutation...",UIParameters.ad)
	baseString=SimPermut:GetBaseString()
	UIElements.tableCrucibleResults={}
	SimPermut:GenerateCrucibleRecursive(currentTree,1,"")
	permuttable=UIElements.tableCrucibleResults
	permutString=SimPermut:GenerateCruciblePermutationStrings(permuttable,currentTree)
	finalString=SimPermut:GetFinalString(baseString,permutString)
	SimPermut:PrintPermut(finalString)
	PersoLib:debugPrint("End of generation",UIParameters.ad)
	PersoLib:debugPrint("--------------------",UIParameters.ad)
end

-- clic btn generate Talent recursion
function SimPermut:GenerateTalentsRecursive(stacks,str)
	local newstacks=stacks
	local newstr=str
	if newstacks > UIParameters.TALENTS_MAX_ROW then
		UIElements.tableTalentResults[#UIElements.tableTalentResults+1]=newstr
	else
		if UIElements.tableTalentcheckbox[newstacks][1]:GetValue()==false and UIElements.tableTalentcheckbox[newstacks][2]:GetValue()==false and UIElements.tableTalentcheckbox[newstacks][3]:GetValue()==false then
			newstr=newstr.."0"
			SimPermut:GenerateTalentsRecursive(newstacks+1,newstr)
		else
			for i=1,UIParameters.TALENTS_MAX_COLUMN do
				if UIElements.tableTalentcheckbox[newstacks][i]:GetValue() then
					newstr=str..""..i
					SimPermut:GenerateTalentsRecursive(newstacks+1,newstr)
				end
			end
		end
	end
end

-- clic btn generate Talent recursion
function SimPermut:GenerateCrucibleRecursive(currentTree,stacks,str)
	local newstacks=stacks
	local newstr=str
	if newstacks > 3 then
		UIElements.tableCrucibleResults[#UIElements.tableCrucibleResults+1]=str
	else
		for i=1,3 do
			if currentTree[stacks][i] and not ((tonumber(string.sub(str,2))==1 and i==3) or (tonumber(string.sub(str,2))==2 and i==1)) then
				
				newstr=str..""..i
				SimPermut:GenerateCrucibleRecursive(currentTree,newstacks+1,newstr)
			end
		end
	end
end

-- Get the count of selected items
function SimPermut:GetSelectedCount()
	UIParameters.selecteditems = 0
	UIElements.tableNumberSelected={}
	for i=1,#ExtraData.ListNames do
		UIElements.tableNumberSelected[i]=0
		for j=1,#UIElements.tableListItems[i] do
			if UIElements.tableCheckBoxes[i][j]:GetValue() then
				UIParameters.selecteditems=UIParameters.selecteditems+1
				UIElements.tableNumberSelected[i]=UIElements.tableNumberSelected[i]+1
			end
		end
	end
	
	SimPermut:CheckItemCount()
end

-- Check if item count is not too high
function SimPermut:CheckItemCount()
	if UIParameters.selecteditems >= UIParameters.ITEM_COUNT_THRESHOLD then
		UIParameters.labelCount:SetText("     Warning : Too many items selected ("..UIParameters.selecteditems.."). Consider using AutoSimC Export")
	else
		UIParameters.labelCount:SetText("     ".. UIParameters.selecteditems.. " items selected")
	end
end

-- draw the frame and print the text
function SimPermut:PrintPermut(finalString)
	UIElements.resultBox:SetText(finalString)
	UIElements.resultBox:HighlightText()
	UIElements.resultBox:SetFocus()
end

-- manage spacers
function SimPermut:AddSpacer(targetFrame,full,width,height)
	UIElements.spacerTable[#UIElements.spacerTable+1] = AceGUI:Create("Label")
	if full then
		UIElements.spacerTable[#UIElements.spacerTable]:SetFullWidth(true)
	else
		if width<=1 then
			UIElements.spacerTable[#UIElements.spacerTable]:SetRelativeWidth(width)
		else
			UIElements.spacerTable[#UIElements.spacerTable]:SetWidth(width)
		end
	end
	if height then
		UIElements.spacerTable[#UIElements.spacerTable]:SetHeight(height)
	end
	targetFrame:AddChild(UIElements.spacerTable[#UIElements.spacerTable])
end

----------------------------
-- Permutation Management --
----------------------------
-- get item string
function SimPermut:GetItemString(itemLink,itemType,base,forceilvl,forcegem,relicOverrideLink,relicOverrideSlot)
	--itemLink 	: link of the item
	--itemType 	: item slot
	--base 		: true if item from equiped gear, false from inventory

	local itemSplit = PersoLib:LinkSplit(itemLink)
	local simcItemOptions = {}	
	local enchantID=""
	
	-- Item id
	local itemId = tonumber(itemSplit[UIParameters.OFFSET_ITEM_ID])
	simcItemOptions[#simcItemOptions + 1] = ',id=' .. itemId
	
	-- Enchant
	if base and not SimPermutVars.replaceEnchantsBase then 
		if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
			enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
		end
	else
		if itemType=="neck" then
			if UIParameters.actualEnchantNeck == 999999 then
				enchantID=""
			elseif (UIParameters.actualForce or (base and SimPermutVars.replaceEnchantsBase)) and UIParameters.actualEnchantNeck~=0 then
				enchantID=UIParameters.actualEnchantNeck
			else	
				if UIParameters.actualEnchantNeck==0 or tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
					end
				else
					enchantID=UIParameters.actualEnchantNeck
				end
			end
		elseif itemType=="back" then
			if UIParameters.actualEnchantBack == 999999 then
				enchantID=""
			elseif (UIParameters.actualForce or (base and SimPermutVars.replaceEnchantsBase))  and UIParameters.actualEnchantBack~=0 then
				enchantID=UIParameters.actualEnchantBack
			else
				if UIParameters.actualEnchantBack==0 or tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
					end
				else
					enchantID=UIParameters.actualEnchantBack
				end
			end
		elseif string.match(itemType, 'finger*') then
			if UIParameters.actualEnchantFinger == 999999 then
				enchantID=""
			elseif (UIParameters.actualForce or (base and SimPermutVars.replaceEnchantsBase))  and UIParameters.actualEnchantFinger~=0 then
				enchantID=UIParameters.actualEnchantFinger
			else
				if UIParameters.actualEnchantFinger==0 or tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
					end
				else
					enchantID=UIParameters.actualEnchantFinger
				end
			end
		else
			if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
				enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
			end
		end	
	end
	
	if enchantID and enchantID ~= "" then
		simcItemOptions[#simcItemOptions + 1] = 'enchant_id=' .. enchantID
	end

	-- New style item suffix, old suffix style not supported
	if tonumber(itemSplit[UIParameters.OFFSET_SUFFIX_ID]) ~= 0 then
		simcItemOptions[#simcItemOptions + 1] = 'suffix=' .. itemSplit[UIParameters.OFFSET_SUFFIX_ID]
	end

	local flags = tonumber(itemSplit[UIParameters.OFFSET_FLAGS])

	local bonuses = {}

	for index=1, tonumber(itemSplit[UIParameters.OFFSET_BONUS_ID]) do
		bonuses[#bonuses + 1] = itemSplit[UIParameters.OFFSET_BONUS_ID + index]
	end

	if #bonuses > 0 then
		simcItemOptions[#simcItemOptions + 1] = 'bonus_id=' .. table.concat(bonuses, '/')
	end

	local rest_offset = UIParameters.OFFSET_BONUS_ID + #bonuses + 1


	-- Artifacts use this
	if bit.band(flags, 256) == 256 then
		local relicNb = 0
		rest_offset = rest_offset + 1 -- An unknown field
		local n_bonus_ids = tonumber(itemSplit[rest_offset])
		if n_bonus_ids==1 then --unlocked traits field
			rest_offset = rest_offset + 1 
		end
		local relic_str = ''
		while rest_offset < #itemSplit do
			relicNb = relicNb + 1
			n_bonus_ids = tonumber(itemSplit[rest_offset])
			rest_offset = rest_offset + 1
			
			if relicOverrideSlot and relicOverrideSlot==relicNb then
				local split = PersoLib:LinkSplit(relicOverrideLink)
				relic_str = relic_str .. split[14] .. ':' ..split[15] .. ':' ..split[16]
				rest_offset = rest_offset + 3
				if rest_offset < #itemSplit then
					relic_str = relic_str .. '/'
				end
			else
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
		end

		if relic_str ~= '' then
      simcItemOptions[#simcItemOptions + 1] = 'relic_id=' .. relic_str
		end
  end

	-- Gems
	if itemType=="main_hand" or itemType=="off_hand" then --exception for relics
		local gems = {}
		for i=1, 4 do -- hardcoded here to just grab all 4 sockets
			if relicOverrideSlot and relicOverrideSlot==i then
				if relicOverrideLink then
					local gemDetail = string.match(relicOverrideLink, "item[%-?%d:]+")
					gems[#gems + 1] = string.match(gemDetail, "item:(%d+):" )
				end
			else
				local _,gemLink = GetItemGem(itemLink, i)
				if gemLink then
					local gemDetail = string.match(gemLink, "item[%-?%d:]+")
					gems[#gems + 1] = string.match(gemDetail, "item:(%d+):" )
				elseif flags == 256 then
					gems[#gems + 1] = "0"
				end
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
			if tonumber(itemSplit[UIParameters.OFFSET_GEM_ID_1]) ~= 0 then
				gemstring='gem_id='
				if (itemSplit[UIParameters.OFFSET_GEM_ID_1]~=0) then 
					gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_1]
					if (itemSplit[UIParameters.OFFSET_GEM_ID_2]~=0) then 
						gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_2]
						if (itemSplit[UIParameters.OFFSET_GEM_ID_3]~=0) then 
							gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_3]
							if (itemSplit[UIParameters.OFFSET_GEM_ID_4]~=0) then 
								gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_4]
							end
						end
					end
				end
				simcItemOptions[#simcItemOptions + 1] = gemstring
			end
		else
			if UIParameters.actualGem == 999999 then
			elseif (UIParameters.actualForce or forcegem or (base and SimPermutVars.replaceEnchantsBase)) and UIParameters.actualGem~=0 then
				if UIParameters.actualGem and UIParameters.actualGem~=0 and (hasSocket>0 or tonumber(itemSplit[UIParameters.OFFSET_GEM_ID_1]) ~= 0) then
					gemstring='gem_id='
					for i=1,hasSocket do
						if i>1 then 
							gemstring=gemstring.."/"
						end
						if actualSettings.gemsEpic>0 and not UIParameters.epicGemUsed then
							gemstring=gemstring..actualSettings.gemsEpic
							UIParameters.epicGemUsed=true
						else
							gemstring=gemstring..UIParameters.actualGem
						end
					end
					simcItemOptions[#simcItemOptions + 1] = gemstring
				end
			else
				if tonumber(itemSplit[UIParameters.OFFSET_GEM_ID_1]) ~= 0 then
					gemstring='gem_id='
					if (itemSplit[UIParameters.OFFSET_GEM_ID_1]~=0) then 
						gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_1]
						if (itemSplit[UIParameters.OFFSET_GEM_ID_2]~=0) then 
							gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_2]
							if (itemSplit[UIParameters.OFFSET_GEM_ID_3]~=0) then 
								gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_3]
								if (itemSplit[UIParameters.OFFSET_GEM_ID_4]~=0) then 
									gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_4]
								end
							end
						end
					end
					simcItemOptions[#simcItemOptions + 1] = gemstring
				else
					if UIParameters.actualGem and UIParameters.actualGem~=0 and hasSocket>0 then
						gemstring='gem_id='
						for i=1,hasSocket do
							if i>1 then 
								gemstring=gemstring.."/"
							end
							if actualSettings.gemsEpic>0 and not UIParameters.epicGemUsed then
							gemstring=gemstring..actualSettings.gemsEpic
							UIParameters.epicGemUsed=true
						else
							gemstring=gemstring..UIParameters.actualGem
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
	UIParameters.epicGemUsed=false
	
	UIParameters.equipedLegendaries = 0

	for slotNum=1, #ExtraData.PermutSlotNames do
		slotId = GetInventorySlotInfo(ExtraData.PermutSlotNames[slotNum])
		itemLink = GetInventoryItemLink('player', slotId) 

		-- if we don't have an item link, we don't care
		if itemLink then
			local _,_,itemRarity = GetItemInfo(itemLink)
			if itemRarity == 5 and PersoLib:GetIDFromLink(itemLink) ~= 154172 then
				UIParameters.equipedLegendaries = UIParameters.equipedLegendaries + 1
			end
			itemString = SimPermut:GetItemString(itemLink,ExtraData.PermutSimcNames[slotNum],true)
			UIElements.tableBaseString[slotNum] = table.concat(itemString, ',')
			itemsLinks[slotNum] = itemLink
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
		UIElements.tableListItems[i]={}
		UIElements.tableListItems[i]=SimPermut:GetListItem(ExtraData.ListNames[i],i)
		
		--added items
		if SimPermutVars.addedItemsTable and SimPermutVars.addedItemsTable[i] then
			for j,_ in pairs(SimPermutVars.addedItemsTable[i]) do
				table.insert(UIElements.tableListItems[i],SimPermutVars.addedItemsTable[i][j])
			end
		end
	end
end

-- generates tablelink to be ready for permuts
function SimPermut:GetTableLink()
	local returnvalue=true
	local slotid
	for i=1,#ExtraData.ListNames do
		UIElements.tableLinkPermut[i]={}
		if UIElements.tableListItems[i] and #UIElements.tableListItems[i]>0 then
			for j=1,#UIElements.tableListItems[i] do
				if UIElements.tableCheckBoxes[i][j]:GetValue() then
					UIElements.tableLinkPermut[i][#UIElements.tableLinkPermut[i] + 1] = {UIElements.tableListItems[i][j][1],UIElements.tableListItems[i][j][2],UIElements.tableListItems[i][j][3]}
				end
			end
		end
		
		--if we have no items, we take the equiped one. exception for finger and trinket
		if #UIElements.tableLinkPermut[i] == 0 and i<11 then
			if(i>=6) then
				slotid=i+2
			else
				slotid=i
			end
			UIElements.tableLinkPermut[i][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[slotid])),nil,nil}
		end
			
	end
	
	--manage fingers and trinkets
	if #UIElements.tableLinkPermut[12]==0 then --if no trinket chosen, we take the equiped ones
		UIElements.tableLinkPermut[13]={}
		UIElements.tableLinkPermut[13][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[15])),nil,nil}
		UIElements.tableLinkPermut[14]={}
		UIElements.tableLinkPermut[14][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[16])),nil,nil}
	else --else we copy the selected ones on the second slot and reposition the slot in the good position
		if #UIElements.tableLinkPermut[12]==1 then
			UIParameters.errorMessage="Can't permut with only one trinket"
			returnvalue=false
		elseif #UIElements.tableLinkPermut[12]==2 then
			UIElements.tableLinkPermut[13]={}
			UIElements.tableLinkPermut[13][1]=UIElements.tableLinkPermut[12][1]
			UIElements.tableLinkPermut[14]={}
			UIElements.tableLinkPermut[14][1]=UIElements.tableLinkPermut[12][2]
			UIElements.tableLinkPermut[12]={}
		else
			UIElements.tableLinkPermut[13]=UIElements.tableLinkPermut[12]
			UIElements.tableLinkPermut[14]=UIElements.tableLinkPermut[13]
			UIElements.tableLinkPermut[12]={}
		end
	end
	
	if #UIElements.tableLinkPermut[11]==0 then --if no finger chosen, we take the equiped ones
		UIElements.tableLinkPermut[11][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[13])),nil,nil}
		UIElements.tableLinkPermut[12][1]={GetInventoryItemLink('player', GetInventorySlotInfo(ExtraData.SlotNames[14])),nil,nil}
	else --else we copy the selected ones on the second slot
		if #UIElements.tableLinkPermut[11]==1 then
			UIParameters.errorMessage="Can't permut with only one ring"
			returnvalue=false
		elseif #UIElements.tableLinkPermut[11]==2 then
			local temptable={}
			temptable[1]=UIElements.tableLinkPermut[11]
			UIElements.tableLinkPermut[11]={}
			UIElements.tableLinkPermut[11][1]=temptable[1][1]
			UIElements.tableLinkPermut[12][1]=temptable[1][2]
		else
			UIElements.tableLinkPermut[12]=UIElements.tableLinkPermut[11]
		end
	end
		
	
	return returnvalue
end

-- generates a raw list of all selected items for autoSimc
function SimPermut:GetItemListString()
	local returnString=""
	local actualString
	for i=1,#UIElements.tableLinkPermut do
		actualString=""
		for j=1,#UIElements.tableLinkPermut[i] do
			local _,_,itemRarity = GetItemInfo(UIElements.tableLinkPermut[i][j][1])
			local itemid = PersoLib:GetIDFromLink(UIElements.tableLinkPermut[i][j][1])
			local itemString = SimPermut:GetItemString(UIElements.tableLinkPermut[i][j][1],ExtraData.PermutSimcNames[i],false,UIElements.tableLinkPermut[i][j][2],UIElements.tableLinkPermut[i][j][3])
			local extraDataString = ""..((itemid == ExtraData.HasTierSets["T21"][UIParameters.classID][i]) and "T21" or "")..((itemid == ExtraData.HasTierSets["T20"][UIParameters.classID][i]) and "T20" or "").. ((itemid == ExtraData.HasTierSets["T19"][UIParameters.classID][i]) and "T19" or "").. ((itemRarity== 5) and "L" or "")
			local actualextraDataString = ""
			if extraDataString == "" then 
				actualextraDataString = "" 
			else 
				actualextraDataString = extraDataString.. "--" 
			end
			actualString = actualString .. actualextraDataString ..table.concat(itemString, ',').."|"
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
	local _, playerClass = UnitClass('player')
	autoSimcString=autoSimcString .. PersoLib:tokenize(playerClass).."="..UnitName('player').."\n"
	autoSimcString=autoSimcString .. "spec="..PersoLib:tokenize(ExtraData.SpecNames[ PersoLib:getSpecID() ]).."\n"
	autoSimcString=autoSimcString .. "level="..UnitLevel('player').."\n"
	autoSimcString=autoSimcString .. "race="..PersoLib:tokenize(PersoLib:getRace()).."\n"
	autoSimcString=autoSimcString .. "role="..PersoLib:translateRole(PersoLib:getSpecID()).."\n"
	autoSimcString=autoSimcString .. "position=back".."\n"
	autoSimcString=autoSimcString .. "talents="..PersoLib:CreateSimcTalentString().."\n"
	local playerArtifact = PersoLib:GetArtifactString()
	local playerCrucible = PersoLib:GetCrucibleString()
	if playerArtifact~="" then
		autoSimcString=autoSimcString .. "artifact="..playerArtifact.."\n"
	end
	if playerCrucible~="" then
		autoSimcString=autoSimcString .. "crucible="..playerCrucible.."\n"
	end
	autoSimcString=autoSimcString .. actualSettings.simcCommands.. '\n'
	autoSimcString=autoSimcString .. "\n".."[Gear]"
	
	return autoSimcString
end

-- generates all permutations for the UIElements.tableLinkPermut
function SimPermut:GetAllPermutations()
	local returnTable={}

	returnTable=PersoLib:doCartesianALACON(UIElements.tableLinkPermut)
	
	PersoLib:debugPrint("Nb of rings:"..UIElements.tableNumberSelected[11],UIParameters.ad)
	PersoLib:debugPrint("Nb of trinkets:"..UIElements.tableNumberSelected[12],UIParameters.ad)
	
	return returnTable
end

-- reorganize ring and trinket before print if only two
function SimPermut:ReorganizeEquip(tabletoPermut)
	local itemIdRing1,itemIdRing2
	local itemIdTrinket1,itemIdTrinket2 
	if UIElements.tableNumberSelected[11]<=2 then
		PersoLib:debugPrint(UIElements.tableNumberSelected[11].." rings. Re-organize",UIParameters.ad)
		itemIdRing1 = PersoLib:GetIDFromLink(tabletoPermut[11][1])
		itemIdRing2 = PersoLib:GetIDFromLink(tabletoPermut[12][1])
		PersoLib:debugPrint("fingerInf:"..tostring(UIParameters.fingerInf).."("..itemIdRing1.."-"..itemIdRing2..")",UIParameters.ad)
		if (UIParameters.fingerInf and itemIdRing1>itemIdRing2) or (not UIParameters.fingerInf and itemIdRing1<itemIdRing2) then
			local tempring = tabletoPermut[11]
			tabletoPermut[11] = tabletoPermut[12]
			tabletoPermut[12] = tempring
		end
	end
	if UIElements.tableNumberSelected[12]<=2 then
		PersoLib:debugPrint(UIElements.tableNumberSelected[12].." trinkets. Re-organize",UIParameters.ad)
		itemIdTrinket1 = PersoLib:GetIDFromLink(tabletoPermut[13][1])
		itemIdTrinket2 = PersoLib:GetIDFromLink(tabletoPermut[14][1])
		PersoLib:debugPrint("trinketInf:"..tostring(UIParameters.trinketInf).."("..itemIdTrinket1.."-"..itemIdTrinket2..")",UIParameters.ad)
		if (UIParameters.trinketInf and itemIdTrinket1>itemIdTrinket2) or (not UIParameters.trinketInf and itemIdTrinket1<itemIdTrinket2) then
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
	if #permuttable[1][11] > 0 and #permuttable[1][12] > 0 then
		if (GetInventoryItemLink('player', INVSLOT_FINGER1)==permuttable[1][11][1] and GetInventoryItemLink('player', INVSLOT_FINGER2)==permuttable[1][12][1]) or 
			(GetInventoryItemLink('player', INVSLOT_FINGER1)==permuttable[1][12][1] and GetInventoryItemLink('player', INVSLOT_FINGER2)==permuttable[1][11][1]) then
			itemIdRing1 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_FINGER1))
			itemIdRing2 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_FINGER2))
		else
			itemIdRing1 = PersoLib:GetIDFromLink(permuttable[1][11][1])
			itemIdRing2 = PersoLib:GetIDFromLink(permuttable[1][12][1])
		end
		if itemIdRing1<itemIdRing2 then
			UIParameters.fingerInf=true
		end
		
		PersoLib:debugPrint("fingerInf:"..tostring(UIParameters.fingerInf).."("..itemIdRing1.."-"..itemIdRing2..")",UIParameters.ad)
	end
	
	--prepare trinkets
	if #permuttable[1][13] > 0 and #permuttable[1][14] > 0 then
		if (GetInventoryItemLink('player', INVSLOT_TRINKET1)==permuttable[1][13][1] and GetInventoryItemLink('player', INVSLOT_TRINKET2)==permuttable[1][14][1]) or 
			(GetInventoryItemLink('player', INVSLOT_TRINKET1)==permuttable[1][14][1] and GetInventoryItemLink('player', INVSLOT_TRINKET2)==permuttable[1][13][1]) then
			
			itemIdTrinket1 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_TRINKET1))
			itemIdTrinket2 = PersoLib:GetIDFromLink(GetInventoryItemLink('player', INVSLOT_TRINKET2))
		else
			itemIdTrinket1 = PersoLib:GetIDFromLink(permuttable[1][13][1])
			itemIdTrinket2 = PersoLib:GetIDFromLink(permuttable[1][14][1])
		end
		if itemIdTrinket1<itemIdTrinket2 then
			UIParameters.trinketInf=true
		end

		PersoLib:debugPrint("trinketInf:"..tostring(UIParameters.trinketInf).."("..itemIdTrinket1.."-"..itemIdTrinket2..")",UIParameters.ad)
	end
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
	
	UIParameters.actualLegMin=tonumber(UIElements.editLegMin:GetText())
	UIParameters.actualLegMax=tonumber(UIElements.editLegMax:GetText())
	
	
	for i=1,#permuttable do
		T192p,T194p=SimPermut:HasTier("T19",permuttable[i])
		T202p,T204p=SimPermut:HasTier("T20",permuttable[i])
		T212p,T214p=SimPermut:HasTier("T21",permuttable[i])
		UIParameters.epicGemUsed=false
		SimPermut:ReorganizeEquip(permuttable[i])
		result=SimPermut:CheckUsability(permuttable[i],UIElements.tableBaseLink)
		if result=="" or UIParameters.ad then
			currentString=""
			nbLeg=0
			nbitem=0
			itemList=""
			
			for j=1,#permuttable[i] do
				draw = true
				local _,_,itemRarity = GetItemInfo(permuttable[i][j][1])
				if (itemRarity == 5) and PersoLib:GetIDFromLink(permuttable[i][j][1]) ~= 154172 then -- exlude amanthul from count 
					nbLeg=nbLeg+1
				end
				
				itemString=SimPermut:GetItemString(permuttable[i][j][1],ExtraData.PermutSimcNames[j],false,permuttable[i][j][2],permuttable[i][j][3])
				itemStringFinal=table.concat(itemString, ',')
				if (j>10) then
					if (j==11 or j==13) then
						itemString2 =SimPermut:GetItemString(permuttable[i][j+1][1],ExtraData.PermutSimcNames[j+1],false,permuttable[i][j][2],permuttable[i][j][3])
						itemStringFinal2 = table.concat(itemString2, ',')
						if(itemStringFinal==UIElements.tableBaseString[j] or (itemStringFinal==UIElements.tableBaseString[j+1] and itemStringFinal2==UIElements.tableBaseString[j]))then
							draw=false
						else
							draw=true
						end
					else
						itemString2 =SimPermut:GetItemString(permuttable[i][j-1][1],ExtraData.PermutSimcNames[j-1],false,permuttable[i][j][2],permuttable[i][j][3])
						itemStringFinal2 = table.concat(itemString2, ',')
						if(itemStringFinal==UIElements.tableBaseString[j] or (itemStringFinal==UIElements.tableBaseString[j-1] and itemStringFinal2==UIElements.tableBaseString[j]))then
							draw=false
						else
							draw=true
						end
					end
				else
					draw = (itemStringFinal ~= UIElements.tableBaseString[j])
				end
				
				if draw or UIParameters.ad then
					local adString=""
					if UIParameters.ad and not draw then
						notDrawn=notDrawn+1
						adString=" # Debug not drawn : "
					end
					if not UIParameters.ad then
						okDrawn=okDrawn+1
					end
					currentString = currentString.. adString ..ExtraData.PermutSimcNames[j] .. "=" .. table.concat(itemString, ',').."\n"
					itemname = GetItemInfo(permuttable[i][j][1])
					nbitem=nbitem+1
					itemList=itemList..PersoLib:tokenize(itemname).."-"
				else
					PersoLib:debugPrint("Not printed: not drawn",UIParameters.ad)
					notDrawn=notDrawn+1
				end
				
			end
			
			itemList=itemList:sub(1, -2)

			if((nbLeg >=UIParameters.actualLegMin and nbLeg<=UIParameters.actualLegMax and nbitem>0 
				and (UIParameters.actualSetsT19==0 or (UIParameters.actualSetsT19==2 and T192p) or (UIParameters.actualSetsT19==4 and T194p)) 
				and (UIParameters.actualSetsT20==0 or (UIParameters.actualSetsT20==2 and T202p) or (UIParameters.actualSetsT20==4 and T204p))
				and (UIParameters.actualSetsT21==0 or (UIParameters.actualSetsT21==2 and T212p) or (UIParameters.actualSetsT21==4 and T214p))) 
				or UIParameters.ad) then
				local adString=""
				if UIParameters.ad then
					if result ~= "" then
						adString=" # Debug print : "..result.."\n"
					elseif(nbLeg>UIParameters.actualLegMax) then
						adString=" # Debug print : Not printed:Too much Leg ("..nbLeg..")\n"
					elseif(nbLeg<UIParameters.actualLegMin) then
						adString=" # Debug print : Not printed:Too few Leg ("..nbLeg..")\n"
					elseif(not T192p and UIParameters.actualSetsT19==2) then
						adString=" # Debug print : Not printed:No 2p T19\n"
					elseif(not T194p and UIParameters.actualSetsT19==4) then
						adString=" # Debug print : Not printed:No 4p T19\n"
					elseif(not T202p and UIParameters.actualSetsT20==2) then
						adString=" # Debug print : Not printed:No 2p T20\n"
					elseif(not T204p and UIParameters.actualSetsT20==4) then
						adString=" # Debug print : Not printed:No 4p T20\n"	
					elseif(not T212p and UIParameters.actualSetsT21==2) then
						adString=" # Debug print : Not printed:No 2p T21\n"
					elseif(not T214p and UIParameters.actualSetsT21==4) then
						adString=" # Debug print : Not printed:No 4p T21\n"	
					end
				end
				returnString =  returnString .. adString..SimPermut:GetCopyName(copynumber,nbitem,itemList,#permuttable,1) .. "\n".. currentString.."\n"
				copynumber=copynumber+1
			
			end
		else
			PersoLib:debugPrint("Not printed:"..result,UIParameters.ad)
		end
	end
	
	if copynumber > UIParameters.COPY_THRESHOLD then
		str="Large number of copy, you may not have every copy (frame limitation). Consider using AutoSimC Export"
		UIElements.mainframe:SetStatusText(str)
		PersoLib:debugPrint(str,UIParameters.ad)
	end
	
	if notDrawn>0 and okDrawn==0 and UIParameters.selecteditems>14 then
		str="No copy generated because no other possible combination were found (outside boundaries legendaries, same ring/trinket, no 4P...)"
		UIElements.mainframe:SetStatusText(str)
		PersoLib:debugPrint(str,UIParameters.ad)
	end
	
	return returnString
end

-- generates the string used for talents
function SimPermut:GenerateTalentString()
	local copynb
	local returnString=""
	for i=1,#UIElements.tableTalentResults do
		if UIElements.tableTalentResults[i]~=PersoLib:CreateSimcTalentString() then
			copynb = SimPermut:GetCopyName(i,nil,UIElements.tableTalentResults[i],#UIElements.tableTalentResults,2)
			returnString =  returnString.."\n" ..copynb .. "\n".. "talents="..UIElements.tableTalentResults[i].."\n"
		end
	end
	return returnString
end

-- generates the string used for relics permut
function SimPermut:GenerateRelicString()
	
	local weaponString,itemLink
	local returnString=""
	local CopyString=""
	local itemLevel1,itemLevel2,itemLevel3
	if not UIParameters.artifactData.relics[1].link or not UIParameters.artifactData.relics[2].link then
		return ""
	end
	_, _, _, itemLevel1 = GetItemInfo(UIParameters.artifactData.relics[1].link)
	_, _, _, itemLevel2 = GetItemInfo(UIParameters.artifactData.relics[2].link)
	
	if not UIParameters.artifactData.relics[3].isLocked then
		_, _, _, itemLevel3 = GetItemInfo(UIParameters.artifactData.relics[3].link)
	end
	
	itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
	if itemLink and (UIParameters.relicComparisonTypeValue==1 and UIElements.ilvlTrait1:GetText() and UIElements.ilvlTrait2:GetText() or (UIParameters.relicComparisonTypeValue==2 and UIElements.ilvlWeapon:GetText())) then
			local relicid1,relicid2,relicid3,relicilvl1,relicilvl2,relicilvl3,weaponilvl
			
			if UIElements.DropdownTrait1:GetValue()==0 then
				relicid1=UIParameters.artifactData.relics[1].itemID
			else
				relicid1=UIElements.DropdownTrait1:GetValue()
			end
			
			if UIElements.DropdownTrait2:GetValue()==0 then
				relicid2=UIParameters.artifactData.relics[2].itemID
			else
				relicid2=UIElements.DropdownTrait2:GetValue()
			end
			if not UIParameters.artifactData.relics[3].isLocked then
				if UIElements.DropdownTrait3:GetValue()==0 then
					relicid3=UIParameters.artifactData.relics[3].itemID
				else
					relicid3=UIElements.DropdownTrait3:GetValue()
				end
			end
			if UIParameters.relicComparisonTypeValue==1 then
				relicilvl1=UIElements.ilvlTrait1:GetText()
				relicilvl2=UIElements.ilvlTrait2:GetText()
				if not UIParameters.artifactData.relics[3].isLocked then
					relicilvl3=UIElements.ilvlTrait3:GetText()
				end
			else
				weaponilvl=UIElements.ilvlWeapon:GetText()
			end
			
			--CopyName
			if UIParameters.relicComparisonTypeValue==2 then
				CopyString="Weapon-"..weaponilvl.."_"
			end
			if UIParameters.relicComparisonTypeValue==1 and tonumber(relicilvl1)~=itemLevel1 then
				CopyString=CopyString..relicilvl1.."-"
			end
			if UIElements.DropdownTrait1:GetValue()==0 then
				CopyString=CopyString.."Current".."_"
			else
				CopyString=CopyString..ExtraData.ArtifactTableTraits[UIParameters.artifactID][1][relicid1].."_"
			end
			
			if UIParameters.relicComparisonTypeValue==1 and tonumber(relicilvl2)~=itemLevel2 then
				CopyString=CopyString..relicilvl2.."-"
			end
			if UIElements.DropdownTrait2:GetValue()==0 then
				CopyString=CopyString.."Current".."_"
			else
				CopyString=CopyString..ExtraData.ArtifactTableTraits[UIParameters.artifactID][2][relicid2].."_"
			end
			
			if not UIParameters.artifactData.relics[3].isLocked then
				if UIParameters.relicComparisonTypeValue==1 and tonumber(relicilvl3)~=itemLevel3 then
					CopyString=CopyString..relicilvl3.."-"
				end
				if UIElements.DropdownTrait3:GetValue()==0 then
					CopyString=CopyString.."Current"
				else
					CopyString=CopyString..ExtraData.ArtifactTableTraits[UIParameters.artifactID][3][relicid3]
				end
			end
			
			local copynb = SimPermut:GetCopyName(UIParameters.relicCopyCount,nil,CopyString,1,3)
			weaponString = SimPermut:OverrideWeapon(itemLink,relicid1,relicid2,relicid3,relicilvl1,relicilvl2,relicilvl3,weaponilvl)
			returnString =  returnString.."\n" ..copynb .. "\n".. "main_hand=" .. weaponString.. '\n'
			
			UIParameters.relicCopyCount=UIParameters.relicCopyCount+1
	end

	return returnString
end

-- generates the data dor the current chosen tree
function SimPermut:GenerateCrucibleData(fullweapon)
	local T1,_=next(ExtraData.NetherlightData[1],nil)
	local crucibleData={}
	
	if fullweapon then
		for ridx = 1, 3 do
			crucibleData[ridx] = {}
			crucibleData[ridx][#crucibleData[ridx]+1] = T1
			crucibleData[ridx][#crucibleData[ridx]+1] = UIElements.dropdownTableCrucible[ridx][2]:GetValue()
			crucibleData[ridx][#crucibleData[ridx]+1] = UIElements.dropdownTableCrucible[ridx][3]:GetValue()
		end
	else --one tree, it's in the 2 relic slot (middle column)
		crucibleData[1] = {}
		crucibleData[1][#crucibleData[1]+1] = T1
		crucibleData[1][#crucibleData[1]+1] = UIElements.dropdownTableCrucible[2][2]:GetValue()
		crucibleData[1][#crucibleData[1]+1] = UIElements.dropdownTableCrucible[2][3]:GetValue()
	end

	return crucibleData
end

-- Generate selected crucible traits
function SimPermut:GenerateCrucibleString()
	local str=""
	local CopyString=""
	local crucibleString
	local crucibleData 
	local crucibleStrings = {}
	
	if UIParameters.CrucibleComparisonTypeValue==1 then
		crucibleData=SimPermut:GenerateCrucibleData(false)
	else
		crucibleData=SimPermut:GenerateCrucibleData(true)
	end
	
	for ridx = 1, #crucibleData do
		crucibleStrings[ridx] = table.concat(crucibleData[ridx], ':')
	end
	
	for k,v in pairs(crucibleData) do
		for i=2,3 do
			CopyString = CopyString..PersoLib:GetNameFromTraitID(crucibleData[k][i],UIParameters.artifactID).."_"
		end
		CopyString = CopyString.."-"
	end
	CopyString=CopyString:sub(1, -2)
	local copynb = SimPermut:GetCopyName(UIParameters.crucibleCopyCount,nil,CopyString,1,4)
	str =  copynb .. "\n".. "crucible=" .. table.concat(crucibleStrings, '/').. '\n'
	
	UIParameters.crucibleCopyCount=UIParameters.crucibleCopyCount+1
		
	return str
end

-- Modify main hand relics
function SimPermut:OverrideWeapon(itemLink,relic1,relic2,relic3,ilvlRelic1,ilvlRelic2,ilvlRelic3,ilvlWeapon)
	local weaponString
	local itemSplit = PersoLib:LinkSplit(itemLink)

	local bonuses = {}
	for index=1, tonumber(itemSplit[UIParameters.OFFSET_BONUS_ID]) do
		bonuses[#bonuses + 1] = itemSplit[UIParameters.OFFSET_BONUS_ID + index]
	end
	
	weaponString=",id="..itemSplit[UIParameters.OFFSET_ITEM_ID]
	if #bonuses > 0 then
		weaponString = weaponString..",bonus_id=" .. table.concat(bonuses, '/')
	end
	if itemSplit[UIParameters.OFFSET_ENCHANT_ID] and itemSplit[UIParameters.OFFSET_ENCHANT_ID]~=0 then
		weaponString = weaponString..",enchant_id=" .. itemSplit[UIParameters.OFFSET_ENCHANT_ID]
	end
	weaponString=weaponString..",relic_id=//"
	weaponString=weaponString..",gem_id="..relic1.."/"..relic2.."/"
	if not UIParameters.artifactData.relics[3].isLocked then
		weaponString=weaponString..relic3
	end
	if UIParameters.relicComparisonTypeValue==1 then
		weaponString=weaponString..",relic_ilevel="..ilvlRelic1.."/"..ilvlRelic2.."/"
		if not UIParameters.artifactData.relics[3].isLocked then
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
		if typeReport==1 then --gear
			returnString=returnString..List
		elseif typeReport==2 then --talent
			returnString=returnString..List
		elseif typeReport==3 then --artifact
			returnString=returnString..string.gsub(List, " ", "-");
		elseif typeReport==4 then --crucible
			returnString=returnString..string.gsub(List, " ", "-");
		end
	else 
		local nbcopies = ''..nbitems
		local digits = string.len(nbcopies)
		local mask = '00000000000000000000000000000000000'
		local maskedProfileID=string.sub(mask..copynumber,-digits)
		returnString=returnString.."copy"..maskedProfileID
	end
	
	returnString=returnString..","..UIParameters.profileName
	return returnString
end

-- generates the string for artifact, equiped gear and player info
function SimPermut:GetBaseString(nocrucible)
	if not nocrucible then nocrucible=false end
	local playerName = UnitName('player')
	local playerClass
	_, playerClass,UIParameters.classID = UnitClass('player')
	local playerLevel = UnitLevel('player')
	local playerRealm = GetRealmName()
	local playerRegion = ExtraData.RegionString[GetCurrentRegion()]
	local bPermut=false
	local slotId,itemLink
	local itemString = {}

	local playerRace = PersoLib:getRace()
	local playerTalents = PersoLib:CreateSimcTalentString()
	local playerArtifact = PersoLib:GetArtifactString()
	local playerCrucible = PersoLib:GetCrucibleString()
	local playerSpec = ExtraData.SpecNames[ PersoLib:getSpecID() ]
	
	UIParameters.profileName='"'..playerName ..'"'

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
	if playerArtifact ~= nil then
		SimPermutProfile = SimPermutProfile .. "artifact=".. playerArtifact .. '\n'
	end
	if playerCrucible ~= nil then
		SimPermutProfile = SimPermutProfile .. "crucible=".. playerCrucible .. '\n'
	end

	--add custome simc parameters
	SimPermutProfile = SimPermutProfile .. actualSettings.simcCommands.. '\n'
	
	SimPermutProfile = SimPermutProfile .. '\n'
	
	-- Method that gets gear information
	local items,itemsLinks = SimPermut:GetItemStrings()

	SimPermutProfile = SimPermutProfile .. "name="..UIParameters.profileName.."\n"
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
	
	if UIParameters.fingerInf then
		if itemIdR111>itemIdR112 then
			return "Ring copy duplication ("..itemIdR111.."-"..itemIdR112.." /fi: "..tostring(UIParameters.fingerInf)..")"
		end
	else
		if itemIdR111<itemIdR112 then
			return "Ring copy duplication ("..itemIdR111.."-"..itemIdR112.." /fi: "..tostring(UIParameters.fingerInf)..")"
		end
	end
	
	--checking same trinket
	if table1[13][1]==table1[14][1] then
		return "Same trinket "..table1[13][1]
	end
	
	--checking trinket inf
	itemIdT111 = PersoLib:GetIDFromLink(table1[13][1])
	itemIdT112 = PersoLib:GetIDFromLink(table1[14][1])
	
	if UIParameters.trinketInf then
		if itemIdT111>itemIdT112 then
			return "Trinket copy duplication ("..itemIdT111.."-"..itemIdT112.." /ti: "..tostring(UIParameters.trinketInf)..") "
		end
	else
		if itemIdT111<itemIdT112 then
			return "Trinket copy duplication ("..itemIdT111.."-"..itemIdT112.." /ti: "..tostring(UIParameters.trinketInf)..")"
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
	if UIParameters.artifactID and ExtraData.ArtifactTable[UIParameters.artifactID] then
		local str = ExtraData.ArtifactTable[UIParameters.artifactID] .. ':0:0:0:0'
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
		for powerId, _ in pairs(ExtraData.NetherlightData[1]) do
			
			local powerId, powerRank, relicRank, crucibleRank = SimPermut:GetPowerData(powerId, true)
			if crucibleRank > 0 then
			  crucibleRanks[#crucibleRanks + 1] = powerId
			  crucibleRanks[#crucibleRanks + 1] = crucibleRank
			end
		end
		for powerId, _ in pairs(ExtraData.NetherlightData[2]) do
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
			cruciblestr = table.concat(crucibleRanks, ':')
	    end
		
		Clear()
		
		return str,cruciblestr
	end
	return "",""
end

-- check for Tier Sets
function SimPermut:HasTier(stier,tableEquip)
	if ExtraData.HasTierSets[stier][UIParameters.classID] then
      local Count = 0;
      local Item;
      for Slot, ItemID in pairs(ExtraData.HasTierSets[stier][UIParameters.classID]) do
        Item = PersoLib:GetIDFromLink(tableEquip[Slot][1]);
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
		if UIElements.tableBaseLink[11]==itemLink or UIElements.tableBaseLink[12]==itemLink then
			returnValue=true
		end
	elseif slot==12 then
		if UIElements.tableBaseLink[13]==itemLink or UIElements.tableBaseLink[14]==itemLink then
			returnValue=true
		end
	else
		if UIElements.tableBaseLink[slot]==itemLink then
			returnValue=true
		end
	end
	return returnValue
end

-- Generate the string from extracted artifact
function SimPermut:GenerateCruciblePermutationStrings(permuttable,currentTree)
	local copynb
	local returnString=""
	local weaponstring=""
	local crucibleStrings = {}
	local copystring=""
	for i=1,#permuttable do
		--build permutation
		crucibleStrings[i]=""
		copystring=""
		for j=1, string.len(permuttable[i])do
			local talentnb = tonumber(string.sub(permuttable[i],j,j))
			if j~=1 then
				copystring = copystring..PersoLib:GetNameFromTraitID(currentTree[j][talentnb],UIParameters.artifactID).."_"
			end
			crucibleStrings[i]=crucibleStrings[i]..currentTree[j][talentnb]..":"
		end
		copystring=copystring:sub(1, -2)
		crucibleStrings[i]=crucibleStrings[i]:sub(1, -2)		
		copynb = SimPermut:GetCopyName(i,nil,copystring,#permuttable,4)
		
		if _G.ArtifactRelicForgeFrame.relicSlot <= 3 then
			if not actualSettings.NCKeepBase then
				returnString=returnString.."\n" ..copynb .. "\n".. "crucible="..crucibleStrings[i].."//".."\n"
			else
				local copystringBase=""
				
				for k=1,3 do
					if _G.ArtifactRelicForgeFrame.relicSlot == k then
						copystringBase=copystringBase..crucibleStrings[i].."/"
					else
						copystringBase=copystringBase..table.concat(PersoLib:GetCrucibleStringForSlot(k,true), ':').."/"
					end
				end
				copystringBase=copystringBase:sub(1, -2)
				returnString=returnString.."\n" ..copynb .. "\n".. "crucible="..copystringBase.."\n"
			end
		else
			if actualSettings.NCPreviewType == 0 then
				returnString=returnString.."\n" ..copynb .. "\n".. "crucible="..crucibleStrings[i].."//".."\n"
			else
				local copystringBase=""
				for k=1,3 do
					if actualSettings.NCPreviewType == k then
						copystringBase=copystringBase..crucibleStrings[i].."/"
					else
						copystringBase=copystringBase..table.concat(PersoLib:GetCrucibleStringForSlot(k,true), ':').."/"
					end
				end
				copystringBase=copystringBase:sub(1, -2)
				
				if actualSettings.NCPreviewReplace then
					weaponstring="\n"
					--add weapons
					itemLink = GetInventoryItemLink('player', INVSLOT_MAINHAND)
					itemString = {}
          local reliclink = ArtifactRelicForgeUI.GetPreviewRelicItemLink()

					-- if we don't have an item link, we don't care
					if itemLink then
						itemString=SimPermut:GetItemString(itemLink,'main_hand',true,_,_,reliclink,actualSettings.NCPreviewType)
						weaponstring = weaponstring .. "main_hand=" .. table.concat(itemString, ',').. '\n'
					end
					
					itemLink = GetInventoryItemLink('player', INVSLOT_OFFHAND)
					itemString = {}

					-- if we don't have an item link, we don't care
					if itemLink then
						itemString=SimPermut:GetItemString(itemLink,'off_hand',true,_,_,reliclink,actualSettings.NCPreviewType)
						weaponstring = weaponstring .. "off_hand=" .. table.concat(itemString, ',').. '\n'
					end
				end
				
				returnString=returnString.."\n" ..copynb .. "\n".. "crucible="..copystringBase..weaponstring.."\n"
			end
		end
	end
	return returnString
end
