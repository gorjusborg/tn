local tn = require('tn_lib')

describe('tn', function()
    describe('xdg_data_dir', function()
        os.getenv = function(var)
            local entries = {
                XDG_DATA_HOME="/tmp/hi"
            }
            return entries[var]
        end

        it('should return value of XDG_DATA_HOME if set', function()
            local ddir = tn.user_data_dir()
            assert.is_equal("/tmp/hi", ddir)
        end)
    end)
end)
