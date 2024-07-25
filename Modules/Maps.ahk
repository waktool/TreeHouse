#Requires AutoHotkey v2.0  ; Ensures the script runs only on AutoHotkey version 2.0, which supports the syntax and functions used in this script.

; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
; MAPS
; ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰

; ----------------------------------------------------------------------------------------
; COLOR_RARITY_MAP Definition
; Description: Defines a map for item rarities, including color codes and experience points (XP) associated with each rarity.
; Operation:
;   - Maps each rarity to an object containing its color code and experience points.
; Dependencies: None
; Parameters: None
; Return: A map object containing rarity information.
; ----------------------------------------------------------------------------------------
COLOR_RARITY_MAP := Map(
    "Basic", {
        color: "0xA5A2BB",
        xp: 200
    },
    "Rare", {
        color: "0x71FF3E",
        xp: 495
    },
    "Epic", {
        color: "0x29DFFF",
        xp: 800
    },
    "Legendary", {
        color: "0xFF8B26",
        xp: 1485
    },
    "Mythical", {
        color: "0xFF3E67",
        xp: 1980
    },
    "Exotic", {
        color: "0xFF42FC",
        xp: 3300
    },
    "Divine", {
        color: "0xFFE542",
        xp: 4950
    },
    "Superior", {
        color: "0xC0EDED",
        xp: 7260
    },
    "Celestial", {
        color: "0xFFB4FA",
        xp: 9240
    },
    "Exclusive", {
        color: "0xAD55FF",
        xp: 100000
    }
)

; ----------------------------------------------------------------------------------------
; ITEM_MAP Initialization
; Description: Initializes the ITEM_MAP with item details including rarity, regex pattern, category, id, tier number, value, and priority.
; Operation:
;   - Creates a map with multiple entries.
;   - Each entry is initialized with item details.
; Dependencies: None
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
ITEM_MAP := Map(
    "Charm Stone", {
        rarity: "Exotic",
        regex: "i)(?=.*cha)(?=.*st).*",
        category: "Misc",
        id: "Charm Stone",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Coins Potion VII", {
        rarity: "Divine",
        regex: "i)(?=.*coin)(?=.*pot).*",
        category: "Potion",
        id: "Coins",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Coins Potion VIII", {
        rarity: "Superior",
        regex: "i)(?=.*coin)(?=.*pot).*",
        category: "Potion",
        id: "Coins",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Coins Potion IX", {
        rarity: "Celestial",
        regex: "i)(?=.*coin)(?=.*pot).*",
        category: "Potion",
        id: "Coins",
        tn: 9,
        value: 0,
        priority: 0
    },
    "Coins V", {
        rarity: "Mythical",
        regex: "i)(?=.*coin)(?!=.*pot).*",
        category: "Enchant",
        id: "Coins",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Coins VI", {
        rarity: "Exotic",
        regex: "i)(?=.*coin)(?!=.*pot).*",
        category: "Enchant",
        id: "Coins",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Coins VII", {
        rarity: "Divine",
        regex: "i)(?=.*coin)(?!=.*pot).*",
        category: "Enchant",
        id: "Coins",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Coins VIII", {
        rarity: "Superior",
        regex: "i)(?=.*coin)(?!=.*pot).*",
        category: "Enchant",
        id: "Coins",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Criticals Charm", {
        rarity: "Mythical",
        regex: "i)(?=.*(crit|clit|tic|cal|als))(?=.*cha).*",
        category: "Charm",
        id: "Criticals",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Criticals V", {
        rarity: "Mythical",
        regex: "i)(?=.*(crit|clit|tic|cal|als))(?!.*cha).*",
        category: "Enchant",
        id: "Criticals",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Criticals VI", {
        rarity: "Exotic",
        regex: "i)(?=.*(crit|clit|tic|cal|als))(?!.*cha).*",
        category: "Enchant",
        id: "Criticals",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Criticals VII", {
        rarity: "Divine",
        regex: "i)(?=.*(crit|clit|tic|cal|als))(?!.*cha).*",
        category: "Enchant",
        id: "Criticals",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Criticals VIII", {
        rarity: "Superior",
        regex: "i)(?=.*(crit|clit|tic|cal|als))(?!.*cha).*",
        category: "Enchant",
        id: "Criticals",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Crystal Key", {
        rarity: "Legendary",
        regex: "i)(?=.*(cr|ry|ys|st|ta|al))(?=.*(ke|ey)).*",
        category: "Misc",
        id: "Crystal Key",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Damage Potion VII", {
        rarity: "Divine",
        regex: "i)(?=.*dam)(?=.*pot).*",
        category: "Potion",
        id: "Damage",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Damage Potion VIII", {
        rarity: "Superior",
        regex: "i)(?=.*dam)(?=.*pot).*",
        category: "Potion",
        id: "Damage",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Damage Potion IX", {
        rarity: "Celestial",
        regex: "i)(?=.*dam)(?=.*pot).*",
        category: "Potion",
        id: "Damage",
        tn: 9,
        value: 0,
        priority: 0
    },
    "Daycare Slot Voucher", {
        rarity: "Mythical",
        regex: "i)(day|care|slot|vou)",
        category: "Misc",
        id: "Daycare Slot Voucher",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Diamonds Charm", {
        rarity: "Exotic",
        regex: "i)(?=.*dia)(?=.*cha).*",
        category: "Charm",
        id: "Diamonds",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Diamonds Potion V", {
        rarity: "Mythical",
        regex: "i)(?=.*dia)(?=.*pot).*",
        category: "Potion",
        id: "Diamonds",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Diamonds Potion VI", {
        rarity: "Exotic",
        regex: "i)(?=.*dia)(?=.*pot).*",
        category: "Potion",
        id: "Diamonds",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Diamonds Potion VII", {
        rarity: "Divine",
        regex: "i)(?=.*dia)(?=.*pot).*",
        category: "Potion",
        id: "Diamonds",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Diamonds V", {
        rarity: "Mythical",
        regex: "i)(?=.*dia)(?!.*pot)(?!.*cha).*",
        category: "Enchant",
        id: "Diamonds",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Diamonds VI", {
        rarity: "Exotic",
        regex: "i)(?=.*dia)(?!.*pot)(?!.*cha).*",
        category: "Enchant",
        id: "Diamonds",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Diamonds VII", {
        rarity: "Divine",
        regex: "i)(?=.*dia)(?!.*pot)(?!.*cha).*",
        category: "Enchant",
        id: "Diamonds",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Explosive", {
        rarity: "Mythical",
        regex: "i)(exp|plos|ive)",
        category: "Enchant",
        id: "Explosive",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Fortune", {
        rarity: "Exotic",
        regex: "i)(?=.*for)(?!=.*fl).*",
        category: "Enchant",
        id: "Fortune",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Fortune Flag", {
        rarity: "Legendary",
        regex: "i)(?=.*for)(?=.*fl).*",
        category: "Misc",
        id: "Fortune Flag",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Glittering Charm", {
        rarity: "Superior",
        regex: "i)(?=.*(gl|lit|itt|ter))(?=.*cha).*",
        category: "Charm",
        id: "Glittering",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Huge Lumi Axolotl", {
        rarity: "Exclusive",
        regex: "i)(hug|lum|axo)",
        category: "Pet",
        id: "Huge Lumi Axolotl",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Large Gift Bag", {
        rarity: "Legendary",
        regex: "i)(?=.*lar)(?!=.*tap).*",
        category: "Misc",
        id: "Large Gift Bag",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Large Taps", {
        rarity: "Exotic",
        regex: "i)(?=.*lar)(?=.*tap).*",
        category: "Enchant",
        id: "Large Taps",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Lightning", {
        rarity: "Mythical",
        regex: "i)(lig|ght|ning)",
        category: "Enchant",
        id: "Lightning",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Lucky Eggs Potion VII", {
        rarity: "Divine",
        regex: "i)(?=.*luc)(?=.*pot).*",
        category: "Potion",
        id: "Lucky",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Lucky Eggs Potion VIII", {
        rarity: "Superior",
        regex: "i)(?=.*luc)(?=.*pot).*",
        category: "Potion",
        id: "Lucky",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Lucky Eggs Potion IX", {
        rarity: "Celestial",
        regex: "i)(?=.*luc)(?=.*pot).*",
        category: "Potion",
        id: "Lucky",
        tn: 9,
        value: 0,
        priority: 0
    },
    "Lucky Eggs V", {
        rarity: "Mythical",
        regex: "i)(?=.*luc)(?!=.*pot).*",
        category: "Enchant",
        id: "Lucky Eggs",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Lucky Eggs VI", {
        rarity: "Exotic",
        regex: "i)(?=.*luc)(?!=.*pot).*",
        category: "Enchant",
        id: "Lucky Eggs",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Lucky Eggs VII", {
        rarity: "Divine",
        regex: "i)(?=.*luc)(?!=.*pot).*",
        category: "Enchant",
        id: "Lucky Eggs",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Lucky Eggs VIII", {
        rarity: "Superior",
        regex: "i)(?=.*luc)(?!=.*pot).*",
        category: "Enchant",
        id: "Lucky Eggs",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Midas Touch", {
        rarity: "Exotic",
        regex: "i)(mid|tou)",
        category: "Enchant",
        id: "Midas Touch",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Mini Chest", {
        rarity: "Exotic",
        regex: "i)(min|che)",
        category: "Misc",
        id: "Mini Chest",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Old Boot", {
        rarity: "Basic",
        regex: "i)(old|boo|oot)",
        category: "Misc",
        id: "Old Boot",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Overload Charm", {
        rarity: "Celestial",
        regex: "i)(?=.*(ov|ver|loa|oad))(?=.*cha).*",
        category: "Charm",
        id: "Overload",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Rainbow Flag", {
        rarity: "Divine",
        regex: "i)(?=.*ra)(?=.*fl).*",
        category: "Misc",
        id: "Rainbow Flag",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Rainbow Swirl", {
        rarity: "Rare",
        regex: "i)(?=.*ra)(?=.*sw).*",
        category: "Misc",
        id: "Rainbow Swirl",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Royalty Charm", {
        rarity: "Celestial",
        regex: "i)(?=.*(ro|yal|lty))(?=.*cha).*",
        category: "Charm",
        id: "Royalty",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Shiny Flag", {
        rarity: "Superior",
        regex: "i)(?=.*sh)(?=.*fl).*",
        category: "Misc",
        id: "Shiny Flag",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Speed III", {
        rarity: "Epic",
        regex: "i)(spe|pee|eed).*",
        category: "Enchant",
        id: "Walkspeed",
        tn: 3,
        value: 0,
        priority: 0
    },
    "Speed IV", {
        rarity: "Legendary",
        regex: "i)(spe|pee|eed).*",
        category: "Enchant",
        id: "Walkspeed",
        tn: 4,
        value: 0,
        priority: 0
    },
    "Speed V", {
        rarity: "Mythical",
        regex: "i)(spe|pee|eed).*",
        category: "Enchant",
        id: "Walkspeed",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Strength Charm", {
        rarity: "Mythical",
        regex: "i)(?=.*(st|tre|ngt|gth))(?=.*cha).*",
        category: "Charm",
        id: "Strength",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Strong Pets V", {
        rarity: "Mythical",
        regex: "i)(?=.*str)(?=.*pet).*",
        category: "Enchant",
        id: "Strong Pets",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Strong Pets VI", {
        rarity: "Exotic",
        regex: "i)(?=.*str)(?=.*pet).*",
        category: "Enchant",
        id: "Strong Pets",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Strong Pets VII", {
        rarity: "Divine",
        regex: "i)(?=.*str)(?=.*pet).*",
        category: "Enchant",
        id: "Strong Pets",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Strong Pets VIII", {
        rarity: "Superior",
        regex: "i)(?=.*str)(?=.*pet).*",
        category: "Enchant",
        id: "Strong Pets",
        tn: 8,
        value: 0,
        priority: 0
    },
    "TNT Charm", {
        rarity: "Exotic",
        regex: "i)(?=.*tn)(?=.*cha).*",
        category: "Charm",
        id: "TNT",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "Tap Power V", {
        rarity: "Mythical",
        regex: "i)(?=.*tap)(?=.*pow).*",
        category: "Enchant",
        id: "Tap Power",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Tap Power VI", {
        rarity: "Exotic",
        regex: "i)(?=.*tap)(?=.*pow).*",
        category: "Enchant",
        id: "Tap Power",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Tap Power VII", {
        rarity: "Divine",
        regex: "i)(?=.*tap)(?=.*pow).*",
        category: "Enchant",
        id: "Tap Power",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Tap Power VIII", {
        rarity: "Superior",
        regex: "i)(?=.*tap)(?=.*pow).*",
        category: "Enchant",
        id: "Tap Power",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Tech Key", {
        rarity: "Mythical",
        regex: "i)(?=.*(te|ec|ch))(?=.*(ke|ey)).*",
        category: "Misc",
        id: "Tech Key",
        tn: "NA",
        value: 0,
        priority: 0
    },
    "The Cocktail", {
        rarity: "Superior",
        regex: "i)(the|coc|ock|tai|ail)",
        category: "Potion",
        id: "The Cocktail",
        tn: 1,
        value: 0,
        priority: 0
    },
    "Treasure Hunter Potion VII", {
        rarity: "Divine",
        regex: "i)(?=.*tre)(?=.*pot).*",
        category: "Potion",
        id: "Treasure Hunter",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Treasure Hunter Potion VIII", {
        rarity: "Superior",
        regex: "i)(?=.*tre)(?=.*pot).*",
        category: "Potion",
        id: "Treasure Hunter",
        tn: 8,
        value: 0,
        priority: 0
    },
    "Treasure Hunter Potion IX", {
        rarity: "Celestial",
        regex: "i)(?=.*tre)(?=.*pot).*",
        category: "Potion",
        id: "Treasure Hunter",
        tn: 9,
        value: 0,
        priority: 0
    },
    "Treasure Hunter V", {
        rarity: "Mythical",
        regex: "i)(?=.*tre)(?!=.*pot).*",
        category: "Enchant",
        id: "Treasure Hunter",
        tn: 5,
        value: 0,
        priority: 0
    },
    "Treasure Hunter VI", {
        rarity: "Exotic",
        regex: "i)(?=.*tre)(?!=.*pot).*",
        category: "Enchant",
        id: "Treasure Hunter",
        tn: 6,
        value: 0,
        priority: 0
    },
    "Treasure Hunter VII", {
        rarity: "Divine",
        regex: "i)(?=.*tre)(?!=.*pot).*",
        category: "Enchant",
        id: "Treasure Hunter",
        tn: 7,
        value: 0,
        priority: 0
    },
    "Treasure Hunter VIII", {
        rarity: "Superior",
        regex: "i)(?=.*tre)(?!=.*pot).*",
        category: "Enchant",
        id: "Treasure Hunter",
        tn: 8,
        value: 0,
        priority: 0
    },
    "XP Charm", {
        rarity: "Divine",
        regex: "i)(?=.*xp)(?=.*cha).*",
        category: "Charm",
        id: "XP",
        tn: "NA",
        value: 0,
        priority: 0
    }
)

; ----------------------------------------------------------------------------------------
; CHOICE_MAP Initialization
; Description: Initializes the CHOICE_MAP with default empty values for itemName, xp, rap, and priority.
; Operation:
;   - Creates a map with three entries.
;   - Each entry is initialized with default empty values for itemName, xp, rap, and priority.
; Dependencies: None
; Parameters: None
; Return: None
; ----------------------------------------------------------------------------------------
CHOICE_MAP := Map()  ; Initialize the map to hold the choices.

; Initialize entries in CHOICE_MAP with default empty values.
Loop 3 {
    CHOICE_MAP[A_Index] := {itemName: "", xp: "", rap: "", priority: ""}
}

; ----------------------------------------------------------------------------------------
; STATS_MAP Definition
; Description: Defines a map for tracking various statistics related to key usage and RAP (Recent Average Price).
; Operation:
;   - Maps each statistic to an object containing its order and initial value.
; Dependencies: None
; Parameters: None
; Return: A map object containing statistical information.
; ----------------------------------------------------------------------------------------
STATS_MAP := Map(
    "Times opened", {
        order: 1,        ; Order of the statistic in display or processing
        value: 0         ; Initial value of the statistic
    },
    "Keys used", {
        order: 2,
        value: 0
    },
    "Keys not consumed", {
        order: 3,
        value: 0
    },
    "Keys RAP (~)", {
        order: 4,
        value: 0
    },
    "Total RAP (~)", {
        order: 5,
        value: 0
    },
    "Balance (~)", {
        order: 6,
        value: 0
    },
    "Total XP (~)", {
        order: 7,
        value: 0
    },
    "World changes", {
        order: 8,
        value: 0
    }        
)