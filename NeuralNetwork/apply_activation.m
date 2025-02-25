function output = apply_activation(T, activation)
output = T;
% applies switch case for possible different types of activations 
switch activation 
    case 'abs'  % applies case for y-axis abs
        output{:,"Var1"} = abs(T{:,"Var1"});
    otherwise 
        fprintf("you fucking broke it you idiot. you need to specify an activation")
end