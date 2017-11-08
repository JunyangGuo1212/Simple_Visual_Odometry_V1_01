function [out_minimum_offset, out_minimum_difference_intensity] = compare_segments(seg1, seg2, shift_length, compare_length_of_intensity)

% input parameters
% seg1, seg2 represent 1D arrays of the intensity profiles of the current image and previous image.
% shift_length is the range of offsets in pixels to consider i.e. slen = 0 considers only the no offset case
% compare_length_of_intensity is the length of the intensity profile to actually compare, and must be < than image width – 1 * slen

% output parameters
% minimum_offset  the minimum shift offset when the difference of intensity
% is smaller
% minimum_difference_intensity the minimum of intensity profile

% assume a large difference
minimum_difference_intensity = 1e6;

% initial the matrix
differencs = zeros(shift_length);

% compare two 1 row*N column matrix 
% for each offset sum the abs difference between the two segments
for offset = 0:shift_length
    compare_difference_segments = abs(seg1(1 + offset:compare_length_of_intensity) - seg2(1:compare_length_of_intensity - offset));
    compare_difference_segments = sum(compare_difference_segments) / (compare_length_of_intensity - offset);
    differencs(shift_length - offset + 1) = compare_difference_segments;
    if (compare_difference_segments < minimum_difference_intensity)
        minimum_difference_intensity = compare_difference_segments;
        minimum_offset = offset;
    end
end

for offset = 1:shift_length
    compare_difference_segments = abs(seg1(1:compare_length_of_intensity - offset) - seg2(1 + offset:compare_length_of_intensity));
    compare_difference_segments = sum(compare_difference_segments) / (compare_length_of_intensity - offset);
    differencs(shift_length + 1 + offset) = compare_difference_segments;
    if (compare_difference_segments < minimum_difference_intensity)
        minimum_difference_intensity = compare_difference_segments;
        minimum_offset = -offset;
    end
end

out_minimum_offset = minimum_offset;
out_minimum_difference_intensity = minimum_difference_intensity;

end



