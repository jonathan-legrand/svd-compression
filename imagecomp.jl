using FileIO, Plots, Colors, LinearAlgebra, Images, ImageView, Gtk.ShortNames

"""
Load and convert the cat to 2d matrix. Assume it is in current directory.
"""
function makematrix(path="cat.jpg"::String)
    cat = load(path)
    graycat = Gray.(cat)
    matcat = @. Float64(gray(graycat))
    return matcat
end

"""
Return SVD components cut up to rank k.
"""
function compress(img::Matrix{Float64}, k::Integer)
    U, S, V = svd(img)
    return U[:, begin:k], S[begin:k], V[:, begin:k]
end

"""
Reconstruct image from compressed singular value decomposition.
"""
function reconstruct(
        U::Matrix{Float64}, S::Vector{Float64}, V::Matrix{Float64}
    )
    return clamp01.(U * diagm(S) * V')
end

"""
Compute size of compression and decompression for rank k.
"""
function experiment(A, k)
    Uk, Sk, Vk = compress(A, k)
    Ak = reconstruct(Uk, Sk, Vk)
    return Ak, sizeof(Uk) + sizeof(Sk) + sizeof(Vk)
end

"""
Launches the compression/decompression experiment,
by computing all the approximations in the 
krange. Returns decompressed images and their
former size in memory.
"""
function launch(img_name="cat2.jpg", krange=[10, 100, 500, 1000]) 
    images = []
    compsizes = []
    A = makematrix(img_name)
    for k in krange
        compressed_image, compsize =  experiment(A, k)
        push!(images, compressed_image)
        push!(compsizes, compsize)
    end
    
    return images, compsizes

end

function save_cats(images, krange, fprefix="cat")
    # TODO Makes more sense to iterate in krange directly
    for (index, image) in enumerate(images)
        save("$fprefix.$(krange[index]).png", image |> colorview(Gray))
    end
end

function display_cats(images)
    images .|> colorview(Gray) |> x->mosaicview(x,nrow=2) |> imshow
end

"""
Use the launch function directly from the REPL to gain more control over the
experiment.
"""
function main(sourcecat="cat2.jpg", mode=:display)
    println("Source cat : $sourcecat")
    images, _ = launch(sourcecat)
    if mode == display
        display_cats(images)
    elseif mode == :save
        save_cats(images)
    end
end
