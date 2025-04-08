using GLPK, Cbc, JuMP, SparseArrays, Cbc, DelimitedFiles, Plots

# METHOD 1 
# reading the content of file as a string 
# lines = readlines("Interpolated.txt")
lines = readlines(raw"C:\Users\liou-\OneDrive - Danmarks Tekniske Universitet\C. Elektroteknologi - Bachelor\6. semester\02526 Mathematical Modeling\-02526-Mathematical-Modeling\Qatarra Depression\Interpolated.txt")

# Initialize arrays to store the two variables
x = Float64[]  # First column
H = Float64[]  # Second column

# Split each line by the comma and parse the values
for line in lines
    values = split(line, ",")
    push!(x, parse(Float64, values[1]))
    push!(H, parse(Float64, values[2]))
end

# H = [
#     10
#     30
#     70
#     50
#     70
#     120
#     140
#     120
#     100
#     80
# ]


K = [
    300 140 40
]

CHD = 10;

function constructA(H, K)
    # Make a function that returns A when given H and K
    A = zeros(Int, length(H), length(H))
    for i = 1:length(H)
        for j = 1:length(H)
            if i == j
                A[i, j] = A[i, j] + K[1]
            elseif abs(i - j) == 1
                A[i, j] = A[i, j] + K[2]
            elseif abs(i - j) == 2
                A[i, j] = A[i, j] + K[3]
            end
        end
    end
    return A
end

# A should be structured as follows
# A = [300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
#     140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0 0.0
#     40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0
#     0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0
#     0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0
#     0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0
#     0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0
#     0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0
#     0.0 0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0
#     0.0 0.0 0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0
# ]


function solveIP(H, K)
    h = length(H)
    myModel = Model(Cbc.Optimizer)
    # If your want ot use GLPK instead use:
    #myModel = Model(GLPK.Optimizer)

    A = constructA(H, K)

    @variable(myModel, x[1:h], Bin)
    @variable(myModel, R[1:h] >= 0)

    @objective(myModel, Min, sum(x[j] for j=1:h) )
    # @objective(myModel, Min, sum(abs(R[i] - H[i] - CHD) for i = 1:h))
    
    @constraint(myModel, [j=1:h],R[j] >= H[j] + CHD )
    @constraint(myModel, [i = 1:h], R[i] == sum(A[i, j] * x[j] for j = 1:h))

    # @constraint(mymodel, [i = 1:h], sum(R[i, j] * x[j]) >= H[i] + CHD for j = 1:h)
    
    optimize!(myModel)

  

    if termination_status(myModel) == MOI.OPTIMAL
        println("Objective value: ", JuMP.objective_value(myModel))
        println("x = ", JuMP.value.(x))
        println("R = ", JuMP.value.(R))

# x(1:h) = JuMP.value.(x)


        # scatter(1:h, H-JuMP.value.(R), label="H", color=:blue, marker=:circle, xlabel="Index", ylabel="Depth", legend=false);
        colors_x = Vector{Symbol}(undef, h)  # Create an array to store colors
        for i in 1:h
            if JuMP.value.(x)[i] == 1
                colors_x[i] = :red
            elseif JuMP.value.(x)[i] == 0 
                colors_x[i] = :green
            else
                colors_x[i] = :blue
            end
        end

        scatter(1:h , H, label="H", color=colors_x, marker=:circle, xlabel="Index", ylabel="Depth", legend=true, title="Depth vs Index");
        scatter!(legend =:topleft);
# if JuMP.value.(x) == 1
#     colors_x = :yellow
# elseif JuMP.value.(x) == 0 
#     colors_x = :red
# else
#     colors_x = :blue
# end


        # scatter(1:h, H, label="H", colors=:colors_x, marker=:circle, xlabel="Index", ylabel="Depth", legend=false);
 


        # println("x = ", JuMP.value.(x))
        # println("xx = ", JuMP.value.(xx))
        # println("xxx = ", JuMP.value.(xxx))
        # println("R = ", JuMP.value.(R))
        # colors_x = [JuMP.value(x[i]) == 1 ? :yellow : JuMP.value(xx[i]) == 1 ? :green : JuMP.value(xxx[i]) == 1 ? :red : :blue for i in 1:h]
        # scatter(1:h, H-JuMP.value.(R), label="H", color=colors_x, marker=:circle, xlabel="Index", ylabel="Value", legend=false)
        #heatmap(1:h, x)

    else
        println("Optimize was not succesful. Return code: ", termination_status(myModel))
    end
end

solveIP(H, K)
