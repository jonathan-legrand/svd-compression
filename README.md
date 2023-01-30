# svd-compression
`imagecomp.jl` is a naive implementation of a SVD-based image compression algorithm.
I recommend including the script in the REPL and call the functions
if you want to experiment with it.
By default the main function computes the rank k approximations of
the cat2 image for k in [10, 100, 500, 1000] and displays them.

`sphere.jl` allows to draw a geometric interpretation for each component
of the SVD for any 2 by 2 matrix.
