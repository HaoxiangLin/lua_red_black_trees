----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'
local pointMetatable, createPoint, nodeCount

local function main()
    local t = redblack.newTree()

    for i = 1, 8 do
        local point = createPoint(i, i * i)
        point.value = point.y * 1000 + point.x
        redblack.insert(t, point)
    end

    for point in redblack.iterate(t) do
        print(point.value)
    end

    print('node count after inserts:  ' .. testredblack.nodeCount(t))

    for i = 1, 8 do
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

function nodeCount(xTree)
    local count = 0

    for i in redblack.iterate(xTree) do
        count = count + 1
    end

    return count
end

main()
