function [rotatedVector] = apply_rotate(input,angle)
%input is a 2D Vector going through the image from Origo?.
%angle is how much the vector should be angled.
angle = deg2rad(angle);
inputVector=input;
rotationVector = [cos(angle),-sin(angle);sin(angle), cos(angle)];
rotatedVector=(rotationVector*inputVector);
end