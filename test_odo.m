
% definition of X range of the image for odometry
global IMAGE_TRANSLATIONAL_VELOCITY_Y_RANGE;
global IMAGE_ROTATIONAL_VELOCITY_Y_RANGE;
global IMAGE_ODOMETRY_X_RANGE;


% set up the values of image range
IMAGE_ROTATIONAL_VELOCITY_Y_RANGE = 300:700;
IMAGE_TRANSLATIONAL_VELOCITY_Y_RANGE = 30:280;
IMAGE_ODOMETRY_X_RANGE = 200:1000;


global VISUAL_ODOMETRY_SHIFT_MATCH;

% initial the visual odometry shift match
VISUAL_ODOMETRY_SHIFT_MATCH = 400;

global TRANSLATIONAL_VELOCITY_SCALE;

% initial the translational velocity scale
TRANSLATIONAL_VELOCITY_SCALE = 100;

global FIELD_OF_VIEW_DEGREE;

% initial the field of view degree
FIELD_OF_VIEW_DEGREE = 61;

global MAXIMUM_VELOCITY_THRESHOLD;

% initial the maximum velocity threshold
MAXIMUM_VELOCITY_THRESHOLD = 3;

global PREVIOUS_ROTATIONAL_VELOCITY_IMAGE_X_SUMS;
global PREVIOUS_TRANSLATIONAL_VELOCITY_IMAGE_X_SUMS;

PREVIOUS_ROTATIONAL_VELOCITY_IMAGE_X_SUMS = zeros(1, size(IMAGE_ODOMETRY_X_RANGE, 2));
PREVIOUS_TRANSLATIONAL_VELOCITY_IMAGE_X_SUMS = zeros(1, size(IMAGE_ODOMETRY_X_RANGE, 2));

% read the visual data
fileName = 'C:\RatSLAM-Dataset\lab_rotation.mp4';

video = VideoReader (fileName);
video_length= video.NumberOfFrames;

frames= read(video,[1 video_length]);
movie = immovie(frames);

% define and initialize some vector 
rotational_velocity_vector = zeros(1, video_length);
translational_velocity_vector = zeros(1, video_length);
rotational_angle__sum_vector = zeros(1, video_length);

% define a variable of sum of rotational angle
rotational_angle_sum = 0;

% processing the visual odometry, and get the rotational velocity,
% rotational angle, translational velocity

for i=1:video_length
    
    im = rgb2gray(movie(i).cdata);
    
    [translational_velocity, rotational_velocity] = visual_odometry(im);
    
    rotational_velocity_vector(i) = rotational_velocity;
    translational_velocity_vector(i) = translational_velocity;
    
    sub_rotational_velocity_vector = rotational_velocity_vector(:,1:i) ;
    sub_translational_velocity_vector = translational_velocity_vector(:,1:i);
    
    rotational_angle_sum = rotational_angle_sum + rotational_velocity;
    
    rotational_angle__sum_vector(i) = rotational_angle_sum * (180/pi);
    sub_rotational_angle__sum_vector = rotational_angle__sum_vector(:,1:i);
    
    subplot(2, 3, 1, 'replace');
    imshow(movie(i).cdata);
    title('Raw Images');
    
    
    subplot(2, 3, 4, 'replace');
    imshow(im);
    title('Gray Images');
    
    
    subplot(2, 3, 2, 'replace');
    plot(sub_rotational_velocity_vector);
    title('Rotational Velocity');
    
    
    subplot(2, 3, 5, 'replace');
    plot(sub_translational_velocity_vector);
    title('Translational Velocity');
    
    subplot(2, 3, 3, 'replace');
    plot(sub_rotational_angle__sum_vector);
    title('Rotational Angle');
    drawnow;
    
    i=i+1;
  
end
