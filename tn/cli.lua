local M = {}

local version = require('tn.version')

local usage_str = [[
Usage: tn edit <note-name>
       tn list
       tn file <note-name>
       tn remove <note-name>
       tn show <note-name>
       tn (-h | --help)
       tn --version
       tn --bash-completion
       tn --commands

Options:
    -h --help           Show this screen.
    --version           Show version.
    --bash-completion   Prints out bash completion script.
    --commands          List supported commands.
]]

local compl_commands = {
    "edit",
    "list",
    "file",
    "remove",
    "show",
    "--help",
    "--version",
    "--bash-completion",
    "--commands"
}

local compl_bash_script = [=[
  _tn_complete() {
      local IFS=$'\n'
      local cur prev opts

      COMPREPLY=()

      cur=${COMP_WORDS[COMP_CWORD]}
      prev=${COMP_WORDS[COMP_CWORD-1]}
      opts=()

      if [[ "$prev" == "$1" ]]; then
          opts=($(tn --commands))
      else
          case "$prev" in
              edit|file|remove|show)
              opts=("$(tn list)")
              ;;
          esac
      fi

      CANDIDATES=($(compgen -W "${opts[*]}" -- ${cur}))

      if [ ${#CANDIDATES[*]} -eq 0 ]; then
          COMPREPLY=()
      else
          COMPREPLY=($(printf '%q\n' "${CANDIDATES[@]}"))
      fi
  }

  complete -F _tn_complete tn
]=]

local function write_message(fileh, msg)
    fileh:write(msg)
    fileh:flush()
end

local function write_usage(fileh)
  fileh:write(usage_str)
  fileh:write("\n")
  fileh:flush()
end

local function write_version(fileh)
    fileh:write(tostring(version))
    fileh:write("\n")
    fileh:flush()
end

local function write_bash_compl(fileh)
  fileh:write(compl_bash_script)
  fileh:flush()
end

local function write_commands_compl(fileh)
  fileh:write(table.concat(compl_commands, "\n"))
  fileh:write("\n")
  fileh:flush()
end

--- parses arg list into table
---@param args any
local function parse_args(args)
    local data = {}

    local singleArgCmds = {
        edit=true,
        file=true,
        remove=true,
        show=true
    }

    local zeroArgCmds = {
        list=true
    }

    local helpOpt = "help"
    local versionOpt = "version"
    local bashCompOpt = "bash-completion"
    local commandsOpt = "commands"

    local zeroArgOptions = {
        ["-h"] = helpOpt,
        ["--help"] = helpOpt,
        ["--version"] = versionOpt,
        ["--bash-completion"] = bashCompOpt,
        ["--commands"] = commandsOpt,
    }
    
    if #args == 0 then
        data.options = data.options or {}
        data.options[helpOpt] = true
        return data
    end
    
    if zeroArgCmds[args[1]] then
        data.subcmd = args[1]
        if #args ~= 1 then
            error("invalid number of arguments for " .. data.subcmd)
        end
        return data
    end

    if singleArgCmds[args[1]] then
        data.subcmd = args[1]
        if #args == 2 then
            data.args = {args[2]}
        else
            error("invalid number of arguments to " .. data.subcmd)
        end
        return data
    end
    
    local opt = zeroArgOptions[args[1]]
    if opt then
        if #args == 1 then
            data.options = data.options or {}
            data.options[opt] = true
            return data
        else
            error("invalid number of option arguments for " .. opt)
        end
    end
    
    local validCmd = (data.subcmd == "list" and #data.args == 0 and not data.options) or
                    ((data.subcmd == "show" or data.subcmd == "edit" or data.subcmd == "remove" or data.subcmd == "file") and
                        data.args and #data.args == 1 and not data.options) or
                    (not data.subcmd and data.options and #data.options == 1 and
                        (data.options[1] == "bash-completion" or data.options[1] == "help" or data.options[1] == "commands"))

    assert(validCmd, "invalid command")
end

M.write_message = write_message
M.write_usage = write_usage
M.write_version = write_version
M.write_bash_compl = write_bash_compl
M.write_commands_compl = write_commands_compl
M.parse_args = parse_args

return M