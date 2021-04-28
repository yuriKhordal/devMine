-- A function module that converts a table object into string representation

_LEADING_SPACE = '  '
function deepStr(obj, tabs) 
	if not tabs then return deepStr(obj, 0) end
	local str = "{\n"
	if type(obj) == "string" then return '"'..obj..'"' end
	if type(obj) ~= "table" then return tostring(obj) end
	for name, value in pairs(obj) do
		str = str..string.rep(_LEADING_SPACE, (tabs + 1))
		str = str..name..": "..deepStr(value, tabs + 1)
		str = str..'\n'
	end
	return str..string.rep(_LEADING_SPACE, tabs).."}"
end

return deepStr