Y= 10000

function compute_sum(x::UInt64)
    sum = 0
    if x <1
        return 0
    end
    idx = 0
    while idx <= x
        sum += idx
        idx +=1
    end
    return sum
end


