using Test
using ImageProcessing

function compute_sum(x::Int64)
    sum = 0
    if x <1
        return 0
    end
    idx = 0
    for idx in range(0,x)
        sum += idx
    end
    return sum
end


@testset "Execution time measurement" begin
    @test typeof(compute_execution_time(compute_sum, [1000])) == Float64
    @test compute_allocation(compute_sum, [1000]) == 32
end
