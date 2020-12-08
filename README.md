# Kaminari_Numbers

** Please, refer to the [Wiki](https://github.com/telecotxesco/Kaminari_Numbers/wiki) for details.

## Overview
On Transport Fever it is not possible to assign to each unit a unique serial number (like UIC identification numbers) because the game engine loads and generates the model once when loading the game, and after that the model remains static on memory. It's possible to randomize somehow the numbering at the beggining, but after that it remains the same across all the models of the same unit. That means that all the locomotives of the same model will show the same number during the game.

**KAMINARI NUMBERS** is a mod script that allows to print random serial numbers on similar models without the need of duplicating model files.

## What KAMINARI NUMBERS can do
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

## What KAMINARI NUMBERS can NOT do
* A number on a unit can not be persisted over the time. It changes after some time.
* Two or more units can have the same generated number at the same time. The shorter the list of numbers, the higher probabilities two units share the same number.
* When placing a new unit on map, tt's not possible to shuffle the starting number, so all the units will show the same number for the first time.
* Only numbers, uppercase letters and dot (.), hyphen (-) and slash (/) are available. No lowercase letters or other characters are available.

## When or how I should avoid using KAMINARU NUMBERS
* It is not intended to do all the static labels because of the inefficiency it may introduce. There are other mods available that can do this in a more efficient way.
* Avoid using hundreds of number variations. Units that may have 2, 4, or even 6 times the number printed. Each digit is a mesh (2 polygons) and each variation introduced is also N times the mesh generated. That means if 100 of variations are defined for a 6 digit plate, and it is on 6 different parts of the unit, that sums 3.600 meshes present that equals 7.200 poligons that are added to **each** model present and inside the LOD. **USE WITH CAUTION AND MODERATION TO AVOID MAYOR SLOWDOWN TO THE GAME**

# Initializing KAMINARI NUMBERS on the model
The first thing to do is to initialize the script. This can be easily done by adding this line on top of the MDL file

```lua
local kaminari_numbers = require "kaminari_numbers"
```

After that, you will have something like:

```lua
local kaminari_numbers = require "kaminari_numbers"
function data()
	return {
		boundingInfo = {
			bbMax = { 10.068499565125, 1.4601999521255, 5.6757001876831, },
			bbMin = { -10.068499565125, -1.4601999521255, 0.18279999494553, },
		},
		
		-- Rest of the model data [...]
	
	}
end
```

**NOTE:** Before continuing, try loading the model on the ModelEditor before proceding, in order to get sure the *KAMINARI NUMBERS* are loaded properly.

Between the `function data()` line and the `return {` line you need to add the following lines:

```lua
  local function generateNumbers()
		return { 
			children = {
				-- Call Kaminari_Numbers functions here:
			}
		}
	end

	local numberPlates = generateNumbers()
```

In this local function *generateNumbers* we will generate dinamically the meshes needed for the number and letters of the model, which function is called and stored on a local variable we call *numberPlates* (you can name as your convenience).

The first lines of the mod now become:

```lua
local kaminari_numbers = require "kaminari_numbers"
function data()
	local function generateNumbers()
		return { 
			children = {
				-- Call Kaminari_Numbers functions here:
			}
		}
	end

	local numberPlates = generateNumbers()
	
	return {
		-- REST OF THE MODEL [...]
```

Then, scroll down under the model until you find the first "lod" children, something like:

```lua
  lods = {
		{
			node = {
				children = {
					{
						materials = {
							"vehicle/train/db_v100/db_v100.mtl",
						},
						mesh = "vehicle/train/db_v100/body_lod0.msh",
						name = "body",
						transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
					},
					{
						-- MULTIPLE MODEL MESHES [...]
					},
				},
				name = "RootNode",
				transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
			},
			static = false,
			visibleFrom = 0,
			visibleTo = 200.0,
		},
```

Just after the **LAST** children node, right before the "name = "RootNode"", add the *numberPlates* local variable reference. It is important to be at the last position in order to avoid messing with the forwardFrontParts, normally used for showing or hidding the train lights depending the direction of movement.

Somehow it will become like this:

```lua
  lods = {
		{
			node = {
				children = {
					{
						materials = { 
							"vehicle/train/db_v100/db_v100.mtl", 
						},
						mesh = "vehicle/train/db_v100/body_lod0.msh",
						name = "body",
						transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
					},
					{
						-- MULTIPLE MODEL MESHES [...]
					},
					numberPlates -- HERE WE ADD THE VARIABLE CALL
				},
				name = "RootNode",
				transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
			},
			static = false,
			visibleFrom = 0,
			visibleTo = 200.0,
		},
```

**NOTE:** The model may have many LOD defined (level of details), each one with visibleFrom and visibleTo distances. Consider referencing the local variable *numberPlates* only if the distance is close enough to be shown or not.

# Generating the numbers
There are multiple ways to generate the numbers. On each one, we will modify the generateNumbers local function defined at the beggining of the model.

## Simple static number
To add a number, simply call the following function:

```lua
kaminari_numbers.getChildrenColorNumber( {"V 100-1035","V 100-1023"} , "white", "Helvetica", 10.0, 2.20, -1.00, 2.05, 180, 0, 0 ),
```

