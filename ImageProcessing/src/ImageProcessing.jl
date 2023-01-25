module ImageProcessing

# Julia call
include("conv.jl")
"""
    jl_apply_filter(img::Matrix, filter::Matrix{Int8})

Apply filter `filter` to the image `img` using Julia implementation.

# Arguments
- `img::Matrix`: The image to transform
- `filter::Matrix{Int8}`: The filter to apply
"""
function jl_apply_filter(img::Matrix, filter::Matrix{Int8})
    return @timed conv(img, filter)
end

# Python call
using PyCall
py"""
import sys
sys.path.insert(0, "../ImageProcessing/src")
"""
const py_conv = pyimport("conv")["conv"]
"""
    py_apply_filter(img::Array{Float64}, filter::Matrix{Int8})

Apply filter `filter` to the image `img` using Python implementation.

# Arguments
- `img::Array{Float64}`: The image to transform
- `filter::Matrix{Int8}`: The filter to apply
"""
function py_apply_filter(img::Array{Float64}, filter::Matrix{Int8})
    return py_conv(img, filter)
end

# R call
using RCall
R"""
options(download.file.method="wget")
if (!("imager" %in% rownames(installed.packages()))){
    install.packages("imager")
}
source("../ImageProcessing/src/conv.R")
"""
"""
    py_apply_filter(img::Array{Float64}, filter::Matrix{Int8})

Apply filter `filter` to the image `img` using R implementation.

# Arguments
- `img::Array{Float64}`: The image to transform
- `filter::Matrix{Int8}`: The filter to apply
"""
function r_apply_filter(img::Array{Float64}, filter::Matrix{Int8})
    img, time = rcall(:conv, img, filter)
    return img, rcopy(time)
end

"""
    img_to_arr(img::Matrix)

Convert the image `img` from a RGB matrix to a Float64 matrix.

# Arguments
- `img::Matrix`: The image to convert
"""
function img_to_arr(img::Matrix)
    arr = channelview(img)
    if length(img) == 3
        arr = permutedims(arr, (2, 3, 1))  # color channel last
    end
    return convert.(Float64, arr)
end

# Filters
"""
    get_filter(filter_name::String)

Returns the matrix representing the filter corresponding to the name `filter_name`.

# Arguments
- `filter_name::String`: The name of filter to return
"""
function get_filter(filter_name::String)
    filter = ones(Int8, (3, 3))
    if filter_name == "flou"
        filter[2, 2] = 3
        filter[1, 2] = filter[2, 1] = filter[2, 3] = filter[3, 2] = 2
    elseif filter_name == "net"
        filter = zeros(Int8, (3, 3))
        filter[2, 2] = 5
        filter[1, 2] = filter[2, 1] = filter[2, 3] = filter[3, 2] = -1
    elseif filter_name == "gaufrage"
        filter[1, 1]  = -2
        filter[3, 3]  = 2
        filter[1, 2]  = filter[2, 1] = -1
        filter[1, 3]  = filter[3, 1] = 0
    end
    filter = convert(Matrix{Int8}, filter)
    return filter
end

# Main entry
"""
    apply_filter(img::Matrix, filter_name::String, lang::String)

Apply filter `filter` to the image `img` using the language `lang` implementation.

# Arguments
- `img::Matrix`: The image to transforme
- `filter_name::String`: The name of the filter to apply
- `lang::String`: The language implementation to use
"""
function apply_filter(img::Matrix, filter_name::String, lang::String)
    filter = get_filter(filter_name)
    if lang == "julia"
        return jl_apply_filter(img, filter)
    elseif lang == "Python"
        return py_apply_filter(img_to_arr(img), filter)
    elseif lang == "R"
        return r_apply_filter(img_to_arr(img), filter)
    end
end

end # module ImageProcessing
