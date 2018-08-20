local _, SimPermut = ...

SimPermut = LibStub("AceAddon-3.0"):NewAddon(SimPermut, "SimPermut", "AceConsole-3.0", "AceEvent-3.0")

SimPermutVars={}

-- Libs
local SocketInventoryItem 	= _G.SocketInventoryItem
local AceGUI 			  	= LibStub("AceGUI-3.0")
local PersoLib			  	= LibStub("PersoLib")

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
	ITEM_COUNT_THRESHOLD = 25,
	COPY_THRESHOLD 		= 500,
	
	mainframeCreated=false,
	classID,
	selecteditems=0,
	labelCount,
	errorMessage="",
	currentFrame=1,
	
	actualEnchantWeapon=0,
	actualEnchantFinger=0,
	actualGem=0,
	actualForce=false,
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
	tableTalentLabel={},
	tableTalentIcon={},
	tableTalentcheckbox={},
	tableTalentSpells={},
	tableTalentResults={},
	tablePreCheck={},
	tableNumberSelected={},
	tableLinkPermut={},
	tableBaseLink={},
	tableBaseString={}
}

-- Config
local variablesLoaded=false
local defaultSettings={
	report_typeGear		= 2,
	report_typeTalents	= 2,
	ilvl_thresholdMin 	= 280,
	ilvl_thresholdMax 	= 500,
	enchant_weapon		= 0,
	enchant_ring		= 0,		
	gems				= 0,	
	gemsEpic			= 0,
	generateStart		= true,
	replaceEnchants		= false,
	replaceEnchantsBase	= false,
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
		for i=1,#ExtraData.ListNames do
			if string.match(arg, ExtraData.ListNames[i]) then
				UIElements.tablePreCheck[i]=true
			else
				UIElements.tablePreCheck[i]=false
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
  	if SimPermutVars.ilvl_thresholdMax == 999 then
    	SimPermutVars.ilvl_thresholdMax = 1000
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
	end
end

----------------------------
----------- UI -------------
----------------------------
-- Main Frame construction
function SimPermut:BuildFrame()
	--Init Vars
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
	elseif UIParameters.currentFrame==3 then --add items
		SimPermut:BuildDungeonJournalFrame()
	elseif UIParameters.currentFrame==4 then --options
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

	
	local labelEnchantWeapon= AceGUI:Create("Label")
	labelEnchantWeapon:SetText("     Enchant Weapon")
	labelEnchantWeapon:SetWidth(95)
	UIElements.mainGroup:AddChild(labelEnchantWeapon)
	
	local dropdownEnchantWeapon = AceGUI:Create("Dropdown")
	dropdownEnchantWeapon:SetWidth(110)
	dropdownEnchantWeapon:SetList(ExtraData.enchantWeapon)
	dropdownEnchantWeapon:SetValue(actualSettings.enchant_weapon)
	dropdownEnchantWeapon:SetCallback("OnValueChanged", function (this, event, item)
		UIParameters.actualEnchantWeapon=item
    end)
	UIElements.mainGroup:AddChild(dropdownEnchantWeapon)
	
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
	
	-- Finger enchant
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
	
	-- Gems
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
	
	-- Epic Gem
	local labelepicGem= AceGUI:Create("Label")
	labelepicGem:SetText("     Use 1 Epic gem")
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

	SimPermut:AddSpacer(container1,false,50)

	-- Replace current checkbox
	UIElements.checkBoxForce = AceGUI:Create("CheckBox")
	UIElements.checkBoxForce:SetWidth(250)
	UIElements.checkBoxForce:SetLabel("Replace current enchant/gems")
	UIElements.checkBoxForce:SetCallback("OnValueChanged", function (this, event, item)
		SimPermutVars.replaceEnchants=UIElements.checkBoxForce:GetValue()
		PersoLib:MergeTables(defaultSettings,SimPermutVars,actualSettings)
    end)
	container1:AddChild(UIElements.checkBoxForce)
	
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
	
	UIParameters.actualEnchantWeapon=actualSettings.enchant_weapon
	UIParameters.actualEnchantFinger=actualSettings.enchant_ring
	UIParameters.actualGem=actualSettings.gems
	UIParameters.actualForce=actualSettings.replaceEnchants
	
	_,UIElements.tableBaseLink=SimPermut:GetBaseString()
	
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
function SimPermut:GetItemString(itemLink,itemType,base,forceilvl,forcegem)
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
		if string.match(itemType, 'finger*') then
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
		elseif (string.match(itemType, 'main_hand')) then
			if UIParameters.actualEnchantFinger == 999999 then
				enchantID=""
			elseif (UIParameters.actualForce or (base and SimPermutVars.replaceEnchantsBase))  and UIParameters.actualEnchantWeapon~=0 then
				enchantID=UIParameters.actualEnchantWeapon
			else
				if UIParameters.actualEnchantWeapon==0 or tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
					if tonumber(itemSplit[UIParameters.OFFSET_ENCHANT_ID]) > 0 then
						enchantID=itemSplit[UIParameters.OFFSET_ENCHANT_ID]
					end
				else
					enchantID=UIParameters.actualEnchantWeapon
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

	-- Gems
	if itemType=="main_hand" or itemType=="off_hand" then
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
		if base and not SimPermutVars.replaceEnchantsBase then
			if tonumber(itemSplit[UIParameters.OFFSET_GEM_ID_1]) ~= 0 then
				gemstring='gem_id='
				if (itemSplit[UIParameters.OFFSET_GEM_ID_1]~=0) then 
					gemstring=gemstring..itemSplit[UIParameters.OFFSET_GEM_ID_1]
					if (itemSplit[UIParameters.OFFSET_GEM_ID_2]~=0) then 
						gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_2]
						if (itemSplit[UIParameters.OFFSET_GEM_ID_3]~=0) then 
							gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_3]
							if (itemSplit[UIParameters.OFFSET_GEM_ID_4]~=0) then 
								gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_4]
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
							gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_2]
							if (itemSplit[UIParameters.OFFSET_GEM_ID_3]~=0) then 
								gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_3]
								if (itemSplit[UIParameters.OFFSET_GEM_ID_4]~=0) then 
									gemstring=gemstring..'/'..itemSplit[UIParameters.OFFSET_GEM_ID_4]
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
	
	for slotNum=1, #ExtraData.PermutSlotNames do
		slotId = GetInventorySlotInfo(ExtraData.PermutSlotNames[slotNum])
		itemLink = GetInventoryItemLink('player', slotId) 

		-- if we don't have an item link, we don't care
		if itemLink then
			local _,_,itemRarity = GetItemInfo(itemLink)
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
	elseif strItem=="main hand" then
		slotID=17
		realSlot=15
	elseif strItem=="off hand" then
		slotID=18
		realSlot=16
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
			actualString = actualString ..table.concat(itemString, ',').."|"
		end
		actualString=actualString:sub(1, -2)
		returnString = returnString..ExtraData.PermutSimcNames[i] .. "="..actualString.."\n"
		
	end
	
	--[[
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
	]]--
	
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
	local itemRarity
	local nbitem
	local itemList
	local itemname
	local result
	local draw = true
	local str
	local notDrawn=0
	local okDrawn=0
	
	for i=1,#permuttable do
		UIParameters.epicGemUsed=false
		SimPermut:ReorganizeEquip(permuttable[i])
		result=SimPermut:CheckUsability(permuttable[i],UIElements.tableBaseLink)
		if result=="" or UIParameters.ad then
			currentString=""
			nbitem=0
			itemList=""
			
			for j=1,#permuttable[i] do
				draw = true
				local _,_,itemRarity = GetItemInfo(permuttable[i][j][1])
				
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
		str="No copy generated because no other possible combination were found (same ring, trinket...)"
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

-- get copy's name
function SimPermut:GetCopyName(copynumber,nbitem,List,nbitems,typeReport)
	local returnString="copy="
	
	if (typeReport==1 and actualSettings.report_typeGear==1 and List) or (typeReport==2 and actualSettings.report_typeTalents==1) then
		if typeReport==1 then --gear
			returnString=returnString..List
		elseif typeReport==2 then --talent
			returnString=returnString..List
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

-- generates the string for equiped gear and player info
function SimPermut:GetBaseString()
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
	
	--[[
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
	]]--

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
