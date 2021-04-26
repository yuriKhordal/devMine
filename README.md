# devMine
Scripts for /dev/Mine server's OpenComputers mod.

## gitpull.lua
A simple command line utility for downloading lua scripts from repositories.

### Usage
```bash
gitpull [url]
gitpull -h [user]/[repo]
```
Opens the repository and searches for `.lua` files and downloads them, retaining names and containing folder, meaning that if the repository has a script inside `scripts/whatever.lua` a `scripts/` directory will be created(if it not yet exists), and the `whatever.lua` script will be downloaded into it.
The `-h` flag allows to only specify the user and repository name, `gitpull -h userName/repository` is equivalent to `gitpull https://api.github.com/repos/userName/repository`.
Running the command without parameters defaults to this repository, and is equivalent to `gitpull https://api.github.com/repos/yuriKhordal/devMine`.

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
