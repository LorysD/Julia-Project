module ImageProcessing
using PyCall
include("measurement.jl")
include("convolution.jl")

# Julia call
function jl_apply_filter(img::Matrix, filter::Matrix{Int8})
    return compute_execution_time(conv, [img, filter])
end

# Python call
const skimage_io = PyNULL()
copy!(skimage_io, pyimport_conda("skimage.io", "scikit-image"))
function py_apply_filter(img::Matrix, filter::Matrix{Int8})

end

# R call
function r_apply_filter(img::Matrix, filter::Matrix{Int8})

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
function apply_filter(img::Matrix, filter_name::String, env::String)
    filter = get_filter(filter_name)
    if env == "julia"
        return jl_apply_filter(img, filter)
    end
end

end # module ImageProcessing
