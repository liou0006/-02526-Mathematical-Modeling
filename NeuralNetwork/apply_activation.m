function output = apply_activation(T, activation)
output = T;
% applies switch case for possible different types of activations
switch activation
    case 'abs'  % applies case for y-axis abs
        output{:,"Var1"} = abs(T{:,"Var1"});
    case 'relu'
        output{:,"Var1"} = max(0,T{:,"Var1"});
    case 'tanh'
        x = output{:,"Var1"};
        expX = exp(x);
        expNegX = exp(-x);
        output{:,"Var1"} = (expX - expNegX) ./ (expX + expNegX);
    case 'sigmoid'
        % Sigmoid (logistic) activation: 1 / (1 + exp(-x))
        x = output{:,"Var1"};
        output{:,"Var1"} = 1 ./ (1 + exp(-x));
    otherwise
        fprintf("you fucking broke it you idiot. you need to specify an activation")
end