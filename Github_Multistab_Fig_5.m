%% to reproduce Fig. 5 in [ref] you will require a pre-simulated data set which can be found here: [x]
% Load data
clear;

load ('multistabData_Fig5');


%% Filter the time series, calculate PLV and correlations using a rolling window of length tau
% Discards first 300,000 time steps

tau = 10000;
fs = 1000;

filtE(1,:) = bandpass(E(1,300000:end),[ITR-5 ITR+5],fs);
filtE(2,:) = bandpass(E(2,300000:end),[ITR-5 ITR+5],fs);

newE = E(:,300000:end);
newK = track_k(300000:end);

for t=1:length(newE)-tau
    t
    sig1 = newE(1,t:t+tau);
    sig2 = newE(2,t:t+tau);
    
    hilb1 = hilbert(filtE(1,t:t+tau));
    hilb2 = hilbert(filtE(2,t:t+tau));
    
    ang1 = angle(hilb1);
    ang2 = angle(hilb2);
    
    pvDat(t) = abs(sum(exp(1i * (ang1 - ang2)))) / length(sig1);
    multcrDat(t)=mean(sig1.*sig2.*heaviside(sig1.*sig2-hnew));
    meank(t) = mean(newK(t:t+tau));
end


%% Fig 5A - PLV vs mean weight
c1 = [0.24 0.43 0.71];
c2 = [0.84 0.25 0.31];

fig = figure(50);
set(fig,'defaultAxesColorOrder',[c1; c2]);
set(gcf, 'Position',  [300, 300, 1000, 300])
yyaxis left
hold on;
    plot(multcrDat,'LineWidth',2,'Color',c1);
    plot(meank,'LineWidth',2,'Color',c1); ylabel('<w>');
hold off;
yyaxis right
plot(pvDat,'LineWidth',2,'Color',c2); xlim([0 length(multcrDat)]); ylabel('PLV')
set(gca,'FontSize',16); 




%% Fig 5B-D phase plots and timecourses

lowStart = 370000;
medStart = 650000;
highStart = 684456+17000;
dur = 1000;

figure(8); set(gcf, 'Position',  [50, 50, 1200, 900])
subplot(231); plot(E(1,lowStart:lowStart+dur),E(2,lowStart:lowStart+dur),'LineWidth',2,'Color',c1); xlabel('E_1'); ylabel('E_2'); set(gca,'FontSize',16); xlim([0 0.8]); ylim([0 0.8]);
subplot(232); plot(E(1,medStart:medStart+dur),E(2,medStart:medStart+dur),'LineWidth',2,'Color',c1); xlabel('E_1'); ylabel('E_2'); set(gca,'FontSize',16); xlim([0 0.8]); ylim([0 0.8]);
subplot(233); plot(E(1,highStart:highStart+dur),E(2,highStart:highStart+dur),'LineWidth',2,'Color',c1); xlabel('E_1'); ylabel('E_2'); set(gca,'FontSize',16); xlim([0 0.8]); ylim([0 0.8]);

subplot(234); plot(E(1,lowStart:lowStart+dur),'LineWidth',1.5,'Color',c1); hold on; plot(E(2,lowStart:lowStart+dur),'LineWidth',1.5,'Color',c2); xlabel('time (ms)'); ylim([0 0.8]); set(gca,'FontSize',16);
subplot(235); plot(E(1,medStart:medStart+dur),'LineWidth',1.5,'Color',c1); hold on; plot(E(2,medStart:medStart+dur),'LineWidth',1.5,'Color',c2); xlabel('time (ms)'); ylim([0 0.8]); set(gca,'FontSize',16);
subplot(236); plot(E(1,highStart:highStart+dur),'LineWidth',1.5,'Color',c1); hold on; plot(E(2,highStart:highStart+dur),'LineWidth',1.5,'Color',c2); xlabel('time (ms)'); ylim([0 0.8]); set(gca,'FontSize',16);






























