local cli = require("../lua/tn/cli")

local TestOutput = {}
TestOutput.__index = TestOutput

function TestOutput:new()
	local obj = {
		content = "",
	}
	setmetatable(obj, TestOutput)
	return obj
end

function TestOutput:write(str)
	self.content = self.content .. str
end

function TestOutput:read()
	return self.content
end

function TestOutput:flush() end

describe("cli", function()
	describe("parse_args", function()
		it("should handle the list subcommand", function()
			local args = { "list" }

			local cmd = cli.parse_args(args)

			assert.is_true(cmd.subcmd == "list")
		end)

		it("should handle the edit subcommand", function()
			local args = { "edit", "my note" }

			local cmd = cli.parse_args(args)

			assert.is_true(cmd.subcmd == "edit")
			assert.is_true(cmd.args[1] == "my note")
		end)

		it("should handle the remove subcommand", function()
			local args = { "remove", "a note to remove" }

			local cmd = cli.parse_args(args)

			assert.is_true(cmd.subcmd == "remove")
			assert.is_true(cmd.args[1] == "a note to remove")
		end)

		it("should handle the show command", function()
			local args = { "show", "a note to show" }

			local cmd = cli.parse_args(args)

			assert.is_true(cmd.subcmd == "show")
			assert.is_true(cmd.args[1] == "a note to show")
		end)

		it("should handle long help option", function()
			local cmd = cli.parse_args({ "--help" })
			assert.is_true(cmd.options["help"])
		end)

		it("should handle short help option", function()
			local cmd = cli.parse_args({ "-h" })
			assert.is_true(cmd.options["help"])
		end)

		it("should handle long version option", function()
			local cmd = cli.parse_args({ "--version" })
			assert.is_true(cmd.options["version"])
		end)

		it("should handle long bash-completion option", function()
			local cmd = cli.parse_args({ "--bash-completion" })
			assert.is_true(cmd.options["bash-completion"])
		end)

		it("should handle long fish-completion option", function()
			local cmd = cli.parse_args({ "--fish-completion" })
			assert.is_true(cmd.options["fish-completion"])
		end)

		it("should handle long zsh-completion option", function()
			local cmd = cli.parse_args({ "--zsh-completion" })
			assert.is_true(cmd.options["zsh-completion"])
		end)

		it("should handle long commands option", function()
			local cmd = cli.parse_args({ "--commands" })
			assert.is_true(cmd.options["commands"])
		end)

		it("should consider unknown option an error", function()
			local success = pcall(cli.parse_args, { "--unknown" })
			assert.is_false(success)
		end)

		it("should consider unknown subcommand an error", function()
			local success = pcall(cli.parse_args, { "somecmd", "some arg" })
			assert.is_false(success)
		end)
	end)

	describe("write_bash_compl", function()
		it("should output bash completion script containing _tn_complete function and complete -F", function()
			local output = TestOutput:new()
			cli.write_bash_compl(output)
			local content = output:read()
			assert.is_true(string.find(content, "_tn_complete()") ~= nil)
			assert.is_true(string.find(content, "complete %-F _tn_complete tn") ~= nil)
		end)
	end)

	describe("write_fish_compl", function()
		it("should output fish completion script containing __tn_complete function and complete -c", function()
			local output = TestOutput:new()
			cli.write_fish_compl(output)
			local content = output:read()
			assert.is_true(string.find(content, "function __tn_complete") ~= nil)
			assert.is_true(string.find(content, "complete %-c tn %-f %-a") ~= nil)
		end)
	end)

	describe("write_zsh_compl", function()
		it("should output zsh completion script containing #compdef tn and _tn function call", function()
			local output = TestOutput:new()
			cli.write_zsh_compl(output)
			local content = output:read()
			assert.is_true(string.find(content, "#compdef tn") ~= nil)
			assert.is_true(string.find(content, '_tn "$@"') ~= nil)
		end)
	end)
end)
