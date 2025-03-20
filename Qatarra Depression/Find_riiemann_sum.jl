function riemann_sum(x, y, CHD) # Function to calculate the Riemann sum

    Riemannsum_ofgraph = 0.0
    for i in 1:length(x)-1
        Riemannsum_ofgraph += (x[i+1] - x[i]) * y[i]
        Riemannsum_ofgraph += abs(x[i+1] - x[i]) * CHD # depth of canal
    end
    return Riemannsum_ofgraph
end