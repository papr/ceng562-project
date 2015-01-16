function [ Y ] = esn(NoN,sparsity,u,EoTSidc)
%esn Trains and validates an Echo State Network
% NoN:      No of neurons                   scalar
% sparsity: How many connections should exist on average
% u:        Total Time Series               (No of features x time steps)
% EoTSidc:  Mask of Sub Time Series indices (1 x No of time step indices)
% Y:        Network time slices             (NoN x No of time step indices)

NoF = size(u,1); % No of features
NoS = size(u,2); % No of time steps: (No of timeseries) * (length of timeseries)
NoT = size(EoTSidc,2); % number of time series to store

% initialize weigths
% scaling of input and recurrent weights necessary to avoid self oscilating
% behavior
scale_W_in = .4;
scale_W  = .3;

W = zeros(NoN,NoN); % neurons x neurons
W_in = (2 * rand(NoN,NoF) - 1) * scale_W_in; % neurons x features
% W_out = 2 * rand(NoN,1) - 1; % neurons x 1, not necessary

% initialize sparse recurrent matrix
for i=1:NoN
    for j = 1:NoN
        if rand < sparsity
            W(i,j) = (2 * rand - 1) * scale_W;
        end
    end
end

% simulation
X = zeros(NoN,NoS); % X stores the network states
X(:,1) = 2*rand(NoN,1) -1; % start with a random state
Y = zeros(2*NoN,NoT); % store output of network state after each time series
ts_counter = 2;

for j = 2:NoS
    
    %     net    =    weigths    * old network state + input weights *    input
    % (neur x 1) = (neur x neur) *     (neur x 1)    + (neur x feat) * (feat x 1)
    net = W*X(:,j-1) + W_in*u(:,j);
    X(:,j) = tanh(net); % apply activation function
    
    switch j
        case EoTSidc(ts_counter) - 150
            Y(1+15*NoN:16*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 140
            Y(1+0*NoN:1*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 130
            Y(1+1*NoN:2*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 120
            Y(1+2*NoN:3*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 110
            Y(1+3*NoN:4*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 100
            Y(1+4*NoN:5*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 90
            Y(1+5*NoN:6*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 80
            Y(1+6*NoN:7*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 70
            Y(1+7*NoN:8*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 60
            Y(1+8*NoN:9*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 50
            Y(1+9*NoN:10*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 40
            Y(1+10*NoN:11*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 30
            Y(1+11*NoN:12*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 20
            Y(1+12*NoN:13*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter) - 10
            Y(1+13*NoN:14*NoN,ts_counter) = X(:,j);
        case EoTSidc(ts_counter)
            Y(1+14*NoN:15*NoN,ts_counter) = X(:,j);
            
            ts_counter = ts_counter + 1;
            X(:,j) = X(:,EoTSidc(1)); % reset to original state
        otherwise
    end    
end

% figure;
subplot(1,2,1)
imagesc(X);
colormap('gray');
subplot(1,2,2)
imagesc(Y);
colormap('gray');
drawnow
end

