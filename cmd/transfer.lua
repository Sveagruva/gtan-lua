return {
	schema = "transfer <location1> <location2>",
	description = "Tranfer files between mix of named locations and inline locations",
	hide = false,
	action = function(parsed, command, app)
		require("src/location")
		local loc1 = ParseLocation(parsed.location1)
		local loc2 = ParseLocation(parsed.location2)

		if not loc1.isLocal and not loc2.isLocal then
			error("can't move between servers yet")
		end
		local password
		if not loc1.isLocal then
			password = loc1.server.password
		else
			password = loc2.server.password
		end
		local loc1rsync = LocationToRsyncStr(loc1)
		local loc2rsync = LocationToRsyncStr(loc2)
		local ssh_command = string.format("sshpass -p %q rsync -ravzhP %s %s", password, loc1rsync, loc2rsync)
		print(ssh_command)
		os.execute(ssh_command)
	end,
}
