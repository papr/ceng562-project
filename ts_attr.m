function [ timesteps min_v max_v ] = ts_attr(cell_array)
%total_ts_length Sums the 2nd dimension size of each cell

timesteps = 0;
min_v =  inf;
max_v = -inf;
c_l = size(cell_array,2);
for i=1:c_l
    cell = cell_array{i};
    cell = cell( :, all(cell,1) );
    cell_size = size(cell,2);
    timesteps = timesteps + cell_size;
    min_v = min(min_v, min(cell(:)));
    max_v = max(max_v, max(cell(:)));
end

