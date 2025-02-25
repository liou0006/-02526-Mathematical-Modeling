function output = apply_activation(input_vector, activation)
output = [0;0];

% applies switch case for possible different types of activations 
switch activation 
    case 'abs'  % applies case for y-axis abs
        output(1,1) = abs(input_vector(1));
        output(2,1) = input_vector(2);

    otherwise 
        output = null
end