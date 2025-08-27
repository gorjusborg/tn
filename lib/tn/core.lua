local M = {}

local lfs = require('lfs')
local fun = require('fun')

local Tn = {}
Tn.__index = Tn

setmetatable(Tn, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

local function writeln_to_fn(fd)
    return function(str)
        fd:write(str)
        fd:write("\n")
    end
end

local function file_exists(file)
    local _, err = lfs.attributes(file)

    if err then
        return false
    else
        return true
    end
end

function Tn.new(note_dir, editor, file_ext, out_fd)
    local self = setmetatable({}, Tn)

    assert(lfs.attributes(note_dir),  "note dir does not exist")
    assert(editor, "editor not defined")
    assert(file_ext, "file extension not defined")

    self.note_dir = note_dir
    self.editor = editor
    self.file_ext = file_ext
    self.out_fd = out_fd or io.stdout
    self.writeln_fn = writeln_to_fn(self.out_fd)

    return self
end

---  luafun compatible directory iterator
---@param path string
---@return iter
local function dir_iter(path)
    local oiter, udata = lfs.dir(path)
    local iter = function(s, v)
        local o = oiter(s)
        return o, o
    end
    return iter, udata
end

local function filename_filt_fn(fext)
    return function(filename)
        return #filename > 0 and not filename:find("^[.]") and filename:find("[.]".. fext .. "$")
    end
end

local function strip_fext(filename, fext)
    return string.gsub(filename, "(.*)[.]"..fext.."$", "%1") or filename
end

local function strip_fext_fn(fext)
    return function(filename)
        return strip_fext(filename, fext)
    end
end

local function add_fattrs_fn(dir)
    return function(filename)
        local res = {
            filename=filename,
            basedir=dir
        }
        return lfs.attributes(dir.."/"..filename, res)
    end
end

local function sort_by_attr_fn(attr)
    return function(a, b)
        return tonumber(a[attr]) < tonumber(b[attr])
    end
end

local function map_select_v_fn(kname)
    return function(tabl)
        return tabl[kname]
    end
end

local function shellQuote(str)
  if not str then
      return str
  end

  return "'"..str.."'"
end

function Tn:_filepath(name)
    return self.note_dir .. "/" .. name .. "." .. self.file_ext
end

function Tn:file(name)
    local fpath = self:_filepath(name)
    assert(lfs.attributes(fpath), "file does not exist")
    self.writeln_fn(self:_filepath(name))
    self.out_fd:flush()
end

function Tn:edit(name)
    os.execute(self.editor .. " " .. shellQuote(self:_filepath(name)))
end

function Tn:show(name)
    local fd = assert(io.open(self:_filepath(name)))
    self.out_fd:write(fd:read("*a"))
    fd:close()
end

function Tn:remove(name)
    os.remove(self:_filepath(name))
end

function Tn:list()
    local files_attrs = fun.iter(dir_iter(self.note_dir))
        :filter(filename_filt_fn(self.file_ext))
        :map(add_fattrs_fn(self.note_dir))
        :totable()

    table.sort(files_attrs, sort_by_attr_fn("modification"))

    fun.iter(files_attrs)
        :map(map_select_v_fn("filename"))
        :map(strip_fext_fn(self.file_ext))
        :each(writeln_to_fn(self.out_fd))

    self.out_fd:flush()
end

M.Tn = Tn

return M