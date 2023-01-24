module Measurement
using RCall

"""
    compute_execution_time(funcn, args, language="julia")

Compute the execution time of `funcn` with `args` as arguments.

If no language is specified than compute_execution_time expects funcn to be a julia function
If not, one must first load the functions using the appropriate language. For instance, if the function to be run is located in *file.R*, make sure to load it using R"source('file.R')".

# Arguments
- `func`: The function to measure
- `args::Array`: The array of arguments
- `language::String`: The language to use to compute the execution time
"""
function compute_execution_time(funcn, args, language="julia")
    if !isa(args, Array)
        @error "Arguments must be passed as an array"
        exit(code=1)
    end
    if language == "R"
        result = @timed rcall(funcn, args...)
    else
        result = @timed funcn(args...)
    end
    return result
end

function compute_allocation(func, args::Array)
    return @allocated func(args...)
end

export compute_execution_time, compute_allocation

end # end of module

