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
