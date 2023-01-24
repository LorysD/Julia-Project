module ImageProcessing

# Julia call
include("conv.jl")
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
function r_apply_filter(img::Array{Float64}, filter::Matrix{Int8})
    img, time = rcall(:conv, img, filter)
    return img, rcopy(time)
end

function img_to_arr(img::Matrix)
    arr = channelview(img)
    if length(img) == 3
        arr = permutedims(arr, (2, 3, 1))  # color channel last
    end
    return convert.(Float64, arr)
end

# Filters
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
