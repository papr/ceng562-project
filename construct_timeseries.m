function [ u,EoTSidc,train_out,test_out,labels ] = ...
    construct_timeseries( mixout,charlabels,train_in,test_in )
%construct_timeseries Constructs TS values for esn()
% Input
%   mixout:     (1 x No of TS) cells, each TS (3 x time steps)
%   charlabels: (1 x No of TS) labels for each TS
%   train_in:   (No of TS x 1) Mask for training TS
%   test_in:    (No of TS x 1) Mask for test TS
% Output
%   u:        Total Time Series               (No of features x time steps)
%   EoTSidc:  Mask of Sub Time Series indices (1 x No of time step indices)
%   train_out:Training index mask             (1 x No of time step indices)
%   test_out: Test index mask                 (1 x No of time step indices)
%   labels:   Labels for Sub Time Series      (1 x No of time step indices)

NoF = 3; % number of features
ts_repeat = 1; % repeat short time series to avoid overlapping memory
warmup_l = 100;

train_cells = mixout(1,train_in);
train_labels = charlabels(train_in);
[train_ts_l, train_min, train_max] = ts_attr(train_cells);

test_cells = mixout(1,test_in);
test_labels = charlabels(test_in);
[test_ts_l, test_min, test_max] = ts_attr(test_cells);

u = zeros(NoF,ts_repeat*(warmup_l+train_ts_l+test_ts_l));
EoTSidc = zeros(1,1+sum(train_in)+sum(test_in));
train_out = logical(zeros(size(EoTSidc)));
test_out  = logical(zeros(size(EoTSidc)));
labels    = zeros(size(EoTSidc));

u_idx = 0; % u column index
EoTS_idx = 1; % end of time column index

a = min(train_min,test_min);
b = max(train_max,test_max);
u(:,u_idx+1:u_idx+(ts_repeat*warmup_l)) = a + (b-a).*rand(NoF,ts_repeat*warmup_l);

u_idx = u_idx + (ts_repeat*warmup_l);
EoTSidc(EoTS_idx) = u_idx; % set reset index
EoTS_idx = EoTS_idx + 1;

for cell_i=1:size(train_cells,2)
    cell_val = train_cells{1,cell_i};
    cell_val = cell_val( :, all(cell_val,1) ); % remove zero columns
    cell_val = repmat(cell_val,[1 ts_repeat]); % repeat TS 'ts_repeat' times
    u(:,u_idx + 1:u_idx + size(cell_val,2)) = cell_val; % copy
    u_idx = u_idx + size(cell_val,2); % set new index
    
    EoTSidc(EoTS_idx) = u_idx;
    train_out(EoTS_idx) = true;
    labels(EoTS_idx) = train_labels(cell_i);
    
    EoTS_idx = EoTS_idx + 1;
end
for cell_i=1:size(test_cells,2)
    cell_val = test_cells{1,cell_i};
    cell_val = cell_val( :, all(cell_val,1) ); % remove zero columns
    cell_val = repmat(cell_val,[1 ts_repeat]); % repeat TS 'ts_repeat' times
    u(:,u_idx+1:u_idx+size(cell_val,2)) = cell_val; % copy
    u_idx = u_idx + size(cell_val,2); % set new index
    
    EoTSidc(EoTS_idx) = u_idx;
    test_out(EoTS_idx) = true;
    labels(EoTS_idx) = test_labels(cell_i);
    
    EoTS_idx = EoTS_idx + 1;
end

end

