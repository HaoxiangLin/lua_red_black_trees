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
