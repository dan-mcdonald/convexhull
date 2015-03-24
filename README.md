# convexhull
Utility to compute convex hull of a set of points. Written in CoffeeScript to
run on node.js.

# prerequisites
You should have node.js and npm installed already.

# usage
`$ npm install` to install dependencies.

`$ $(npm bin)/grunt test` to compile and run tests.

`$ node main.js [input]` to run convex hull algorithm. `input` should refer to
a file containing lines of space-separated 2D coordinates. If not specified,
will read from standard input expecting the same format. Output will be in the
same format.

# generating input data
You can use the `rbox` utility from the [qhull](http://qhull.org/) package to
generate input data. If you use OSX and have Homebrew qhull can be installed
with just a `brew install qhull` command. To generate data for this utility,
you need to filter out the first two lines, which are part of qhull's "OFF"
format. E.g. 

    $ rbox D2 10 | tail +3 | tee input.data
    0.1740912428815767 -0.04848616481617668 
    0.09302440108081733 0.4611043245169374 
    -0.2196253656592456 -0.2435228291372981 
    0.1118086824303574 0.1685208190870665 
    0.3294011646224196 0.2453673181546547 
    -0.1114896080563679 0.1941543563214637 
    0.1522612624357094 0.05503265238835719 
    -0.06621565256846662 0.1135238871104306 
    -0.004034136425735579 0.1982652113756772 
    0.2434021264718865 -0.1404662049752345 

# implementation
Implements [Andrew's monotone chain convex hull algorithm](http://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain)
and written in a functional style. The algorithm runs in four stages: first it
sorts the input points according to x-axis. Second it computes the lower hull
by going through the sorted points one by one, checking whether each point is
clockwise to the last two points. Third it does another pass against the
sorted points reversed to calculate the upper hull. Finally, it removes the
first point from each half-hull and concatenates them. 

# limitations
Since this was written in a functional style, recursion is used instead of
looping. Unfortunately node.js v0.12.0 (and all major JS engines I'm aware of)
don't [currently implement](http://kangax.github.io/compat-table/es6/) any tail
recursion optimizations. So unfortunately the algorithm only works for inputs
not much more than ~6000 points (YMMV).

# author
Dan McDonald
