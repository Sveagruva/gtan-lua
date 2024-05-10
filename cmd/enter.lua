return {
	schema = "enter <host>",
	description = "Enter host by name",
	positional_args = {
		req_arg = "Host name",
	},
	hide = false,
	action = function(parsed, command, app)
		local userData = require("src/UserData")
		local host = userData.hosts[parsed.host]

		if host == nil then
			error("host not found, make sure you typing name of the host correctly")
		end

		local ssh_command = string.format("sshpass -p %q ssh %s@%s", host.password, host.username, host.hostname)
		os.execute(ssh_command)
	end,
}

-- <namedLocation>
-- <localPath>
-- <username>@<host>:<path>
