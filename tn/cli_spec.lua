local cli = require('tn.cli')

describe('cli', function() 
  
  describe('parse_args', function()
    
    it('should handle the list subcommand', function()
      local args = {"list"}
      
      local cmd = cli.parse_args(args)
      
      assert.is_true(cmd.subcmd == "list")
    end)
    
    it('should handle the edit subcommand', function() 
      local args = {"edit", "my note"}
      
      local cmd = cli.parse_args(args)

      assert.is_true(cmd.subcmd == "edit")
      assert.is_true(cmd.args[1] == "my note")
    end)
    
    it('should handle the remove subcommand', function()
      local args = {"remove", "a note to remove"}
      
      local cmd = cli.parse_args(args)

      assert.is_true(cmd.subcmd == "remove")
      assert.is_true(cmd.args[1] == "a note to remove")
    end)
    
    it('should handle the show command', function() 
      local args = {"show", "a note to show"}
      
      local cmd = cli.parse_args(args)
      
      assert.is_true(cmd.subcmd == "show")
      assert.is_true(cmd.args[1] == "a note to show")
    end)
    
    it('should handle long help option', function() 
      local cmd = cli.parse_args({"--help"})
      assert.is_true(cmd.options["help"])
    end)
    
    it('should handle short help option', function() 
      local cmd = cli.parse_args({"-h"})
      assert.is_true(cmd.options["help"])
    end)
    
    it('should handle long version option', function()
      local cmd = cli.parse_args({"--version"})
      assert.is_true(cmd.options["version"])
    end)

    it('should handle long bash-completion option', function()
      local cmd = cli.parse_args({"--bash-completion"})
      assert.is_true(cmd.options["bash-completion"])
    end)

    it('should handle long commands option', function()
      local cmd = cli.parse_args({"--commands"})
      assert.is_true(cmd.options["commands"])
    end)

    it('should consider unknown option an error', function()
      local success = pcall(cli.parse_args, {"--unknown"})
      assert.is_false(success)
    end)
    
    it('should consider unknown subcommand an error', function()
      local success = pcall(cli.parse_args, {"somecmd", "some arg"})
      assert.is_false(success)
    end)
    
  end)

end)
