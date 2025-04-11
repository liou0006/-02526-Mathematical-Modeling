


kernel = fspecial("sobel",20,6); %4,1
dtotal_Vx_filtered = zeros(sizing);
dtotal_Vy_filtered = zeros(sizing);
dtotal_Vt_filtered = zeros(sizing);
for k = 1 : sizing(1)
    dtotal_Vx_filtered(k,:,:) = imfilter(D3matrixarray(k,:,:),kernel);
end
for k = 1 : sizing(2)
    dtotal_Vy_filtered(:,k,:) = imfilter(dtotal_Vx_filtered(:,k,:),kernel);
end
for k = 1 : sizing(3)
    dtotal_Vt_filtered(:,:,k) = imfilter(dtotal_Vy_filtered(:,:,k),kernel);
end