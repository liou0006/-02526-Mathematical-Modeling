%open folder and files




% Specify the folder where the files live.
myFolder = 'C:\Users\edwar\OneDrive\Documents\TAMU files\spring 2025\mathmatical models\toyProblem_F22\timelapse(1)';
% Check to make sure that folder actually exists. Warn user if it doesn't.
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
    uiwait(warndlg(errorMessage));
    myFolder = uigetdir(); % Ask for a new one.
    if myFolder == 0
        % User clicked Cancel
        return;
    end
end

% 
% 
% videofile = handles.videofile;
% scanrate = handles.scanrate;
% frame_rate = handles.frame_rate;
% Time = handles.Time;
% Chamber_P = handles.Chamber_P;
% TimeScale = scanrate/frame_rate;
% handles.TimeScale = TimeScale;
% 
% 
% 








% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.png'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

baseFileName = theFiles(1).name;
fullFileName = fullfile(theFiles(1).folder, baseFileName);
%fprintf(1, 'Now reading %s\n', fullFileName);
% Now do whatever you want with this file name,
% such as reading it in as an image array with imread()
imageArray = imread(fullFileName);
imageArray = rgb2gray(imageArray);

sizing = size(imageArray);
sizing(1,3) =  length(theFiles);

D3matrixarray = zeros(sizing,"double");
% D3_X_matrixarray = zeros(sizing(1),sizing(2)-1,sizing(3),"double");
% D3_Y_matrixarray = zeros(sizing(1)-1,sizing(2),sizing(3),"double");
% D3_T_matrixarray = zeros(sizing(1),sizing(2),sizing(3)-1,"double");
% dx_y_total = zeros(sizing(1)-1,sizing(2)-1,sizing(3),"double");
% dtotal_filtered = zeros(sizing(1),sizing(2),sizing(3),"double");
% dt = zeros(sizing(1),sizing(2),sizing(3)-1,"double");
% dtotal_Vt_filtered = zeros(sizing(1),sizing(2),sizing(3), "double");
GGF3 = zeros(sizing(1),sizing(2),sizing(3), "double");

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    %fprintf(1, 'Now reading %s\n', fullFileName);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    imageArray = imread(fullFileName);
    imageArray = double(imageArray)./256.0;
    imageArray = rgb2gray(imageArray);

    % 3-d matrix is created
    D3matrixarray(1:sizing(1),1:sizing(2),k) = imageArray(1:sizing(1) ,1: sizing(2));

    % part 2.1
    % dx = imageArray(1:end,2:end) - imageArray(1:end,1:end-1);
    % D3_X_matrixarray(:,:,k) = dx(:,:);
    % 
    % dy = imageArray(2:end,1:end) - imageArray(1:end-1,1:end);
    % D3_Y_matrixarray(:,:,k) = dy(:,:);
    % dx_y_total(:,:,k) = sqrt(D3_X_matrixarray(1:sizing(1)-1,1:sizing(2)-1 ,k).^2 + D3_Y_matrixarray(1:sizing(1)-1,1:sizing(2)-1,k).^2);
    % 
    % if k > 1
    %     dt(:,:,k) = D3matrixarray(:,:,k) - D3matrixarray(:,:,k-1);
    % end


    % Part 2.2 axis Vt
    %kernel = fspecial("gaussian",4,1);
    %dtotal_Vt_filtered(:,:,k) = imfilter(D3matrixarray(:,:,k),kernel);


    %imshow(imageArray); % Display image.
    %pause(0);
    %drawnow; % Force display to update immediately.
end


sizing = size(D3matrixarray);
%for k = sizing[3]

%Part 2.2 Axis Vx and Vy can transpose kernel for different kernel
kernel = fspecial("gaussian",4,1);
dtotal_Vx_filtered = zeros(sizing);
dtotal_Vy_filtered = zeros(sizing);

for k = 1 : sizing(1)
    dtotal_Vx_filtered(k,:,:) = imfilter(D3matrixarray(k,:,:),kernel);
end
for k = 1 : sizing(2)
    dtotal_Vy_filtered(:,k,:) = imfilter(D3matrixarray(:,k,:),kernel);
end


%displays 2.2
%volumeViewer(dtotal_Vx_filtered)
%volumeViewer(dtotal_Vy_filtered)
%volumeViewer(dtotal_Vt_filtered)

% Part 2.3
sigma = 1;  % change size of sigma
filter_size = 3; %pixels from center filter size
x = -filter_size:filter_size;
G = (1/sqrt((2*pi*sigma^2)))*exp(-x.^2/(2*sigma^2));
G = G / sum(G);
dG = -(x./(sigma^2)) .* G; % differential gradient 
Gz = reshape(dG,1,1,length(G));
GGFZ3 = zeros(sizing(1),sizing(2),sizing(3));
GGFX3 = zeros(sizing(1),sizing(2),sizing(3));
GGFY3 = zeros(sizing(1),sizing(2),sizing(3));

for k = 1:sizing(1) % applies gradient to X and Y planes
        GGFX3(k,:,:) =  imfilter(D3matrixarray(k,:,:),dG);
end
for k = 1:sizing(2) % applies gradient to X and Y planes
        GGFY3(:,k,:) =  imfilter(D3matrixarray(:,k,:),dG.');
end
%volumeViewer(GGFX3);
%volumeViewer(GGFY3);
% gradient for Vt
for k = 1:sizing(1,1) % applies gradient to T plane
    GGFZ3(:,:,:) =  imfilter(D3matrixarray(:,:,:),Gz);
end
%volumeViewer(GGFZ3) %displays 3d matrix
for k = 1:sizing(1,3)
    %imshow(GGFZ3(:,:,k));
end

%------------------ PART 3------------------%

u = size(GGFZ3(:,:,k));
v = size(GGFY3(:,:,k));
LKrange = 100; % set size of neighbors
    
for z =  1:sizing(1,3)
    for n = 1+LKrange:LKrange: sizing(1,1)-LKrange
        for m = 1+LKrange:LKrange: sizing(1,2)-LKrange
            Ix = GGFX3(n-LKrange:n+LKrange,m-LKrange:m+LKrange,z);
            Iy = GGFY3(n-LKrange:n+LKrange,m-LKrange:m+LKrange,z);
            Iz = GGFZ3(n-LKrange:n+LKrange,m-LKrange:m+LKrange,z);
% 
            Ix = Ix(:);
            Iy = Iy(:);
            b = -Iz(:); % get b here

            A = [Ix Iy]; % get A here
            nu = pinv(A)*b; % get velocity here

            u(m,n)=nu(1);
            v(m,n)=nu(2);


        end
    end
    v_space = LKrange;
    u_deci = u(1:v_space:end, 1:v_space:end);
    v_deci = v(1:v_space:end, 1:v_space:end);
    % get coordinate for u and v in the original frame
    [X,Y] = meshgrid(1+v_space:sizing(1,1)-v_space, 1+v_space:sizing(1,2)-v_space);
    X_deci = X(1:v_space:end, 1:v_space:end);
    Y_deci = Y(1:v_space:end, 1:v_space:end);

    if size(u_deci) > size(X_deci)
        u_deci(:,1) = [];
        v_deci(1,:) = [];
        u_deci(1,:) = [];
        v_deci(:,1) = [];
    elseif size(X_deci) > size(u_deci)
        X_deci(:,1) = [];
        X_deci(1,:) = [];
        Y_deci(1,:) = [];
        Y_deci(:,1) = [];
    end

    %% Plot optical flow field
    imshow(D3matrixarray(:,:,z));
    hold on;
    u_deci(1,1) = 0;
    v_deci(1,1) = 0;

    % draw the velocity vectors
    quiver(X_deci, Y_deci, u_deci,v_deci , 'r' )
    pause(1);
end


