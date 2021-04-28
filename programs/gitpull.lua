local deepStr = require("deepString")
local parse = require("jsonParser")
local internet = require("internet")

-- The current directory
local cd = shell.getWorkingDirectory()..'/'

-- Checks whether a string ends with another string
function endswith(str, ending)
	return str:sub(#str - #ending + 1, #str) == ending
end

-- Traverse repository metadata to search for lua files
function findLua(repo)
	for i = 0, #repo do
		local file = repo[i]
		
		if file.type == "file" and endswith(file.name, ".lua") then
			print("Lua file found: "..file.path)
			getFile(file)
		elseif file.type == "dir" then
			local request = internet.request(src.."/contents/"..file.path)
			local json = ""
			for packet in request do json = json..packet end
			local subrepo = parse(json)
			findLua(subrepo)
		end
	end
end

-- Download file from the internet and save it on the computer
function getFile(file)
	local path = filesystem.path(file.path)
	if path:sub(1,1) ~= '/' then path = filesystem.concat(cd, path) end
	path = filesystem.canonical(path)
	local fullpath = filesystem.concat(path, file.name)
	
	if not filesystem.exists(path) then
		filesystem.makeDirectory(path)
	elseif filesystem.exists(fullpath) then
		filesystem.remove(fullpath)
	end
	
	local url = file.download_url
	local request = internet.request(url)
	local newFile = io.open(fullpath, "w")
	if not newFile then print("Failed opening file."); return end
	print("Downloading to "..fullpath)
	for packet in request do newFile:write(packet) end
	newFile:flush()
	newFile:close()
	print("Download complete")
end

--arguments
local arg = {...}
local src = "devMine"
local dest
local fail = false

local i = 1
while i < #arg do
	if arg[i] == '-h' then
		i = i + 1
		if not arg[i] then
			print("Missing user/repo after '-h'")
			fail = true
		end
		src = "https://api.github.com/repos/"..arg[i]
	--[[elseif arg[i] == "-f" then
		i = i + 1
		if not arg[i] then
			print("Missing destination file after '-f'")
			fail = true
		end
		dest = cd..arg[i] ]]
	elseif not src then
		src = arg[i]
	elseif arg[i]:sub(1,1) == '-' then
		print("Unrecognised option "..arg[i])
		fail = true
	else
		print("Wrong number of parameters")
		fail = true
	end
	
	i = i + 1
end
if fail then return end

if src == 'devMine' then
	src = "https://api.github.com/repos/yuriKhordal/devMine"
end

--request repository
local request = internet.request(src.."/contents")
local json = ""
for packet in request do json = json..packet end
local repo = parse(json)

--F
findLua(repo)