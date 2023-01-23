module measurement

function compute_execution_time(func, args)
    return @timed func(args...)
end

function compute_allocation(func, args::Array)
    return @allocated func(args...)
end

export compute_execution_time, compute_allocation

end # end of the module