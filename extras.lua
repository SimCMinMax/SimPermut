local _, SimPermut = ...

-- Artifact lookup
SimPermut.ArtifactTable = {
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

-- regionID lookup
SimPermut.RegionString = {
  [1] = 'us',
  [2] = 'kr',
  [3] = 'eu',
  [4] = 'tw',
  [5] = 'cn'
}

-- non-localized profession names from ids
SimPermut.ProfNames = {
  [129] = 'First Aid',
  [164] = 'Blacksmithing',
  [165] = 'Leatherworking',
  [171] = 'Alchemy',
  [182] = 'Herbalism',
  [184] = 'Cooking',
  [186] = 'Mining',
  [197] = 'Tailoring',
  [202] = 'Engineering',
  [333] = 'Enchanting',
  [356] = 'Fishing',
  [393] = 'Skinning',
  [755] = 'Jewelcrafting',
  [773] = 'Inscription',
  [794] = 'Archaeology'  
}

-- non-localized spec names from spec ids
SimPermut.SpecNames = {
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
}

-- slot name conversion stuff

SimPermut.slotNames = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "AmmoSlot" };    
SimPermut.simcSlotNames = {'head','neck','shoulder','back','chest','shirt','tabard','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2','main_hand','off_hand','ammo'}
SimPermut.listNames = {'head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger','trinket'}
SimPermut.PermutSimcNames = {'head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2'}
SimPermut.PermutSlotNames = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"}
SimPermut.statsString= {"ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_HASTE_RATING_SHORT", "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_MASTERY_RATING_SHORT", "ITEM_MOD_VERSATILITY"}

SimPermut.statsStringCorres= {
["ITEM_MOD_INTELLECT_SHORT"]='Int', 
["ITEM_MOD_AGILITY_SHORT"]='Agi', 
["ITEM_MOD_STRENGTH_SHORT"]='Str', 
["ITEM_MOD_HASTE_RATING_SHORT"]='Hast', 
["ITEM_MOD_CRIT_RATING_SHORT"]='Crit', 
["ITEM_MOD_MASTERY_RATING_SHORT"]='Mast', 
["ITEM_MOD_VERSATILITY"]='Vers'
}

SimPermut.enchantNeck = {
  [0] 	 = 'Untouched',
  [5891] = 'Ancient Priestess',
  [5437] = 'Claw',
  [5438] = 'Distant Army',
  [5889] = 'Heavy Hide',
  [5439] = 'Hidden Satyr',
  [5890] = 'Trained Soldier'
}
SimPermut.enchantCloak = {
  [0] 	 = 'Untouched',
  [5434] = '+200 Str',
  [5435] = '+200 Agi',
  [5436] = '+200 Int'
}
SimPermut.enchantRing = {
  [0] 	 = 'Untouched',
  [5427] = '+200 Crit',
  [5428] = '+200 Hast',
  [5429] = '+200 Mast',
  [5430] = '+200 Vers'
}
SimPermut.gemList = {
  [0] 	 = 'Untouched',
  [130219] = '+150 Crit',
  [130220] = '+150 Hast',
  [130222] = '+150 Mast',
  [130221] = '+150 Vers',
  [130246] = '+200 Str',
  [130247] = '+200 Agi',
  [130248] = '+200 Int'
}
SimPermut.Sets = {
  [0] = 'All',
  [2] = 'T19 2P',
  [4] = 'T19 4P'
}

SimPermut.HasTierSets = {
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
    }
  }

SimPermut.RelicSlots = {
	[127829] = {"Fel","Shadow","Fel"}, -- Havoc DH
	[128832] = {"Iron","Arcane","Fel"}, -- Vengeance DH

	[128402] = {"Blood","Shadow","Iron"}, -- Blood DK
	[128292] = {"Frost","Shadow","Frost"}, -- Frost DK
	[128403] = {"Fire","Shadow","Blood"}, -- Unholy DK

	[128858] = {"Arcane","Life","Arcane"}, -- Balance Druid
	[128860] = {"Frost","Blood","Life"}, -- Feral Druid
	[128821] = {"Fire","Blood","Life"}, -- Guardian Druid
	[128306] = {"Life","Frost","Life"}, -- Restoration Druid

	[128861] = {"Wind","Arcane","Iron"}, -- Beast Mastery Hunter
	[128826] = {"Wind","Blood","Life"}, -- Marksmanship Hunter
	[128808] = {"Wind","Iron","Blood"}, -- Survival Hunter

	[127857] = {"Arcane","Frost","Arcane"}, -- Arcane Mage
	[128820] = {"Fire","Arcane","Fire"}, -- Fire Mage
	[128862] = {"Frost","Arcane","Frost"}, -- Frost Mage

	[128938] = {"Life","Wind","Iron"}, -- Brewmaster Monk
	[128937] = {"Frost","Life","Wind"}, -- Mistweaver Monk
	[128940] = {"Wind","Iron","Wind"}, -- Windwalker Monk

	[128823] = {"Holy","Life","Holy"}, -- Holy Paladin
	[128866] = {"Holy","Iron","Arcane"}, -- Protection Paladin
	[120978] = {"Holy","Fire","Holy"}, -- Retribution Paladin

	[128868] = {"Holy","Shadow","Holy"}, -- Discipline Priest
	[128825] = {"Holy","Life","Holy"}, -- Holy Priest
	[128827] = {"Shadow","Blood","Shadow"}, -- Shadow Priest

	[128870] = {"Shadow","Iron","Blood"}, -- Assassination Rogue
	[128872] = {"Blood","Iron","Wind"}, -- Outlaw Rogue
	[128476] = {"Fel","Shadow","Fel"}, -- Subtlety Rogue

	[128935] = {"Wind","Frost","Wind"}, -- Elemental Shaman
	[128819] = {"Fire","Iron","Wind"}, -- Enhancement Shaman
	[128911] = {"Life","Frost","Life"}, -- Restoration Shaman

	[128942] = {"Shadow","Blood","Shadow"}, -- Affliction Warlock
	[128943] = {"Shadow","Fire","Fel"}, -- Demonology Warlock
	[128941] = {"Fel","Fire","Fel"}, -- Destruction Warlock

	[128910] = {"Iron","Blood","Shadow"}, -- Arms Warrior
	[128908] = {"Fire","Wind","Iron"}, -- Fury Warrior
	[128289] = {"Iron","Blood","Fire"}, -- Protection Warrior
}

SimPermut.RelicTypes = {
	["Blood"] = RELIC_SLOT_TYPE_BLOOD,
	["Shadow"] = RELIC_SLOT_TYPE_SHADOW,
	["Iron"] = RELIC_SLOT_TYPE_IRON,
	["Frost"] = RELIC_SLOT_TYPE_FROST,
	["Fire"] = RELIC_SLOT_TYPE_FIRE,
	["Fel"] = RELIC_SLOT_TYPE_FEL,
	["Arcane"] = RELIC_SLOT_TYPE_ARCANE,
	["Life"] = RELIC_SLOT_TYPE_LIFE,
	["Wind"] = RELIC_SLOT_TYPE_WIND,
	["Holy"] = RELIC_SLOT_TYPE_HOLY,
}


