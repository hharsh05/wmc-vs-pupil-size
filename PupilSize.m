% Demo by Image Analyst.  July 2021
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

%--------------------------------------------------------------------------------------------------------
%    READ IN IMAGE
folder = pwd;
baseFileName = 'Capture1.jpg';
grayImage = imread(baseFileName);
% Get the dimensions of the image.
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(grayImage)
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Use weighted sum of ALL channels to create a gray scale image.
	grayImage = min(grayImage, [], 3);
end

%--------------------------------------------------------------------------------------------------------
% Display the image.
subplot(2, 2, 1);
imshow(grayImage, []);
axis('on', 'image');
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
hFig = gcf;
hFig.WindowState = 'maximized'; % May not work in earlier versions of MATLAB.

%--------------------------------------------------------------------------------------------------------
% Get the histogram so we can see where to threshold it.
subplot(2, 2, 2);
imhist(grayImage);
grid on;
xlabel('Gray Level', 'FontSize', fontSize, 'Interpreter', 'None');
ylabel('Pixel Count', 'FontSize', fontSize, 'Interpreter', 'None');
title('Histogram of Original Image', 'FontSize', fontSize, 'Interpreter', 'None');

%--------------------------------------------------------------------------------------------------------
% Threshold to get the pupil.
% Use interactive thresholding app at https://www.mathworks.com/matlabcentral/fileexchange/29372-thresholding-an-image?s_tid=srchtitle
lowThreshold = 0.0;	% Set an initial guess.
highThreshold = 48;	% Set an initial guess.  (Depends on neighborhood size used for stdfilt().)

% Put lines of threshold on the histogram.
xline(lowThreshold, 'Color', 'r', 'LineWidth', 2);
xline(highThreshold, 'Color', 'r', 'LineWidth', 2);

pupilImage = (grayImage >= lowThreshold) & (grayImage <= highThreshold);
% Display the image.
subplot(2, 2, 3);
imshow(pupilImage, []);
axis('on', 'image');
title('Binary (Thresholded) Image', 'FontSize', fontSize, 'Interpreter', 'None');
caption = sprintf('Binary Image Thresholded at %d.', highThreshold);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;
drawnow;

%--------------------------------------------------------------------------------------------------------
% Further clean up.
% Remove blobs touching edge of the image
% grayImage = imclearborder(grayImage);
% Take largest blob only.
pupilImage = bwareafilt(pupilImage, 1);
% Fill holes due to specular reflections.
pupilImage = imfill(pupilImage, 'holes');
subplot(2, 2, 4);
imshow(pupilImage, []);
axis('on', 'image');
title('Final Pupil Mask', 'FontSize', fontSize, 'Interpreter', 'None');
impixelinfo;

%--------------------------------------------------------------------------------------------------------
% Measure areas
props = regionprops(pupilImage, 'Area', 'Centroid');
pupilArea = props.Area; % A simple pixel ocount.
% Measure area an alternative way that takes into account the shape of the boundary of the pupil.
weightedArea = bwarea(pupilImage)
caption = sprintf('Final Pupil Mask.  The pupil area is %d pixels (or %.1f pixels)', pupilArea, weightedArea);
subplot(2, 2, 4);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%--------------------------------------------------------------------------------------------------------
% Plot the boundaries and center over the original image.
subplot(2, 2, 1);
boundaries = bwboundaries(pupilImage);
boundaries = boundaries{1};
x = boundaries(:, 2);
y = boundaries(:, 1);
hold on;
plot(x, y, 'r-', 'LineWidth', 2); % Plot outline (boundary)
xCenter = props.Centroid(1);
yCenter = props.Centroid(2);
plot(xCenter, yCenter, 'r+', 'LineWidth', 2, 'MarkerSize', 40); % Plot crosshairs at centroid
title('Original Image with Pupil Outlined in Red', 'FontSize', fontSize, 'Interpreter', 'None');

message = sprintf('The pupil area is %d pixels (or %.1f pixels)', pupilArea, weightedArea);
fprintf('%s\n', message);
message = sprintf('Done!\nThe pupil area is %d pixels (or %.1f pixels).', pupilArea, weightedArea);
uiwait(helpdlg(message));
 mm = ( pupilArea*0.206)
 c = mm/3.14
 k = sqrt(c)
 k/5

 