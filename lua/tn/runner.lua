local cli = require("tn.cli")
local core = require("tn.core")

local M = {}

local function run()
	local editor = os.getenv("EDITOR") or os.getenv("VISUAL")

	local notes_dir_envvar = "TN_NOTES_DIR"
	local notes_dir = os.getenv(notes_dir_envvar)

	if not notes_dir then
		cli.write_message(io.stderr, "unable to local document directory, please set " .. notes_dir_envvar .. "\n")
		os.exit(1)
	end

	if not editor then
		cli.write_message(io.stderr, "unable to determine editor, please set EDITOR variable\n")
		os.exit(1)
	end

	local success, cmd = pcall(cli.parse_args, arg)

	if not success or (cmd.options and cmd.options.help) then
		cli.write_usage(io.stderr)
		os.exit(1)
	end

	if cmd.options then
		if cmd.options.version then
			cli.write_version(io.stdout)
			os.exit(0)
		end

		if cmd.options["bash-completion"] then
			cli.write_bash_compl(io.stdout)
			os.exit(0)
		end

		if cmd.options["fish-completion"] then
			cli.write_fish_compl(io.stdout)
			os.exit(0)
		end

		if cmd.options["zsh-completion"] then
			cli.write_zsh_compl(io.stdout)
			os.exit(0)
		end

		if cmd.options.commands then
			cli.write_commands_compl(io.stdout)
			os.exit(0)
		end
	end

	local tn = core.Tn(notes_dir, editor, "md")

	if cmd.subcmd == "show" then
		local name = cmd.args[1]
		tn:show(name)
	end

	if cmd.subcmd == "list" then
		tn:list()
	end

	if cmd.subcmd == "file" then
		local name = cmd.args[1]
		local _, err = pcall(tn.file, tn, name)
		if err then
			os.exit(1)
		end
	end

	if cmd.subcmd == "edit" then
		local name = cmd.args[1]
		tn:edit(name)
	end

	if cmd.subcmd == "remove" then
		local name = cmd.args[1]
		tn:remove(name)
	end

	if cmd.subcmd == "copy" then
		local source_name = cmd.args[1]
		local target_name = cmd.args[2]
		local _, err = pcall(tn.copy, tn, source_name, target_name)
		if err then
			cli.write_message(io.stderr, err .. "\n")
			os.exit(1)
		end
	end
end

M.run = run

return M

