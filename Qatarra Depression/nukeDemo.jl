using GLPK, Cbc, JuMP, SparseArrays, Cbc, DelimitedFiles





# METHOD 1 
# reading the content of file as a string 
lines = readlines("Interpolated.txt")

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

A = zeros(Float64, length(H), length(H))

function constructA(H, K)
    # Make a function that returns A when given H and K
    for i = 1:length(H)
        for j = 1:length(H)
            if i == H
                A[i, j] = K[i,j] + K[i+1,j] + K[i-1,j] + K[i,j+1] + K[i,j-1]
            end
        end
    end
    

    return A
end

# A should be structured as follows
A = [300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0 0.0
    40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0 0.0
    0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0 0.0
    0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0 0.0
    0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0 0.0
    0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0 0.0
    0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0 40.0
    0.0 0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0 140.0
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 40.0 140.0 300.0
]


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

    # @constraint(mymodel, [i = 1:h], sum(R[i, j] * x[j]) >= H[i] + CHD for j = 1:h)
    @constraint(myModel, [j=1:h],R[j] >= H[j] + CHD )
    @constraint(myModel, [i = 1:h], R[i] == sum(A[i, j] * x[j] for j = 1:h))



    optimize!(myModel)

    if termination_status(myModel) == MOI.OPTIMAL
        println("Objective value: ", JuMP.objective_value(myModel))
        println("x = ", JuMP.value.(x))
        println("R = ", JuMP.value.(R))
    else
        println("Optimize was not succesful. Return code: ", termination_status(myModel))
    end
end

solveIP(H, K)
