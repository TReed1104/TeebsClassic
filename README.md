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
#### Usage
```
/teebs get-slot $character_name$ $equipment_index$
/tbs get-slot $character_name$ $equipment_index$
/th get-slot $character_name$ $equipment_index$
```
#### Example
```
/teebs get-slot teebs 12
/tbs get-slot teebs 12
/th get-slot teebs 12
```

<br/>

### Character Command - "get-bag"
#### Usage
```
/teebs get-bag $character_name$ $bag_index$
/tbs get-bag $character_name$ $bag_index$
/th get-bag $character_name$ $bag_index$
```
#### Example
```
/teebs get-bag teebs 2
/tbs get-bag teebs 2
/th get-bag teebs 2
```

<br/>

### Character Command - "get-exp"
#### Usage
```
/teebs get-exp $character_name$
/tbs get-exp $character_name$
/th get-exp $character_name$
```
#### Example
```
/teebs get-exp teebs
/tbs get-exp teebs
/th get-exp teebs
```

<br/>

### Character Command - "get-level"
#### Usage
```
/teebs get-level $character_name$
/tbs get-level $character_name$
/th get-level $character_name$
```
#### Example
```
/teebs get-level teebs
/tbs get-level teebs
/th get-level teebs
```

<br/>

### Character Command - "get-spec"
#### Usage
```
/teebs get-spec $character_name$
/tbs get-spec $character_name$
/th get-spec $character_name$
```
#### Example
```
/teebs get-spec $character_name$
/tbs get-spec $character_name$
/th get-spec $character_name$
```

<br/>

### Character Command - "get-talents"
#### Usage
```
/teebs get-talents $character_name$
/tbs get-talents $character_name$
/th get-talents $character_name$
```
#### Example
```
/teebs get-talents $character_name$
/tbs get-talents $character_name$
/th get-talents $character_name$
```

<br/>

### Character Command - "get-gold"
#### Usage
```
/teebs get-gold $character_name$
/tbs get-gold $character_name$
/th get-gold $character_name$
```
#### Example
```
/teebs get-gold teebs
/tbs get-gold teebs
/th get-gold teebs
```

<br/>

### Character Command - "get-professions"
#### Usage
```
/teebs get-professions $character_name$
/tbs get-professions $character_name$
/th get-professions $character_name$
```
#### Example
```
/teebs get-professions teebs
/tbs get-professions teebs
/th get-professions teebs
```

<br/>

### Character Command - "get-primary-professions"
#### Usage
```
/teebs get-primary-professions $character_name$
/tbs get-primary-professions $character_name$
/th get-primary-professions $character_name$
```
#### Example
```
/teebs get-primary-professions /teebs get-total-gold
/tbs get-primary-professions /tbs get-total-gold
/th get-primary-professions /th get-total-gold
```

<br/>

### Character Command - "get-secondary-professions"
#### Usage
```
/teebs get-secondary-professions $character_name$
/tbs get-secondary-professions $character_name$
/th get-secondary-professions $character_name$
```
#### Example
```
/teebs get-secondary-professions teebs
/tbs get-secondary-professions teebs
/th get-secondary-professions teebs
```

<br/>

### Character Command - "get-rep"
#### Usage
```
/teebs get-rep $character_name$
/tbs get-rep $character_name$
/th get-rep $character_name$
```
#### Example
```
/teebs get-rep teebs
/tbs get-rep teebs
/th get-rep teebs
```

<br/>

### Character Command - "get-playtime"
#### Usage
```
/teebs get-playtime $character_name$
/tbs get-playtime $character_name$
/th get-playtime $character_name$
```
#### Example
```
/teebs get-playtime teebs
/tbs get-playtime teebs
/th get-playtime teebs
```

<br/>

### Character Command - "get-slot-all"
#### Usage
```
/teebs get-slot-all $character_name$
/tbs get-slot-all $character_name$
/th get-slot-all $character_name$
```
#### Example
```
/teebs get-slot-all teebs
/tbs get-slot-all teebs
/th get-slot-all teebs
```

<br/>

### Character Command - "get-bags-all"
#### Usage
```
/teebs get-exp $character_name$
/tbs get-exp $character_name$
/th get-exp $character_name$
```
#### Example
```
/teebs get-exp teebs
/tbs get-exp teebs
/th get-exp teebs
```

<br/>

### Character Command - "get-reps-all"
#### Usage
```
/teebs get-reps-all $character_name$
/tbs get-reps-all $character_name$
/th get-reps-all $character_name$
```
#### Example
```
/teebs get-reps-all teebs
/tbs get-reps-all teebs
/th get-reps-all teebs
```

<br/>

### All Character Command - "get-exp-all"
#### Usage
```
/teebs get-exp-all
/tbs get-exp-all
/th get-exp-all
```
#### Example
```
/teebs get-exp-all
/tbs get-exp-all
/th get-exp-all
```

<br/>

### All Character Command - "get-level-all"
#### Usage
```
/teebs get-level-all
/tbs get-level-all
/th get-level-all
```
#### Example
```
/teebs get-level-all
/tbs get-level-all
/th get-level-all
```

<br/>

### All Character Command - "get-gold-all"
#### Usage
```
/teebs get-gold-all
/tbs get-gold-all
/th get-gold-all
```
#### Example
```
/teebs get-gold-all
/tbs get-gold-all
/th get-gold-all
```

<br/>

### All Character Command - "get-professions-all"
#### Usage
```
/teebs get-professions-all
/tbs get-professions-all
/th get-professions-all
```
#### Example
```
/teebs get-professions-all
/tbs get-professions-all
/th get-professions-all
```

<br/>

### All Character Command - "get-primary-professions-all"
#### Usage
```
/teebs get-primary-professions-all
/tbs get-primary-professions-all
/th get-primary-professions-all
```
#### Example
```
/teebs get-primary-professions-all
/tbs get-primary-professions-all
/th get-primary-professions-all
```

<br/>

### All Character Command - "get-secondary-professions-all"
#### Usage
```
/teebs get-secondary-professions-all
/tbs get-secondary-professions-all
/th get-secondary-professions-all
```
#### Example
```
/teebs get-secondary-professions-all
/tbs get-secondary-professions-all
/th get-secondary-professions-all
```

<br/>

### All Character Command - "get-playtime-all"
#### Usage
```
/teebs get-playtime-all
/tbs get-playtime-all
/th get-playtime-all
```
#### Example
```
/teebs get-playtime-all
/tbs get-playtime-all
/th get-playtime-all
```

<br/>

### Realm total Command - "get-total-playtime"
#### Usage
```
/teebs get-total-playtime
/tbs get-total-playtime
/th get-total-playtime
```
#### Example
```
/teebs get-total-playtime
/tbs get-total-playtime
/th get-total-playtime
```

<br/>

### Realm total Command - "get-total-gold"
#### Usage
```
/teebs get-total-gold
/tbs get-total-gold
/th get-total-gold
```
#### Example
```
/teebs get-total-gold
/tbs get-total-gold
/th get-total-gold
```

<br/>

