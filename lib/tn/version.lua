-- major, minor, bugfix
local version = {0, 3, 1}
setmetatable(version, version)

function version:__tostring()
    return string.format("%d.%d.%d", unpack(self))
end

return version