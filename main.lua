#!/usr/bin/env lua

local function get_directory_from_path(filepath)
	local last_separator = filepath:match("[\\/]([^\\/]+)$")

	if last_separator then
		return filepath:sub(1, -#last_separator - 2)
	else
		return "/"
	end
end

local function is_symlink_unix(filepath)
	local pipe = io.popen("ls -l " .. filepath)
	if pipe then
		local output = pipe:read("*a")
		pipe:close()
		if output and string.match(output, "^l") then
			return true
		end
	end
	return false
end

local current_file_path = debug.getinfo(1, "S").source:sub(2)
local is_symlink = is_symlink_unix(current_file_path)

if is_symlink then
	local pipe = io.popen("readlink -f " .. current_file_path)
	if pipe then
		local target = pipe:read("*a"):gsub("\n$", "") -- Remove trailing newline
		pipe:close()
		current_file_path = target
	end
end

current_file_path = get_directory_from_path(current_file_path)
package.path = current_file_path .. "/?.lua;" .. package.path

local Lummander = require("lummander")
local cli = Lummander.new({
	title = "Gtan",
	tag = "gtan-lua", -- define command to launch this script at terminal
	description = "GTan is a SSH transfer utility on top of Rsync", -- <string> CLI description. Default: ""
	version = "0.1.0", -- define cli version
	author = "Sveagruva", -- <string> author. Default: ""
	-- ropath = "/path/to/folder/contains/this/file", -- <string> root_path. Default "". Concat this path to load commands of a subfolder
	theme = "acid", -- Default = "default". "default" and "acid" are built-in themes
	flag_prevent_help = false, -- prevent show help when :parse() doesn't find a valid command to execute
})

local commandFiles = {
	"ls",
	"enter",
	"transfer",
}

for _, cmdName in ipairs(commandFiles) do
	local cmd = require("cmd/" .. cmdName)
	cli:command(cmd.schema, cmd)
end

cli:parse(arg)
