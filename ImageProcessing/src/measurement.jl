function compute_execution_time(f, args)
    if !isa(args, Array)
        @error "Arguments must be passed as an array"
        exit(code=1)
    end
    result = @timed f(args...)
    return result
end

function compute_allocation(f, args::Array)
    result = @allocated f(args...)
    return result
end

export compute_execution_time, compute_allocation
