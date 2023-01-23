module measurement

function compute_execution_time(funcn, args, language="julia")
    if !isa(args, Array)
        @error "Arguments must be passed as an array"
        exit(code=1)
    end
    if language == "R"
        result = @timed rcall(funcn, args...)
    else
        result = @timed f(args...)
    end
    return result
end

function compute_allocation(f, args::Array)
    result = @allocated f(args...)
    return result
end

export compute_execution_time, compute_allocation

end # end of the module
