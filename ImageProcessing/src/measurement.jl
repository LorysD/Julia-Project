module Measurement
using RCall

export compute_execution_time, compute_allocation

"""
    compute_execution_time(funcn, args, language="julia")

Compute the execution time of `funcn` with `args` as arguments.

If no language is specified than compute\\_execution\\_time expects funcn to be a julia function
If not, one must first load the functions using the appropriate language. For instance, if the function to be run is located in *file.R*, make sure to load it using R"source('file.R')".

# Arguments
- `func`: The function to measure
- `args::Array`: The array of arguments
- `language::String`: The language to use to compute the execution time

# Examples
```julia-repl
julia> function fibo(n)
+     if (n==0 || n==1)
+         return 1
+     end
+     a = 1
+     b = 1
+     c = 1
+     ctx = 1
+     while(ctx <= n)
+         c = a + b
+         a = b
+         b = c
+         ctx += 1
+     end
+     return c
+ end
fibo (generic function with 1 method)

julia> compute_execution_time(fibo, [1243])
(value = -1802555961753093374, time = 0.004444458, bytes = 152067, gctime = 0.0, gcstats = Base.GC_Diff(152067, 0, 0, 2695, 0, 0, 0, 0, 0))
```
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

"""
    compute_allocation(func, args::Array)

Compute the allocated memory to execute `func` with `args` as arguments.

# Arguments
- `func`: The function to measure
- `args::Array`: The array of arguments

# Examples
```julia-repl
julia> function fibo(n)
+     if (n==0 || n==1)
+         return 1
+     end
+     a = 1
+     b = 1
+     c = 1
+     ctx = 1
+     while(ctx <= n)
+         c = a + b
+         a = b
+         b = c
+         ctx += 1
+     end
+     return c
+ end
fibo (generic function with 1 method)

julia> compute_allocation(fibo, [1243])
151539
```
"""
function compute_allocation(func, args::Array)
    return @allocated func(args...)
end



end # end of module

