
T = readtable("Libian_desert_data.csv");
close all
rotatelist = [90,0,0,0]; % change rotation amount here
biaslist = [180,-10,0,0];
for i=1:1:numel(biaslist)
    rotation=rotatelist(i);
    rotatedImage = rotate_image(T,rotation);

    bias =  biaslist(i);  % Change Bias here
    biasedimage = apply_bias(rotatedImage,bias);  % applying bias

    foldedimage = apply_activation(biasedimage,'abs');
    T=foldedimage;

    x_values_bias = biasedimage(:,1);
    x_values_folded=foldedimage(:,1);
    % Find indices where a mirrored version exists
    gg = x_values_folded.Var1 - x_values_bias.Var1;
    mirrored_indices = false(size(gg));

    m_index = find(gg>0);
    array_fold = foldedimage(m_index,:);
    % foldedimage(1,:) = -foldedimage(1,:);
    %
    % saveas(foldedimage)
    %
    % writematrix(foldedimage, 'transformed_data.csv');
    %
    clf reset
    figure(1)
    hold on
    title('Folded')

    scatter(foldedimage,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    scatter(array_fold,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    xline(0,'Color','red','LineWidth',1.5)
    hold off
    figure(2)
    hold on
    title('OG')
    scatter(biasedimage,"Var1","Var2","ColorVariable","Var3","SizeData",1,MarkerFaceAlpha=.1)
    xline(0,'Color','red','LineWidth',1.5)
    fig = figure();
    btn = uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
        'Position', [20 20 100 40], ...
        'Callback', 'uiresume(gcbf)');

    uiwait(fig); % Waits for the button to be clicked
    close(fig); % Closes the figure after clicking
end