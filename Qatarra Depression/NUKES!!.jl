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

CHD = 10 # Canal height depth
plot!(col1, col2 .- CHD, line=:dash, label="Canal height")

# Calculate the Riemann Riemannsum_ofgraph
Riemannsum_ofgraph = riemann_sum(col1, col2, CHD)
println("Riemann sum: ", Riemannsum_ofgraph)

# Crater diamensions of a 100 kiloton explosion 
# from page 238 of the textbook
# alluvial_soil (all units in feet)
opitmal_depth_of_burst = 635
crater_radius = 611
depth = 323
Volume = 179000000

m = Model(GLPK.Optimizer)

@variable(m, bombs >= 0)
@variable(m, x[1:length(col1)] >= 0)

