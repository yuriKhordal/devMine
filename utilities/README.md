# Utilities

Modules that provide usefull functionalities for developers.

## jsonParser.lua
A JSON parser that turns JSON strings into lua tables.

### Usage
```lua
local parse = require("jsonParser")
parse(JSON: string)
```
The module is exported as a single function, that gets a string in JSON format, and returns a table constructed form the values in the string.

## deepString.lua
A function that returns a string represantation of a table in a format similar to JSON.

### Usage
```lua
local deepString = require("deepString")
deepString(tbl: table[, tabs: number])
```
The module is exported as a single function, that gets a table and tabs(*optional*, default is 0) , and returns a string in the following format:
```
{
[_LEADING_SPACE*(tabs+1)] [key1]: [deepString(value1, tabs+1)]
[_LEADING_SPACE*(tabs+1)] [key2]: [deepString(value2, tabs+1)]
...
[_LEADING_SPACE*(tabs+1)] [keyn]: [deepString(valuen, tabs+1)]
[_LEADING_SPACE*tabs] }
```
