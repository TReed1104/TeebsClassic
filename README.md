# TeebsClassic
## What is TeebsClassic?
TeebsClassic is World of Warcraft Classic Addon written to provide players who have multiple alts and want a single palce for tracking as much information on those alts as possible.

Currently TeebsClassic works as a command line tool in the Wow Classic chatbox, with a UI version coming soon.

## What Character Data Is Tracked?
For each character TeebsClassic tracks the following data:
- Realm
- Faction
- Character Name
- Class
- Level
- Current Experience
- Rested Experience
- Currency
- Specialisation (E.g. 19/32/0)
- Class Talents
- Reputations
- Primary Professions
- Secondary Professions
- Equipped Gear
- Equipped Bags
- Play time


## Command Documentation
### Character Command - "get-slot"
#### Command Usage
```
/teebs get-slot $character_name$ $equipment_index$
/tbs get-slot $character_name$ $equipment_index$
/th get-slot $character_name$ $equipment_index$
```
#### How To Use
```
/teebs get-slot teebs 12
/tbs get-slot teebs 12
/th get-slot teebs 12
```
#### Example Response
```
Teebs has [Quick Strike Ring] equipped in gear slot 12
```

<br/>

### Character Command - "get-bag"
#### Command Usage
```
/teebs get-bag $character_name$ $bag_index$
/tbs get-bag $character_name$ $bag_index$
/th get-bag $character_name$ $bag_index$
```
#### How To Use
```
/teebs get-bag teebs 2
/tbs get-bag teebs 2
/th get-bag teebs 2
```
#### Example Response
```
Teebs has [Traveler's Backpack] equipped in bag slot 2
```

<br/>

### Character Command - "get-exp"
#### Command Usage
```
/teebs get-exp $character_name$
/tbs get-exp $character_name$
/th get-exp $character_name$
```
#### How To Use
```
/teebs get-exp teebs
/tbs get-exp teebs
/th get-exp teebs
```
#### Example Response
```
Teebs is 0% into level 60 and has 0% rested experience remaining
```

<br/>

### Character Command - "get-level"
#### Command Usage
```
/teebs get-level $character_name$
/tbs get-level $character_name$
/th get-level $character_name$
```
#### How To Use
```
/teebs get-level teebs
/tbs get-level teebs
/th get-level teebs
```
#### Example Response
```
Teebs is currently level 60
```

<br/>

### Character Command - "get-spec"
#### Command Usage
```
/teebs get-spec $character_name$
/tbs get-spec $character_name$
/th get-spec $character_name$
```
#### How To Use
```
/teebs get-spec $character_name$
/tbs get-spec $character_name$
/th get-spec $character_name$
```
#### Example Response
```
Teebs is currently specced 19/32/0
```

<br/>

### Character Command - "get-talents"
#### Command Usage
```
/teebs get-talents $character_name$
/tbs get-talents $character_name$
/th get-talents $character_name$
```
#### How To Use
```
/teebs get-talents teebs
/tbs get-talents teebs
/th get-talents teebs
```
#### Example Response
```
Teebs Talent Tree - Assassination 
Teebs has talent Malice at Rank 5/5 
Teebs has talent Ruthlessness at Rank 3/3 
Teebs has talent Murder at Rank 2/2 
Teebs has talent Improved Slice and Dice at Rank 3/3 
Teebs has talent Relentless Strikes at Rank 1/1 
Teebs has talent Lethality at Rank 5/5 
Teebs Talent Tree - Combat 
Teebs has talent Improved Gouge at Rank 3/3 
Teebs has talent Improved Sinister Strike at Rank 2/2 
Teebs has talent Improved Backstab at Rank 3/3 
Teebs has talent Precision at Rank 5/5 
Teebs has talent Endurance at Rank 2/2 
Teebs has talent Dual Wield Specialization at Rank 5/5 
Teebs has talent Blade Flurry at Rank 1/1 
Teebs has talent Sword Specialization at Rank 5/5 
Teebs has talent Weapon Expertise at Rank 2/2 
Teebs has talent Aggression at Rank 3/3 
Teebs has talent Adrenaline Rush at Rank 1/1
```

<br/>

### Character Command - "get-gold"
#### Command Usage
```
/teebs get-gold $character_name$
/tbs get-gold $character_name$
/th get-gold $character_name$
```
#### How To Use
```
/teebs get-gold teebs
/tbs get-gold teebs
/th get-gold teebs
```
#### Example Response
```
Teebs has 163g 33s 3c
```

<br/>

### Character Command - "get-professions"
#### Command Usage
```
/teebs get-professions $character_name$
/tbs get-professions $character_name$
/th get-professions $character_name$
```
#### How To Use
```
/teebs get-professions teebs
/tbs get-professions teebs
/th get-professions teebs
```
#### Example Response
```
Teebs has Cooking - 140 / 150
Teebs has First Aid - 300 / 300
Teebs has Fishing - 1 / 75
Teebs has Herbalism - 300 / 300
Teebs has Enchanting - 300 / 300
```

<br/>

### Character Command - "get-primary-professions"
#### Command Usage
```
/teebs get-primary-professions $character_name$
/tbs get-primary-professions $character_name$
/th get-primary-professions $character_name$
```
#### How To Use
```
/teebs get-primary-professions teebs
/tbs get-primary-professions teebs
/th get-primary-professions teebs
```
#### Example Response
```
Teebs has Herbalism - 300 / 300
Teebs has Enchanting - 300 / 300
```

<br/>

### Character Command - "get-secondary-professions"
#### Command Usage
```
/teebs get-secondary-professions $character_name$
/tbs get-secondary-professions $character_name$
/th get-secondary-professions $character_name$
```
#### How To Use
```
/teebs get-secondary-professions teebs
/tbs get-secondary-professions teebs
/th get-secondary-professions teebs
```
#### Example Response
```
Teebs has Cooking - 140 / 150
Teebs has First Aid - 300 / 300
Teebs has Fishing - 1 / 75
```

<br/>

### Character Command - "get-rep"
#### Command Usage
```
/teebs get-rep $character_name$ $faction_name$
/tbs get-rep $character_name$ $faction_name$
/th get-rep $character_name$ $faction_name$
```
#### How To Use
```
/teebs get-rep teebs argent-dawn
/tbs get-rep teebs argent-dawn
/th get-rep teebs argent-dawn
```
#### Example Response
```
Teebs - Argent Dawn is currently Revered - 2941/21000
```

<br/>

### Character Command - "get-playtime"
#### Command Usage
```
/teebs get-playtime $character_name$
/tbs get-playtime $character_name$
/th get-playtime $character_name$
```
#### How To Use
```
/teebs get-playtime teebs
/tbs get-playtime teebs
/th get-playtime teebs
```
#### Example Response
```
Teebs Total time played: 31 days, 16 hours, 14 minutes, 42 seconds 
Teebs Time played this level: 22 days, 16 hours, 51 minutes, 37 seconds
```

<br/>

### Character Command - "get-slot-all"
#### Command Usage
```
/teebs get-slot-all $character_name$
/tbs get-slot-all $character_name$
/th get-slot-all $character_name$
```
#### How To Use
```
/teebs get-slot-all teebs
/tbs get-slot-all teebs
/th get-slot-all teebs
```
#### Example Response
```
Teebs has [Striker's Mark] equipped in gear slot 18 
Teebs has [Bloodfang Bracers] equipped in gear slot 9 
Teebs has [Bloodfang Boots] equipped in gear slot 8 
Teebs has [Bloodfang Hood] equipped in gear slot 1 
Teebs has [Thorium Headed Arrow] equipped in gear slot 0 
Teebs has [Bloodfang Spaulders] equipped in gear slot 3 
Teebs has [Prestor's Talisman of Connivery] equipped in gear slot 2 
Teebs has [Bloodfang Chestpiece] equipped in gear slot 5 
Teebs has [Bloodfang Pants] equipped in gear slot 7 
Teebs has [Bloodfang Belt] equipped in gear slot 6 
Teebs has [Blackhand's Breadth] equipped in gear slot 14 
Teebs has [Cape of the Black Baron] equipped in gear slot 15 
Teebs has [Chromatically Tempered Sword] equipped in gear slot 16 
Teebs has [Warblade of the Hakkari] equipped in gear slot 17 
Teebs has [Renataki's Charm of Trickery] equipped in gear slot 13 
Teebs has [Quick Strike Ring] equipped in gear slot 12 
Teebs has [Master Dragonslayer's Ring] equipped in gear slot 11 
Teebs has [Bloodfang Gloves] equipped in gear slot 10
```

<br/>

### Character Command - "get-bags-all"
#### Command Usage
```
/teebs get-bags-all $character_name$
/tbs get-bags-all $character_name$
/th get-bags-all $character_name$
```
#### How To Use
```
/teebs get-bags-all teebs
/tbs get-bags-all teebs
/th get-bags-all teebs
```
#### Example Response
```
Teebs has [Onyxia Hide Backpack] equipped in bag slot 1 
Teebs has [Mooncloth Bag] equipped in bag slot 4 
Teebs has [Mooncloth Bag] equipped in bag slot 3 
Teebs has [Traveler's Backpack] equipped in bag slot 2
```

<br/>

### Character Command - "get-reps-all"
#### Command Usage
```
/teebs get-reps-all $character_name$
/tbs get-reps-all $character_name$
/th get-reps-all $character_name$
```
#### How To Use
```
/teebs get-reps-all teebs
/tbs get-reps-all teebs
/th get-reps-all teebs
```
#### Example Response
```
Teebs - Cenarion Circle is currently Friendly - 411/6000 
Teebs - Bloodsail Buccaneers is currently Hated - 12575/36000 
Teebs - Ratchet is currently Friendly - 4325/6000 
Teebs - Gnomeregan Exiles is currently Honored - 7097/12000 
Teebs - Timbermaw Hold is currently Neutral - 1654/3000 
Teebs - Ironforge is currently Revered - 1065/21000 
Teebs - Argent Dawn is currently Revered - 2941/21000 
Teebs - Shen'dralar is currently Neutral - 220/3000 
Teebs - Magram Clan Centaur is currently Hostile - 1700/3000 
Teebs - Gadgetzan is currently Friendly - 5623/6000 
Teebs - Thorium Brotherhood is currently Neutral - 770/3000 
Teebs - Booty Bay is currently Honored - 663/12000 
Teebs - Hydraxian Waterlords is currently Revered - 14079/21000 
Teebs - Wildhammer Clan is currently Neutral - 1508/3000 
Teebs - Stormpike Guard is currently Neutral - 0/3000 
Teebs - The League of Arathor is currently Neutral - 0/3000 
Teebs - Stormwind is currently Revered - 9663/21000 
Teebs - Gelkis Clan Centaur is currently Friendly - 364/6000 
Teebs - Everlook is currently Friendly - 4696/6000 
Teebs - Ravenholdt is currently Neutral - 407/3000 
Teebs - Darkmoon Faire is currently Neutral - 0/3000 
Teebs - Zandalar Tribe is currently Exalted - 999/1000 
Teebs - Darnassus is currently Exalted - 986/1000
```

<br/>

### All Character Command - "get-exp-all"
#### Command Usage
```
/teebs get-exp-all
/tbs get-exp-all
/th get-exp-all
```
#### How To Use
```
/teebs get-exp-all
/tbs get-exp-all
/th get-exp-all
```
#### Example Response
```
Teebs is level 60 
Tweebs is level 60 
Tinge is 19% into level 30 and has 150% rested experience remaining 
Khare is 13% into level 30 and has 150% rested experience remaining 
Twibbler is 44% into level 31 and has 150% rested experience remaining 
Krae is 10% into level 49 and has 7% rested experience remaining 
Remmus is 33% into level 30 and has 150% rested experience remaining 
Teebsbank is 13% into level 1 and has 150% rested experience remaining 
Felthus is 4% into level 30 and has 150% rested experience remaining
```

<br/>

### All Character Command - "get-level-all"
#### Command Usage
```
/teebs get-level-all
/tbs get-level-all
/th get-level-all
```
#### How To Use
```
/teebs get-level-all
/tbs get-level-all
/th get-level-all
```
#### Example Response
```
Teebs is level 60 
Tweebs is level 60 
Tinge is level 30 
Khare is level 30 
Twibbler is level 31 
Krae is level 49 
Remmus is level 30 
Teebsbank is level 1 
Felthus is level 30
```

<br/>

### All Character Command - "get-gold-all"
#### Command Usage
```
/teebs get-gold-all
/tbs get-gold-all
/th get-gold-all
```
#### How To Use
```
/teebs get-gold-all
/tbs get-gold-all
/th get-gold-all
```
#### Example Response
```
Teebs has 163g 33s 3c 
Tweebs has 53g 16s 22c 
Tinge has 9g 91s 51c 
Khare has 5g 30s 52c 
Twibbler has 15g 22s 45c 
Krae has 59g 38s 69c 
Remmus has 6g 68s 26c 
Teebsbank has 5g 81s 86c 
Felthus has 1g 29s 1c
```

<br/>

### All Character Command - "get-professions-all"
#### Command Usage
```
/teebs get-professions-all
/tbs get-professions-all
/th get-professions-all
```
#### How To Use
```
/teebs get-professions-all
/tbs get-professions-all
/th get-professions-all
```
#### Example Response
```
Teebs has Herbalism - 300 / 300 
Teebs has Enchanting - 300 / 300 
Teebs has Cooking - 140 / 150 
Teebs has First Aid - 300 / 300 
Teebs has Fishing - 1 / 75 
Tweebs has First Aid - 300 / 300 
Tweebs has Alchemy - 300 / 300 
Tweebs has Mining - 109 / 150 
Tinge has Cooking - 1 / 75 
Tinge has First Aid - 225 / 225 
Tinge has Herbalism - 2 / 75 
Khare has First Aid - 225 / 225 
Khare has Tailoring - 225 / 225 
Khare has Mining - 76 / 150 
Twibbler has Cooking - 1 / 75 
Twibbler has First Aid - 225 / 225 
Twibbler has Blacksmithing - 59 / 150 
Twibbler has Mining - 98 / 150 
Krae has Alchemy - 274 / 300 
Krae has Herbalism - 154 / 225 
Krae has Cooking - 1 / 75 
Krae has First Aid - 290 / 300 
Remmus has Herbalism - 7 / 75 
Remmus has Cooking - 1 / 75 
Remmus has First Aid - 225 / 225 
Felthus has Alchemy - 1 / 75 
Felthus has Herbalism - 16 / 75 
Felthus has First Aid - 225 / 225
```

<br/>

### All Character Command - "get-primary-professions-all"
#### Command Usage
```
/teebs get-primary-professions-all
/tbs get-primary-professions-all
/th get-primary-professions-all
```
#### How To Use
```
/teebs get-primary-professions-all
/tbs get-primary-professions-all
/th get-primary-professions-all
```
#### Example Response
```
irst Aid - 225 / 225 
Teebs has Herbalism - 300 / 300 
Teebs has Enchanting - 300 / 300 
Tweebs has Alchemy - 300 / 300 
Tweebs has Mining - 109 / 150 
Tinge has Herbalism - 2 / 75 
Khare has Tailoring - 225 / 225 
Khare has Mining - 76 / 150 
Twibbler has Blacksmithing - 59 / 150 
Twibbler has Mining - 98 / 150 
Krae has Alchemy - 274 / 300 
Krae has Herbalism - 154 / 225 
Remmus has Herbalism - 7 / 75 
Felthus has Alchemy - 1 / 75 
Felthus has Herbalism - 16 / 75
```

<br/>

### All Character Command - "get-secondary-professions-all"
#### Command Usage
```
/teebs get-secondary-professions-all
/tbs get-secondary-professions-all
/th get-secondary-professions-all
```
#### How To Use
```
/teebs get-secondary-professions-all
/tbs get-secondary-professions-all
/th get-secondary-professions-all
```
#### Example Response
```

```

<br/>

### All Character Command - "get-playtime-all"
#### Command Usage
```
/teebs get-playtime-all
/tbs get-playtime-all
/th get-playtime-all
```
#### How To Use
```
/teebs get-playtime-all
/tbs get-playtime-all
/th get-playtime-all
```
#### Example Response
```

```

<br/>

### Realm total Command - "get-total-playtime"
#### Command Usage
```
/teebs get-total-playtime
/tbs get-total-playtime
/th get-total-playtime
```
#### How To Use
```
/teebs get-total-playtime
/tbs get-total-playtime
/th get-total-playtime
```
#### Example Response
```

```

<br/>

### Realm total Command - "get-total-gold"
#### Command Usage
```
/teebs get-total-gold
/tbs get-total-gold
/th get-total-gold
```
#### How To Use
```
/teebs get-total-gold
/tbs get-total-gold
/th get-total-gold
```
#### Example Response
```

```

<br/>

