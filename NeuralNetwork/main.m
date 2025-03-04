close all
T = readtable("Libian_desert_data.csv");
rotatelist = [90,-10,160,0]; % change rotation amount here
biaslist = [180,0,450,0];
for i=1:1:numel(biaslist)
    rotation=rotatelist(i);
    rotatedImage = rotate_image(T,rotation);

    bias =  biaslist(i);  % Change Bias here
    biasedimage = apply_bias(rotatedImage,bias);  % applying bias

    foldedimage = apply_activation(biasedimage,'abs');
    T=biasedimage;

    x_values_bias = biasedimage(:,1);
    x_values_folded=foldedimage(:,1);
    % Find indices where a mirrored version exists
    gg = x_values_folded.Var1 - x_values_bias.Var1;
    m_index = find(gg>0);
    array_fold = foldedimage(m_index,:);
    % foldedimage(1,:) = -foldedimage(1,:);
    %
    % saveas(foldedimage)
    %
    % writematrix(foldedimage, 'transformed_data.csv');
    %
    figure(i)
    hold on
    title('Folded')
    scatter(foldedimage,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    scatter(array_fold,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    xline(0,'Color','red','LineWidth',1.5)
    hold off
    figure(i+numel(biaslist))
    hold on
    title('OG')
    scatter(biasedimage,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    xline(0,'Color','red','LineWidth',1.5)
    hold off
    fig = figure(i+numel(biaslist)*2);
    btn = uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
        'Position', [20 20 100 40], ...
        'Callback', 'uiresume(gcbf)');
    uiwait(fig); % Waits for the button to be clicked
    close(fig);
end