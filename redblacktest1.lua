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
