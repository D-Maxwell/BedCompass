## TODO : somehow get, store, and refer to the slot index that holds the current itemstack to update ==> merge new and update functions ; removes the need for item summoning ? no

summon minecraft:chest_minecart ~ ~ ~ {NoGravity:1b,Marker:1b,NoAI:1b,Tags:["BedCompassHolder"]}
item replace entity @e[tag=BedCompassHolder,limit=1] container.0 from entity @s weapon.mainhand

item replace entity @e[tag=BedCompassHolder,limit=1] container.1 from entity @s weapon.mainhand
data modify entity @e[tag=BedCompassHolder,limit=1] Items[1] merge value {Count:1b}

$data modify entity @e[tag=BedCompassHolder,limit=1] Items[1] merge value {tag:{BedCompass:1b, LodestoneTracked:0b,LodestonePos:{X:$(SpawnX), Y:$(SpawnY), Z:$(SpawnZ)},LodestoneDimension:"minecraft:overworld"}}

## item data is in tag component for some reason
execute as @e[tag=BedCompassHolder,limit=1] unless data entity @s Items[1].tag.display.Name run data modify entity @s Items[1] merge value {tag:{display:{Name:'{"translate": "item.minecraft.compass", "italic": false}'}}}

## set_count modifier ?

execute store result score @s bed_compass.compass_item_count run data get entity @s SelectedItem.Count
scoreboard players remove @s bed_compass.compass_item_count 1
execute store result entity @e[tag=BedCompassHolder,limit=1] Items[0].Count byte 1 run scoreboard players get @s bed_compass.compass_item_count


item replace entity @s weapon.mainhand from entity @e[tag=BedCompassHolder,limit=1] container.0

#loot give @s kill @e[tag=BedCompassHolder,limit=1]

## need dummy item in preceeding slot in order not to disrupt item order, otherwise modified compass becomes slot of index 0
execute if score @s bed_compass.compass_item_count matches ..0 run item replace entity @e[tag=BedCompassHolder,limit=1] container.0 with minecraft:structure_void
summon minecraft:item ~ ~ ~ {Tags:["BedCompass"], Item:{id:"minecraft:structure_void",Count:1b}}
data modify entity @e[type=minecraft:item,limit=1,tag=BedCompass] Item set from entity @e[tag=BedCompassHolder,limit=1] Items[1]

item replace entity @e[tag=BedCompassHolder,limit=1] container.0 with air
tp @e[tag=BedCompassHolder,limit=1] ~ -9999 ~
kill @e[tag=BedCompassHolder,limit=1]

scoreboard players reset @s bed_compass.compass_item_count
