function [biased_Vector] = apply_bias(input,b)
%Moves the input vector in the orthogonal direction by b amount.
%Add a perpendicular normalized vector for displacement.
perpVector=[-input(2),input(1)];
perpVectorUnit=perpVector/abs(perpVector);
biased_Vector=input+b*perpVectorUnit;
end