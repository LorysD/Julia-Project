using Test
using ImageProcessing
using RCall

## fibo computes
## n-th term of the fibonacci sequence
## only used for testing
function fibo(n)
    if (n==0 || n==1)
        return 1
    end
    a = 1
    b = 1
    c = 1
    ctx = 1
    while(ctx <= n)
        c = a + b
        a = b
        b = c
        ctx += 1
    end
    return c
end

R"source('test.R')"
a = @rget fibo_r

@testset "Execution time measurement" begin
    @test typeof(ImageProcessing.Measurement.compute_execution_time(fibo, [1000], "julia")[2]) == Float64
    @test typeof(ImageProcessing.Measurement.compute_execution_time(a, [1000], "R")[2]) == Float64
    @test typeof(ImageProcessing.Measurement.compute_allocation(fibo, [10000])) == Int64
end
