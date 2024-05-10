#!/usr/bin/env lua

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
