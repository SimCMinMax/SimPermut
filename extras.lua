local _, SimPermut = ...

-- UI
SimPermut.ExtraData={
	-- SimcData
	RegionString = {
	  [1] = 'us',
	  [2] = 'kr',
	  [3] = 'eu',
	  [4] = 'tw',
	  [5] = 'cn'
	},
	SpecNames = {
	-- Death Knight
	  [250] = 'Blood',
	  [251] = 'Frost',
	  [252] = 'Unholy',
	-- Demon Hunter
	  [577] = 'Havoc',
	  [581] = 'Vengeance',
	-- Druid 
	  [102] = 'Balance',
	  [103] = 'Feral',
	  [104] = 'Guardian',
	  [105] = 'Restoration',
	-- Hunter 
	  [253] = 'Beast Mastery',
	  [254] = 'Marksmanship',
	  [255] = 'Survival',
	-- Mage 
	  [62] = 'Arcane',
	  [63] = 'Fire',
	  [64] = 'Frost',
	-- Monk 
	  [268] = 'Brewmaster',
	  [269] = 'Windwalker',
	  [270] = 'Mistweaver',
	-- Paladin 
	  [65] = 'Holy',
	  [66] = 'Protection',
	  [70] = 'Retribution',
	-- Priest 
	  [256] = 'Discipline',
	  [257] = 'Holy',
	  [258] = 'Shadow',
	-- Rogue 
	  [259] = 'Assassination',
	  [260] = 'Outlaw',
	  [261] = 'Subtlety',
	-- Shaman 
	  [262] = 'Elemental',
	  [263] = 'Enhancement',
	  [264] = 'Restoration',
	-- Warlock 
	  [265] = 'Affliction',
	  [266] = 'Demonology',
	  [267] = 'Destruction',
	-- Warrior 
	  [71] = 'Arms',
	  [72] = 'Fury',
	  [73] = 'Protection'
	},
	RoleTable={
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
	},
	-- Permutation data
	GetItemInfoName = {
		["INVTYPE_HEAD"]=1,
		["INVTYPE_NECK"]=2,
		["INVTYPE_SHOULDER"]=3,
		["INVTYPE_CLOAK"]=4,
		["INVTYPE_CHEST"]=5,
		["INVTYPE_ROBE"]=5,
		["INVTYPE_WRIST"]=6,
		["INVTYPE_HAND"]=7,
		["INVTYPE_WAIST"]=8,
		["INVTYPE_LEGS"]=9,
		["INVTYPE_FEET"]=10,
		["INVTYPE_FINGER"]=11,
		["INVTYPE_TRINKET"]=12,
		["INVSLOT_MAINHAND"]=13,
		["INVSLOT_OFFHAND"]=14
	},
	SlotNames = {
		[1]="HeadSlot", 
		[2]="NeckSlot", 
		[3]="ShoulderSlot", 
		[4]="BackSlot", 
		[5]="ChestSlot", 
		[6]="ShirtSlot", 
		[7]="TabardSlot", 
		[8]="WristSlot", 
		[9]="HandsSlot", 
		[10]="WaistSlot", 
		[11]="LegsSlot", 
		[12]="FeetSlot", 
		[13]="Finger0Slot", 
		[14]="Finger1Slot", 
		[15]="Trinket0Slot", 
		[16]="Trinket1Slot", 
		[17]="MainHandSlot", 
		[18]="SecondaryHandSlot", 
		[19]="AmmoSlot" 
	},
	SimcSlotNames = {
		[1]="head",
		[2]="neck",
		[3]="shoulder",
		[4]="back",
		[5]="chest",
		[6]="shirt",
		[7]="tabard",
		[8]="wrist",
		[9]="hands",
		[10]="waist",
		[11]="legs",
		[12]="feet",
		[13]="finger1",
		[14]="finger2",
		[15]="trinket1",
		[16]="trinket2",
		[17]="main_hand",
		[18]="off_hand",
		[19]="ammo"
	},
	ListNames = {
		[1]="head",
		[2]="neck",
		[3]="shoulder",
		[4]="back",
		[5]="chest",
		[6]="wrist",
		[7]="hands",
		[8]="waist",
		[9]="legs",
		[10]="feet",
		[11]="finger",
		[12]="trinket",
		[13]="main hand",
		[14]="off hand"
	},
	PermutSimcNames = {
		[1]="head",
		[2]="neck",
		[3]="shoulder",
		[4]="back",
		[5]="chest",
		[6]="wrist",
		[7]="hands",
		[8]="waist",
		[9]="legs",
		[10]="feet",
		[11]="finger1",
		[12]="finger2",
		[13]="trinket1",
		[14]="trinket2",
		[15]="main_hand",
		[16]="off_hand"
	},
	PermutSlotNames = {
		[1]="HeadSlot", 
		[2]="NeckSlot", 
		[3]="ShoulderSlot", 
		[4]="BackSlot", 
		[5]="ChestSlot", 
		[6]="WristSlot", 
		[7]="HandsSlot", 
		[8]="WaistSlot", 
		[9]="LegsSlot", 
		[10]="FeetSlot", 
		[11]="Finger0Slot", 
		[12]="Finger1Slot", 
		[13]="Trinket0Slot", 
		[14]="Trinket1Slot", 
		[15]="MainHandSlot", 
		[16]="SecondaryHandSlot"
	},

	-- UI
	FrameMenu={
		[1] = "Gear permutation",
		[2] = "Talent permutation",
		[3] = "Add Items",
		[4] = "Options"
	},
	ReportTypeGear = {
		[1] = 'Item names',
		[2] = 'Copy number'
	},
	ReportTypeTalents = {
		[1] = 'Talents taken',
		[2] = 'Copy number'
	},
	enchantWeapon = {
		[0] 	= 'Untouched',
		[5946] 	= 'Coastal Surge',
		[5950] 	= 'Gale-Force Striking',
		[5949] 	= 'Torrent of Elements',
		[5948] 	= 'Siphoning',
		[5965] 	= 'Deadly Navigation',
		[5964] 	= 'Masterful Navigation',
		[5963] 	= 'Quick Navigation',
		[5966] 	= 'Stalwart Navigation',
		[5962] 	= 'Versatile Navigation',
		[999999]= 'Scrap ench.'
	},
	enchantRing = {
		[0] 	= 'Untouched',
		[5942] 	= '+37 Crit',
		[5943] 	= '+37 Haste',
		[5944] 	= '+37 Mast',
		[5945] 	= '+37 Vers',
		[999999]= 'Scrap ench.'
	},
	gemList = {
		[0] 	 = 'Untouched',
		[153710] = '+30 Crit',
		[153711] = '+30 Haste',
		[153713] = '+30 Mast',
		[153712] = '+30 Vers',
		[154126] = '+40 Crit',
		[154127] = '+40 Haste',
		[154129] = '+40 Mast',
		[154128] = '+40 Vers',
		[999999] = 'Scrap gem'
	},
	gemListEpic = {
		[0] 	   = 'No Epic gem',
		[130246] = '+40 Str',
		[130247] = '+40 Agi',
		[130248] = '+40 Int',
	}
}


