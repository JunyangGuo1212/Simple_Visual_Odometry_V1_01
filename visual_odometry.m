function [translational_velocity, rotational_velocity] = visual_odometry(raw_image)
% A simple visual odometry with scanline intensity profile algorithm.
% the input is a raw image
% the output including vtransn (translational velocity(speed)) and vrot (rotational
% velocity (speed))


%%% start to set up the visual odometry 

% x_sums, sum each column of intensity in the current image and previous
% image perspectively.
% form a one dimensional vector, 1*N array
global PREVIOUS_ROTATIONAL_VELOCITY_IMAGE_X_SUMS;
global PREVIOUS_TRANSLATIONAL_VELOCITY_IMAGE_X_SUMS;


% There are three types images, e.g. A for image matching; B for rotation
% relocity; C for translational velocity; and width of the B and C is same. 
% the upper image is for rotational velociy;
% the lower ground image is for translational velociy.

% definition the Y range of images for odomentry, including image for
% translational velocity and image for rotational velocity
global IMAGE_TRANSLATIONAL_VELOCITY_Y_RANGE;
global IMAGE_ROTATIONAL_VELOCITY_Y_RANGE;

% definition of X range of the image for odometry
global IMAGE_ODOMETRY_X_RANGE;

% define the scale of translational velocity 
global TRANSLATIONAL_VELOCITY_SCALE;

% define the veriable for visual odometry shift match
global VISUAL_ODOMETRY_SHIFT_MATCH;

% define the degree of the field of view
% Field of View (FOV), Degree (DEG) the horizontal, vertical, and diagonal
% degrees for all FOVs
global FIELD_OF_VIEW_DEGREE;

% computing the angle degree per pixel of column
% size (x,n) if n==1, return num of rows, if n==2, return num of column
degree_per_pixel = FIELD_OF_VIEW_DEGREE / size(raw_image, 2);

%%% End up for setting up the visual odometry 


%%% start to compute the translational velocity

% principle
% speeds are estimates based on the rate of image change. 
% the speed measure v is obtained from the filtered average absolute
% intensity difference between consecutive scanline intensity profiles at
% the best match for rotation

% get the sub_image for translational velocity from raw image with range constrait

sub_image = raw_image(IMAGE_TRANSLATIONAL_VELOCITY_Y_RANGE, IMAGE_ODOMETRY_X_RANGE); 


% get the x_sum of average sum intensity values in every column of image

% sum(x) sum of every column
% sum(x,2) sum of every row
% sum(x(:)) sum of matrix
% image_x_sums  is a 1 row* N Column  
% size(image_x_sums, 2) the number of Columns

image_x_sums = sum(sub_image);
average_intensity = sum(image_x_sums) / size(image_x_sums, 2);
image_x_sums = image_x_sums / average_intensity; 


% compare the current image with the previous image
% get the minimum offset and minimum difference of intensity between two images 
% 
% function [offset, sdif] = compare_segments(seg1, seg2, shift_length, compare_length_of_intensity)
% seg1, seg2 represent 1D arrays of the intensity profiles of the current image and previous image.
% shift_length is the range of offsets in pixels to consider i.e. slen = 0 considers only the no offset case
% compare_length_of_intensity is the length of the intensity profile to actually compare, and must be < than image width – 1 * slen

[minimum_offset, minimum_difference_intensity] = compare_segments(image_x_sums, PREVIOUS_TRANSLATIONAL_VELOCITY_IMAGE_X_SUMS, VISUAL_ODOMETRY_SHIFT_MATCH, size(image_x_sums, 2));


% covert the perceptual speed into a physical speed with an empirically
% determined constant TRANSLATIONAL_VELOCITY_SCALE
translational_velocity = minimum_difference_intensity * TRANSLATIONAL_VELOCITY_SCALE;


% to detect excessively large translational velocity
% the threshold Vmax ensured that spuriously high image differences were
% not used. Large image differences could be caused by sudden illumination
% changes such as when travelling uphill facing directly into the sun.

% define a maximum velocity threshold according to the average motion speed

global MAXIMUM_VELOCITY_THRESHOLD;

if translational_velocity > MAXIMUM_VELOCITY_THRESHOLD
    translational_velocity = 0;
end

PREVIOUS_TRANSLATIONAL_VELOCITY_IMAGE_X_SUMS = image_x_sums;

%%% end up to compute the translational velocity



%%% start to compute the rotational velocity

% get the sub_image for rotational velocity from raw image with range constrait
sub_image = raw_image(IMAGE_ROTATIONAL_VELOCITY_Y_RANGE, IMAGE_ODOMETRY_X_RANGE);


% get the x_sum of average sum intensity values in every column of image
image_x_sums = sum(sub_image);
average_intensity = sum(image_x_sums) / size(image_x_sums, 2);
image_x_sums = image_x_sums/average_intensity;

% compare the current image with the previous image
% get the minimum offset and minimum difference of intensity between two images 
[minimum_offset, minimum_difference_intensity] = compare_segments(image_x_sums, PREVIOUS_ROTATIONAL_VELOCITY_IMAGE_X_SUMS, VISUAL_ODOMETRY_SHIFT_MATCH, size(image_x_sums, 2));  

rotational_velocity = minimum_offset * degree_per_pixel * pi / 180;

PREVIOUS_ROTATIONAL_VELOCITY_IMAGE_X_SUMS = image_x_sums;

%%% end up to compute the translational velocity

end

