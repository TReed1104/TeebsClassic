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

```

<br/>

### Character Command - "get-bags-all"
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

