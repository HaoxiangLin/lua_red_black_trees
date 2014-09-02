----------------------------------------------------------------------------
-- Copyright (C) 2014, Greg Johnson.
-- Released under the terms of the GNU GPL v2.0.
----------------------------------------------------------------------------
--[[
Usage:
    require 'redblack'
    local tree = newTree()

    redblack.insert(tree, 10)
    redblack.insert(tree, 20)

    for value in redblack.iterate(tree) do
        print(value)
    end

    redblack.delete(tree, 10)
    redblack.delete(tree, 20)
--]]

local delete, deleteNode, farNephew, findNode, first, grandparent, insert
local insertIntoSortedPosition, insideChild, isBlackNode, isInsideChild
local isLeftChild, isRedNode, isRightChild, isRootNode, iterate, leftChild
local makeFarNephewRed, makeOutsideChild, makeRoot, makeSiblingBlack
local maxBlackHeight, nearNephew, newNode, newTree, outsideChild, parent
local restoreBlackProperty, restoreRedProperty, rightChild
local rotateUp, rotateUpBlackNode, setChild, sibling, successor, swapColors
local swapWithSuccessor, uncle, violatesBlackProperty
local violatesRedProperty
local lchild, rchild = 1,2

function newTree()
    return {}
end

-- data values must be comparable using "<".
function insert(tree, data)
    local insertedNode = insertIntoSortedPosition(tree, tree.root, data)

    if violatesRedProperty(insertedNode) then
        restoreRedProperty(tree, insertedNode)
    end
end

-- data values must be comparable using "<".
function delete(tree, data)
    local deleteMe = findNode(tree.root, data)

    if deleteMe == nil then return end

    if deleteMe[lchild] ~= nil and deleteMe[rchild] ~= nil then
        deleteMe = swapWithSuccessor(deleteMe)
    end

    if not isRootNode(deleteMe) and not isRedNode(deleteMe) then
        deleteMe.color = 'white'
        restoreBlackProperty(tree, deleteMe)
    end

    deleteNode(tree, deleteMe)
end

function violatesRedProperty(node)
    return isRedNode(node) and isRedNode(parent(node))
end

-- not called; included here to algorithmically define the black property.
--
function violatesBlackProperty(node)
    return maxBlackHeight(node) ~= maxBlackHeight(sibling(node))
end

function maxBlackHeight(node)
    local result
    if node == nil then
        result = 0
    else
        local nodeIsBlack = (node.color == 'black' and 1 or 0)

        local leftMaxBlackHeight = maxBlackHeight(leftChild(node))
        local rightMaxBlackHeight = maxBlackHeight(rightChild(node))

        result = nodeIsBlack + math.max(leftMaxBlackHeight, rightMaxBlackHeight)
    end

    return result
end

-- Node "fixMe" is red and has a red parent, violating the red property.
-- Other than that, all nodes in the tree satisfy the red and black properties.
--
function restoreRedProperty(tree, fixMe)
    if isRootNode(parent(fixMe)) then
        parent(fixMe).color = 'black'

    elseif not isRedNode(uncle(fixMe)) then
        -- rotateUp changes color of outside child's parent.
        -- So, if fixMe is outside child, then
        -- rotateUp(parent of fixMe) fixes red violation.
        makeOutsideChild(tree, fixMe)

        rotateUp(tree, parent(fixMe))
    else
        parent(fixMe).color      = 'black'
        uncle(fixMe).color       = 'black'
        grandparent(fixMe).color = 'red'

        if violatesRedProperty(grandparent(fixMe)) then
            restoreRedProperty(tree, grandparent(fixMe))
        end
    end
end

-- Node fixMe has max black height one less than its sibling, violating the black property.
-- Other than that, all nodes in the tree satisfy the red and black properties.
-- (This algorithm also requires that fixMe not be a red node.)
--
function restoreBlackProperty(tree, fixMe)
    makeSiblingBlack(tree, fixMe)

    if isRedNode(nearNephew(fixMe)) or isRedNode(farNephew(fixMe)) then
        -- rotateUpBlackNode(sibling) exchanges max black heights of parent's two subtrees:
        --     increases max black height of subtree containing fixMe (good)
        --     decreases max black height of subtree containing far nephew (bad)

        -- pre-emptively increase farNephew's max black height by changing it from red to black.
        makeFarNephewRed(fixMe)
        farNephew(fixMe).color = 'black'

        rotateUpBlackNode(tree, sibling(fixMe))

    else
        -- fix black property violation by reducing sibling's max black height.  (this also
        -- reduces max black height of parent, potentially giving parent a black violation.)

        sibling(fixMe).color = 'red'

        if isRedNode(parent(fixMe)) then
            parent(fixMe).color = 'black'

        elseif not isRootNode(parent(fixMe)) then
            restoreBlackProperty(tree, parent(fixMe))
        end
    end
end

function findNode(subtreeRoot, data)
    if subtreeRoot == nil then
        return nil

    elseif data < subtreeRoot.data then
        return findNode(subtreeRoot[lchild], data)

    elseif subtreeRoot.data < data then
        return findNode(subtreeRoot[rchild], data)

    else
        return subtreeRoot
    end
end

function insertIntoSortedPosition(tree, subtreeRoot, xData)
    if subtreeRoot == nil then 
        return makeRoot(tree, newNode(xData))

    else
        local childIndex = (xData < subtreeRoot.data and lchild or rchild)

        if subtreeRoot[childIndex] == nil then 
            return setChild(tree,
                            subtreeRoot, newNode(xData),
                            childIndex == lchild)
        else
            return insertIntoSortedPosition(tree, subtreeRoot[childIndex], xData)
        end
    end
end

-- pre-condition:  redNode must be red and must not have a red sibling.
-- This operation preserves the red and black properties of the tree and the
-- in-order traversal of the tree.
--
-- redNode is pushed up to be the new parent, and parent becomes one of its children.
-- the previous inside child of redNode becomes the new inside child of parent.
-- redNode and parent swap colors.
--
function rotateUp(tree, redNode)
    assert(parent(redNode))

    swapColors(redNode, parent(redNode))

    local leftChild = isLeftChild(redNode)
    local p  = parent(redNode)
    local gp = grandparent(redNode)

    setChild(tree, p,         insideChild(redNode), leftChild)
    setChild(tree, gp,        redNode,              isLeftChild(p))
    setChild(tree, redNode,   p,                    not leftChild)
end

-- pre-condition:  blackNode must be black and must not have a red outside child.
-- This function preserves the red property and the in-order traversal of the tree,
-- but it violates the black property:
--
-- rotateUpBlackNode(node) changes max black heights of parent node's two subtrees:
--     increases max black height of subtree containing blackNode
--     decreases max black height of sibling subtree
--
function rotateUpBlackNode(tree, blackNode)
    rotateUp(tree, blackNode)
end

function parent(node)
    return node and node.parent
end

function leftChild(node)
    return node and node[lchild]
end

function rightChild(node)
    return node and node[rchild]
end

function sibling(node)
    if     isLeftChild(node)  then return rightChild(parent(node))
    elseif isRightChild(node) then return leftChild(parent(node))
    else                           return nil
    end
end

function insideChild(node)
    if     isLeftChild(node)  then return node[rchild]
    elseif isRightChild(node) then return node[lchild]
    else                           return nil
    end
end

function outsideChild(node)
    if     isLeftChild(node)  then return node[lchild]
    elseif isRightChild(node) then return node[rchild]
    else                           return nil
    end
end

function grandparent(node)
    return parent(parent(node))
end

function uncle(node)
    return sibling(parent(node))
end

function nearNephew(node)
    return insideChild(sibling(node))
end

function farNephew(node)
    return outsideChild(sibling(node))
end

function isLeftChild(child)
    return child ~= nil and child == leftChild(parent(child))
end

function isRightChild(child)
    return child ~= nil and child == rightChild(parent(child))
end

function isBlackNode(node)
    return node ~= nil and node.color == 'black'
end

function isRedNode(node)
    return node ~= nil and node.color == 'red'
end

function isRootNode(node)
    return node ~= nil and node.parent == nil
end

function isInsideChild(node)
    return    isLeftChild(parent(node))  and isRightChild(node)
           or isRightChild(parent(node)) and isLeftChild(node)
end

function newNode(xData)
    local node = { data = xData, color = 'red' }
    return node
end

function makeRoot(tree, node)
    tree.root = node
    return node
end

function first(xNode)
    while leftChild(xNode) do
        xNode = leftChild(xNode)
    end
    return xNode
end

function successor(xNode)
    local result = first(rightChild(xNode))
    if result == nil then
        while isRightChild(xNode) do
            xNode = parent(xNode)
        end
        result = parent(xNode)
    end
    return result
end

function iterate(xTree)
    local f = function(s, var)
                 local result = s.returnMe
                 s.returnMe = successor(s.returnMe)
                 return result and result.data
              end

    local s = { returnMe = first(xTree.root) }

    local var = nil

    return f, s, var
end

function setChild(tree, parentNode, childNode, makeLeftChild)
    if parentNode == nil then
        tree.root = childNode

    elseif makeLeftChild then
        parentNode[lchild] = childNode

    else
        parentNode[rchild] = childNode
    end

    if childNode ~= nil then
        childNode.parent = parentNode
    end

    return childNode
end

function swapColors(node1, node2)
      node1.color, node2.color = node2.color, node1.color
end

function makeOutsideChild(tree, node)
    if isInsideChild(node) then
        rotateUp(tree, node)
        node = outsideChild(node)
    end
    return node
end

function makeSiblingBlack(tree, node)
    if isRedNode(sibling(node)) then
        rotateUp(tree, sibling(node))
    end
end

function makeFarNephewRed(tree, node)
    if isBlackNode(farNephew(node)) then
        rotateUp(tree, nearNephew(node))
    end
end

function swapWithSuccessor(deleteMe)
    local succ = successor(deleteMe)
    deleteMe.data, succ.data = succ.data, deleteMe.data
    return succ
end

function deleteNode(tree, deleteMe)
    assert(deleteMe ~= nil and (deleteMe[lchild] == nil or deleteMe[rchild] == nil))

    setChild(tree,
             parent(deleteMe),
             deleteMe[lchild] and deleteMe[lchild] or deleteMe[rchild],
             isLeftChild(deleteMe))
end

redblack = {
    newTree = newTree,
    insert  = insert,
    delete  = delete,
    iterate = iterate,
}

local function printNode(node)
    io.write(tostring(node))
    for k,v in pairs(node) do
        io.write(' <' .. tostring(k) .. ': ' .. tostring(v) .. '>')
    end
    print()
end

local function printTree(tree, depth)
    if tree == nil then return end
    if tree.root ~= nil then tree = tree.root end
    if depth == nil then depth = 0 end

    if depth == 0 then print() end

    printTree(tree[lchild], depth+1)

    for i = 1, depth do io.write("    ") end
    printNode(tree)

    printTree(tree[rchild], depth+1)

    if depth == 0 then print() end
end

local function nodeCount(xTree)
    local count = 0

    for i in redblack.iterate(xTree) do
        count = count + 1
    end

    return count
end

testredblack = {
    insertIntoSortedPosition = insertIntoSortedPosition,
    printNode = printNode,
    printTree = printTree,
    nodeCount = nodeCount
}
