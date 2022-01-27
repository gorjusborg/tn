-- major, minor, bugfix
local M = {0, 3, 0}
setmetatable(M, M)

function M:__tostring()
    return string.format("%d.%d.%d", unpack(self))
end

return M