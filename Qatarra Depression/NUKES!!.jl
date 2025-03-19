using Plots, GLPK, Cbc, JuMP, SparseArrays
using DelimitedFiles

# Load the data from the file
file_path = "C:/Users/edwar/OneDrive/Documents/TAMU files/spring 2025/mathmatical models/-02526-Mathematical-Modeling/-02526-Mathematical-Modeling/Qatarra Depression/Interpolated.txt"
data = readdlm(file_path, ',')

# Extract each column into separate arrays
col1 = data[:, 1]  # First column 
col2 = data[:, 2]  # Second column
# col3 = data[:, 3]  # Third column

scatter(col1, col2, xlabel="distance", ylabel="height", title="Location Data", legend=true, markersize=4)

# Function to calculate the Riemann sum
function riemann_sum(x, y)
    sum = 0.0
    for i in 1:length(x)-1
        sum += (x[i+1] - x[i]) * y[i]
        sum += abs(x[i+1] - x[i]) * 10 # depth of canal
    end
    return sum
end

# Calculate the Riemann sum
sum = riemann_sum(col1, col2)
println("Riemann sum: ", sum)

# Crater diamensions of a 100 kiloton explosion from page 238 of the textbook
# alluvial_soil 
opitmal_depth_of_burst = 635
crater_radius = 611
depth = 323
Volume = 179000000
