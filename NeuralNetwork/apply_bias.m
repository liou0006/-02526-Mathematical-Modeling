function [T] = apply_bias(T,b)
% moves the input_vector by b along the x-axis 
% biased_table = T ; 
T{:,"Var1"} = T{:,"Var1"} +b ;
end