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
		["INVTYPE_TRINKET"]=12
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
		[12]="trinket"
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
		[14]="trinket2"
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
		[14]="Trinket1Slot"
	},

	-- UI
	FrameMenu={
		[1]	= "Gear permutation",
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
	HasTierSets = {
		["T19"] = {
		  [0]  = function (Count) return Count > 1, Count > 3; end,                                       -- Return Function
		  [1]  = {[5] = 138351, [4] = 138374, [7] = 138354, [1] = 138357, [9] = 138360, [3] = 138363},  -- Warrior:      Chest, Back, Hands, Head, Legs, Shoulder
		  [2]  = {[5] = 138350, [4] = 138369, [7] = 138353, [1] = 138356, [9] = 138359, [3] = 138362},  -- Paladin:      Chest, Back, Hands, Head, Legs, Shoulder
		  [3]  = {[5] = 138339, [4] = 138368, [7] = 138340, [1] = 138342, [9] = 138344, [3] = 138347},  -- Hunter:       Chest, Back, Hands, Head, Legs, Shoulder
		  [4]  = {[5] = 138326, [4] = 138371, [7] = 138329, [1] = 138332, [9] = 138335, [3] = 138338},  -- Rogue:        Chest, Back, Hands, Head, Legs, Shoulder
		  [5]  = {[5] = 138319, [4] = 138370, [7] = 138310, [1] = 138313, [9] = 138316, [3] = 138322},  -- Priest:       Chest, Back, Hands, Head, Legs, Shoulder
		  [6]  = {[5] = 138349, [4] = 138364, [7] = 138352, [1] = 138355, [9] = 138358, [3] = 138361},  -- Death Knight: Chest, Back, Hands, Head, Legs, Shoulder
		  [7]  = {[5] = 138346, [4] = 138372, [7] = 138341, [1] = 138343, [9] = 138345, [3] = 138348},  -- Shaman:       Chest, Back, Hands, Head, Legs, Shoulder
		  [8]  = {[5] = 138318, [4] = 138365, [7] = 138309, [1] = 138312, [9] = 138315, [3] = 138321},  -- Mage:         Chest, Back, Hands, Head, Legs, Shoulder
		  [9]  = {[5] = 138320, [4] = 138373, [7] = 138311, [1] = 138314, [9] = 138317, [3] = 138323},  -- Warlock:      Chest, Back, Hands, Head, Legs, Shoulder
		  [10] = {[5] = 138325, [4] = 138367, [7] = 138328, [1] = 138331, [9] = 138334, [3] = 138337},  -- Monk:         Chest, Back, Hands, Head, Legs, Shoulder
		  [11] = {[5] = 138324, [4] = 138366, [7] = 138327, [1] = 138330, [9] = 138333, [3] = 138336},  -- Druid:        Chest, Back, Hands, Head, Legs, Shoulder
		  [12] = {[5] = 138376, [4] = 138375, [7] = 138377, [1] = 138378, [9] = 138379, [3] = 138380}   -- Demon Hunter: Chest, Back, Hands, Head, Legs, Shoulder
		},
		["T20"] = {
		  [0]  = function (Count) return Count > 1, Count > 3; end,                                       -- Return Function
		  [1]  = {[5] = 147187, [4] = 147188, [7] = 147189, [1] = 147190, [9] = 147191, [3] = 147192},  -- Warrior:      Chest, Back, Hands, Head, Legs, Shoulder
		  [2]  = {[5] = 147157, [4] = 147158, [7] = 147159, [1] = 147160, [9] = 147161, [3] = 147162},  -- Paladin:      Chest, Back, Hands, Head, Legs, Shoulder
		  [3]  = {[5] = 147139, [4] = 147140, [7] = 147141, [1] = 147142, [9] = 147143, [3] = 147144},  -- Hunter:       Chest, Back, Hands, Head, Legs, Shoulder
		  [4]  = {[5] = 147169, [4] = 147170, [7] = 147171, [1] = 147172, [9] = 147173, [3] = 147174},  -- Rogue:        Chest, Back, Hands, Head, Legs, Shoulder
		  [5]  = {[5] = 147167, [4] = 147163, [7] = 147164, [1] = 147165, [9] = 147166, [3] = 147168},  -- Priest:       Chest, Back, Hands, Head, Legs, Shoulder
		  [6]  = {[5] = 147121, [4] = 147122, [7] = 147123, [1] = 147124, [9] = 147125, [3] = 147126},  -- Death Knight: Chest, Back, Hands, Head, Legs, Shoulder
		  [7]  = {[5] = 147175, [4] = 147176, [7] = 147177, [1] = 147178, [9] = 147179, [3] = 147180},  -- Shaman:       Chest, Back, Hands, Head, Legs, Shoulder
		  [8]  = {[5] = 147149, [4] = 147145, [7] = 147146, [1] = 147147, [9] = 147148, [3] = 147150},  -- Mage:         Chest, Back, Hands, Head, Legs, Shoulder
		  [9]  = {[5] = 147185, [4] = 147181, [7] = 147182, [1] = 147183, [9] = 147184, [3] = 147186},  -- Warlock:      Chest, Back, Hands, Head, Legs, Shoulder
		  [10] = {[5] = 147151, [4] = 147152, [7] = 147153, [1] = 147154, [9] = 147155, [3] = 147156},  -- Monk:         Chest, Back, Hands, Head, Legs, Shoulder
		  [11] = {[5] = 147133, [4] = 147134, [7] = 147135, [1] = 147136, [9] = 147137, [3] = 147138},  -- Druid:        Chest, Back, Hands, Head, Legs, Shoulder
		  [12] = {[5] = 147127, [4] = 147128, [7] = 147129, [1] = 147130, [9] = 147131, [3] = 147132}   -- Demon Hunter: Chest, Back, Hands, Head, Legs, Shoulder
		},
		["T21"] = {
		  [0]  = function (Count) return Count > 1, Count > 3; end,                                       -- Return Function
		  [1]  = {[5] = 152178, [4] = 152179, [7] = 152180, [1] = 152181, [9] = 152182, [3] = 152183},  -- Warrior:      Chest, Back, Hands, Head, Legs, Shoulder
		  [2]  = {[5] = 152148, [4] = 152149, [7] = 152150, [1] = 152151, [9] = 152152, [3] = 152153},  -- Paladin:      Chest, Back, Hands, Head, Legs, Shoulder
		  [3]  = {[5] = 152130, [4] = 152131, [7] = 152132, [1] = 152133, [9] = 152134, [3] = 152135},  -- Hunter:       Chest, Back, Hands, Head, Legs, Shoulder
		  [4]  = {[5] = 152160, [4] = 152161, [7] = 152162, [1] = 152163, [9] = 152164, [3] = 152165},  -- Rogue:        Chest, Back, Hands, Head, Legs, Shoulder
		  [5]  = {[5] = 152158, [4] = 152154, [7] = 152155, [1] = 152156, [9] = 152157, [3] = 152159},  -- Priest:       Chest, Back, Hands, Head, Legs, Shoulder
		  [6]  = {[5] = 152112, [4] = 152113, [7] = 152114, [1] = 152115, [9] = 152116, [3] = 152117},  -- Death Knight: Chest, Back, Hands, Head, Legs, Shoulder
		  [7]  = {[5] = 152166, [4] = 152167, [7] = 152168, [1] = 152169, [9] = 152170, [3] = 152171},  -- Shaman:       Chest, Back, Hands, Head, Legs, Shoulder
		  [8]  = {[5] = 152140, [4] = 152136, [7] = 152137, [1] = 152138, [9] = 152139, [3] = 152141},  -- Mage:         Chest, Back, Hands, Head, Legs, Shoulder
		  [9]  = {[5] = 152176, [4] = 152172, [7] = 152173, [1] = 152174, [9] = 152175, [3] = 152177},  -- Warlock:      Chest, Back, Hands, Head, Legs, Shoulder
		  [10] = {[5] = 152142, [4] = 152143, [7] = 152144, [1] = 152145, [9] = 152146, [3] = 152147},  -- Monk:         Chest, Back, Hands, Head, Legs, Shoulder
		  [11] = {[5] = 152124, [4] = 152125, [7] = 152126, [1] = 152127, [9] = 152128, [3] = 152129},  -- Druid:        Chest, Back, Hands, Head, Legs, Shoulder
		  [12] = {[5] = 152118, [4] = 152119, [7] = 152120, [1] = 152121, [9] = 152122, [3] = 152123}   -- Demon Hunter: Chest, Back, Hands, Head, Legs, Shoulder
		}
	},
	SetsListT19 = {
	  [0] = 'All',
	  [2] = 'T19 2P',
	  [4] = 'T19 4P'
	},
	SetsListT20 = {
	  [0] = 'All',
	  [2] = 'T20 2P',
	  [4] = 'T20 4P'
	},
	SetsListT21 = {
	  [0] = 'All',
	  [2] = 'T21 2P',
	  [4] = 'T21 4P'
	},
	enchantNeck = {
		[0] 	= 'Untouched',
		[5891] 	= 'Ancient Priestess',
		[5437] 	= 'Claw',
		[5438] 	= 'Distant Army',
		[5889] 	= 'Heavy Hide',
		[5439] 	= 'Hidden Satyr',
		[5890] 	= 'Trained Soldier',
		[999999]= 'Scrap ench.'
	},
	enchantCloak = {
		[0] 	 = 'Untouched',
		[5434] 	= '+9 Str',
		[5435] 	= '+9 Agi',
		[5436] 	= '+9 Int',
		[5310]  = '+5 Crit',
		[5311]  = '+5 Haste',
		[5312]  = '+5 Mast',
		[5314]  = '+5 Vers',
		[999999]= 'Scrap ench.'
	},
	enchantRing = {
		[0] 	= 'Untouched',
		[5427] 	= '+7 Crit',
		[5428] 	= '+7 Haste',
		[5429] 	= '+7 Mast',
		[5430] 	= '+7 Vers',
		[999999]= 'Scrap ench.'
	},
	gemList = {
		
		[0] 	 = 'Untouched',
		[130219] = '+9 Crit',
		[130220] = '+9 Haste',
		[130222] = '+9 Mast',
		[130221] = '+9 Vers',
		[151580] = '+11 Crit',
		[151583] = '+11 Haste',
		[151584] = '+11 Mast',
		[151585] = '+11 Vers',
		[999999] = 'Scrap gem'
	},
	gemListEpic = {
		[0] 	   = 'No Epic gem',
		[130246] = '+9 Str',
		[130247] = '+9 Agi',
		[130248] = '+9 Int',
	}
}


