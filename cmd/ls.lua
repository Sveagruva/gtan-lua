return {
	schema = "ls", -- Schema to parse. Required
	description = "List hosts and locations", -- Command description
	-- options = { -- Add flags arguments
	-- 	{
	-- 		long = "server",
	-- 		short = "s",
	-- 		description = "Pick servers",
	-- 		transform = function(param) end,
	-- 		type = "flag",
	-- 		default = true,
	-- 	},
	-- },
	hide = false, -- hide from help command
	action = function(parsed, command, app) -- same command:action(function)
		local tablua = require("tablua")
		local userData = require("../src/userData")

		local hostsTable = tablua({
			{ "name", "host", "username" },
		})

		for key, value in pairs(userData.hosts) do
			hostsTable:add_line({
				key,
				value.hostname,
				value.username,
			})
		end

		local locationsTable = tablua({
			{ "name", "path", "server name" },
		})

		for key, value in pairs(userData.namedLocations) do
			locationsTable:add_line({
				key,
				value.path,
				value.serverName,
			})
		end

		print("Hosts:")
		print(hostsTable)

		print("Locations:")
		print(locationsTable)
	end,
}
