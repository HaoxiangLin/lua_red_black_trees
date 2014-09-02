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
