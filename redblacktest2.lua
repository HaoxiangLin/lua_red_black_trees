----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'
local pointMetatable
local createPoint

local function main()
    local t = redblack.newTree()

    for i = 1, 10 do
        redblack.insert(t, createPoint(i, i * i))
    end

    for point in redblack.iterate(t) do
        io.write('<', point.x, ', ', point.y, '> ')
    end
    print()

    print('node count after inserts:  ' .. testredblack.nodeCount(t))

    for i = 1, 10 do
        redblack.delete(t, createPoint(i, i * i))
    end

    print('node count after deletes:  ' .. testredblack.nodeCount(t))
end

pointMetatable = {
    __lt = function(lhs, rhs)
        return (lhs.x < rhs.x or lhs.x == rhs.x and lhs.y < rhs.y)
    end,
}

function createPoint(x, y)
    result = { x = x, y = y }
    setmetatable(result, pointMetatable)
    return result
end

main()
