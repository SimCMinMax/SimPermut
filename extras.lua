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
	
	-- Artifact Data
	ArtifactTable = {
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
	[128911] = 42,
	-- Warlock
	[128942] = 39,
	[128943] = 37,
	[128941] = 38,
	-- Warrior
	[128910] = 36,
	[128908] = 35,
	[128289] = 11
},
	ArtifactTableTraits = {
		-- Death Knight
			--Blood
		[128402] = {},
			--Frost (Frost, Shadow, Frost)-
		[128292] = {
		{[0]="Current trait",[136692]="Howling Blast dmg",[142515]="Frost dmg",[137308]="Frost Strike+Obliterate dmg",[132791]="Obliterate crit dmg",[141267]="Obliterate generation",[132849]="Razorice runeforge dmg",[142308]="Remorseless Winter dmg",[137545]="Armor",[133141]="Death Strike heal"},
		{[0]="Current trait",[135576]="Howling Blast dmg",[145370]="Frost dmg",[133122]="Frost Strike+Obliterate dmg",[137399]="Obliterate crit dmg",[142512]="Obliterate generation",[142310]="Razorice runeforge dmg",[147108]="Remorseless Winter dmg",[132806]="Armor",[133088]="Death Strike heal"},
		{[0]="Current trait",[136692]="Howling Blast dmg",[142515]="Frost dmg",[137308]="Frost Strike+Obliterate dmg",[132791]="Obliterate crit dmg",[141267]="Obliterate generation",[132849]="Razorice runeforge dmg",[142308]="Remorseless Winter dmg",[137545]="Armor",[133141]="Death Strike heal"}},
			--Unholy (Fire, Shadow, Blood)-
		[128403] = {
		{[0]="Current trait",[133055]="Virulent Plague dmg",[133107]="Fallen Crusader bnus",[133010]="Festering Strike dmg",[132319]="Dark Transformation duration",[141522]="Scourge Strike generation",[132987]="Max runic power & generation",[147756]="Death Coil dmg",[135571]="AMS & IF bonus",[143701]="AOE dmg reduction"},
		{[0]="Current trait",[135576]="Virulent Plague dmg",[142310]="Fallen Crusader bnus",[133122]="Festering Strike dmg",[142512]="Dark Transformation duration",[133100]="Scourge Strike generation",[132783]="Max runic power & generation",[145370]="Death Coil dmg",[133088]="AMS & IF bonus",[132806]="AOE dmg reduction"},
		{[0]="Current trait",[139260]="Virulent Plague dmg",[141523]="Fallen Crusader bnus",[133008]="Festering Strike dmg",[147082]="Festering Wound dmg",[133127]="Dark Transformation duration",[143524]="Scourge Strike generation",[132985]="Max runic power & generation",[133020]="Death Coil dmg",[141264]="AMS & IF bonus",[137471]="AOE dmg reduction"}},
		-- Demon Hunter
			--Havoc (Fel, Shadow, Fel)-
		[127829] = {
		{[0]="Current trait",[147086]="Chaos Strike crit dmg",[137476]="Throw Glaive dmg",[147085]="Eye Beam cost reduction",[147755]="Metamorphosis CD",[132337]="Max Fury",[136687]="Eye Beam dmg",[133095]="Demon's Bite dmg",[141255]="Fury generation when dodging",[139267]="Chaos Nova stun",[144512]="Magic dmg reduction"},
		{[0]="Current trait",[133122]="Chaos Strike crit dmg",[147108]="Throw Glaive dmg",[142310]="Metamorphosis CD",[145370]="Max Fury",[135576]="Eye Beam dmg",[133100]="Demon's Bite dmg",[132806]="Fury generation when dodging",[142512]="Chaos Nova stun",[133088]="Magic dmg reduction"},
		{[0]="Current trait",[147086]="Chaos Strike crit dmg",[137476]="Throw Glaive dmg",[147085]="Eye Beam cost reduction",[147755]="Metamorphosis CD",[132337]="Max Fury",[136687]="Eye Beam dmg",[133095]="Demon's Bite dmg",[141255]="Fury generation when dodging",[139267]="Chaos Nova stun",[144512]="Magic dmg reduction"}},
			--Vengeance
		[128832] = {{},{},{}},
		-- Druid
			--MK (Arcane, Life, Arcane)-
		[128858] = {
		{[0]="Current trait",[132984]="Starsurge crit chance",[142175]="Solar Wrath dmg",[140813]="Lunar Strike crit",[142176]="Empowerments bonus dmg",[147076]="Sunfire dmg",[132305]="Moonfire dmg",[147079]="Starfall dmg",[133030]="Stellar Empowerment dmg",[132799]="Heal on dmg",[141272]="Moonkin Form armor"},
		{[0]="Current trait",[142309]="Starsurge crit chance",[143702]="Solar Wrath dmg",[138228]="Lunar Strike crit",[144458]="Empowerments bonus dmg",[147076]="Sunfire dmg",[143803]="Moonfire dmg",[139263]="Stellar Empowerment dmg",[134079]="Heal on dmg",[133047]="Moonkin Form armor"},
		{[0]="Current trait",[132984]="Starsurge crit chance",[142175]="Solar Wrath dmg",[140813]="Lunar Strike crit",[142176]="Empowerments bonus dmg",[147076]="Sunfire dmg",[132305]="Moonfire dmg",[147079]="Starfall dmg",[133030]="Stellar Empowerment dmg",[132799]="Heal on dmg",[141272]="Moonkin Form armor"}},
			--feral (Frost, Blood, Life)-
		[128860] = {
		{[0]="Current trait",[132791]="Rake dmg",[142515]="Rip dmg",[142308]="Tiger's Fury generation",[137308]="Shred crit chance",[141267]="Berserk dmg bonus",[132849]="Swipe dmg",[136692]="Ferocious Bite crit dmg",[133141]="Survival Instinct duration",[137545]="Regrowth heal"},
		{[0]="Current trait",[143524]="Rake dmg",[133020]="Rip dmg",[147082]="Trash dmg",[132985]="Tiger's Fury generation",[133008]="Shred crit chance",[133127]="Berserk dmg bonus",[141523]="Swipe dmg",[139260]="Ferocious Bite crit dmg",[141264]="Survival Instinct duration",[132800]="Regrowth heal"},
		{[0]="Current trait",[139263]="Rake dmg",[138228]="Rip dmg",[142309]="Tiger's Fury generation",[143803]="Shred crit chance",[144458]="Berserk dmg bonus",[141290]="Swipe dmg",[140838]="Ferocious Bite crit dmg",[133047]="Survival Instinct duration",[134079]="Regrowth heal"}},
			--Guardian
		[128821] = {{},{},{}},
			--Restoration
		[128306] = {{},{},{}},
		-- Hunter
			--BM (Storm, Arcane, Iron)-
		[128861] = {
		{[0]="Current trait",[141514]="Cobra Shot dmg",[132993]="Multi-Shot dmg",[146932]="Kill command bonus dmg",[144531]="Aspect of the wild duration",[147112]="Cobra Shot focus reduc",[133016]="Beast Cleave dmg",[137365]="Kill command dmg",[137421]="Bestial Wrath bonus dmg",[132808]="Dodge",[136471]="Aspect of the Turtle heal"},
		{[0]="Current trait",[133030]="Cobra Shot dmg",[132984]="Multi-Shot dmg",[147076]="Kill command bonus dmg",[140813]="Aspect of the wild duration",[147079]="Cobra Shot focus reduc",[132305]="Beast Cleave dmg",[142175]="Kill command dmg",[142176]="Bestial Wrath bonus dmg",[137490]="Dodge",[133081]="Aspect of the Turtle heal"},
		{[0]="Current trait",[133763]="Cobra Shot dmg",[132781]="Multi-Shot dmg",[140815]="Kill command bonus dmg",[133075]="Aspect of the wild duration",[147101]="Beast Cleave dmg",[144522]="Kill command dmg",[134081]="Bestial Wrath bonus dmg",[133120]="Dodge",[147759]="Aspect of the Turtle heal"}},
			--MM (Storm, Blood, Life)-
		[128826] = {
		{[0]="Current trait",[132303]="Aimed Shot crit Vulnerable",[144531]="Aimed Shot crit dmg",[147112]="Vulnerability effect",[133016]="Marked Shot dmg",[141514]="Marked Shot crit chance",[132993]="Multi Shot dmg",[137365]="Trueshot CD",[137421]="Bursting Shot CD",[132808]="Disengage dmg reduc",[137468]="Aspect of the Turtle heal"},
		{[0]="Current trait",[141523]="Aimed Shot crit Vulnerable",[133020]="Aimed Shot crit dmg",[147082]="Vulnerability effect",[133008]="Marked Shot dmg",[143524]="Marked Shot crit chance",[132985]="Multi Shot dmg",[139260]="Trueshot CD",[133127]="Bursting Shot CD",[132800]="Disengage dmg reduc",[141264]="Aspect of the Turtle heal"},
		{[0]="Current trait",[141290]="Aimed Shot crit Vulnerable",[138228]="Aimed Shot crit dmg",[143803]="Marked Shot dmg",[140078]="Marked Shot crit chance",[142309]="Multi Shot dmg",[140838]="Trueshot CD",[144458]="Bursting Shot CD",[134079]="Disengage dmg reduc",[136973]="Aspect of the Turtle heal"}},
			--Sv (Storm, Iron, Blood)-
		[128808] = {
		{[0]="Current trait",[144531]="Mongoose Bite dmg",[147112]="Mongoose Bite crit dmg",[137421]="Carve dmg",[132993]="Raptor Strike dmg",[133016]="Flanking Strike crit chance",[146932]="Explosive Trap dmg",[137365]="Lacerate dmg",[141514]="Pet's haste",[132808]="Exhilaration CD",[137468]="Raptor Strike heal"},
		{[0]="Current trait",[133075]="Mongoose Bite dmg",[134081]="Carve dmg",[132781]="Raptor Strike dmg",[147101]="Flanking Strike crit chance",[140815]="Explosive Trap dmg",[144522]="Lacerate dmg",[133763]="Pet's haste",[133120]="Exhilaration CD",[147759]="Raptor Strike heal"},
		{[0]="Current trait",[133020]="Mongoose Bite dmg",[147082]="Mongoose Bite crit dmg",[133127]="Carve dmg",[132985]="Raptor Strike dmg",[133008]="Flanking Strike crit chance",[141523]="Explosive Trap dmg",[139260]="Lacerate dmg",[143524]="Pet's haste",[132800]="Exhilaration CD",[141264]="Raptor Strike heal"}},
		-- Mage
			--Arcane (Arcane, Frost, Arcane)-
		[127857] = {
		{[0]="Current trait",[147076]="Arcane Missile proc",[142175]="Crit chance",[132305]="Arcane Blast dmg",[132995]="Arcane Missile dmg",[147079]="Arcane Missile crit chance",[133030]="Arcane Explosion dmg",[132984]="Arcane Power duration",[140813]="Arcane Barrage dmg",[141272]="Displacement CD",[137490]="Prismatic Barrier absorb"},
		{[0]="Current trait",[132849]="Arcane Missile proc",[136692]="Crit chance",[137308]="Arcane Blast dmg",[141267]="Arcane Missile dmg",[132791]="Arcane Explosion dmg",[142308]="Arcane Power duration",[142515]="Arcane Barrage dmg",[133141]="Displacement CD",[137545]="Prismatic Barrier absorb"},
		{[0]="Current trait",[147076]="Arcane Missile proc",[142175]="Crit chance",[132305]="Arcane Blast dmg",[132995]="Arcane Missile dmg",[147079]="Arcane Missile crit chance",[133030]="Arcane Explosion dmg",[132984]="Arcane Power duration",[140813]="Arcane Barrage dmg",[141272]="Displacement CD",[137490]="Prismatic Barrier absorb"}},
			--Fire (Fire, Arcane, Fire)-
		[128820] = {
		{[0]="Current trait",[133107]="Ignite dmg",[133055]="Fire crit dmg",[132319]="Pyroblast dmg",[141522]="Fireball dmg",[132987]="Flamestrike dmg",[133010]="Fire Blast dmg",[132338]="Fire Ball cast time",[143701]="Blazing Barrier reduc",[135571]="Blink heal"},
		{[0]="Current trait",[147076]="Ignite dmg",[142175]="Fire crit dmg",[142176]="Pyroblast dmg",[147079]="Combustion duration",[133030]="Fireball dmg",[132984]="Flamestrike dmg",[132305]="Fire Blast dmg",[140813]="Fire Ball cast time",[137490]="Blazing Barrier reduc",[141272]="Blink heal"},
		{[0]="Current trait",[133107]="Ignite dmg",[133055]="Fire crit dmg",[132319]="Pyroblast dmg",[141522]="Fireball dmg",[132987]="Flamestrike dmg",[133010]="Fire Blast dmg",[132338]="Fire Ball cast time",[143701]="Blazing Barrier reduc",[135571]="Blink heal"}},
			--Frost (Frost, Arcane, Frost)-
		[128862] = {
		{[0]="Current trait",[136692]="Ice Lance crit dmg",[132791]="Icy veins CD",[137308]="Flurry dmg",[132849]="Brain Freeze proc",[142515]="Frostbolt dmg",[141267]="Blizzard crit chance",[142308]="Frozen Orb crit dmg",[133141]="Ice Barrier absorb",[137545]="Ice Lance dmg reduc"},
		{[0]="Current trait",[142175]="Ice Lance crit dmg",[133030]="Icy veins CD",[132305]="Flurry dmg",[147079]="Ice Lance vs Frost dmg",[147076]="Brain Freeze proc",[140813]="Frostbolt dmg",[142176]="Blizzard crit chance",[132984]="Frozen Orb crit dmg",[141272]="Ice Barrier absorb",[137490]="Ice Lance dmg reduc"},
		{[0]="Current trait",[136692]="Ice Lance crit dmg",[132791]="Icy veins CD",[137308]="Flurry dmg",[132849]="Brain Freeze proc",[142515]="Frostbolt dmg",[141267]="Blizzard crit chance",[142308]="Frozen Orb crit dmg",[133141]="Ice Barrier absorb",[137545]="Ice Lance dmg reduc"}},
		-- Monk
			--Brew
		[128938] = {{},{},{}},
			--WW (Storm, Iron, Storm)-
		[128940] = {
		{[0]="Current trait",[133016]="Rising Sun Kick dmg",[146932]="Fist of Fury dmg",[147112]="Storm Earth and Fire CD",[144531]="Max Energy up",[137365]="Tiger Palm dmg",[137421]="Blackout Kick no chi",[141514]="Spinning Crane Kick dmg",[132993]="Touch of Death CD",[137468]="Dodge up",[132808]="Transcendence heal"},
		{[0]="Current trait",[147101]="Rising Sun Kick dmg",[140815]="Fist of Fury dmg",[133075]="Max Energy up",[144522]="Tiger Palm dmg",[134081]="Blackout Kick no chi",[133763]="Spinning Crane Kick dmg",[132781]="Touch of Death CD",[147759]="Dodge up",[133120]="Transcendence heal"},
		{[0]="Current trait",[133016]="Rising Sun Kick dmg",[146932]="Fist of Fury dmg",[147112]="Storm Earth and Fire CD",[144531]="Max Energy up",[137365]="Tiger Palm dmg",[137421]="Blackout Kick no chi",[141514]="Spinning Crane Kick dmg",[132993]="Touch of Death CD",[137468]="Dodge up",[132808]="Transcendence heal"}},
			--Mist
		[128937] = {{},{},{}},
		-- Paladin
			--Holy
		[128823] = {{},{},{}},
			--Prot
		[128866] = {{},{},{}},
			--Ret (Holy, Fire, Holy)-
		[120978] = {
		{[0]="Current trait",[136717]="Avenging Wrath duration",[140411]="Divine Storm dmg",[147097]="Blade of Justice dmg",[147098]="Holy Power for Blade of Justice dmg",[135572]="Templar's Verdict dmg",[147758]="Judgment dmg",[143695]="Crusader Strike crit chance",[137402]="Shield of Vengeance CD",[140042]="Blessing of Protection CD",[137548]="Flash of Light heal"},
		{[0]="Current trait",[132987]="Avenging Wrath duration",[133055]="Divine Storm dmg",[141522]="Blade of Justice dmg",[133107]="Templar's Verdict dmg",[147756]="Judgment dmg",[133010]="Crusader Strike crit chance",[143701]="Shield of Vengeance CD",[132319]="Blessing of Protection CD",[135571]="Flash of Light heal"},
		{[0]="Current trait",[136717]="Avenging Wrath duration",[140411]="Divine Storm dmg",[147097]="Blade of Justice dmg",[147098]="Holy Power for Blade of Justice dmg",[135572]="Templar's Verdict dmg",[147758]="Judgment dmg",[143695]="Crusader Strike crit chance",[137402]="Shield of Vengeance CD",[140042]="Blessing of Protection CD",[137548]="Flash of Light heal"}},
		-- Priest
			--Disc
		[128868] = {{},{},{}},
			--Holy
		[128825] = {{},{},{}},
			--SP (Shadow, Blood, Shadow)-
		[128827] ={ 
		{[0]="Current trait",[133100]="Vampiric Touch dmg",[135576]="Shadow Word Pain dmg",[152512]="Shadow dmg",[141518]="Mind Blast dmg",[133026]="Vampiric Touch Apparition",[132783]="Shadow Word Death dmg",[142310]="Mind Sear dmg",[133088]="Dispersion CD",[132806]="ShadowMend heal"}, 
		{[0]="Current trait",[147082]="Shadowfiend duration",[143524]="Vampiric Touch dmg",[139260]="Shadow Word Pain dmg",[133127]="Shadow dmg",[133008]="Mind Blast dmg",[133020]="Vampiric Touch Apparition",[132985]="Shadow Word Death dmg",[136718]="Mind Sear dmg",[141264]="Dispersion CD",[132800]="ShadowMend heal"},
		{[0]="Current trait",[133100]="Vampiric Touch dmg",[135576]="Shadow Word Pain dmg",[152512]="Shadow dmg",[141518]="Mind Blast dmg",[133026]="Vampiric Touch Apparition",[132783]="Shadow Word Death dmg",[142310]="Mind Sear dmg",[133088]="Dispersion CD",[132806]="ShadowMend heal"}},
		-- Rogue
			--Assa (Shadow, Iron, Blood)-
		[128870] = {
		{[0]="Current trait",[142310]="Vendetta CD",[133100]="Rupture dmg",[145370]="Envenom dmg",[147108]="Mutilate crit chance",[133120]="Rupture crit chance",[142512]="Fan of Knives proc",[135576]="Poisons dmg",[132806]="Sprint CD",[133088]="Cloak of Shadows CDs"},
		{[0]="Current trait",[140815]="Vendetta CD",[133763]="Rupture dmg",[133075]="Envenom dmg",[132781]="Mutilate crit chance",[147101]="Rupture crit chance",[134081]="Fan of Knives proc",[144522]="Poisons dmg",[133120]="Sprint CD",[147759]="Cloak of Shadows CDs"},
		{[0]="Current trait",[141523]="Vendetta CD",[143524]="Rupture dmg",[133020]="Envenom dmg",[147082]="Garrote dmg",[132985]="Mutilate crit chance",[133008]="Rupture crit chance",[133127]="Fan of Knives proc",[143691]="Poisons dmg",[137471]="Sprint CD",[141264]="Cloak of Shadows CDs"}},
			--Outlaw (Blood, Iron, Storm)-
		[128872] = {
		{[0]="Current trait",[139260]="Run through dmg",[143524]="Finishing moves cost",[141523]="Combat Potency generation",[147082]="Saber Slash crit dmg",[133008]="Blade Furry regeneration",[133127]="Adrenaline Rush CD",[132985]="Pistol Shot crit chance",[133020]="Between the Eyes dmg",[141264]="Main Gauche dmg",[132800]="Cloak of Shadows heal"},
		{[0]="Current trait",[144522]="Run through dmg",[133098]="Finishing moves cost",[140815]="Combat Potency generation",[141288]="Blade Furry regeneration",[134081]="Adrenaline Rush CD",[132781]="Pistol Shot crit chance",[142061]="Between the Eyes dmg",[147759]="Main Gauche dmg",[133120]="Cloak of Shadows heal"},
		{[0]="Current trait",[141278]="Run through dmg",[133039]="Finishing moves cost",[146932]="Combat Potency generation",[147112]="Saber Slash crit dmg",[133016]="Blade Furry regeneration",[137421]="Adrenaline Rush CD",[132993]="Pistol Shot crit chance",[144531]="Between the Eyes dmg",[137468]="Main Gauche dmg",[132808]="Cloak of Shadows heal"}},
			--Sub (Fel, Shadow, Fel)-
		[128476] = {
		{[0]="Current trait",[139267]="Cheap Shot refund",[136687]="Eviscerate crit chance",[147086]="Nightblade dmg",[137476]="Shadowstrike dmg",[147085]="Backstab+Shadowstrike dmg",[147755]="Shadow Blades duration",[133117]="Shadow Technique generation",[132337]="Backstab dmg",[144512]="Dodge+immune fall",[141255]="Dodge"},
		{[0]="Current trait",[142512]="Cheap Shot refund",[135576]="Eviscerate crit chance",[141518]="Nightblade dmg",[147108]="Shadowstrike dmg",[142310]="Shadow Blades duration",[133100]="Shadow Technique generation",[145370]="Backstab dmg",[143823]="Dodge+immune fall",[132806]="Dodge"},
		{[0]="Current trait",[139267]="Cheap Shot refund",[136687]="Eviscerate crit chance",[147086]="Nightblade dmg",[137476]="Shadowstrike dmg",[147085]="Backstab+Shadowstrike dmg",[147755]="Shadow Blades duration",[133117]="Shadow Technique generation",[132337]="Backstab dmg",[144512]="Dodge+immune fall",[141255]="Dodge"}},
		-- Shaman
			--Elem (Storm, Frost, Storm)-
		[128935] = {
		{[0]="Current trait",[137365]="Lava Burst dmg",[141514]="Lava Burst crit dmg",[144531]="Nature dmg",[133682]="Flame Shock dmg",[147112]="Elemental Fury bonus",[137421]="Earth Shock dmg",[146932]="Chain Lightning dmg",[133016]="EarthQuake dmg",[132808]="Heal when low",[137468]="Healing Surge Heal"},
		{[0]="Current trait",[136692]="Lava Burst dmg",[132791]="Lava Burst crit dmg",[142515]="Nature dmg",[142308]="Flame Shock dmg",[141267]="Earth Shock dmg",[132849]="Chain Lightning dmg",[137308]="EarthQuake dmg",[137545]="Heal when low",[137403]="Healing Surge Heal"},
		{[0]="Current trait",[137365]="Lava Burst dmg",[141514]="Lava Burst crit dmg",[144531]="Nature dmg",[133682]="Flame Shock dmg",[147112]="Elemental Fury bonus",[137421]="Earth Shock dmg",[146932]="Chain Lightning dmg",[133016]="EarthQuake dmg",[132808]="Heal when low",[137468]="Healing Surge Heal"}},
			--Enh (Fire, Iron, Storm)-
		[128819] = {
		{[0]="Current trait",[132987]="Attack speed bonus",[133010]="Lava Lash dmg",[133107]="Rockbiter generation",[141522]="Stormstrike dmg",[133055]="Windfury dmg",[147756]="Flametongue/Rockbiter/Frostband dmg",[132319]="Ghost wolf generation",[143701]="Astral Shift heal",[135571]="Healing Surge heal"},
		{[0]="Current trait",[132781]="Attack speed bonus",[147101]="Lava Lash dmg",[140815]="Rockbiter generation",[133763]="Stormstrike dmg",[144522]="Windfury dmg",[133075]="Flametongue/Rockbiter/Frostband dmg",[134081]="Ghost wolf generation",[133120]="Astral Shift heal",[147759]="Healing Surge heal"},
		{[0]="Current trait",[132993]="Attack speed bonus",[133016]="Lava Lash dmg",[146932]="Rockbiter generation",[141514]="Stormstrike dmg",[147112]="Crashing Light dmg",[137365]="Windfury dmg",[144531]="Flametongue/Rockbiter/Frostband dmg",[137421]="Ghost wolf generation",[132808]="Astral Shift heal",[137468]="Healing Surge heal"}},
			--Rest
		[128911] = {{},{},{}},
		-- Warlock
			--Affli (Shadow, Blood, Shadow)-
		[128942] = {
		{[0]="Current trait",[142310]="Crit dmg",[142512]="Shadow dmg",[147108]="Unstable Affliction crit chance",[145370]="Agony dmg",[133122]="Corruption dmg",[135576]="Drain life dmg",[133100]="Seed of Corruption dmg",[133088]="Soul Leech absorb",[132806]="Drain Life heal"},
		{[0]="Current trait",[136718]="Crit dmg",[133127]="Shadow dmg",[132985]="Unstable Affliction crit chance",[147082]="Dots crit chance",[133020]="Agony dmg",[133008]="Corruption dmg",[139260]="Drain life dmg",[143524]="Seed of Corruption dmg",[141264]="Soul Leech absorb",[132800]="Drain Life heal"},
		{[0]="Current trait",[142310]="Crit dmg",[142512]="Shadow dmg",[147108]="Unstable Affliction crit chance",[145370]="Agony dmg",[133122]="Corruption dmg",[135576]="Drain life dmg",[133100]="Seed of Corruption dmg",[133088]="Soul Leech absorb",[132806]="Drain Life heal"}},
			--Demo (Shadow, Fire, Fel)-
		[128943] = {
		{[0]="Current trait",[142310]="Wild Imp's Firebolt dmg",[135576]="Doom dmg",[142512]="Shadow Bolt Crit chance",[145370]="Demonic Empowerment bonus",[147108]="Dreadstalkers crit chance",[133100]="Hand of Gul'dan dmg",[133122]="Demonwrath dmg",[132806]="Unending Resolve CD",[133088]="Soul Link heal"},
		{[0]="Current trait",[147091]="Wild Imp's Firebolt dmg",[133055]="Doom dmg",[132319]="Shadow Bolt Crit chance",[147756]="Demonic Empowerment bonus",[132987]="Dreadstalkers crit chance",[141522]="Hand of Gul'dan dmg",[133010]="Demonwrath dmg",[143701]="Unending Resolve CD",[135571]="Soul Link heal"},
		{[0]="Current trait",[147755]="Wild Imp's Firebolt dmg",[136687]="Doom dmg",[139267]="Shadow Bolt Crit chance",[132337]="Demonic Empowerment bonus",[137476]="Dreadstalkers crit chance",[133095]="Hand of Gul'dan dmg",[147085]="Pet dmg",[147086]="Demonwrath dmg",[141255]="Unending Resolve CD",[144512]="Soul Link heal"}},
			--Destru (Fel, Fire, Fel)-
		[128941] = {
		{[0]="Current trait",[147755]="Immolate crit chance",[137476]="Immolate dmg",[147086]="Chaos Bolt crit dmg",[136687]="Incinerate cast time",[132337]="Incinerate dmg",[133095]="Chaos Bolt refund",[147085]="Conflagrate dmg",[139267]="Rain of Fire dmg",[141255]="Life Tap dmg reduc",[144512]="Drain Life proc"},
		{[0]="Current trait",[133107]="Immolate crit chance",[132987]="Immolate dmg",[133010]="Chaos Bolt crit dmg",[133055]="Incinerate cast time",[147756]="Incinerate dmg",[141522]="Chaos Bolt refund",[132319]="Rain of Fire dmg",[143701]="Life Tap dmg reduc",[137375]="Drain Life proc"},
		{[0]="Current trait",[147755]="Immolate crit chance",[137476]="Immolate dmg",[147086]="Chaos Bolt crit dmg",[136687]="Incinerate cast time",[132337]="Incinerate dmg",[133095]="Chaos Bolt refund",[147085]="Conflagrate dmg",[139267]="Rain of Fire dmg",[141255]="Life Tap dmg reduc",[144512]="Drain Life proc"}},
		-- Warrior
			--Arms (Iron, Blood, Shadow)-
		[128910] = {
		{[0]="Current trait",[134081]="Tactician's chance bonus",[140815]="Mortal Strike&Execute crit chance",[133075]="Rage max up",[132781]="Whirlwind dmg",[147101]="Cleave+Whirlwind dmg",[144522]="Slam dmg",[133763]="Execute crit chance",[147759]="Heroic Leap +armor",[133120]="Mortal Strike heal"},
		{[0]="Current trait",[133127]="Tactician's chance bonus",[141523]="Mortal Strike&Execute crit chance",[147082]="Bladestorm dmg",[133020]="Rage max up",[132985]="Whirlwind dmg",[133008]="Cleave+Whirlwind dmg",[139260]="Slam dmg",[143524]="Execute crit chance",[141264]="Heroic Leap +armor",[132800]="Mortal Strike heal"},
		{[0]="Current trait",[142512]="Tactician's chance bonus",[142310]="Mortal Strike&Execute crit chance",[145370]="Rage max up",[147108]="Whirlwind dmg",[133122]="Cleave+Whirlwind dmg",[135576]="Slam dmg",[133100]="Execute crit chance",[143823]="Heroic Leap +armor",[132806]="Mortal Strike heal"}},
			--Fury (Fire, Storm, Iron)-
		[128908] = {
		{[0]="Current trait",[133107]="Battle cry crit dmg",[132319]="Enrage dmg bonus",[133055]="Raging blow dmg",[132987]="Rampage dmg",[133010]="Furious Slash dmg",[147756]="Execute crit chance",[141522]="Charge rage bonus",[135571]="Enrage health bonus",[143701]="Bloodthirst heal"},
		{[0]="Current trait",[146932]="Battle cry crit dmg",[137421]="Enrage dmg bonus",[137365]="Raging blow dmg",[132993]="Rampage dmg",[133016]="Furious Slash dmg",[144531]="Execute crit chance",[147112]="Raging Blow crit generation",[141514]="Charge rage bonus",[137468]="Enrage health bonus",[132808]="Bloodthirst heal"},
		{[0]="Current trait",[140815]="Battle cry crit dmg",[134081]="Enrage dmg bonus",[144522]="Raging blow dmg",[132781]="Rampage dmg",[147101]="Furious Slash dmg",[133075]="Execute crit chance",[133763]="Charge rage bonus",[147759]="Enrage health bonus",[133120]="Bloodthirst heal"}},
			--Prot
		[128289] = {{},{},{}}
	},
	ArtifactTableTraitsOrder = {
		-- Death Knight
		[128402] = {{},{},{}},
		[128292] = {{0,136692,142515,137308,132791,141267,132849,142308,137545,133141},{0,135576,145370,133122,137399,142512,142310,147108,132806,133088},{0,136692,142515,137308,132791,141267,132849,142308,137545,133141}},--Frost
		[128403] = {{0,133055,133107,133010,132319,141522,132987,147756,135571,143701},{0,135576,142310,133122,142512,133100,132783,145370,133088,132806},{0,139260,141523,133008,147082,133127,143524,132985,133020,141264,137471}},--Unholy
		-- Demon Hunter
		[127829] = {{0,147086,137476,147085,147755,132337,136687,133095,141255,139267,144512},{0,133122,147108,142310,145370,135576,133100,132806,142512,133088},{0,147086,137476,147085,147755,132337,136687,133095,141255,139267,144512}},--Havoc
		[128832] = {{},{},{}},
		-- Druid
		[128858] = {{0,132984,142175,140813,142176,147076,132305,147079,133030,141272,132799},{0,142309,143702,138228,144458,147076,143803,139263,134079,133047},{0,132984,142175,140813,142176,147076,132305,147079,133030,141272,132799}},--Balance
		[128860] = {{0,132791,142515,142308,137308,141267,132849,136692,133141,137545},{0,143524,133020,147082,132985,133008,133127,141523,139260,141264,132800},{0,139263,138228,142309,143803,144458,141290,140838,133047,134079}},--Feral
		[128821] = {{},{},{}},
		[128306] = {{},{},{}},
		-- Hunter
		[128861] = {{0,141514,132993,146932,144531,147112,133016,137365,137421,132808,136471},{0,133030,132984,147076,140813,147079,132305,142175,142176,137490,133081},{0,144522,140815,133763,132781,133075,147101,134081,133120,147759}},--Beast Mastery
		[128826] = {{0,132303,144531,147112,133016,141514,132993,137365,137421,132808,137468},{0,141523,133020,147082,133008,143524,132985,139260,133127,132800,141264},{0,141290,138228,143803,140078,142309,140838,144458,134079,136973}},--Marksmanship
		[128808] = {{0,144531,147112,137421,132993,133016,146932,137365,141514,132808,137468},{0,133075,134081,132781,147101,140815,144522,133763,133120,147759},{0,133020,147082,133127,132985,133008,141523,139260,143524,132800,141264}},--Survival
		-- Mage
		[127857] = {{0,147076,142175,132305,132995,147079,133030,132984,140813,141272,137490},{0,132849,136692,137308,141267,132791,142308,142515,133141,137545},{0,147076,142175,132305,132995,147079,133030,132984,140813,141272,137490}},--Arcane
		[128820] = {{0,133107,133055,132319,141522,132987,133010,132338,143701,135571},{0,147076,142175,142176,147079,133030,132984,132305,140813,137490,141272},{0,133107,133055,132319,141522,132987,133010,132338,143701,135571}},--Fire
		[128862] = {{0,136692,132791,137308,132849,142515,141267,142308,133141,137545},{0,142175,133030,132305,147079,147076,140813,142176,132984,141272,137490},{0,136692,132791,137308,132849,142515,141267,142308,133141,137545}},--Frost
		-- Monk
		[128938] = {{},{},{}},
		[128940] = {{0,133016,146932,147112,144531,137365,137421,141514,132993,137468,132808},{0,147101,140815,133075,144522,134081,133763,132781,147759,133120},{0,133016,146932,147112,144531,137365,137421,141514,132993,137468,132808}},--Windwalker
		[128937] = {{},{},{}},
		-- Paladin
		[128823] = {{},{},{}},
		[128866] = {{},{},{}},
		[120978] = {{0,136717,140411,147097,147098,135572,147758,143695,137402,140042,137548},{0,147082,132987,133055,141522,133107,147756,133010,143701,132319,135571},{0,136717,140411,147097,147098,135572,147758,143695,137402,140042,137548}},--Retribution
		-- Priest
		[128868] = {{},{},{}},
		[128825] = {{},{},{}},
		[128827] = {{0,133100,135576,152512,141518,133026,132783,142310,133088,132806},{0,147082,143524,139260,133127,133008,133020,132985,136718,141264,132800},{0,133100,135576,152512,141518,133026,132783,142310,133088,132806}},--Shadow
		-- Rogue
		[128870] = {{0,142310,133100,145370,147108,133120,142512,135576,132806,133088},{0,140815,133763,133075,132781,147101,134081,144522,133120,147759},{0,141523,143524,133020,147082,132985,133008,133127,143691,137471,141264}},--Assassination
		[128872] = {{0,139260,143524,141523,147082,133008,133127,132985,133020,141264,132800},{0,144522,133098,140815,141288,134081,132781,142061,147759,133120},{0,141278,133039,146932,147112,133016,137421,132993,144531,137468,132808}},--Outlaw
		[128476] = {{0,139267,136687,147086,137476,147085,147755,133117,132337,144512,141255},{0,142512,135576,141518,147108,142310,133100,145370,143823,132806},{0,139267,136687,147086,137476,147085,147755,133117,132337,144512,141255}},--Subtlety
		-- Shaman
		[128935] = {{0,137365,141514,144531,133682,147112,137421,146932,133016,132808,137468},{0,136692,132791,142515,142308,141267,132849,137308,137545,137403},{0,137365,141514,144531,133682,147112,137421,146932,133016,132808,137468}},--Elemental
		[128819] = {{0,132987,133010,133107,141522,133055,147756,132319,143701,135571},{0,132781,147101,140815,133763,144522,133075,134081,133120,147759},{0,132993,133016,146932,141514,147112,137365,144531,137421,132808,137468}},--Enhancement
		[128911] = {{},{},{}},
		-- Warlock
		[128942] = {{0,142310,142512,147108,145370,133122,135576,133100,133088,132806},{0,136718,133127,132985,147082,133020,133008,139260,143524,141264,132800},{0,142310,142512,147108,145370,133122,135576,133100,133088,132806}},--Affliction
		[128943] = {{0,142310,135576,142512,145370,147108,133100,133122,132806,133088},{0,147091,133055,132319,147756,132987,141522,133010,143701,135571},{0,137476,147755,136687,133095,147086,132337,139267,147085,141255,144512}},--Demonology
		[128941] = {{0,147755,137476,147086,136687,132337,133095,147085,139267,141255,144512},{0,133107,132987,133010,133055,147756,141522,132319,143701,137375},{0,147755,137476,147086,136687,132337,133095,147085,139267,141255,144512}},--Destruction
		-- Warrior
		[128910] = {{0,134081,140815,133075,132781,147101,144522,133763,147759,133120},{0,133127,141523,147082,133020,132985,133008,139260,143524,141264,132800},{0,142512,142310,145370,147108,133122,135576,133100,143823,132806}},--Arms
		[128908] = {{0,133107,132319,133055,132987,133010,147756,141522,135571,143701},{0,146932,137421,137365,132993,133016,144531,147112,141514,137468,132808},{0,140815,134081,144522,132781,147101,133075,133763,147759,133120}},--Fury
		[128289] = {{},{},{}}
	},
	NetherlightData={
	{
		[1739]="Netherlight Fortification"
	},
	{
		[1771]="Master of Shadows",
		[1774]="Murderous Intent",
		[1778]="Shadowbind",
		[1779]="Chaotic Darkness",
		[1780]="Torment the Weak",
		[1781]="Dark Sorrows",
		[1770]="Light Speed",
		[1775]="Refractive Shell",
		[1777]="Shocklight",
		[1782]="Secure in the Light",
		[1783]="Infusion of Light",
		[1784]="Lights Embrace",
	},
	{	-- Death Knight
			--Blood
		[128402] = {},
			--Frost (Frost, Shadow, Frost)-
		[128292] = {[109]="Howling Blast dmg",[108]="Frost dmg",[110]="Frost Strike+Obliterate dmg",[1485]="Runic Empowerment proc chance",[113]="Obliterate crit dmg",[111]="Obliterate generation",[114]="Razorice runeforge dmg",[117]="Remorseless Winter dmg",[1090]="Armor",[115]="Death Strike heal"},
			--Unholy (Fire, Shadow, Blood)-
		[128403] = {[158]="Virulent Plague dmg",[266]="Fallen Crusader up",[157]="Festering Strike dmg",[1489]="Festering Wound dmg",[1119]="Dark Transformation duration",[265]="Scourge Strike generation",[264]="Max runic power & generation",[156]="Death Coil dmg",[262]="AMS & IF bonus",[267]="AOE dmg reduction"},
		-- Demon Hunter
			--Havoc (Fel, Shadow, Fel)-
		[127829] = {[1001]="Chaos Strike crit dmg",[1003]="Throw Glaive dmg",[1493]="Eye Beam cost reduction",[1006]="Metamorphosis CD",[1000]="Max Fury",[1002]="Eye Beam dmg",[1004]="Demon's Bite dmg",[1007]="Fury generation when dodging",[1008]="Chaos Nova stun",[1005]="Magic dmg reduction"},
			--Vengeance
		[128832] = {},
		-- Druid
			--MK (Arcane, Life, Arcane)-
		[128858] = {[1039]="Starsurge crit chance",[1038]="Solar Wrath dmg",[1036]="Lunar Strike crit chance",[1042]="Empowerments bonus dmg",[1041]="Sunfire dmg",[1037]="Moonfire dmg",[1501]="Starfall dmg",[1040]="Stellar Empowerment dmg",[1035]="Heal on dmg",[1034]="Moonkin Form armor"},
			--feral (Frost, Blood, Life)-
		[128860] = {[1166]="Rake dmg",[1161]="Rip dmg",[1164]="Tiger's Fury generation",[1162]="Shred crit chance",[1167]="Berserk dmg bonus",[1168]="Swipe dmg",[1163]="Ferocious Bite crit dmg",[1160]="Survival Instinct duration",[1165]="Regrowth heal"},
			--Guardian
		[128821] = {},
			--Restoration
		[128306] = {},
		-- Hunter
			--BM (Storm, Arcane, Iron)-
		[128861] = {[873]="Cobra Shot dmg",[872]="Multi-Shot dmg",[875]="Kill command bonus dmg",[868]="Aspect of the wild duration",[1517]="Cobra Shot focus reduc",[869]="Beast Cleave dmg",[870]="Kill command dmg",[1095]="Bestial Wrath bonus dmg",[871]="Dodge",[874]="Aspect of the Turtle heal"},
			--MM (Storm, Blood, Life)-
		[128826] = {[319]="Aimed Shot crit Vulnerable",[312]="Aimed Shot crit dmg",[1521]="Vulnerability effectiveness",[313]="Marked Shot dmg",[318]="Marked Shot crit chance",[315]="Multi Shot dmg",[314]="Trueshot CD",[320]="Bursting Shot CD",[317]="Disengage dmg reduc",[316]="Aspect of the Turtle heal"},
			--Sv (Storm, Iron, Blood)-
		[128808] = {[1070]="Mongoose Bite dmg",[1525]="Mongoose Bite crit dmg",[1076]="Carve dmg",[1073]="Raptor Strike dmg",[1071]="Flanking Strike crit chance",[1075]="Explosive Trap dmg",[1072]="Lacerate dmg",[1074]="Pet's haste",[1078]="Exhilaration CD",[1077]="Raptor Strike heal"},
		-- Mage
			--Arcane (Arcane, Frost, Arcane)-
		[127857] = {[81]="Arcane Missile proc",[75]="Crit chance",[74]="Arcane Blast dmg",[79]="Arcane Missile dmg",[1529]="Arcane Missile crit chance",[77]="Arcane Explosion dmg",[82]="Arcane Power duration",[72]="Arcane Barrage dmg",[83]="Displacement CD",[84]="Prismatic Barrier absorb"},
			--Fire (Fire, Arcane, Fire)-
		[128820] = {[755]="Ignite dmg",[752]="Fire crit dmg",[751]="Pyroblast dmg",[1533]="Combustion duration",[754]="Fireball dmg",[753]="Flamestrike dmg",[750]="Fire Blast dmg",[749]="Fire Ball cast time",[757]="Blazing Barrier reduc",[756]="Blink heal"},
			--Frost (Frost, Arcane, Frost)-
		[128862] = {[786]="Ice Lance crit dmg",[788]="Icy veins CD",[785]="Flurry dmg",[1537]="Ice Lance vs Frozen dmg",[789]="Brain Freeze proc",[784]="Frostbolt dmg",[790]="Blizzard crit chance",[787]="Frozen Orb crit dmg",[791]="Ice Barrier absorb",[792]="Ice Lance dmg reduc"},
		-- Monk
			--Brew
		[128938] = {},
			--WW (Storm, Iron, Storm)-
		[128940] = {[820]="Rising Sun Kick dmg",[825]="Fist of Fury dmg",[1549]="Storm Earth and Fire CD",[800]="Max Energy up",[821]="Tiger Palm dmg",[1094]="Blackout Kick no chi",[824]="Spinning Crane Kick dmg",[822]="Touch of Death CD",[801]="Dodge up",[829]="Transcendence heal"},
			--Mist
		[128937] = {},
		-- Paladin
			--Holy
		[128823] = {},
			--Prot
		[128866] = {},
			--Ret (Holy, Fire, Holy)-
		[120978] = {[53]="Avenging Wrath duration",[43]="Divine Storm dmg",[50]="Blade of Justice dmg",[1561]="Holy Power for Blade of Justice dmg",[51]="Templar's Verdict dmg",[41]="Judgment dmg",[42]="Crusader Strike crit chance",[47]="Shield of Vengeance CD",[52]="Blessing of Protection CD",[44]="Flash of Light heal"},
		-- Priest
			--Disc
		[128868] = {},
			--Holy
		[128825] = {},
			--SP (Shadow, Blood, Shadow)-
		[128827] ={[1573]="Shadowfiend duration",[777]="Vampiric Touch dmg",[773]="Shadow Word Pain dmg",[776]="Shadow dmg",[772]="Mind Blast dmg",[767]="Vampiric Touch Apparition",[774]="Shadow Word Death dmg",[778]="Mind Sear dmg",[771]="Dispersion CD",[775]="ShadowMend heal"},
		-- Rogue
			--Assa (Shadow, Iron, Blood)-
		[128870] = {[330]="Vendetta CD",[328]="Rupture dmg",[323]="Envenom dmg",[1577]="Garrote dmg",[327]="Mutilate crit chance",[324]="Rupture crit chance",[331]="Fan of Knives proc",[325]="Poisons dmg",[329]="Sprint CD",[326]="Cloak of Shadows CDs"},
			--Outlaw (Blood, Iron, Storm)-
		[128872] = {[1061]="Run through dmg",[1064]="Finishing moves cost",[1065]="Combat Potency generation",[1581]="Saber Slash crit dmg",[1060]="Blade Furry regeneration",[1067]="Adrenaline Rush CD",[1063]="Pistol Shot crit chance",[1059]="Between the Eyes dmg",[1062]="Main Gauche dmg",[1066]="Cloak of Shadows heal"},
			--Sub (Fel, Shadow, Fel)-
		[128476] = {[858]="Cheap Shot refund",[854]="Eviscerate crit chance",[853]="Nightblade dmg",[855]="Shadowstrike dmg",[1585]="Backstab+Shadowstrike dmg",[857]="Shadow Blades duration",[856]="Shadow Technique generation",[852]="Backstab dmg",[859]="Dodge+immune fall",[860]="Dodge"},
		-- Shaman
			--Elem (Storm, Frost, Storm)-
		[128935] = {[300]="Lava Burst dmg",[303]="Lava Burst crit dmg",[298]="Nature dmg",[301]="Flame Shock dmg",[1589]="Elemental Fury bonus",[306]="Earth Shock dmg",[304]="Chain Lightning dmg",[299]="EarthQuake dmg",[305]="Heal when low",[302]="Healing Surge Heal"},
			--Enh (Fire, Iron, Storm)-
		[128819] = {[910]="Attack speed bonus",[906]="Lava Lash dmg",[913]="Rockbiter generation",[1351]="Stormstrike dmg",[912]="Crashing Light dmg",[908]="Windfury dmg",[905]="Flametongue/Rockbiter/Frostband dmg",[907]="Ghost wolf generation",[909]="Astral Shift heal",[911]="Healing Surge heal"},
			--Rest
		[128911] = {},
		-- Warlock
			--Affli (Shadow, Blood, Shadow)-
		[128942] = {[920]="Crit dmg",[921]="Shadow dmg",[918]="Unstable Affliction crit chance",[1601]="Dots crit chance",[915]="Agony dmg",[916]="Corruption dmg",[917]="Drain life dmg",[919]="Seed of Corruption dmg",[922]="Soul Leech absorb",[923]="Drain Life heal"},
			--Demo (Shadow, Fire, Fel)-
		[128943] = {[1176]="Wild Imp's Firebolt dmg",[1173]="Doom dmg",[1177]="Shadow Bolt Crit chance",[1171]="Demonic Empowerment bonus",[1174]="Dreadstalkers crit chance",[1175]="Hand of Gul'dan dmg",[1605]="Pet dmg",[1172]="Demonwrath dmg",[1179]="Unending Resolve CD",[1178]="Soul Link heal"},
			--Destru (Fel, Fire, Fel)-
		[128941] = {[809]="Immolate crit chance",[807]="Immolate dmg",[805]="Chaos Bolt crit dmg",[806]="Incinerate cast time",[804]="Incinerate dmg",[808]="Chaos Bolt refund",[1609]="Conflagrate dmg",[810]="Rain of Fire dmg",[812]="Life Tap dmg reduc",[811]="Drain Life proc"},
		-- Warrior
			--Arms (Iron, Blood, Shadow)-
		[128910] = {[1150]="Tactician's chance bonus",[1149]="Mortal Strike&Execute crit chance",[1613]="Bladestorm dmg",[1143]="Rage max up",[1146]="Whirlwind dmg",[1144]="Cleave+Whirlwind dmg",[1145]="Slam dmg",[1147]="Execute crit chance",[1148]="Heroic Leap +armor",[1151]="Mortal Strike heal"},
			--Fury (Fire, Storm, Iron)-
		[128908] = {[995]="Battle cry crit dmg",[996]="Enrage dmg bonus",[990]="Raging blow dmg",[991]="Rampage dmg",[989]="Furious Slash dmg",[988]="Execute crit chance",[1617]="Raging Blow crit generation",[992]="Charge rage bonus",[993]="Enrage health bonus",[994]="Bloodthirst heal"},
			--Prot
		[128289] = {}
	}
	},
	NetherlightSpellID={
		[1771]=252091,
		[1774]=252191,
		[1778]=252875,
		[1779]=252888,
		[1780]=252906,
		[1781]=252922,
		[1770]=252088,
		[1775]=252207,
		[1777]=252799,
		[1782]=253070,
		[1783]=253093,
		[1784]=253111
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
		[3] = "Artifact Generator",
		[4] = "Netherlight Crucible",
		[5] = "Add Items",
		[6] = "Options"
	},
	RelicComparisonType = {
	  [1] = 'relic ilevel',
	  [2] = 'weapon ilevel'
	},
	CrucibleComparisonType = {
	  [1] = 'One tree',
	  [2] = 'Full weapon',
	  [3] = 'Current Tree permutation'
	},
	CruciblePreviewType = {
	  [0] = 'Crucible traits only',
	  [1] = 'Replace relic slot 1',
	  [2] = 'Replace relic slot 2',
	  [3] = 'Replace relic slot 3'
	},
	CruciblePreviewTypeFull = {
	  [0] = 'Crucible traits only',
	  [1] = 'Replace relic traits'
	},
	CrucibleExtractPreviewType = {
	  [0] = 'This tree alone',
	  [1] = 'Replace relic slot 1',
	  [2] = 'Replace relic slot 2',
	  [3] = 'Replace relic slot 3'
	},
	ReportTypeGear = {
	  [1] = 'Item names',
	  [2] = 'Copy number'
	},
	ReportTypeTalents = {
	  [1] = 'Talents taken',
	  [2] = 'Copy number'
	},
	ReportTypeRelics = {
	  [1] = 'Relics taken',
	  [2] = 'Copy number'
	},
	ReportTypeCrucible = {
	  [1] = 'Traits taken',
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
		[5434] 	= '+200 Str',
		[5435] 	= '+200 Agi',
		[5436] 	= '+200 Int',
		[5310]  = '+100 Crit',
		[5311]  = '+100 Haste',
		[5312]  = '+100 Mast',
		[5314]  = '+100 Vers',
		[999999]= 'Scrap ench.'
	},
	enchantRing = {
		[0] 	= 'Untouched',
		[5427] 	= '+200 Crit',
		[5428] 	= '+200 Haste',
		[5429] 	= '+200 Mast',
		[5430] 	= '+200 Vers',
		[999999]= 'Scrap ench.'
	},
	gemList = {
		
		[0] 	 = 'Untouched',
		[130219] = '+150 Crit',
		[130220] = '+150 Haste',
		[130222] = '+150 Mast',
		[130221] = '+150 Vers',
		[151580] = '+200 Crit',
		[151583] = '+200 Haste',
		[151584] = '+200 Mast',
		[151585] = '+200 Vers',
		[999999] = 'Scrap gem'
	},
	gemListEpic = {
		[0] 	   = 'No Epic gem',
		[130246] = '+200 Str',
		[130247] = '+200 Agi',
		[130248] = '+200 Int',
	}
}


