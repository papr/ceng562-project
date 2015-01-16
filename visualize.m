close all;
clear all;
clc;

loadtic = tic;
display('Loading trajectories...');
load('char-trajectories.mat');
loadtoc = toc(loadtic);
fprintf('Data loading took %d''%0.0f''''\n',floor(loadtoc/60),rem(loadtoc,60));

fs = 24; % font size

%%


s_idx = [12, 132, 211, 245, 323, 456, 507, 603, 682, 702,...
    772, 875, 929, 1000, 1024, 1092, 1160, 1230, 1330, 1391];

figure;
for i=1:20
    
    sample = mixout{1,s_idx(i)};
    
    subplot(4,5,i);
    plot3(sample(1,:),sample(2,:),sample(3,:));
    title(consts.key(i),'FontSize',fs-6,'FontWeight','normal');
    
end

%%

figure;
for i=1:20
    
    sample = mixout{1,s_idx(i)};
    
    subplot(4,5,i);
    plot(sample(1,:),sample(2,:));
    title(consts.key(i),'FontSize',fs-6,'FontWeight','normal');
    
end

%% 
close all;

figure;
i = 11;
sample = mixout{1,s_idx(i)};
subplot(1,2,1);
plot(sample(1,:),sample(2,:));
title('Two Dimensions','FontSize',fs);
xlabel('x','FontSize',fs);
ylabel('y','FontSize',fs);

subplot(1,2,2);
plot3(sample(1,:),sample(2,:),sample(3,:));
title('Three Dimensions','FontSize',fs);
xlabel('x','FontSize',fs);
ylabel('y','FontSize',fs);
zlabel('pen tip force','FontSize',fs);