----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'

local function main()
    local t = redblack.newTree()

    redblack.insert(t, 10)
    redblack.insert(t, 20)
    redblack.insert(t, 15)

    testredblack.printTree(t)
end

main()
----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'
local tree = redblack.newTree()

redblack.insert(tree, 10)
redblack.insert(tree, 20)

for value in redblack.iterate(tree) do
    print(value)
end

print(redblack.find(tree, 10))        -- expect 10

redblack.delete(tree, 10)
redblack.delete(tree, 20)

print(redblack.find(tree, 10) ~= nil) -- expect false
----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'

local function main()
    local t = redblack.newTree()

    for i = 1, 10 do
        redblack.insert(t, i)
    end

    for i in redblack.iterate(t) do
        io.write(i, ' ')
    end
    print('\ntree contains 10 after inserts:  ', redblack.find(t, 10) ~= nil)

    for i = 1, 10 do
        redblack.delete(t, i)
    end
    print('tree contains 10 after deletes:  ', redblack.find(t, 10) ~= nil)
end

main()
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
----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'

local function main()
    local t = redblack.newTree()

    testredblack.insertIntoSortedPosition(t, t.root, 10).color = 'red'

        testredblack.insertIntoSortedPosition(t, t.root, 8).color = 'black'
            testredblack.insertIntoSortedPosition(t, t.root, 7).color = 'red'
            testredblack.insertIntoSortedPosition(t, t.root, 9).color = 'red'

        testredblack.insertIntoSortedPosition(t, t.root, 11).color = 'black'

    testredblack.printTree(t)

    redblack.delete(t, 11)
    testredblack.printTree(t)
end

main()
