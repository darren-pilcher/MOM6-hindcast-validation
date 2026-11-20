% Script used to compare MOM6 output to Sharp et al., 2024 product of 
% arag, pH, and pCO2
% Note, because this script uses post-processed output, need to re-run for
% updated model output

% Created by DJP 12/24

close all
clear

OBS_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/obs/sharp_2024';
MODEL_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/northeast_pacific/hindcast/monthly/r20250912';

% Overlapping years
years = [1998:2022];

% Overlapping timeframe between obs and model
olp_start = datetime(years(1),1,1);
olp_end = datetime(years(end),12,31,23,59,59);

obs.pH = ncread([OBS_DIR,'/US_RFR_LME_pH.nc'],'ph');
obs.pco2 = ncread([OBS_DIR,'/US_RFR_LME_pCO2.nc'],'pco2');
obs.arag = ncread([OBS_DIR,'/US_RFR_LME_OmA.nc'],'om_a');
obs.lat = ncread([OBS_DIR,'/US_RFR_LME_pH.nc'],'lat');
obs.lon = ncread([OBS_DIR,'/US_RFR_LME_pH.nc'],'lon');
obs.time = ncread([OBS_DIR,'/US_RFR_LME_pH.nc'],'time');
obs.lme = ncread([OBS_DIR,'/US_RFR_LME_pH.nc'],'lme_num');

[obs.lon,obs.lat] = meshgrid(obs.lon,obs.lat);

% Grab masks
mask_CC = obs.lme == 1;
mask_Bering = obs.lme == 4;

% Convert time format
obs.time = datetime(obs.time,'ConvertFrom','datenum');

% Load MOM6 model output
model.pH = ncread([MODEL_DIR,'/phos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'phos');
model.pco2 = ncread([MODEL_DIR,'/pco2surf.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'pco2surf');
model.arag_sol = ncread([MODEL_DIR,'/sfc_co3_sol_arag.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'sfc_co3_sol_arag');
model.co3 = ncread([MODEL_DIR,'/sfc_co3_ion.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'sfc_co3_ion');
model.time = ncread([MODEL_DIR,'/phos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'time');
model.lat = ncread([MODEL_DIR,'/ocean_static.nc'],'geolat');
model.lon = ncread([MODEL_DIR,'/ocean_static.nc'],'geolon');

model.arag = model.co3 ./ model.arag_sol;

model.time = model.time + datenum('01/01/1993','mm/dd/yyyy');
model.time = datetime(model.time,'ConvertFrom','datenum');

% Constrain model and obs to same 1998-2022 timeframe
tmp_ind = isbetween(obs.time,olp_start,olp_end);
obs.pH = obs.pH(:,:,tmp_ind);
obs.arag = obs.arag(:,:,tmp_ind);
obs.pco2 = obs.pco2(:,:,tmp_ind);
obs.time = obs.time(tmp_ind);

tmp_ind = isbetween(model.time,olp_start,olp_end);
model.pH = model.pH(:,:,tmp_ind);
model.pco2 = model.pco2(:,:,tmp_ind);
model.arag = model.arag(:,:,tmp_ind);
model.time = model.time(tmp_ind);

% Nans for land in the default model lat/lon need to be removed for scatterdinterpolant
model.lat = inpaint_nans(model.lat);
model.lon = inpaint_nans(model.lon);

tmp_pH = squeeze(mean(model.pH,3));
tmp_pco2 = squeeze(mean(model.pco2,3));
tmp_arag = squeeze(mean(model.arag,3));
F = scatteredInterpolant(model.lon(:),model.lat(:),tmp_pH(:));
model.pH_regrid = F(obs.lon,obs.lat);

F = scatteredInterpolant(model.lon(:),model.lat(:),tmp_arag(:));
model.arag_regrid = F(obs.lon,obs.lat);

F = scatteredInterpolant(model.lon(:),model.lat(:),tmp_pco2(:));
model.pco2_regrid = F(obs.lon,obs.lat);

cmap = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'}); % pastel jet
cmap2 = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'}); % redblue

% Interpolate full model timeseries to obs grid to faciliate direct timeseries comparison

% This takes a while to run, so run once for each variable and save as postprocessed output
% for t = 1:size(model.pco2,3)
% 	tmp_pco2 = squeeze(model.pco2(:,:,t));
% 	F = scatteredInterpolant(model.lon(:),model.lat(:),tmp_pco2(:));
% 	pco2_sharp2024_regrid_full(:,:,t) = F(obs.lon,obs.lat);
% end

%save([MODEL_DIR,'/postprocessed/pco2_sharp2024_regrid_full.mat'],'pco2_sharp2024_regrid_full','-v7.3');

load([MODEL_DIR,'/postprocessed/pco2_sharp2024_regrid_full.mat']);
load([MODEL_DIR,'/postprocessed/arag_sharp2024_regrid_full.mat']);
load([MODEL_DIR,'/postprocessed/pH_sharp2024_regrid_full.mat']);

% Calculate annual averages for both obs and model
yr_start = datetime(years,1,01); yr_end = datetime(years,12,31,23,59,59);

for t = 1:length(years)
	tmp_ind = isbetween(obs.time,yr_start(t),yr_end(t));
	obs.pH_ann(:,:,t) = squeeze(nanmean(obs.pH(:,:,tmp_ind),3));
        obs.arag_ann(:,:,t) = squeeze(nanmean(obs.arag(:,:,tmp_ind),3));
        obs.pco2_ann(:,:,t) = squeeze(nanmean(obs.pco2(:,:,tmp_ind),3));

        tmp_ind = isbetween(model.time,yr_start(t),yr_end(t));
	model.pH_ann(:,:,t) = squeeze(nanmean(pH_sharp2024_regrid_full(:,:,tmp_ind),3));
	model.arag_ann(:,:,t) = squeeze(nanmean(arag_sharp2024_regrid_full(:,:,tmp_ind),3));
	model.pco2_ann(:,:,t) = squeeze(nanmean(pco2_sharp2024_regrid_full(:,:,tmp_ind),3));
end

model.pH_CC = local(pH_sharp2024_regrid_full,mask_CC','omitnan');
model.arag_CC = local(arag_sharp2024_regrid_full,mask_CC','omitnan');
model.pco2_CC = local(pco2_sharp2024_regrid_full,mask_CC','omitnan');

obs.pH_CC = local(obs.pH,mask_CC,'omitnan');
obs.arag_CC = local(obs.arag,mask_CC,'omitnan');
obs.pco2_CC = local(obs.pco2,mask_CC,'omitnan');

model.pH_ann_CC = local(model.pH_ann,mask_CC','omitnan');
model.arag_ann_CC = local(model.arag_ann,mask_CC','omitnan');
model.pco2_ann_CC = local(model.pco2_ann,mask_CC','omitnan');

obs.pH_ann_CC = local(obs.pH_ann,mask_CC,'omitnan');
obs.arag_ann_CC = local(obs.arag_ann,mask_CC,'omitnan');
obs.pco2_ann_CC = local(obs.pco2_ann,mask_CC,'omitnan');

model.pH_ann_Bering = local(model.pH_ann,mask_Bering','omitnan');
model.arag_ann_Bering = local(model.arag_ann,mask_Bering','omitnan');
model.pco2_ann_Bering = local(model.pco2_ann,mask_Bering','omitnan');

obs.pH_ann_Bering = local(obs.pH_ann,mask_Bering,'omitnan');
obs.arag_ann_Bering = local(obs.arag_ann,mask_Bering,'omitnan');
obs.pco2_ann_Bering = local(obs.pco2_ann,mask_Bering,'omitnan');
%% 

% Plot comparison figures
% California Current
figure(1); set(gcf, 'units','centimeters','position',[10 10 25 16]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,3,1);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.pH,3))',[7.9:.02:8.15]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([7.9 8.15])
colormap(ax(1),flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('RFR-LME Surface pH','Fontsize',14)

ax(2) = subplot(1,3,2);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.pH,3)),[7.9:.02:8.15]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([7.9 8.15])
colormap(ax(2),flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model Surface pH','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(1).Position(1) .1 .495 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[7.9:.05:8.15],'fontsize',12); ylabel(cb,'pH','fontsize',14);

ax(3) = subplot(1,3,3);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,model.pH_regrid - squeeze(nanmean(obs.pH,3))',[-.2:.02:.2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([-.2 .2])
colormap(ax(3),flipud(cmap2))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model - (RFR-LME)','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(3).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[-.2:.1:.2],'fontsize',12); ylabel(cb,'{\Delta}pH','fontsize',14);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/CA_current_pH_ann_spatial.jpg','Resolution',300);
%% 

figure(2); set(gcf, 'units','centimeters','position',[10 10 25 16]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,3,1);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.pco2,3))',[250:25:500]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([250 500])
colormap(ax(1),cmap)
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('RFR-LME Surface pCO_2','Fontsize',14)

ax(2) = subplot(1,3,2);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.pco2,3)),[250:25:500]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([250 500])
colormap(ax(2),cmap)
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model Surface pCO_2','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(1).Position(1) .1 .495 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[250:50:500],'fontsize',12); ylabel(cb,'pCO_2','fontsize',14);

ax(3) = subplot(1,3,3);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,model.pco2_regrid - squeeze(nanmean(obs.pco2,3))',[-150:15:150]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([-150 150])
set(cb,'ytick',[-150:50:150],'Fontsize',14)
ylabel(cb,'pCO2','Fontsize',14)
colormap(ax(3),cmap2)
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model - (RFR-LME)','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(3).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[-150:50:150],'fontsize',12); %ylabel(cb,'{\Delta}pCO2','fontsize',14);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/CA_current_pCO2_ann_spatial.jpg','Resolution',300);
%% 

figure(3); set(gcf, 'units','centimeters','position',[10 10 25 16]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,3,1);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.arag,3))',[1:.1:2.6]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([1 2.6])
colormap(ax(1),flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('RFR-LME Surface {\Omega}_{arag}','Fontsize',14)

ax(2) = subplot(1,3,2); 
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.arag,3)),[1:.1:2.6]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([1 2.6])
colormap(ax(2),flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model Surface {\Omega}_{arag}','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(1).Position(1) .1 .495 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[1:.2:2.6],'fontsize',12); ylabel(cb,'{\Omega}_{arag}','fontsize',14);

ax(3) = subplot(1,3,3);
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,model.arag_regrid - squeeze(nanmean(obs.arag,3))',[-.8:.1:.8]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
caxis([-.8 .8])
colormap(ax(3),flipud(cmap2))
%colormap(ax(3),cmap2)
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('Model - (RFR-LME)','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(3).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[-.8:.4:.8],'fontsize',12); ylabel(cb,'{\Delta}{\Omega}_{arag}','fontsize',14);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/CA_current_pH_ann_spatial.jpg','Resolution',300);
%% 

figure(4); set(gcf, 'units','centimeters','position',[10 10 27 18]); set(gcf,'Color',[1 1 1]);
subplot(1,2,1)
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.pH,3)),[7.9:.02:8.15]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([7.9 8.15])
set(cb,'ytick',[7.9:.05:8.15],'Fontsize',16)
ylabel(cb,'pH','Fontsize',16)
colormap(flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('1993-2022 Annual pH Model','Fontsize',14)

subplot(1,2,2)
m_proj('Mercator','long',[232  245],'lat',[30 50])
m_contourf(obs.lon,obs.lat,model.pH_regrid,[7.9:.02:8.15]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([7.9 8.15])
set(cb,'ytick',[7.9:.05:8.15],'Fontsize',16)
ylabel(cb,'pH','Fontsize',14)
colormap(flipud(cmap))
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('1993-2022 Annual pH Model Regrided','Fontsize',14)

figure(5); set(gcf, 'units','centimeters','position',[10 10 18 21]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
plot(obs.pH_CC,'k','Linewidth',2)
hold on
plot(model.pH_CC,'b','Linewidth',2)
set(gca,'xtick',[1:12*4:264])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018'},'Fontsize',12)
axis([1 264 8 8.12])
ylabel('pH','Fontsize',16)
title(['Monthly pH R = ',num2str(corr(obs.pH_CC,model.pH_CC,'rows','complete'),2)],'Fontsize',16)
legend('Obs','Model','Location','Northeast')

subplot(3,1,2)
plot(obs.arag_CC,'k','Linewidth',2)
hold on
plot(model.arag_CC,'b','Linewidth',2)
set(gca,'xtick',[1:12*4:264])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018'},'Fontsize',12)
axis([1 264 1.9 2.5])
ylabel('Monthly {\Omega}_{arag}','Fontsize',16)
title(['{\Omega}_{arag} R = ',num2str(corr(obs.arag_CC,model.arag_CC,'rows','complete'),2)],'Fontsize',16)

subplot(3,1,3)
plot(obs.pco2_CC,'k','Linewidth',2)
hold on
plot(model.pco2_CC,'b','Linewidth',2)
set(gca,'xtick',[1:12*4:264])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018'},'Fontsize',12)
axis([1 264 320 440])
ylabel('pCO2','Fontsize',16)
title(['Monthly pCO2 R = ',num2str(corr(obs.pco2_CC,model.pco2_CC,'rows','complete'),2)],'Fontsize',16)

%saveas(gcf,['/home/Darren.Pilcher/figures/NEP/model_comparisons/monthly_timeseries'],'jpeg')
%% 

figure(6); set(gcf, 'units','centimeters','position',[10 10 18 21]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
plot(obs.pH_ann_CC,'k','Linewidth',2)
hold on
plot(model.pH_ann_CC,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 8 8.12])
ylabel('pH','Fontsize',14)
title(['Annual Surface pH (R = ',num2str(corr(obs.pH_ann_CC,model.pH_ann_CC,'rows','complete'),2),')'],'Fontsize',16)
legend('RFR-LME','Model','Location','Northeast')

subplot(3,1,2)
plot(obs.arag_ann_CC,'k','Linewidth',2)
hold on
plot(model.arag_ann_CC,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 1.9 2.5])
ylabel('{\Omega}_{arag}','Fontsize',14)
title(['Annual Surface {\Omega}_{arag} (R = ',num2str(corr(obs.arag_ann_CC,model.arag_ann_CC,'rows','complete'),2),')'],'Fontsize',16)

subplot(3,1,3)
plot(obs.pco2_ann_CC,'k','Linewidth',2)
hold on
plot(model.pco2_ann_CC,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 320 440])
ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
xlabel('Year','FontSize',14)
title(['Annual Surface pCO_2 (R = ',num2str(corr(obs.pco2_ann_CC,model.pco2_ann_CC,'rows','complete'),2),')'],'Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/ca_current_ann_timeseries.jpg','Resolution',300);
%% 

% Bering Sea
figure(7); set(gcf, 'units','centimeters','position',[20 30 12 30]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(3,1,1);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.pH,3))',[7.8:.02:8.2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([7.8 8.2])
set(cb,'ytick',[7.8:.1:8.2],'Fontsize',14)
ylabel(cb,'pH','Fontsize',14)
colormap(ax(1),flipud(cmap))
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('1993-2022 Annual pH Sharp product','Fontsize',14)

ax(2) = subplot(3,1,2);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.pH,3)),[7.8:.02:8.2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([7.8 8.2])
set(cb,'ytick',[7.8:.1:8.2],'Fontsize',14)
ylabel(cb,'pH','Fontsize',14)
colormap(ax(2),flipud(cmap))
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('1993-2022 Annual pH Model','Fontsize',14)

ax(3) = subplot(3,1,3);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,model.pH_regrid - squeeze(nanmean(obs.pH,3))',[-.2:.02:.2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([-.2 .2])
set(cb,'ytick',[-.2:.1:.2],'Fontsize',14)
ylabel(cb,'pH','Fontsize',14)
colormap(ax(3),flipud(cmap2))
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('Difference (Model-Sharp)','Fontsize',14)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/Bering_pH_ann_spatial.jpg','Resolution',300);
%% 

figure(8); set(gcf, 'units','centimeters','position',[20 30 12 30]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(3,1,1);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.pco2,3))',[220:20:520]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([220 520])
set(cb,'ytick',[250:50:500],'Fontsize',14)
ylabel(cb,'pCO2','Fontsize',14)
colormap(ax(1),cmap)
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('1993-2022 Annual pCO2 Sharp product','Fontsize',14)

ax(2) = subplot(3,1,2);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.pco2,3)),[220:20:520]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([220 520])
set(cb,'ytick',[250:50:500],'Fontsize',14)
ylabel(cb,'pCO2','Fontsize',14)
colormap(ax(2),cmap)
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('1993-2022 Annual pCO2 Model','Fontsize',14)

ax(3) = subplot(3,1,3);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,model.pco2_regrid - squeeze(nanmean(obs.pco2,3))',[-150:20:150]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([-150 150])
set(cb,'ytick',[-150:75:150],'Fontsize',14)
ylabel(cb,'pCO2','Fontsize',14)
colormap(ax(3),cmap2)
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('Difference (Model-Sharp)','Fontsize',14)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/Bering_pCO2_ann_spatial.jpg','Resolution',300);
%% 

figure(9); set(gcf, 'units','centimeters','position',[20 30 12 30]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(3,1,1);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,squeeze(nanmean(obs.arag,3))',[.5:.1:2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([0.5 2])
set(cb,'ytick',[.5:.5:2],'Fontsize',14)
ylabel(cb,'{\Omega}_{arag}','Fontsize',14)
colormap(ax(1),flipud(cmap))
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('RFR-LME Surface {\Omega}_{arag}','Fontsize',14)

ax(2) = subplot(3,1,2);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(model.lon,model.lat,squeeze(nanmean(model.arag,3)),[.5:.1:2]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([0.5 2])
set(cb,'ytick',[.5:.5:2],'Fontsize',14)
ylabel(cb,'{\Omega}_{arag}','Fontsize',14)
colormap(ax(2),flipud(cmap))
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('Model Surface {\Omega}_{arag}','Fontsize',14)

ax(3) = subplot(3,1,3);
m_proj('Mercator','long',[165 210],'lat',[48 66])
m_contourf(obs.lon,obs.lat,model.arag_regrid - squeeze(nanmean(obs.arag,3))',[-.8:.1:.8]);
m_gshhs_i('patch',[0.5 0.5 0.5]);
cb = colorbar;
caxis([-.8 .8])
set(cb,'ytick',[-.5:.5:.5],'Fontsize',14)
ylabel(cb,'{\Omega}_{arag}','Fontsize',14)
colormap(ax(3),flipud(cmap2))
%colormap(ax(3),cmap2)
m_grid('xtick',[165:10:215],'ytick',[49:5:65],'linestyle','none','color','k','Fontsize',10);
title('Model - (RFR-LME)','Fontsize',14)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/sharp_2024/Bering_arag_ann_spatial_v2.jpg','Resolution',300);
%% 

figure(10); set(gcf, 'units','centimeters','position',[10 10 18 21]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
plot(obs.pH_ann_Bering,'k','Linewidth',2)
hold on
plot(model.pH_ann_Bering,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 8 8.12])
ylabel('pH','Fontsize',16)
title(['Annual Bering Sea pH R = ',num2str(corr(obs.pH_ann_Bering,model.pH_ann_Bering,'rows','complete'),2)],'Fontsize',16)
legend('Sharp 2024','Model','Location','Northeast')

subplot(3,1,2)
plot(obs.arag_ann_Bering,'k','Linewidth',2)
hold on
plot(model.arag_ann_Bering,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 1.4 1.8])
ylabel('{\Omega}_{arag}','Fontsize',16)
title(['Annual Bering Sea {\Omega}_{arag} R = ',num2str(corr(obs.arag_ann_Bering,model.arag_ann_Bering,'rows','complete'),2)],'Fontsize',16)

subplot(3,1,3)
plot(obs.pco2_ann_Bering,'k','Linewidth',2)
hold on
plot(model.pco2_ann_Bering,'b','Linewidth',2)
set(gca,'xtick',[1:4:26])
set(gca,'xticklabel',{'1998' '2002' '2006' '2010' '2014' '2018' '2022'},'Fontsize',12)
axis([1 25 320 440])
ylabel('pCO2','Fontsize',16)
title(['Annual Bering Sea pCO2 R = ',num2str(corr(obs.pco2_ann_CC,model.pco2_ann_CC,'rows','complete'),2)],'Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/sharp_2024/Bering_ann_timeseries.jpg','Resolution',300);






