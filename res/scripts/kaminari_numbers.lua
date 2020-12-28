--[[
	KAMINARI_NUMBERS - Author: Kaminari 2020
	===========================================================
	Random numbers and characters generator mod for models
	
	It's a free mod. Use at your own risk. I take no responsability for any bad usage of this mod.

]]--
local vec3 = require "vec3"
local transf = require "transf"

local kaminari_numbers = { }

local hideDisplacement = -0.05
local animationSpeed   = 1000000
local maxNumbers       = 100
local next = next

local numberQuantity = 0
local modelVariant = ""
local modPath

-- Function to generate a list of numbers
-- startNumber:  integer - The starting number
-- endNumber:    integer - The last number
-- randomized:   boolean - true: randomize list - false: ordered list
-- appendZeroes: integer - number of zeroes to append. "0" for none like "1". For example: 4 will print like "0043"
-- prefix:       string  - Any string to be added before the automatic generated number. If don't want to use, specify "". (i.e: "252-" will generate a list of "252-XXX")
-- suffix:       string  - Any string to be added after the automatic generated number. If don't want to use, specify "". (i.e: "/23" will generate a list of "XXX/23")
function kaminari_numbers.buildListOfNumbers( startNumber, endNumber, randomized, appendZeroes, prefix, suffix )
	local listOfNumbers = {}
	returnNumberList    = {}
	numberLength        = string.len( tostring(endNumber) )
	numberQuantity      = 0
	
	i = startNumber
	repeat
		table.insert(listOfNumbers,i)
		i = i+1
		numberQuantity = numberQuantity + 1
		-- Prevent too much numbers (slowdown)
		if numberQuantity > maxNumbers then
			endNumber = i
		end
	until i == endNumber

	i = startNumber
	repeat	
		if randomized == true then
			rnd = math.random(i, endNumber-1)
			result        = rnd - i + 1
			choosenNumber = listOfNumbers[result]
		else
			choosenNumber = listOfNumbers[1]
		end
	
		local numberToInsert = tostring(choosenNumber)

		if appendZeroes > 0 then
			formatNumber = "%0"..appendZeroes.."d"
			numberToInsert = string.format( formatNumber, numberToInsert ) 
		end
				
		if prefix ~= NIL then
			numberToInsert = prefix .. numberToInsert
		end
					
		if suffix ~= NIL then
			numberToInsert = numberToInsert .. suffix
		end
		
		table.insert(returnNumberList, numberToInsert )

		if tablelength( listOfNumbers ) > 0 then
			tempListOfNumbers = {}
			for j, value in pairs(listOfNumbers) do
				if value ~= choosenNumber then
					table.insert(tempListOfNumbers, value)
				end
			end

			listOfNumbers = tempListOfNumbers
			i = i+1
		else
			i = endNumber
		end
	until i == endNumber

	return returnNumberList
end

-- Function to generate a list of random characters following a pattern
-- listValidCharacters:  list of strings - A list of characters allowed. Each index is a fixed position. (i.e.) { "ABC", "01234", "01234" } will generate numbers like "A01", "C32", "B
-- numberOfResults:      integer - The number of results to obtain
-- prefix:               string  - Any string to be added before the automatic generated number. If don't want to use, specify "". (i.e: "252-" will generate a list of "252-XXX")
-- suffix:               string  - Any string to be added after the automatic generated number. If don't want to use, specify "". (i.e: "/23" will generate a list of "XXX/23")
function kaminari_numbers.generateRandomCharacters( listValidCharacters, numberOfResults, prefix, suffix )
	local listOfNumbers = {}
	numCharacters       = tablelength( listValidCharacters )
	
	if listValidCharacters == nil or numberOfResults < 1 then return generatedWord end
	
	-- Prevent too much numbers (slowdown)
	if numberOfResults > maxNumbers then
		numberOfResults = maxNumbers
	end
	
	idx = 1
	repeat
		i = 1
		generatedWord = ""
		repeat
			local rnd = 1
			local resultingChar = ""

			qtyOfCharacters     = string.len( tostring(listValidCharacters[i]) )
			if qtyOfCharacters > 1 then
				rnd = math.random( 1, qtyOfCharacters )
				resultingChar = string.sub( listValidCharacters[i], rnd, rnd ) 
			else
				resultingChar = tostring(listValidCharacters[i])
			end
			generatedWord = generatedWord .. resultingChar
		
			i = i + 1
		until i > numCharacters

		if prefix ~= NIL then
			generatedWord = prefix .. generatedWord
		end
					
		if suffix ~= NIL then
			generatedWord = generatedWord .. suffix
		end

		table.insert( listOfNumbers, string.upper( generatedWord ) )
		idx = idx + 1
	until idx >= numberOfResults
	
	return listOfNumbers
end

-- Function to obtain the children node to be put on LOD tag in the model.
-- listOfNumbers: table of strings - a table with all the numbers to be printed (i.e.: {"201", "202, "203"})
-- color:         string - the color of the label: see documentation for complete list (i.e.: "white")
-- font:          string - the name of the font: see documentation for complete list (i.e.: "Helvetica")
-- size:          float - the size of the number. A typical value is 4.0
-- x:             float - the position X to be placed the first character of the number
-- y:             float - the position Y to be placed the first character of the number
-- z:             float - the position Z to be placed the first character of the number
-- rotx:          float - the rotation on axis X in degrees to be applied to the whole number
-- roty:          float - the rotation on axis Y in degrees to be applied to the whole number
-- rotz:          float - the rotation on axis Z in degrees to be applied to the whole number
function kaminari_numbers.getChildrenColorNumber( listOfNumbers, 
									   color,
									   font,
									   size,
									   x,
									   y, 
									   z,
									   rotx,
									   roty,
									   rotz,
									   xcomp)
	
	local spacing = 1
			
	local compression = (xcomp == nil and 1.0) or xcomp
			
	local numberTransf = transf.scaleRotZYXTransl(
													vec3.new( 1.0, 1.0, 1.0 ), 
													transf.degToRad( 0.0, 0.0, 0.0), 
													vec3.new( 0.0, 0.0, 0.0)
												 )
	
	local labelTransf = transf.scaleRotZYXTransl(
													vec3.new( size * compression, size, 1.0 ), 
													transf.degToRad( 180.0 + rotx, roty, 90.0 + rotz), 
													vec3.new( x, y, z)
												 )
	
	modPath = getModPath()
	prepareMaterialFileFromColor( font, color )
	
	result = {
		children = {
			buildRandomNumbers( listOfNumbers, color, font, spacing, numberTransf )
		},
		transf = labelTransf
	}
	
	return result
end

-- Function to obtain the children node to be put on LOD tag in the model.
-- listOfNumbers: table of strings - a table with all the numbers to be printed (i.e.: {"201", "202, "203"})
-- r:             integer - the RED component of the color of the number, from 0 to 255.
-- g:             integer - the GREEN component of the color of the number, from 0 to 255.
-- b:             integer - the BLUE component of the color of the number, from 0 to 255.
-- font:          string - a typical value is 4.0
-- size:          float - the size of the number
-- x:             float - the position X to be placed the first character of the number
-- y:             float - the position Y to be placed the first character of the number
-- z:             float - the position Z to be placed the first character of the number
-- rotx:          float - the rotation on axis X in degrees to be applied to the whole number
-- roty:          float - the rotation on axis Y in degrees to be applied to the whole number
-- rotz:          float - the rotation on axis Z in degrees to be applied to the whole number
function kaminari_numbers.getChildrenRGBNumber( listOfNumbers, 
									   r,g,b,
									   font,
									   size,
									   x,
									   y, 
									   z,
									   rotx,
									   roty,
									   rotz,
									   xcomp)
	
	local spacing = 1
	
	local compression = (xcomp == nil and 1.0) or xcomp
				   
	local numberTransf = transf.scaleRotZYXTransl(
													vec3.new( 1.0, 1.0, 1.0 ), 
													transf.degToRad( 0.0, 0.0, 0.0), 
													vec3.new( 0.0, 0.0, 0.0)
												 )
	
	local labelTransf = transf.scaleRotZYXTransl(
													vec3.new( size * compression, size, 1.0 ), 
													transf.degToRad( 180.0 + rotx, roty, 90.0 + rotz), 
													vec3.new( x, y, z)
												 )
	
	modPath = getModPath()
	prepareMaterialFileFromRGB( font, r, g, b )
	
	result = {
		children = {
			buildRandomNumbers( listOfNumbers, getRGBname( r, g, b ), font, spacing, numberTransf )
		},
		transf = labelTransf
	}
	
	return result
end
-- PRIVATE METHODS

-- Build a list of numbers
function buildRandomNumbers( listOfNumbers, strColor, strFont, spacing, transfLocation ) 
	local childrenNumbers = {}
	local count = tablelength( listOfNumbers )
	local isStatic = false
	if count == 1 then 
		isStatic = true
	end

	if isStatic == true then
		for i, strNum in ipairs( listOfNumbers ) do
			table.insert(childrenNumbers, {
					children = buildNumber(strNum, strColor, strFont, spacing, isStatic, i, count),
					transf = transfLocation
			})
		end
	else
		for i, strNum in ipairs( listOfNumbers ) do
			table.insert(childrenNumbers, {
					animations = getAnimation( i, count ),
					children = buildNumber(strNum, strColor, strFont, spacing, isStatic, i, count),
					transf = transfLocation
			})
		end
	end


	
	return {
		children = childrenNumbers
	}
	
end

-- Build single string number
function buildNumber(strNumber, strColor, strFont, spacing, static, index, length)
	numberMeshTable = {}
	strNumber = string.upper(strNumber)
	tableNumber = getNumberText(strNumber)
	local ptransf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	
	for i, charNum in ipairs(tableNumber) do
		table.insert(numberMeshTable, getMeshNumber(charNum, strColor, strFont, ptransf, static, index, length))
		ptransf = getNextCharacterPosition( charNum, strFont, ptransf, spacing )
	end

	return numberMeshTable
end

-- Get the table of numbers
function getNumberText(strNumber)
    textTable = {}

    for t in string.gmatch(strNumber,"([0-9A-Z\\/%-\\.\\ ])") do
        table.insert(textTable,t)
    end
	
    return textTable
end

-- Get next number position
function getNextCharacterPosition( charNum, font, lastPosition, spacing )
	local width = 0.0243
	local bNum = tonumber(charNum) ~= nil

	if font == "Helvetica" then
		if bNum == true or charNum == "/" or charNum == "-" then
			width = 0.02
		elseif charNum == "I" or charNum == "." then
			width = 0.01
		elseif charNum == "J" then
			width = 0.02
		elseif charNum == "W" then
			width = 0.032
		elseif charNum == " " then
			width = 0.012
		end
	elseif font == "DIN1451" then
		if bNum == true or charNum == "/" or charNum == "-" then
			width = 0.02
		elseif charNum == "I" or charNum == "." then
			width = 0.01
		elseif charNum == "J" then
			width = 0.02
		elseif charNum == "W" then
			width = 0.032
		elseif charNum == " " then
			width = 0.012
		end
	elseif font == "CenturyGothic" or font == "British" then
		if bNum == true or charNum == "/" or charNum == "-" then
			width = 0.02
		elseif charNum == "I" or charNum == "." then
			width = 0.01
		elseif charNum == "B" or 
			   charNum == "E" or 
			   charNum == "F" or 
			   charNum == "J" or 
			   charNum == "K" or 
			   charNum == "L" or 
			   charNum == "P" or 
			   charNum == "R" or 
			   charNum == "S" or 
			   charNum == "T" or 
			   charNum == "U" or 
			   charNum == "X" or 
			   charNum == "Y" or 
			   charNum == "Z" then
			width = 0.02
		elseif charNum == "W" then
			width = 0.0315
		elseif charNum == " " then
			width = 0.012
		end
	elseif font == "Renfe3" then
		if charNum == "/" or charNum == "-" then
			width = 0.02
		elseif charNum == "1" or charNum == "I" or charNum == "." then
			width = 0.01
		elseif charNum == "W" then
			width = 0.032
		elseif charNum == " " then
			width = 0.012
		end
	else
		width = 0.0243
	end

	local position = lastPosition[13] + width*spacing 
    return { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, position, 0, 0, 1 }
end

-- Get the respective mesh of the number
function getMeshNumber( charNumber, strColor, strFont, transformation, static, index, length )
	local meshDigit
	local meshName
	local meshPrefix = "Kaminari_Numbers"
	
	if charNumber == "." then
		meshName = "Dot"
	elseif charNumber == "/" then
		meshName = "Slash"
	elseif charNumber == "-" then
		meshName = "Hyphen"
	elseif charNumber == " " then
		return meshDigit
	else
		meshName = charNumber
	end

	if fileExists(modPath .. "res/models/material/kaminari_numbers/" .. strFont .. "_" .. strColor .. ".mtl") and
	   fileExists(modPath .. "res/models/mesh/kaminari_numbers/" .. meshPrefix .. "_" .. meshName .. "_lod0.msh") then
	
		meshDigit = {
			materials = { "kaminari_numbers/" .. strFont .. "_" .. strColor .. ".mtl", },
						mesh = "kaminari_numbers/" .. meshPrefix .. "_" .. meshName .. "_lod0.msh",
						transf = transformation
		}
	else
		print ("[kaminari_numbers.getMeshNumber()] WARNING: Mesh or material not found! Check:")
		print (modPath .. "res/models/material/kaminari_numbers/" .. strFont .. "_" .. strColor .. ".mtl")
		print (modPath .. "res/models/mesh/kaminari_numbers/" .. meshPrefix .. "_" .. meshName .. "_lod0.msh")
	end
	
	return meshDigit
end 

-- ANIMATION REGION
function getAnimation(index, length)
	local animationTag

	if fileExists( modPath .."res/models/animation/kaminari_numbers/" .. animationSpeed .. "_" .. length .. "_" .. index ..".ani") == false then
		local animationFile = generateAnimationFile( getKeyFramesAnimation(index, length) )
		writeFile(animationFile, "res/models/animation/kaminari_numbers/" .. animationSpeed .. "_" .. length .. "_" .. index ..".ani")
	end

	animationTag = {
		forever = {
			params = {
				id = "kaminari_numbers/" .. animationSpeed .. "_" .. length .. "_" .. index ..".ani",
			},
			type = "FILE_REF"
		}
	}
	
	return animationTag
end

function getKeyFramesAnimation(index, length)
	local animationTag
	
	keyFrames = {}

	local i = 0
	repeat
		table.insert(keyFrames, getFrame(i, index-1, 0.0, 0.0, hideDisplacement, 0))
		table.insert(keyFrames, getFrame(i, index-1, 0.0, 0.0, hideDisplacement, 1))
		table.insert(keyFrames, getFrame(i, index-1, 0.0, 0.0, hideDisplacement, 2))
		table.insert(keyFrames, getFrame(i, index-1, 0.0, 0.0, hideDisplacement, 3))
		i = i+1
	until i == length

	return keyFrames
end

function getFrame(index, frontFrame, x, y, z, step)
	local keyFrameTag
	local t = animationSpeed * index
	local instant
	local ffx = x
	local ffy = y
	local ffz = z
	
	if index == frontFrame and (step == 1 or step == 2) then
		ffx = 0.0
		ffy = 0.0
		ffz = 0.0
	end
	
	if step == 0 then
		instant = t
	elseif step == 1 then
		instant = t + 1
	elseif step == 2 then
		instant = t + animationSpeed - 2
	else
		instant = t + animationSpeed - 1
	end
	
	keyFrameTag = {
		time = instant,
		transf = transf.scaleRotZYXTransl(
											vec3.new( 1.0, 1.0, 1.0 ), 
											transf.degToRad( 0.0, 0.0, 0.0), 
											vec3.new( ffx, ffy, ffz)
										 ),
	}
	
	return keyFrameTag
end

function generateAnimationFile( myanimation )
	local times = {}
	local transfs = ""
	local count = tablelength( myanimation )
	local i = 1
	
	if count > 0 then
		repeat
			for key, value in pairs ( myanimation[i] ) do
				if type (value) ~= "table" then
					if key == "time" then
						table.insert( times, value )
					end
				elseif key == "transf" then
					local transfLen = tablelength( value )
					if transfLen == 16 then
						transfs = transfs .. "\t\t{"
						for j, v in pairs(value) do
							transfs = transfs .. string.format(" %s,", tostring(v))
						end
						transfs = transfs .. "},\n"
					end
				end
			end
			i = i+1
		until i > count 
	end
	
	local tbTimes
	tbTimes = table_print( times )

	return string.format("function data()\nreturn {\n\ttimes = {%s},\n\ttransfs = {\n%s\t}\n}\nend\n", tostring(tbTimes), tostring(transfs))
	
end
-- END ANIMATION REGION

-- MATERIAL FONT REGION
function kaminari_numbers.colorAlbedoFromColorName( fontName )
	if fontName == "white" 		then return { 1.0, 1.0, 1.0, }		end
	if fontName == "black" 		then return { 0.0, 0.0, 0.0, }	    end

	if fontName == "gray" 		then return { 0.5, 0.5, 0.5, }	    end
	if fontName == "darkgray" 	then return { 0.25, 0.25, 0.25, }	end
	if fontName == "cleargray" 	then return { 0.75, 0.75, 0.75, }	end

	if fontName == "blue" 		then return { 0.0, 0.0, 1.0, }		end
	if fontName == "darkblue" 	then return { 0.0, 0.0, 0.5, }		end
	if fontName == "lightblue" 	then return { 0.5, 1.0, 1.0, }		end

	if fontName == "green" 		then return { 0.0, 1.0, 0.0, }		end
	if fontName == "darkgreen" 	then return { 0.0, 0.5, 0.0, }	    end
	if fontName == "lightgreen" then return { 0.5, 1.0, 0.5, }		end

	if fontName == "red" 		then return { 1.0, 0.0, 0.0, }		end
	if fontName == "darkred" 	then return { 0.5, 0.0, 0.0, }	    end
	if fontName == "lightred" 	then return { 1.0, 0.5, 0.5, }	    end

	if fontName == "pink" 		then return { 1.0, 0.0, 1.0, }		end

	if fontName == "purple" 	then return { 0.5, 0.0, 0.5, }	    end
	if fontName == "lightpurple" then return { 1.0, 0.5, 1.0, }	    end

	if fontName == "yellow" 	then return { 1.0, 1.0, 0.0, }		end
	if fontName == "darkyellow" then return { 0.5, 0.5, 0.0, }	    end
	if fontName == "lightyellow" then return { 1.0, 1.0, 0.5, }		end

	if fontName == "orange" 	then return { 1.0, 0.75, 0.0, }		end
	if fontName == "darkorange" then return { 1.0, 0.5, 0.0, }	    end
	
	print ("[kaminari_numbers.colorAlbedoFromColorName( " .. fontName .. " )] WARNING: Color not defined. Applying color white...")
	return  { 1.0, 1.0, 1.0, }
end

function prepareMaterialFileFromColor(fontName, colorName)

	if fileExists(modPath .. "res/models/material/kaminari_numbers/" .. fontName .. "_" .. colorName .. ".mtl") == false then
		local materialFile = generateMaterialFileFromColorName( fontName, colorName )
		writeFile(materialFile, "res/models/material/kaminari_numbers/" .. fontName .. "_" .. colorName .. ".mtl")
	end
	
end

function prepareMaterialFileFromRGB(fontName, r, g, b)
	local colorName = getRGBname( r, g, b ) 
	
	if fileExists(modPath .. "res/models/material/kaminari_numbers/" .. fontName .. "_" .. colorName .. ".mtl") == false then
		local materialFile = generateMaterialFileFromRGB( fontName, r, g, b )
		writeFile(materialFile, "res/models/material/kaminari_numbers/" .. fontName .. "_" .. colorName .. ".mtl")
	end
	
end

function getRGBname( r, g, b )
	return tostring(r) .. "_" .. tostring(g) .. "_" .. tostring(b) 
end

function generateMaterialFileFromColorName( fontName, fontColor )
	return string.format("local kaminari_numbers = require \"kaminari_numbers\"\n\nfunction data()\n\tlocal albedoScale = kaminari_numbers.colorAlbedoFromColorName( \"%s\" )\n\treturn kaminari_numbers.getFontMaterial( albedoScale, \"%s\" )\nend\n", tostring(fontColor), tostring(fontName))
end

function generateMaterialFileFromRGB( fontName, r, g, b )
	if r > 255 then r = 1.0 else r = tonumber(string.format("%.2f", r/255)) end
	if g > 255 then g = 1.0 else g = tonumber(string.format("%.2f", g/255)) end
	if b > 255 then b = 1.0 else b = tonumber(string.format("%.2f", b/255)) end

	return string.format("local kaminari_numbers = require \"kaminari_numbers\"\n\nfunction data()\n\tlocal albedoScale = {%s, %s, %s,}\n\treturn kaminari_numbers.getFontMaterial( albedoScale, \"%s\" )\nend\n", tostring(r), tostring(g), tostring(b), tostring(fontName))
end

function kaminari_numbers.getFontMaterial( albedoScaleColor, fontFile )
	if modPath == NIL then
		modPath = getModPath()
	end
	

	if fileExists( modPath .. "res/textures/models/kaminari_numbers/" .. fontFile .. ".dds" ) == false then
		fontFile = "Helvetica"
	end

	return {
		order = 20,
		params = {
			albedo_scale = {
				albedoScale = albedoScaleColor,
			},
			alpha_scale = {
				alphaScale = 1,
			},
			alpha_test = {
				alphaThreshold = 1.15,
				cutout = true,
			},
			color_blend = {
				albedoScales = { 1.12, },
				colors = { },
			},
			dirt_rust = {
				age = 0,
				dirtColor = { 0.23137255012989, 0.18823529779911, 0.14901961386204, },
				dirtOpacity = 0.05,
				dirtScale = 16,
				rustColor = { 0.34901961684227, 0.26274511218071, 0.21176470816135, },
				rustOpacity = 0.5,
				rustScale = 1.6730800867081,
			},
			fade_out_range = {
				fadeOutEndDist = 20000,
				fadeOutStartDist = 10000,
			},
			map_albedo_opacity = {
				fileName = "models/kaminari_numbers/" .. fontFile .. ".dds",
				scaleDownAllowed = false,
				type = "TWOD",
			},
			map_cblend_dirt_rust = {
				fileName = "models/kaminari_numbers/dust.dds",
				type = "TWOD",
			},
			map_dirt = {
				fileName = "models/vehicle/dirt_albedo.dds",
				type = "TWOD",
				wrapS = "REPEAT",
				wrapT = "REPEAT",
			},
			map_dirt_normal = {
				fileName = "models/kaminari_numbers/nrml.dds",
				redGreen = true,
				type = "TWOD",
				wrapS = "REPEAT",
				wrapT = "REPEAT",
			},
			map_metal_gloss_ao = {
				fileName = "default_metal_gloss_ao.tga",
				scaleDownAllowed = false,
				type = "TWOD",
			},
			map_normal = {
				fileName = "models/kaminari_numbers/nrml.dds",
				redGreen = true,
				type = "TWOD",
			},
			map_rust = {
				fileName = "models/vehicle/rust_albedo.dds",
				type = "TWOD",
				wrapS = "REPEAT",
				wrapT = "REPEAT",
			},
			map_rust_normal = {
				fileName = "models/kaminari_numbers/nrml.dds",
				redGreen = true,
				type = "TWOD",
				wrapS = "REPEAT",
				wrapT = "REPEAT",
			},
			normal_scale = {
				normalScale = 1,
			},
			polygon_offset = {
				factor = 0,
				forceDepthWrite = false,
				units = 0,
			},
			two_sided = {
				flipNormal = true,
				twoSided = false,
			},
		},
		type = "PHYS_TRANSPARENT_NRML_MAP_CBLEND_DIRT",
	}

end

-- END MATERIAL FONT REGION

-- HELPERS REGION
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function tableEmpty(t)
	return next(t) == nil
end

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent))
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, key .. " = {\n");
        table.insert(sb, table_print (value, indent, done))
        table.insert(sb, string.rep (" ", indent))
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("%s,", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = %s\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function writeFile( content, fileName )
	local file = io.open( modPath .. fileName, "w" )
	if file then
		file:write( content )
		file:close()
	end
end
-- END HELPERS REGION

-- MOD FILE REGION
function fileExists(fileName)
	local file = io.open(fileName, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function getModPath()
	local function debugPath ()
		local level = 1
		local info

		repeat
			info = debug.getinfo(level, "S")
			if info ~= nil then
				if string.find(info.source, "/2312549569/") then
					return string.gsub(string.gsub(info.source, '\\', '/'), '@', "")
				elseif string.find(info.source, "/staging_area/kaminari_numbers_1/") then
					return string.gsub(string.gsub(info.source, '\\', '/'), '@', "")
				end
			end
			level = level + 1
		until (info == nil)
		if (level > 1) then
			return string.gsub(string.gsub(debug.getinfo(level - 2, 'S').source, '\\', '/'), '@', "")
		else
			return ""
		end
	end

	local result = debugPath ()
	local i = result:find("/res/")

	if i then
		return result:sub(1, i)
	else
		return result:match("(.*[/\\])")
	end

end
-- END MOD FILE REGION

return kaminari_numbers
