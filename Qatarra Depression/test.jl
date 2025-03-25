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

A = constructA(H, K)

println(size(A));
println(A)
# println((H));


# for i = 1:3
#     for j = 1:3
#         A[1, 1] = 300
#         A[1, 2] = 140
#         A[1, 3] = 40
#         A[2, 1] = 140
#         A[2, 2] = 40


#         #explosion on i and j

#         A[2, 2] = A[2, 2] + 300
#         A[2, 1] = A[2, 1] + 140
#         A[2, 3] = A[2, 3] + 140
#         A[2, 4] = A[2, 4] + 40

#         A[1, 2] = A[1, 2] + 140
#         A[3, 2] = A[3, 2] + 140
#         A[4, 2] = A[4, 2] + 40


#         if i == 2 && j == 2

#             A[i+1, j] = A[i+1, j] + K[2]
#             A[i-1, j] = A[i-1, j] + K[2]
#             A[i+2, j] = A[i+2, j] + K[3]
#             A[i-2, j] = K[3]

#             A[i, j+1] = K[2]
#             A[i, j-1] = K[2]
#             A[i, j+2] = K[3]
#             A[i, j-2] = K[3]

#         end


#     end
# end