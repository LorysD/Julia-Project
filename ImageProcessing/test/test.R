fibo_r <- function(n) {
    if (n==0 || n==1) {
        return(1)
    }
    a <- 1
    b <- 1
    c <- 1
    ctx <- 1
    while(ctx <=n) {
        c <- a+b
        a <- b
        b <- c
        ctx <- ctx +1
    }
    return(c)
}
