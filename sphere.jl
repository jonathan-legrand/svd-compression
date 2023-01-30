using LinearAlgebra, Plots

"""
Generate random points on the unit sphere
"""
function generate_point()
    x = rand(2, 1) .- 0.5
    return x / norm(x)
end

"""
Plot unit sphere in R^2 and the image of it inder A.
"""
function job(A, n=100)
    s2 = [generate_point() for _ in range(1, n)]

    U, S, Vt = svd(A)
    Σ = Diagonal(S)
    sv1, sv2 = map(s -> round(s, digits=3), S)

    Vt_rotated = [Vt * x for x in s2]
    sigma_stretched = [Σ * x for x in Vt_rotated]
    U_rotated = [U * x for x in sigma_stretched]

    ellipsoids = [s2, Vt_rotated, sigma_stretched, U_rotated]
    # Reduce to plottable format
    ellipsoids = map(x -> mapreduce(permutedims, vcat, x), ellipsoids)

    scatter(
            ellipsoids[1][:, 1], 
            ellipsoids[1][:, 2], 
            label="Unit circle", 
            set_aspect=:equal,
            title="Geometric interpretation of SVD"
           )
    scatter!(ellipsoids[2][:, 1], ellipsoids[2][:, 2], label="Vt rotated")
    scatter!(
             ellipsoids[3][:, 1],
             ellipsoids[3][:, 2],
             label="Stretched with sv $sv1 and $sv2"
            )
    scatter!(ellipsoids[4][:, 1], ellipsoids[4][:, 2], label="U rotated")
    gui()
    return S
end
