Copyright (C) 2012, Greg Johnson
Released under the terms of the GNU GPL v2.0.

lua_red_black_trees
===================
This is a lua implementation of red black trees.  The main purpose of this
code is to be straightforward, understandable, and self-explanatory.

No attention has been paid to code optimization tricks, etc. other than the
inherent O(logN) efficiency of the red black tree algorithms themselves.

The hope is that this presentation of the red black tree algorithms will
serve as a reference for other implementations that attempt to optimize
for specific languages and/or platforms.

(And, help students who are struggling through the "binary search tree"
section of computer science algorithms classes!)

The code was developed and tested using lua 5.1.

A couple of innovations have been added to aid in understandability:

 - The usual definition of the black property has been changed; the
   new definition is provably equivalent to the standard definition,
   but IMHO is much better in making the red black delete algorithm
   understandable.  As usually presented, the delete algorithm
   is notorious for its obscurity and difficulty.  I think that the
   essential reason for this has been a bad formulation of the pre-condition
   for the "restoreBlackProperty()" function.  (The restoreBlackProperty()
   pre-condition is simply that there is a black property violation
   in the tree.)  The new definition of the black property makes each
   step of the restoreBlackProperty() function beautifully intuitive,
   natural, and inevitable.

 - Except for low-level helper functions, the algorithms make no mention
   of "left child" or "right child".  Typical presentations of the
   red black tree algorithms replicate large blocks of code to handle
   the left and right subtree cases separately.  The key here has been
   to define a new function "rotateUp(node)" that replaces the traditional
   pair of functions "rotateLeft(node)" and "rotateRight(node)".

 - There is no need for fake black NULL pseudo-nodes as leaves, and no
   requirement about the color of the root node.  Neither the algorithms
   as presented nor their correctness proofs require these annoying
   but minor complexities in the traditional presentation of red black trees.
