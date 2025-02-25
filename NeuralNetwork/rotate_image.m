% rotates each vector using function apply_vector

function [rotated_image] = rotate_image(T, angle)
sz = [height(T) 3];
typeVar = ["double","double","logical"];
nameVar = ["X_pos", "Y_pos", "land||water"];
rotated_image = table('Size',sz , 'VariableTypes', typeVar, 'VariableNames', nameVar);

for k = 1:height(T)
    m = apply_rotate(T{k,["Var1","Var2"]}.',angle);
    
    rotated_image{k,["X_pos","Y_pos"]} = m.';
end
rotated_image(:,"land||water") = T(:,"Var3");

end