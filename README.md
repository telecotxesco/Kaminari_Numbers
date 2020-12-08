# Kaminari_Numbers

Please, refer to the [Wiki](https://github.com/telecotxesco/Kaminari_Numbers/wiki) for details.

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
