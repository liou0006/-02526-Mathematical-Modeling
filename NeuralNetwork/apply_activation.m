function output = apply_activation(input_vector, activation)
output = [0;0];
switch activation 
    case 'abs'
        output(1,1) = abs(input_vector(1));
        output(2,1) = input_vector(2);

    otherwise 
        output = null
end