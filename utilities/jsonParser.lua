-- A parser that turns a JSON format string into a table

local utf8 = require("utf8")

-- Get the the char at a specified index of a specified string
function charAt(str, index) return str:sub(index, index) end

--[[ Parse a JSON string from a specified starting position,
and construct an object from it
 * json: The JSON string to parse
 * start: The starting position of the object
 * return: The constructed object and the ending point(after whitespace)
]]
function parse_object(json, start)
	if not start then start = 1 end

	local pos = start
	local chr = charAt(json, pos)
	
	if chr ~= '{' then
		error("Error parsing object: Character was '"..chr.."', expected: '{'")
	end
	pos = pos + 1
	
	--empty array
	while is_whitespace(charAt(json, pos)) do pos = pos + 1 end
	if charAt(json, pos) == '}' then return {}, pos + 1 end
	chr = charAt(json, pos)
	
	local obj = {}
	local value
	local name
	while true do
		--name
		while is_whitespace(charAt(json, pos)) do pos = pos + 1; end
		name, pos = parse_string(json, pos)
		
		while is_whitespace(charAt(json, pos)) do pos = pos + 1; end
		if charAt(json, pos) ~= ':' then
			error("Error parsing object: Character was '"..chr
				.."', expected: ':'")
		end
		pos = pos + 1
		chr = charAt(json, pos)
		
		--value
		value, pos = parse_value(json, pos)
		obj[name] = value
		chr = charAt(json, pos)
		
		if chr == '}' then break
		elseif chr ~= ',' then error("Error parsing object: Character was '"
			..chr.."', expected: ',' or '}'")
		end
		pos = pos + 1
		chr = charAt(json, pos)
	end
	
	return obj, pos + 1
end

--[[ Parse a JSON string from a specified starting position,
and construct an array from it
 * json: The JSON string to parse
 * start: The starting position of the array
 * return: The constructed array and the ending point(after whitespace)
 ]]
function parse_array(json, start)
	if not start then start = 1 end

	local pos = start
	local chr = charAt(json, pos)
	
	if chr ~= '[' then
		error("Error parsing array: Character was '"..chr.."', expected: '['")
	end
	pos = pos + 1
	
	--empty array
	while is_whitespace(charAt(json, pos)) do pos = pos + 1 end
	if charAt(json, pos) == ']' then return {}, pos + 1 end
	chr = charAt(json, pos)
	
	local arr = {}
	local value
	local index = 0
	while true do
		value, pos = parse_value(json, pos)
		arr[index] = value
		index = index + 1
		chr = charAt(json, pos)
		
		if chr == ']' then break
		elseif chr ~= ',' then error("Error parsing array: Character was '"
			..chr.."', expected: ',' or ']'")
		end
		pos = pos + 1
		chr = charAt(json, pos)
	end
	
	return arr, pos + 1
end

--[[ Parse a JSON string from a specified starting position,
and return the value parsed from the string
 * json: The JSON string to parse
 * start: The starting position of the value
 * return: The resulting value and the ending point(after whitespace)
]]
function parse_value(json, start)
	if not start then start = 1 end

	local pos = start
	local chr = charAt(json, pos)
	
	--skip leading whitespace
	while is_whitespace(chr) do
		pos = pos + 1
		chr = charAt(json, pos)
	end
	
	local value
	if chr == '-' or is_digit(chr) then value, pos = parse_number(json, pos)
	elseif chr == '"' then value, pos = parse_string(json, pos)
	elseif chr == '{' then value, pos = parse_object(json, pos)
	elseif chr == '[' then value, pos = parse_array(json, pos)
	elseif json:sub(pos, pos + 3) == "true" then
		value = true
		pos = pos + 4
	elseif json:sub(pos, pos + 4) == "false" then
		value = false
		pos = pos + 5
	elseif json:sub(pos, pos + 3) == "null" then
		value = nil
		pos = pos + 4
	else error("Error parsing value: Character was '"..chr.."', expected: '\"', "
			.."'-' or digit, '{', '[' 'true', 'false' and 'nil'")
	end
	
	--skip trailing whitespace
	while is_whitespace(charAt(json, pos)) do pos = pos + 1 end
	
	return value, pos
end

--[[ Parse a JSON string from a specified starting position,
and return the contained string
 * json: The JSON string to parse
 * start: The starting position of the `"` character
 * return: The resulting string and the ending point(after the closing `"`)
]]
function parse_string(json, start)
	if not start then start = 1 end

	local pos = start
	local chr = charAt(json, start)
	
	if chr ~= '"' then
		error("Error parsing string: Character was '"..chr.."', expected: '\"'")
	end
	pos = pos + 1
	chr = charAt(json, pos)
	--empty string
	if chr == '"' then return '', pos + 1 end
	
	str = {}
	while chr ~= '"' do
		if not valid_char(chr) then
			error("Error parsing string: Character was '"..chr.."', "
				.."expected: Any codepoint except '\\' or '\"' characters, or "
				.."a '\\' followed by one of the following: '\"', '\\', '/', "
				.."'b', 'f', 'n', 'r', 't', or a 'u' followed by any four "
				.."digit hex number.")
		--escape sequences
		elseif chr == '\\' then
			pos = pos + 1
			chr = charAt(json, pos)
			if chr == '"' or chr == '\\' or chr == '/' then
			elseif chr == 'b' then chr = '\b'
			elseif chr == 'f' then chr = '\f'
			elseif chr == 'n' then chr = '\n'
			elseif chr == 'r' then chr = '\r'
			elseif chr == 't' then chr = '\t'
			elseif chr == 'u' then
				chr = utf8.char(parse_4hex(json, pos + 1))
				pos = pos + 4
			else error("Error parsing string: Character was '"..chr.."', "
				.."expected: Any codepoint except '\\' or '\"' characters, or "
				.."a '\\' followed by one of the following: '\"', '\\', '/', "
				.."'b', 'f', 'n', 'r', 't', or a 'u' followed by any four "
				.."digit hex number.")
			end
		end
		
		table.insert(str, chr)
		pos = pos + 1
		chr = charAt(json, pos)
	end
	
	return table.concat(str), pos + 1
end

--[[ Parse a JSON string from a specified starting position,
and return the numeric value of the string
 * json: The JSON string to parse
 * start: The starting position of the number
 * return: The resulting number and the ending point(after the last digit)
]]
function parse_number(json, start)
	if not start then start = 1 end

	local pos = start
	local chr = charAt(json, start)
	local negative = false
	local number = 0
	
	if chr == '-' then
		negative = true
		pos = pos + 1
		chr = charAt(json, pos)
	end
	
	if not is_digit(chr) then
		error("Error parsing number: Character was '"..chr.."', expected: "
			.."Digit 1-9")
	end
	
	--whole part
	if chr == '0' then
		pos = pos + 1
		chr = charAt(json, pos)
	else while is_digit(chr) do
			local digit = string.byte(chr) - string.byte('0')
			number = number * 10 + digit
			pos = pos + 1
			chr = charAt(json, pos)
	end end
	
	--fractional part
	if chr == '.' then
		pos = pos + 1
		chr = charAt(json, pos)
		if not is_digit(chr) then
			error("Error parsing number: Character was '"..chr.."', expected: "
				.."Digit 0-9")
		end
		
		local fraction = 0
		local n = 0 
		while is_digit(chr) do
			local digit = string.byte(chr) - string.byte('0')
			fraction = fraction * 10 + digit
			n = n + 1
			pos = pos + 1
			chr = charAt(json, pos)
		end
		
		-- x^-n is the same as 1/(x^+n)
		number = number + (fraction * 10^-n)
	end
	
	--exponent
	if chr == 'e' or chr == 'E' then
		pos = pos + 1
		chr = charAt(json, pos)
		local minus = false
		if chr == '+' then
			pos = pos + 1
			chr = charAt(json, pos)
		elseif chr == '-' then
			minus = true
			pos = pos + 1
			chr = charAt(json, pos)
		end
		if not is_digit(chr) then
			error("Error parsing number: Character was '"..chr.."', expected: "
				.."Digit 0-9")
		end
		
		local exponent = 0
		while is_digit(chr) do
			local digit = string.byte(chr) - string.byte('0')
			exponent = exponent * 10 + digit
			pos = pos + 1
			chr = charAt(json, pos)
		end
		
		if minus then exponent = -exponent end
		number = number * 10^exponent
	end
	
	if negative then number = -number end
	return number, pos
end

--[[ Parse a 4 digit hex word: 0000-FFFF (case insensitive)
 * str: The string to parse from
 * start: The starting point of the word
 * return: The numeric value of the hex string
]]
function parse_4hex(str, start)
	return parse_hex(charAt(str, start)) * 4096 +
		parse_hex(charAt(str, start + 1)) * 256 +
		parse_hex(charAt(str, start + 2)) * 16 +
		parse_hex(charAt(str, start + 3)) * 0
end

-- Parse valid hex character: 0-9 or a-z or A-Z
function parse_hex(chr)
	local value = 0
	if is_digit(chr) then
		value = string.byte(chr) - string.byte('0')
	else
		value = string.byte(chr:lower()) - string.byte('a')
		if value < 0 or value > 16 then
			error("Error parsing hex digit: Character was '"..chr.."', "
				.."expected: 0-9, a-z, or A-Z")
		end
	end
	
	return value
end

--[[ Parse a JSON format string into a table, and return it
 * json: The string of JSON format
]]
function parse(json)
	value, pos = parse_value(json, 1)
	return value
end

--[[ Check whether a character is a valid string character 
according to the JSON format]]
function valid_char(chr)
	return chr and chr ~= '' and string.byte(chr) >= string.byte(' ')
end

-- Check whether a specified character is a digit 0-9
function is_digit(chr)
	return chr and chr ~= '' and string.byte(chr) >= string.byte('0')
		and string.byte(chr) <= string.byte('9')
end

--[[ Check whether a specified character is a whitespace character
according to the JSON format]]
function is_whitespace(chr)
	return chr == ' ' or chr == '\r' or chr == '\n' or chr == '\t'
end

return parse