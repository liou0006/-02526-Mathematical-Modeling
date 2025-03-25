using GLPK, Cbc, JuMP, SparseArrays, DelimitedFiles, Plots, Plots.PlotMeasures, HiGHS

 
data = readdlm("Interpolated.txt", ',')

# Extract each column into separate arrays
col1 = data[:, 1]  # First column 
col2 = data[:, 2]  # Second column
# col3 = data[:, 3]  # Third column

H = col2

K = [
300 140 40
]


# A should be structured as follows
function constructA(H, K)
    h = length(H)
    A = zeros(h, h)  # Create a zero matrix of size h x h
    for i in 1:h
        for j in 1:h
            if abs(i - j) < length(K)
                A[i, j] = K[abs(i - j) + 1]
            end
        end
    end
    return A
end


function solveIP(H, K)
    h = length(H)
    myModel = Model(HiGHS.Optimizer)
    # If your want ot use GLPK instead use:
    #myModel = Model(GLPK.Optimizer)

    A = constructA(H,K)

    @variable(myModel, x[1:h], Bin )
    @variable(myModel, R[1:h] >= 0 )

    #@objective(myModel, Min, sum(x[j] for j=1:h) )
    @objective(myModel, Min, sum((R[j]-H[j]-10) for j=1:h) )

    @constraint(myModel, [j=1:h],R[j] >= H[j] + 10 )
    @constraint(myModel, [i=1:h],R[i] == sum(A[i,j]*x[j] for j=1:h) )

    optimize!(myModel)

    if termination_status(myModel) == MOI.OPTIMAL
        println("Objective value: ", JuMP.objective_value(myModel))
        println("x = ", JuMP.value.(x))
        println("R = ", JuMP.value.(R))
        
        #scatter(col1, JuMP.value.(x))
        
        #plot(col1, col2-JuMP.value.(R))
        
       # scatter(col1, 200*JuMP.value.(x), label="x", markersize=2)
        #plot!(col1, col2, label="H", right_margin=1cm) 
        colors = [JuMP.value(x[i]) == 1 ? :yellow : :blue for i in 1:h]
        scatter(col1, H, label="H", color=colors, marker=:circle, markersize=3, xlabel="Index", ylabel="Value", legend=false,size=(600,400))
       # png("file121")


    else
        println("Optimize was not succesful. Return code: ", termination_status(myModel))
    end
end

solveIP(H,K)





