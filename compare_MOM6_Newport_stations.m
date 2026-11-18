% Script used to compare the 2 Newport stations with NEP10k temp, salt, oxygen

% Created by DJP 10/26

close all
clear

years = 1997:2025; 

OBS_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/obs/Newport_Hydrographic_Line_Data_1997_2021/';
MODEL_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/northeast_pacific/hindcast/monthly/r20250912';

Oxyratio = 1.025 * (10^6) * .02241; %mol/kg O2 to ml/l

% Load Newport Hydrography Data
% NH05 is at 50m, NH25 is at 150m
tmp = readmatrix([OBS_DIR,'/temperature_data_NH051997_to_2026.csv'],'NumHeaderLines',1);
NH05.temp = tmp(:,2); clear tmp
tmp = readmatrix([OBS_DIR,'/temperature_data_NH251997_to_2026.csv'],'NumHeaderLines',1);
NH25.temp = tmp(:,2); clear tmp

tmp = readmatrix([OBS_DIR,'/oxygen_data_NH051997_to_2026.csv'],'NumHeaderLines',1);
NH05.oxy = tmp(:,2); clear tmp
tmp = readmatrix([OBS_DIR,'/oxygen_data_NH251997_to_2026.csv'],'NumHeaderLines',1);
NH25.oxy = tmp(:,2); clear tmp

tmp = readmatrix([OBS_DIR,'/arag_NH05.csv'],'NumHeaderLines',2,'Delimiter',',');
NH05.arag = tmp(:,2); clear tmp
tmp = readmatrix([OBS_DIR,'/arag_NH25.csv'],'NumHeaderLines',2,'Delimiter',',');
NH25.arag = tmp(:,2); clear tmp

tmp = readmatrix([OBS_DIR,'/temperature_data_NH051997_to_2026.csv'],'OutputType','string','NumHeaderLines',1);
NH05.time = datetime(tmp(:,1),'InputFormat','yyyy-MM-dd'); clear tmp
tmp = readmatrix([OBS_DIR,'/temperature_data_NH251997_to_2026.csv'],'OutputType','string','NumHeaderLines',1);
NH25.time = datetime(tmp(:,1),'InputFormat','yyyy-MM-dd'); clear tmp

a = datetime(1998,8,15); b = datetime(2025,12,15);
t1 = a:calmonths(1):b;
NH05.time_arag = datetime(t1,'Format','yyyy-MM-dd'); clear a b t1
NH25.time_arag = NH05.time_arag;

% Load Model output
model_NH05.temp = squeeze(ncread([MODEL_DIR,'/thetao.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'thetao',[253 323 1 1],[1 1 Inf Inf]));
model_NH25.temp = squeeze(ncread([MODEL_DIR,'/thetao.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'thetao',[249 325 1 1],[1 1 Inf Inf]));
model_NH05.oxy = squeeze(ncread([MODEL_DIR,'/o2.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'o2',[253 323 1 1],[1 1 Inf Inf])) * Oxyratio;
model_NH25.oxy = squeeze(ncread([MODEL_DIR,'/o2.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'o2',[249 325 1 1],[1 1 Inf Inf])) * Oxyratio;
model_NH05.arag = squeeze(ncread([MODEL_DIR,'/omega_arag.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'omega_arag',[253 323 1 1],[1 1 Inf Inf]));
model_NH25.arag = squeeze(ncread([MODEL_DIR,'/omega_arag.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'omega_arag',[249 325 1 1],[1 1 Inf Inf]));
model.z = ncread([MODEL_DIR,'/so.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'z_l');
% model.lat = ncread([MODEL_DIR,'/ocean_static.nc'],'geolat',[200 200],[100 200]);
% model.lon = ncread([MODEL_DIR,'/ocean_static.nc'],'geolon',[200 200],[100 200]);
model.time = ncread([MODEL_DIR,'/so.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'time');
model.time = model.time + datenum('01/01/1993','mm/dd/yyyy'); model.time = datetime(model.time,'ConvertFrom','datenum');

% Example code for finding closest model grid points to NH05 and NH25
% This gives point 253,323 for NH05 and 249,325 for NH25
% [xrho, yrho, zrho] = geodetic2enu(model.lat, model.lon, 0, nanmean(nanmean(model.lat)), nanmean(nanmean(model.lon)), 0, referenceEllipsoid('earth'));
% [xobs, yobs, zobs] = geodetic2enu(44.7, 360-124.7, 0, nanmean(nanmean(model.lat)), nanmean(nanmean(model.lon)), 0, referenceEllipsoid('earth'));
% 
% [d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);
% 
% % Convert to subscript indicies
% [rowmin,colmin] = ind2sub([342 816],imin);


% Nearest Neighbor approach
% Closest depth levels are z = 9 (42.5m) for NH05 and z = 20 (145m) for NH25
model_NH05.temp = model_NH05.temp(9,:)';
model_NH05.oxy = model_NH05.oxy(9,:)';
model_NH05.arag = model_NH05.arag(9,:)';

% Try interpolating NH25 (can't interpolate NH05 becuase deepest z-level is
% already less than 50m)
model_NH25.temp = interp1(model.z,model_NH25.temp,150);
model_NH25.oxy = interp1(model.z,model_NH25.oxy,150);
model_NH25.arag = interp1(model.z,model_NH25.arag,150);

% Interpolate model output to time sampling of Newport Line
model_NH05.temp_interp = interp1(model.time,model_NH05.temp,NH05.time,'linear');
model_NH25.temp_interp = interp1(model.time,model_NH25.temp,NH25.time,'linear');
model_NH05.oxy_interp = interp1(model.time,model_NH05.oxy,NH05.time,'linear');
model_NH25.oxy_interp = interp1(model.time,model_NH25.oxy,NH25.time,'linear');
model_NH05.arag_interp = interp1(model.time,model_NH05.arag,NH05.time_arag,'linear')';
model_NH25.arag_interp = interp1(model.time,model_NH25.arag,NH25.time_arag,'linear')';

% Compute some stats with the temporally interpolated output
model_NH05.temp_R = corrcoef(model_NH05.temp_interp,NH05.temp,'rows','complete');
model_NH05.temp_bias = nanmean(model_NH05.temp_interp) - nanmean(NH05.temp);
model_NH05.temp_RMSE = sqrt(nanmean((model_NH05.temp_interp - NH05.temp).^2));

model_NH25.temp_R = corrcoef(model_NH25.temp_interp,NH25.temp,'rows','complete');
model_NH25.temp_bias = nanmean(model_NH25.temp_interp) - nanmean(NH25.temp);
model_NH25.temp_RMSE = sqrt(nanmean((model_NH25.temp_interp - NH25.temp).^2));

model_NH05.oxy_R = corrcoef(model_NH05.oxy_interp,NH05.oxy,'rows','complete');
model_NH05.oxy_bias = nanmean(model_NH05.oxy_interp) - nanmean(NH05.oxy);
model_NH05.oxy_RMSE = sqrt(nanmean((model_NH05.oxy_interp - NH05.oxy).^2));

model_NH25.oxy_R = corrcoef(model_NH25.oxy_interp,NH25.oxy,'rows','complete');
model_NH25.oxy_bias = nanmean(model_NH25.oxy_interp) - nanmean(NH25.oxy);
model_NH25.oxy_RMSE = sqrt(nanmean((model_NH25.oxy_interp - NH25.oxy).^2));

model_NH05.arag_R = corrcoef(model_NH05.arag_interp,NH05.arag,'rows','complete');
model_NH05.arag_bias = nanmean(model_NH05.arag_interp) - nanmean(NH05.arag);
model_NH05.arag_RMSE = sqrt(nanmean((model_NH05.arag_interp - NH05.arag).^2));

model_NH25.arag_R = corrcoef(model_NH25.arag_interp,NH25.arag,'rows','complete');
model_NH25.arag_bias = nanmean(model_NH25.arag_interp) - nanmean(NH25.arag);
model_NH25.arag_RMSE = sqrt(nanmean((model_NH25.arag_interp - NH25.arag).^2));

% Calculate monthly climatologies
for m = 1:12
    NH05.temp_mon(m) = monthly(NH05.temp,NH05.time,m,'omitnan');
    NH25.temp_mon(m) = monthly(NH25.temp,NH25.time,m,'omitnan');
    NH05.oxy_mon(m) = monthly(NH05.oxy,NH05.time,m,'omitnan');
    NH25.oxy_mon(m) = monthly(NH25.oxy,NH25.time,m,'omitnan');
    NH05.arag_mon(m) = monthly(NH05.arag,NH05.time_arag,m,'omitnan');
    NH25.arag_mon(m) = monthly(NH25.arag,NH25.time_arag,m,'omitnan');

    model_NH05.temp_mon(m) = monthly(model_NH05.temp,model.time,m);
    model_NH25.temp_mon(m) = monthly(model_NH25.temp,model.time,m);
    model_NH05.oxy_mon(m) = monthly(model_NH05.oxy,model.time,m);
    model_NH25.oxy_mon(m) = monthly(model_NH25.oxy,model.time,m);
    model_NH05.arag_mon(m) = monthly(model_NH05.arag,model.time,m);
    model_NH25.arag_mon(m) = monthly(model_NH25.arag,model.time,m);

    NH05.temp_mon_std(m) = monthly(NH05.temp,NH05.time,m,@std,'omitnan');
    NH25.temp_mon_std(m) = monthly(NH25.temp,NH25.time,m,@std,'omitnan');
    NH05.oxy_mon_std(m) = monthly(NH05.oxy,NH05.time,m,@std,'omitnan');
    NH25.oxy_mon_std(m) = monthly(NH25.oxy,NH25.time,m,@std,'omitnan');
    NH05.arag_mon_std(m) = monthly(NH05.arag,NH05.time_arag,m,@std,'omitnan');
    NH25.arag_mon_std(m) = monthly(NH25.arag,NH25.time_arag,m,@std,'omitnan');

    model_NH05.temp_mon_std(m) = monthly(model_NH05.temp,model.time,m,@std);
    model_NH25.temp_mon_std(m) = monthly(model_NH25.temp,model.time,m,@std);
    model_NH05.oxy_mon_std(m) = monthly(model_NH05.oxy,model.time,m,@std);
    model_NH25.oxy_mon_std(m) = monthly(model_NH25.oxy,model.time,m,@std);
    model_NH05.arag_mon_std(m) = monthly(model_NH05.arag,model.time,m,@std);
    model_NH25.arag_mon_std(m) = monthly(model_NH25.arag,model.time,m,@std);
end


%% 

% Plot figures

% Temperature
figure(1); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time,NH05.temp,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH05.temp,'b','Linewidth',1.3)
xlim([datetime(1997,1,1) datetime(2026,1,1)])
ylabel('Temp ({\circ}C)')
title('NH05 50m Temperature','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time,NH25.temp,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH25.temp,'b','Linewidth',1.3)
xlim([datetime(1997,1,1) datetime(2026,1,1)])
title('NH25 150m Temperature','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('Temp ({\circ}C)')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/temp_stations_timeseries.jpg','Resolution',300);

figure(2); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time,NH05.temp,'k','Linewidth',1.3)
hold on
plot(NH05.time,model_NH05.temp_interp,'b','Linewidth',1.3)
xlim([datetime(1997,1,1) datetime(2026,1,1)])
ylabel('Temp ({\circ}C)')
title('NH05 50m Temperature','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time,NH25.temp,'k','Linewidth',1.3)
hold on
plot(NH25.time,model_NH25.temp_interp,'b','Linewidth',1.3)
xlim([datetime(1997,1,1) datetime(2026,1,1)])
title('NH25 150m Temperature','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('Temp ({\circ}C)')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/temp_stations_timeseries_interp.jpg','Resolution',300);

% Oxygen - note that constraining the x-axis to start in 2005 since data
% prior to that are pretty spotty and not particularily useful to visualize
% in this timeseries

figure(3); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time,NH05.oxy,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH05.oxy,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
ylabel('Oxygen (ml/l)')
title('NH05 50m Oxygen','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time,NH25.oxy,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH25.oxy,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
title('NH25 150m Oxygen','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('Oxygen (ml/l)')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/oxy_stations_timeseries.jpg','Resolution',300);

figure(4); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time,NH05.oxy,'k','Linewidth',1.3)
hold on
plot(NH05.time,model_NH05.oxy_interp,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
ylabel('Oxygen (ml/l)')
title('NH05 50m Oxygen','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time,NH25.oxy,'k','Linewidth',1.3)
hold on
plot(NH25.time,model_NH25.oxy_interp,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
title('NH25 150m Oxygen','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('Oxygen (ml/l)')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/oxy_stations_timeseries_interp.jpg','Resolution',300);

% Omega Arag - note that constraining the x-axis to start in 2005 since data
% prior to that are pretty spotty and not particularily useful to visualize
% in this timeseries

figure(5); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time_arag,NH05.arag,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH05.arag,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
ylabel('{\Omega}_{arag}')
title('NH05 50m {\Omega}_{arag}','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time_arag,NH25.arag,'k','Linewidth',1.3)
hold on
plot(model.time,model_NH25.arag,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
title('NH25 150m {\Omega}_{arag}','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('{\Omega}_{arag}')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/arag_stations_timeseries.jpg','Resolution',300);

figure(6); set(gcf, 'units','centimeters','position',[20 20 21 17]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(NH05.time_arag,NH05.arag,'k','Linewidth',1.3)
hold on
plot(NH05.time_arag,model_NH05.arag_interp,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
ylabel('{\Omega}_{arag}')
title('NH05 50m {\Omega}_{arag}','FontSize',16)
legend('Obs','Model','Location','northeast','Fontsize',12)

subplot(2,1,2)
plot(NH25.time_arag,NH25.arag,'k','Linewidth',1.3)
hold on
plot(NH25.time_arag,model_NH25.arag_interp,'b','Linewidth',1.3)
xlim([datetime(2005,1,1) datetime(2026,1,1)])
title('NH25 150m {\Omega}_{arag}','FontSize',16)
xlabel('Year','FontSize',14)
ylabel('{\Omega}_{arag}')

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/arag_stations_timeseries_interp.jpg','Resolution',300);

figure(7); set(gcf, 'units','centimeters','position',[20 20 25 23]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(1:12,NH05.temp_mon,NH05.temp_mon_std,'ko-','LineWidth',1.2);
hold on
shadedErrorBar(1:12,model_NH05.temp_mon,model_NH05.temp_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('Temp ({\circ}C)','FontSize',14)
title('NH05 Monthly Temperature','FontSize',14)

subplot(3,2,2)
errorbar(1:12,NH25.temp_mon,NH25.temp_mon_std,'ko-','LineWidth',1.2);
hold on
shadedErrorBar(1:12,model_NH25.temp_mon,model_NH25.temp_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('Temp ({\circ}C)','FontSize',14)
title('NH25 Monthly Temperature','FontSize',14)

subplot(3,2,3)
errorbar(1:12,NH05.oxy_mon,NH05.oxy_mon_std,'ko-','LineWidth',1.2);
hold on
shadedErrorBar(1:12,model_NH05.oxy_mon,model_NH05.oxy_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('Oxygen (ml/l)','FontSize',14)
title('NH05 Monthly Oxygen','FontSize',14)

subplot(3,2,4)
p1 = errorbar(1:12,NH25.oxy_mon,NH25.oxy_mon_std,'ko-','LineWidth',1.2);
hold on
p2 = shadedErrorBar(1:12,model_NH25.oxy_mon,model_NH25.oxy_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('Oxygen (ml/l)','FontSize',14)
title('NH25 Monthly Oxygen','FontSize',14)

subplot(3,2,5)
errorbar(1:12,NH05.arag_mon,NH05.arag_mon_std,'ko-','LineWidth',1.2);
hold on
shadedErrorBar(1:12,model_NH05.arag_mon,model_NH05.arag_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('{\Omega}_{arag}','FontSize',14)
xlabel('Month','FontSize',14)
title('NH25 Monthly {\Omega}_{arag}','FontSize',14)

subplot(3,2,6)
errorbar(1:12,NH25.arag_mon,NH25.arag_mon_std,'ko-','LineWidth',1.2);
hold on
shadedErrorBar(1:12,model_NH25.arag_mon,model_NH25.arag_mon_std,{'bo-','LineWidth',1.2},1);
xlim([0.5 12.5]); xticks(1:12); ylabel('{\Omega}_{arag}','FontSize',14)
xlabel('Month','FontSize',14)
title('NH25 Monthly {\Omega}_{arag}','FontSize',14)
lx = legend([p1,p2.mainLine],'Obs','Model','Fontsize',14,'Position',[.465 .001 .1 .1],'Orientation','horizontal');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/Newport_line/3vars_stations_mon_clim.jpg','Resolution',300);
