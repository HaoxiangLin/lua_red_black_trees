----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
require 'redblack'

function checkTree(values, tree)
    for i in redblack.iterate(tree) do
        local nextv = table.remove(values, 1)
        assert(i == nextv)
    end
    assert(#values == 0)
end

local function insertNoRedViolation()
    local t = redblack.newTree()

    testredblack.insertIntoSortedPosition(t, t.root, 10).color = 'red'
        testredblack.insertIntoSortedPosition(t, t.root, 5).color = 'black'
        testredblack.insertIntoSortedPosition(t, t.root, 15).color = 'black'

    redblack.insert(t, 2)

    checkTree({2, 5, 10, 15}, t)
end

local function insertBaseCase1()
    local t = redblack.newTree()

    testredblack.insertIntoSortedPosition(t, t.root, 10).color = 'red'

    redblack.insert(t, 2)

    checkTree({2, 10}, t)
end

local function insertTest1()
    local t = redblack.newTree()

    redblack.insert(t, 10)
    redblack.insert(t, 20)
    redblack.insert(t, 15)

    checkTree({10, 15, 20}, t)
end

local function iterateTest1()
    local tree = redblack.newTree()

    redblack.insert(tree, 10)
    redblack.insert(tree, 20)

    checkTree({10, 20}, tree)

    redblack.delete(tree, 10)
    redblack.delete(tree, 20)

    assert(redblack.find(tree, 10) == nil) -- expect false
end

local function deleteTest1()
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

local function structuredDataTest1()
    local pointMetatable, createPoint, nodeCount

    local pointMetatable = {
        __lt = function(lhs, rhs)
            return (lhs.x < rhs.x or lhs.x == rhs.x and lhs.y < rhs.y)
        end,
    }

    local function createPoint(x, y)
        result = { x = x, y = y }
        setmetatable(result, pointMetatable)
        return result
    end

    local function nodeCount(xTree)
        local count = 0

        for i in redblack.iterate(xTree) do
            count = count + 1
        end

        return count
    end

    local t = redblack.newTree()

    for i = 1, 8 do
        local point = createPoint(i, i * i)
        point.value = point.y * 1000 + point.x
        redblack.insert(t, point)
    end
    --assert(nodeCount(t) == 8)

    for point in redblack.iterate(t) do
        print(point.value)
    end

    print('node count after inserts:  ' .. nodeCount(t))

    for i = 1, 8 do
        redblack.delete(t, createPoint(i, i * i))
    end

    print('node count after deletes:  ' .. nodeCount(t))
    --assert(nodeCount(t) == 0)
end

local function testInsertIntoSortedPosition()
    print('testInsertIntoSortedPosition start')
    local t = redblack.newTree()

    testredblack.insertIntoSortedPosition(t, t.root, 10).color = 'red'

        testredblack.insertIntoSortedPosition(t, t.root, 8).color = 'black'
            testredblack.insertIntoSortedPosition(t, t.root, 7).color = 'red'
            testredblack.insertIntoSortedPosition(t, t.root, 9).color = 'red'

        testredblack.insertIntoSortedPosition(t, t.root, 11).color = 'black'

    checkTree({7, 8, 9, 10, 11}, t)

    redblack.delete(t, 11)
    checkTree({7, 8, 9, 10}, t)

    print('testInsertIntoSortedPosition end')
end

function main()
    insertNoRedViolation()
    insertBaseCase1()
    insertTest1()
    iterateTest1()
    deleteTest1()
    structuredDataTest1()
    testInsertIntoSortedPosition()
end

main()
