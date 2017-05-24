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

SimPermut.ArtifactTableTraits = {
	-- Death Knight
	[128402] = {},
	[128292] = {[0]="Current trait",[135576]="Howling Blast dmg",[137399]="Obliterate crit dmg",[132806]="Armor",[147108]="Remorseless Winter dmg",[145370]="Frost dmg",[142512]="Obliterate generation",[133088]="Death Strike heal",[142310]="Razorice runeforge dmg",[133122]="Frost Strike+Obliterate dmg"},--Frost
	[128403] = {[0]="Current trait",[132319]="Dark Transformation duration",[133010]="Festering Strike dmg",[132987]="Max runic power & generation", [133107]="Fallen Crusader up",[133055]="Virulent Plague dmg",[141522]="Scourge Strike generation",[135571]="AMS & IF up",[143701]="AOE dmg down",[147756]="Death Coil dmg"},--Unholy
	-- Demon Hunter
	[127829] = {[0]="Current trait",[137476]="Throw Glaive dmg",[147755]="Metamorphosis CD",[147086]="Chaos Strike crit", [141255]="Fury generation when dodging",[139267]="Chaos Nova stun",[136687]="Eye Beam dmg",[144512]="Magic dmg reduction",[132337]="Max Fury",[133095]="Demon's Bite dmg"},--Havoc
	[128832] = {},
	-- Druid
	[128858] = {[0]="Current trait",[133030]="Stellar Empowerment dmg",[132799]="Heal on dmg",[140813]="Lunar Strike crit",[142176]="Empowerments bonus dmg",[147076]="Sunfire dmg",[132305]="Moonfire dmg",[142175]="Solar Wrath dmg",[132984]="Starsurge crit",[141272]="Moonkin Form armor"},--Balance/
	[128860] = {[0]="Current trait",[139263]="Rake dmg",[141290]="Swipe dmg",[143803]="Shred crit",[133047]="Survival Instinct duration",[142309]="Tiger's Fury generation",[144458]="Berserk dmg bonus",[138228]="Rip dmg",[140838]="Ferocious Bite crit dmg",[134079]="Regrowth heal"},--Feral
	[128821] = {},
	[128306] = {},
	-- Hunter
	-- [128861] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Beast Mastery
	-- [128826] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Marksmanship
	-- [128808] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Survival
	-- Mage
	-- [127857] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Arcane
	-- [128820] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Fire
	-- [128862] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Frost
	-- Monk
	[128938] = {},
	[128937] = {[0]="Current trait",[133016]="Rising Sun Kick dmg",[132993]="Touch of Death CD",[137468]="Dodge up",[146932]="Fist of Fury dmg",[144531]="Max Energy up",[137365]="Tiger Palm dmg",[132808]="Transcendence heal",[141514]="Spinning Crane Kick dmg",[137421]="Blackout Kick no chi"},--Windwalker/
	[128940] = {},
	-- Paladin
	[128823] = {},
	[128866] = {},
	[120978] = {[0]="Current trait",[140411]="Divine Storm dmg",[135572]="Templar's Verdict dmg",[147097]="Blade of Justice dmg",[143695]="Crusader Strike crit",[147758]="Judgment dmg",[136717]="Avenging Wrath duration",[137402]="Shield of Vengeance CD",[140042]="Blessing of Protection CD",[137548]="Flash of Light heal"},--Retribution
	-- Priest
	[128868] = {},
	[128825] = {},
	[128827] = {[0]="Current trait",[135576]="Shadow Word Pain dmg",[133100]="Vampiric Touch dmg",[152512]="Shadow dmg",[141518]="Mind Blast dmg",[133026]="Vampiric Touch Apparition",[132783]="Shadow Word Death dmg",[142310]="Mind Sear dmg",[133088]="Dispersion CD",[132806]="ShadowMeld heal"},--Shadow
	-- Rogue
	-- [128870] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Assassination
	-- [128872] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Outlaw
	-- [128476] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Subtlety
	-- Shaman
	[128935] = {[0]="Current trait",[133682]="Flame Shock dmg",[146932]="Chain Lightning dmg",[133016]="EarthQuake dmg",[141514]="Lava Burst crit dmg",[137365]="Lava Burst dmg",[144531]="Nature dmg",[137421]="Earth Shock dmg",[132808]="Heal when low",[137468]="Healing Surge Heal"},--Elemental
	[128819] = {[0]="Current trait",[141522]="Stormstrike dmg",[132987]="Attack speed bonus",[133107]="Rockbiter generation",[133055]="Windfury dmg",[147756]="Flametongue/Rockbiter/Frostband dmg",[133010]="Lava Lash dmg",[132319]="Ghost wolf generation",[143701]="Astral Shift heal",[135571]="Healing Surge heal"},--Enhancement
	[128911] = {},
	-- Warlock
	-- [128942] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Affliction
	-- [128943] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Demonology
	-- [128941] = {[0]="Current trait",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]="",[]=""},--Destruction
	-- Warrior
	[128910] = {[0]="Current trait",[133122]="Cleave +Whirlwind dmg",[147108]="Whirlwind dmg",[135576]="Slam dmg",[142512]="Tactician's chance bonus",[133100]="Execute crit dmg",[142310]="Mortal Strike&Execute cost",[145370]="Rage max up",[143823]="Heroic Leap +armor",[132806]="Mortal Strike heal"},--Arms
	[128908] = {[0]="Current trait",[132781]="Rampage dmg",[147101]="Furious Slash dmg",[133075]="Execute crit chance",[144522]="Raging blow dmg",[134081]="Enrage dmg bonus",[140815]="Battle cry crit",[133763]="Charge rage bonus",[147759]="Enrage health bonus",[133120]="Bloodthirst heal"},--Fury
	[128289] = {}
}

SimPermut.ArtifactTableTraitsOrder = {
	-- Death Knight
	[128402] = {},
	[128292] = {0,135576,145370,133122,137399,142512,142310,147108,132806,133088},--Frost
	[128403] = {0,133055,133107,133010,132319,141522,132987,147756,135571,143701},--Unholy
	-- Demon Hunter
	[127829] = {0,147086,137476,147755,132337,136687,133095,141255,139267,144512},--Havoc
	[128832] = {},
	-- Druid
	[128858] = {0,132984,142175,140813,142176,147076,132305,133030,141272,132799},--Balance
	[128860] = {0,139263,138228,142309,143803,144458,141290,140838,133047,134079},--Feral
	[128821] = {},
	[128306] = {},
	-- Hunter
	-- [128861] = {0,},--Beast Mastery
	-- [128826] = {0,},--Marksmanship
	-- [128808] = {0,},--Survival
	-- Mage
	-- [127857] = {0,},--Arcane
	-- [128820] = {0,},--Fire
	-- [128862] = {0,},--Frost
	-- Monk
	[128938] = {},
	[128937] = {0,133016,146932,144531,137365,137421,141514,132993,137468,132808},--Windwalker
	[128940] = {},
	-- Paladin
	[128823] = {},
	[128866] = {},
	[120978] = {0,136717,140411,147097,135572,147758,143695,137402,140042,137548},--Retribution
	-- Priest
	[128868] = {},
	[128825] = {},
	[128827] = {0,135576,133100,152512,141518,133026,132783,142310,133088,132806},--Shadow
	-- Rogue
	-- [128870] = {0,},--Assassination
	-- [128872] = {0,},--Outlaw
	-- [128476] = {0,},--Subtlety
	-- Shaman
	[128935] = {0,137365,141514,144531,133682,137421,146932,133016,132808,137468},--Elemental
	[128819] = {0,132987,133010,133107,141522,133055,147756,132319,143701,135571},--Enhancement
	[128911] = {0,},
	-- Warlock
	-- [128942] = {0,},--Affliction
	-- [128943] = {0,},--Demonology
	-- [128941] = {0,},--Destruction
	-- Warrior
	[128910] = {0,142512,142310,145370,147108,133122,135576,133100,143823,132806},--Arms
	[128908] = {0,140815,134081,144522,132781,147101,133075,133763,147759,133120},--Fury
	[128289] = {}
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

SimPermut.FrameMenu={
	[1]	= "Gear permutation",
	[2] = "Talent permutation",
	[3] = "Relic permutation",
	[4] = "Options"
}

SimPermut.enchantNeck = {
	[0] 	= 'Untouched',
	[5891] 	= 'Ancient Priestess',
	[5437] 	= 'Claw',
	[5438] 	= 'Distant Army',
	[5889] 	= 'Heavy Hide',
	[5439] 	= 'Hidden Satyr',
	[5890] 	= 'Trained Soldier'
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
  [5428] = '+200 Haste',
  [5429] = '+200 Mast',
  [5430] = '+200 Vers'
}
SimPermut.gemList = {
  [0] 	 = 'Untouched',
  [130219] = '+150 Crit',
  [130220] = '+150 Haste',
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
SimPermut.ReportType = {
  [1] = 'Item names',
  [2] = 'Copy number'
}
SimPermut.RelicComparisonType = {
  [1] = 'relic ilevel',
  [2] = 'weapon ilevel'
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





