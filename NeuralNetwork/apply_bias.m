function [biased_Vector] = apply_bias(input_vector,b)
% moves the input_vector by b along the x-axis 
biased_Vector(1) = input_vector(1) + b
biased_Vector(2) = input_vector(2)

end