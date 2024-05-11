require("lua-string")

function HydratePath(path)
	if path:startswith("~") then
		local home = os.getenv("HOME")
		path = home .. path:sub(2)
	end

	return path
end

function string.split(input, separator)
	if separator == nil then
		separator = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(input, "([^" .. separator .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function ParseLocation(location)
	local UserData = require("src/UserData")
	if not string.find(location, "@") and not string.find(location, ":") then
		if string.find(location, "/") then
			return { path = location, isLocal = true, server = {} }
		end

		for name, obj in pairs(UserData.namedLocations) do
			if name == location then
				if obj.serverName == "local" then
					return { path = obj.path, isLocal = true, server = {} }
				end

				for serverName, server in pairs(UserData.hosts) do
					if serverName == obj.serverName then
						return { path = obj.path, isLocal = obj.serverName == "local", server = server }
					end
				end

				error("server for location not found")
			end
		end
		error("named location not found")
	end

	local usernameParts = string.split(location, "@")
	if #usernameParts > 2 then
		error("@ must appear 0 or 1 times")
	end

	local pathParts = string.split(usernameParts[#usernameParts], ":")
	if #pathParts ~= 2 then
		error("no path found, must be of the form <host>:<path>")
	end

	local path = pathParts[2]

	if #usernameParts == 1 then
		local serverName = pathParts[1]

		if serverName == "local" then
			return { path = path, isLocal = true, server = {} }
		end

		local server = UserData.hosts[serverName]
		if server == nil then
			error("server not found")
		end

		return { path = path, isLocal = false, server = server }
	end

	local username = usernameParts[1]
	local hostname = pathParts[1]

	return { path = path, isLocal = false, server = { hostname = hostname, username = username } }
end

function LocationToRsyncStr(location)
	if location.isLocal then
		return location.path
	end

	return location.server.username .. "@" .. location.server.hostname .. ":" .. location.path
end
