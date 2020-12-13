# Kaminari_Numbers
![example](https://github.com/telecotxesco/Kaminari_Numbers/blob/main/img/banner.jpg?raw=true)

### :point_right: Please, refer to the [Wiki](https://github.com/telecotxesco/Kaminari_Numbers/wiki) for details. :point_left:

## Overview
On Transport Fever it is not possible to assign to each unit a unique serial number (like UIC identification numbers) because the game engine loads and generates the model once when loading the game, and after that the model remains static on memory. It's possible to randomize somehow the numbering at the beggining, but after that it remains the same across all the models of the same unit. That means that all the locomotives of the same model will show the same number during the game.

**KAMINARI NUMBERS** is a mod script that allows to print random serial numbers on similar models without the need of duplicating model files.

You can subsribe to **KAMINARI NUMBERS** on the [Steam Workshop](https://steamcommunity.com/workshop/managerequireditems/?id=2312549569/)

## :heavy_check_mark: What KAMINARI NUMBERS can do
* Place numbers and uppercase letters over any model (trains, planes, trucks, buildings, ...).
* Show different numbers or letters across all the same models placed on map, creating the sensation that every model has its own identification number.
* Create lists of consecutive numbers, from a starting number to a final one (i.e. from 30 to 59).
* Cicle through numbers consecutively or randomly.
* Create lists of identification numbers that combines letters and numbers, being able to randomize each position from a list of allowed characters.
* Create your own list of identification numbers manually.
* The last number assigned on each unit is persisted when saving and quitting the game and loading it after.
* Paint the letters with any color, either RGB or descriptive (i.e. "white", "darkblue", ...)
* Letters become dirt over the time.
* Change the size, position and rotation of the letters.

## :x: What KAMINARI NUMBERS can NOT do
* A number on a unit can not be persisted over the time. It changes after some time.
* Two or more units can have the same generated number at the same time. The shorter the list of numbers, the higher probabilities two units share the same number.
* When placing a new unit on map, tt's not possible to shuffle the starting number, so all the units will show the same number for the first time.
* Only numbers, uppercase letters and dot (.), hyphen (-) and slash (/) are available. No lowercase letters or other characters are available.

## :point_up: When or how I should avoid using KAMINARU NUMBERS
* It is not intended to do all the static labels because of the inefficiency it may introduce. There are other mods available that can do this in a more efficient way.
* Avoid using hundreds of number variations. Units that may have 2, 4, or even 6 times the number printed. Each digit is a mesh (2 polygons) and each variation introduced is also N times the mesh generated. That means if 100 of variations are defined for a 6 digit plate, and it is on 6 different parts of the unit, that sums 3.600 meshes present that equals 7.200 poligons that are added to **each** model present and inside the LOD. **USE WITH CAUTION AND MODERATION TO AVOID MAYOR SLOWDOWN TO THE GAME**

# Quick start
1) Instanciate the script :warning: **avoid this way of direct require. Instead refer [initializing script](https://github.com/telecotxesco/Kaminari_Numbers/wiki/Initializing-KAMINARI-NUMBERS-on-the-model) to see a better way**
```lua 
local kaminari_numbers = require "kaminari_numbers"
```
2) Create a list of numbers with `buildListOfNumbers` or `generateRandomCharacters`
```lua
local numberPlates = kaminari_numbers.buildListOfNumbers( 1, 35, true, 3, "1", "" )
```
3) Create a list of groups of numbers ready to be put on the model LOD subnode with `getChildrenColorNumber` or `getChildrenRGBNumber`
```lua
local plates = kaminari_numbers.getChildrenColorNumber( numberPlates, "white", "Helvetica", 24.0,  3.90, 1.00, 2.05, 0, 0, 0 )
```
4) Append on the last element of the LOD in the model the list groups created on step 3.
```lua
plates
```

# :information_source: Staging_area and ModelEditor
If you are planning to work with the model on staging_area folder and view it with ModelEditor, then you need to copy the **KAMINARI NUMBERS** scripts and files into the staging_area model folder. You can follow the steps as expained on the wiki at page [previous preparations](https://github.com/telecotxesco/Kaminari_Numbers/wiki/Previous-preparations).

# :warning: **IMPORTANT** :warning:
### ¡WHEN USING ModelEditor, DO NOT SAVE THE MODEL!
#### ModelEditor when you press the SAVE button, it **REMOVES** all the LUA code and *flattens* all the model into a static *no-code* model. Saving a model that uses of *KAMINARI NUMBERS* will make the *flatten* model file size **VERY MUCH** and also will loose all the code writed on the model before to generate the lists of numbers.
#### Consider making backup copies of your model often.

## Example
The model is on the example folder. We will modify the V100 in-game model in order to add 2 numbers on the sides, and one in front and in back like this:

![example](https://github.com/telecotxesco/Kaminari_Numbers/blob/main/img/example1.jpg?raw=true)

This is how the model will look like:
```lua
local kaminari_numbers = require "kaminari_numbers"

function data()
        -- Generation of the plates: this will create numbers like 1001, 1002, ... 1035.
        local numberPlates = kaminari_numbers.buildListOfNumbers( 1, 35, true, 3, "1", "" )

        -- With this loop, we will create a secondary list derived from the first, in order
        -- to match the numbers
        local largeNumberPlates = {}
        for i, singleNumberPlate in ipairs(numberPlates) do
                table.insert( largeNumberPlates, "V 100-" .. singleNumberPlate )
        end

        -- Generation of the groups of numbers to display
        -- These two will be a big label with only que number like 1001, 1002, ... 1035
        local platesLeft  = kaminari_numbers.getChildrenColorNumber( numberPlates      , "white", "Helvetica", 24.0,  3.90,  1.00, 2.05,   0, 0, 0 )
        local platesRight = kaminari_numbers.getChildrenColorNumber( numberPlates      , "white", "Helvetica", 24.0,  1.90, -1.00, 2.05, 180, 0, 0 )
		
        -- These two will generate a larger label, derived from the mail numberPlates list, 
        -- but on front and rear of the unit
        local platesFront = kaminari_numbers.getChildrenColorNumber( largeNumberPlates , "white", "Helvetica",  4.0,  6.01, -0.38, 1.45, -90, 0, 0 )
        local platesBack  = kaminari_numbers.getChildrenColorNumber( largeNumberPlates , "white", "Helvetica",  4.0, -6.31,  0.38, 1.45,  90, 0, 0 )
	
-- HERE BEGINS THE USUAL RETURN DATA OF THE MODEL
return {
    boundingInfo = {
        bbMax = { 6.7790122032166, 1.5564205646515, 4.2407073974609, },
        bbMin = { -7.0255718231201, -1.5564205646515, -0.036832869052887, },
    },
    -- the rest of the model ... 
```

And inside each LOD you want to be the numbers shown, usually LOD0 and LOD1, append at the **end** of the meshes the lists of groups defined at the beggining. In the case of this example, `platesLeft`,`platesRight`,`platesFront` and `platesBack`:
```lua
                    -- THE LAST LOD MESH NODE ELEMENT
		    {
                        materials = { "vehicle/train/emissive/train_red_lights.mtl", },
                        mesh = "vehicle/train/db_v100/breaklights_back_lod0.msh",
                        name = "breaklights_back",
                        transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
                    },
                    -- OUR GROUP OF NUMBERS
                    platesLeft,
                    platesRight,
                    platesFront,
                    platesBack
                },
                name = "RootNode",
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
            },
            static = false,
            visibleFrom = 0,
            visibleTo = 200.0,
        },
    -- END OF LOD0, BEGINING OF LOD1
        {
            node = {
                children = {
```

