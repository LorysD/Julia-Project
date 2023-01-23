function compute_execution_time(funcn, args, isexp)
    if !isa(args, Array)
        @error "Arguments must be passed as an array"
        exit(code=1)
    end
    if isexp
        result = @timed rcall(funcn, args...)
    else
        result = @timed f(args...)
    end
    return result[2]
end

function compute_allocation(f, args::Array)
    result = @allocated f(args...)
    return result
end

export compute_execution_time, compute_allocation
