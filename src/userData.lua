local jsonSchema = require("jsonschema")
local json = require("json")
local readFile = require("src/readFile")
require("src/location")

local defaultConfig = "~/.gtan.json"
-- todo: read env variable GTAN_SETTINGS to read settings file from that location

local configPath = defaultConfig
local jsonStr = readFile(HydratePath(configPath))
local jsonParsed = json:decode(jsonStr)
-- todo validate structure

return jsonParsed
