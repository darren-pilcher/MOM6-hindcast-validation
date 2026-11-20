% Script used to comapred MOM6 output to various pCO2 moorings

% Created by DJP 10/25

close all
clear

plt_daily = false; % For OBS daily averaged plots
plt_monthly = true; % For OBS monthly averaged plots

OBS_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/obs/mooring';
MODEL_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/northeast_pacific/hindcast/monthly/r20250912';

% Load CCE1 mooring
tmp = readmatrix([OBS_DIR,'/CCE1/CCE1_oct2025.csv'],'NumHeaderLines',110);
CCE1.SST = tmp(:,2); CCE1.SSS = tmp(:,3); CCE1.pCO2 = tmp(:,4); CCE1.chl = tmp(:,9); CCE1.oxy = tmp(:,8); clear tmp
tmp = readmatrix([OBS_DIR,'/CCE1/CCE1_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
CCE1.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
CCE1.time = dateshift(CCE1.time,'start','day');
% Also load TOATS output from Adrienne Sutton
tmp = readmatrix([OBS_DIR,'/CCE1/CCE1_TOATS.csv'],'NumHeaderLines',1);
CCE1.TA = tmp(:,8); CCE1.DIC = tmp(:,10); clear tmp

% Load CCE2 mooring
tmp = readmatrix([OBS_DIR,'/CCE2/CCE2_oct2025.csv'],'NumHeaderLines',110);
CCE2.SST = tmp(:,2); CCE2.SSS = tmp(:,3); CCE2.pCO2 = tmp(:,4); CCE2.chl = tmp(:,9); CCE2.oxy = tmp(:,8); clear tmp
tmp = readmatrix([OBS_DIR,'/CCE2/CCE2_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
CCE2.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
CCE2.time = dateshift(CCE2.time,'start','day');
tmp = readmatrix([OBS_DIR,'/CCE2/CCE2_TOATS.csv'],'NumHeaderLines',1);
CCE2.TA = tmp(:,8); CCE2.DIC = tmp(:,10); clear tmp

% Load Cape Arago
tmp = readmatrix([OBS_DIR,'/Cape_Arago/CAPE_ARAGO_oct2025.csv'],'NumHeaderLines',110);
Arago.SST = tmp(:,2); Arago.SSS = tmp(:,3); Arago.pCO2 = tmp(:,4); Arago.chl = tmp(:,9); Arago.oxy = tmp(:,8); clear tmp
tmp = readmatrix([OBS_DIR,'/Cape_Arago/CAPE_ARAGO_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
Arago.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
Arago.time = dateshift(Arago.time,'start','day');
tmp = readmatrix([OBS_DIR,'/Cape_Arago/CAPEARAGO_TOATS.csv'],'NumHeaderLines',1);
Arago.TA = tmp(:,8); Arago.DIC = tmp(:,10); clear tmp

% Load Cape Elizabeth
tmp = readmatrix([OBS_DIR,'/Cape_Elizabeth/CAPE_ELIZABETH_oct2025.csv'],'NumHeaderLines',110);
Elizabeth.SST = tmp(:,2); Elizabeth.SSS = tmp(:,3); Elizabeth.pCO2 = tmp(:,4); Elizabeth.chl = tmp(:,9); clear tmp
tmp = readmatrix([OBS_DIR,'/Cape_Elizabeth/CAPE_ELIZABETH_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
Elizabeth.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
Elizabeth.time = dateshift(Elizabeth.time,'start','day');
tmp = readmatrix([OBS_DIR,'/Cape_Elizabeth/CAPEELIZABETH_TOATS.csv'],'NumHeaderLines',1);
Elizabeth.TA = tmp(:,8); Elizabeth.DIC = tmp(:,10); clear tmp

% Load CHABA
tmp = readmatrix([OBS_DIR,'/CHABA/CHABA_oct2025.csv'],'NumHeaderLines',110);
CHABA.SST = tmp(:,2); CHABA.SSS = tmp(:,3); CHABA.pCO2 = tmp(:,4); CHABA.chl = tmp(:,9); CHABA.oxy = tmp(:,8); clear tmp
tmp = readmatrix([OBS_DIR,'/CHABA/CHABA_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
CHABA.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
CHABA.time = dateshift(CHABA.time,'start','day');
tmp = readmatrix([OBS_DIR,'/CHABA/CHABA_TOATS.csv'],'NumHeaderLines',1);
CHABA.TA = tmp(:,8); CHABA.DIC = tmp(:,10); clear tmp

% Load GAKOA
tmp = readmatrix([OBS_DIR,'/GAKOA/GAKOA_oct2025.csv'],'NumHeaderLines',110);
GAKOA.SST = tmp(:,2); GAKOA.SSS = tmp(:,3); GAKOA.pCO2 = tmp(:,4); GAKOA.chl = tmp(:,9); clear tmp
tmp = readmatrix([OBS_DIR,'/GAKOA/GAKOA_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
GAKOA.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
GAKOA.time = dateshift(GAKOA.time,'start','day');

% Load M2
tmp = readmatrix([OBS_DIR,'/M2/M2_oct2025.csv'],'NumHeaderLines',110);
M2.SST = tmp(:,2); M2.SSS = tmp(:,3); M2.pCO2 = tmp(:,4); M2.chl = tmp(:,9); clear tmp
tmp = readmatrix([OBS_DIR,'/M2/M2_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
M2.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
M2.time = dateshift(M2.time,'start','day');

% Load NH10
tmp = readmatrix([OBS_DIR,'/NH10/NH10_oct2025.csv'],'NumHeaderLines',110);
NH10.SST = tmp(:,2); NH10.SSS = tmp(:,3); NH10.pCO2 = tmp(:,4); NH10.chl = tmp(:,9); clear tmp
tmp = readmatrix([OBS_DIR,'/NH10/NH10_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
NH10.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
NH10.time = dateshift(NH10.time,'start','day');

% Load PAPA
tmp = readmatrix([OBS_DIR,'/PAPA/PAPA_oct2025.csv'],'NumHeaderLines',110);
PAPA.SST = tmp(:,2); PAPA.SSS = tmp(:,3); PAPA.pCO2 = tmp(:,4); PAPA.chl = tmp(:,9); clear tmp
tmp = readmatrix([OBS_DIR,'/PAPA/PAPA_oct2025.csv'],'OutputType','string','NumHeaderLines',110);
PAPA.time = datetime(tmp(:,1),'InputFormat','MM/dd/yy HH:mm','Pivotyear',2000); clear tmp
PAPA.time = dateshift(PAPA.time,'start','day');
tmp = readmatrix([OBS_DIR,'/PAPA/PAPA_TOATS.csv'],'NumHeaderLines',1);
PAPA.TA = tmp(:,8); PAPA.DIC = tmp(:,10); clear tmp

% Code used to find nearest model grid cell to mooring location.  Only need
% to run 1st time to get location

% CHABA 47.97°N, 124.95°W  [263 358]
% NH10 44.6°N, 124.3°W     [251 323]
% Cape Arago 43.3°N, 124.5°W [244 311]
% Cape Elizabeth 47.35°N 124.73°W [262 352]
% CCE2 34.324°N, 120.814°W [232 206]
% GAKOA 59.85°N 149.5°W [210 555]
% CCE1 33.5°N, 122.5°W [213 204]
% PAPA 50.1°N, 144.9°W [157 457]
% M2 56.87°N, 164.06°W [131 599]

model.lat = ncread([MODEL_DIR,'/ocean_static.nc'],'geolat');
model.lon = ncread([MODEL_DIR,'/ocean_static.nc'],'geolon');
% 
% [xrho, yrho, zrho] = geodetic2enu(model.lat, model.lon, 0, nanmean(nanmean(model.lat)), nanmean(nanmean(model.lon)), 0, referenceEllipsoid('earth'));
% [xobs, yobs, zobs] = geodetic2enu(56.87, 360-164.06, 0, nanmean(nanmean(model.lat)), nanmean(nanmean(model.lon)), 0, referenceEllipsoid('earth'));
% 
% [d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);
% 
% % Convert to subscript indicies
% [rowmin,colmin] = ind2sub([342 816],imin);

% Load NEP10K model output and grab points
model.time = ncdateread([MODEL_DIR,'/pco2surf.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'time'); % All variables have same time

tmp = ncread([MODEL_DIR,'/pco2surf.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'pco2surf');
model_CCE1.pCO2 = squeeze(tmp(213,204,:)); model_CCE2.pCO2 = squeeze(tmp(232,206,:)); model_Arago.pCO2 = squeeze(tmp(244,311,:));  
model_Elizabeth.pCO2 = squeeze(tmp(262,352,:)); model_CHABA.pCO2 = squeeze(tmp(263,358,:)); model_GAKOA.pCO2 = squeeze(tmp(210,555,:));
model_NH10.pCO2 = squeeze(tmp(251,323,:)); model_PAPA.pCO2 = squeeze(tmp(157,457,:)); model_M2.pCO2 = squeeze(tmp(131,599,:)); 
model.pCO2 = tmp; clear tmp  

tmp = ncread([MODEL_DIR,'/tos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'tos');
% tos and sos have 6 duplicated values at very end for current run, so remove these
tmp_time = ncdateread([MODEL_DIR,'/tos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'time'); % All variables have same time
[C,ia,ic] = (unique(tmp_time)); tmp = tmp(:,:,ia); clear C ia ic tmp_time
model_CCE1.SST = squeeze(tmp(213,204,:)); model_CCE2.SST = squeeze(tmp(232,206,:)); model_Arago.SST = squeeze(tmp(244,311,:));  
model_Elizabeth.SST = squeeze(tmp(262,352,:)); model_CHABA.SST = squeeze(tmp(263,358,:)); model_GAKOA.SST = squeeze(tmp(210,555,:));
model_NH10.SST = squeeze(tmp(251,323,:)); model_PAPA.SST = squeeze(tmp(157,457,:)); model_M2.SST = squeeze(tmp(131,599,:));
model.SST = tmp; clear tmp

tmp = ncread([MODEL_DIR,'/sos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'sos');
% tos and sos have 6 duplicated values at very end for current run, so remove these
tmp_time = ncdateread([MODEL_DIR,'/sos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'time');
[C,ia,ic] = (unique(tmp_time)); tmp = tmp(:,:,ia); clear C ia ic tmp_time
model_CCE1.SSS = squeeze(tmp(213,204,:)); model_CCE2.SSS = squeeze(tmp(232,206,:)); model_Arago.SSS = squeeze(tmp(244,311,:));  
model_Elizabeth.SSS = squeeze(tmp(262,352,:)); model_CHABA.SSS = squeeze(tmp(263,358,:)); model_GAKOA.SSS = squeeze(tmp(210,555,:));
model_NH10.SSS = squeeze(tmp(251,323,:)); model_PAPA.SSS = squeeze(tmp(157,457,:)); model_M2.SSS = squeeze(tmp(131,599,:)); 
model.SSS = tmp; clear tmp 

tmp = ncread([MODEL_DIR,'/chlos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'chlos');
tmp = tmp / 1000 * 1000 * (10^6); % Convert from model kg/m3 to ug/L
model_CCE1.chl = squeeze(tmp(213,204,:)); model_CCE2.chl = squeeze(tmp(232,206,:)); model_Arago.chl = squeeze(tmp(244,311,:));  
model_Elizabeth.chl = squeeze(tmp(262,352,:)); model_CHABA.chl = squeeze(tmp(263,358,:)); model_GAKOA.chl = squeeze(tmp(210,555,:));
model_NH10.chl = squeeze(tmp(251,323,:)); model_PAPA.chl = squeeze(tmp(157,457,:)); model_M2.chl = squeeze(tmp(131,599,:)); 
model.chl = tmp; clear tmp 

tmp = ncread([MODEL_DIR,'/o2os.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'o2os');
tmp = tmp * (10^3) / 1.025; % convert from model mol/m^3 to umol/kg
model_CCE1.oxy = squeeze(tmp(213,204,:)); model_CCE2.oxy = squeeze(tmp(232,206,:)); model_Arago.oxy = squeeze(tmp(244,311,:));  
model_CHABA.oxy = squeeze(tmp(263,358,:)); model.oxy = tmp; clear tmp 

tmp = ncread([MODEL_DIR,'/dissicos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'dissicos');
tmp = tmp * 1000 / 1.025; % Convert from mol/m^3 to umol/kg
model_CCE1.DIC = squeeze(tmp(213,204,:)); model_CCE2.DIC = squeeze(tmp(232,206,:)); model_Arago.DIC = squeeze(tmp(244,311,:));  
model_Elizabeth.DIC = squeeze(tmp(262,352,:)); model_CHABA.DIC = squeeze(tmp(263,358,:)); model_GAKOA.DIC = squeeze(tmp(210,555,:));
model_NH10.DIC = squeeze(tmp(251,323,:)); model_PAPA.DIC = squeeze(tmp(157,457,:)); model_M2.DIC = squeeze(tmp(131,599,:)); 
model.DIC = tmp; clear tmp 

tmp = ncread([MODEL_DIR,'/talkos.nep.full.hcast.monthly.raw.r20250912.199301-202506.nc'],'talkos');
tmp = tmp * 1000 / 1.025; % Convert from mol/m^3 to umol/kg
model_CCE1.TA = squeeze(tmp(213,204,:)); model_CCE2.TA = squeeze(tmp(232,206,:)); model_Arago.TA = squeeze(tmp(244,311,:));  
model_Elizabeth.TA = squeeze(tmp(262,352,:)); model_CHABA.TA = squeeze(tmp(263,358,:)); model_GAKOA.TA = squeeze(tmp(210,555,:));
model_NH10.TA = squeeze(tmp(251,323,:)); model_PAPA.TA = squeeze(tmp(157,457,:)); model_M2.TA = squeeze(tmp(131,599,:)); 
model.TA = tmp; clear tmp 

% Mooring daily averaging
% Daily average M2 pCO2
CCE1.days = unique(CCE1.time);
for t = 1:length(CCE1.days)
    tmp_ind = isbetween(CCE1.time,CCE1.days(t),CCE1.days(t));
    CCE1.SST_daily(t) = nanmean(CCE1.SST(tmp_ind));
    CCE1.SSS_daily(t) = nanmean(CCE1.SSS(tmp_ind));
    CCE1.pCO2_daily(t) = nanmean(CCE1.pCO2(tmp_ind));
    CCE1.chl_daily(t) = nanmean(CCE1.chl(tmp_ind));
    CCE1.oxy_daily(t) = nanmean(CCE1.oxy(tmp_ind));
    CCE1.TA_daily(t) = nanmean(CCE1.TA(tmp_ind));
    CCE1.DIC_daily(t) = nanmean(CCE1.DIC(tmp_ind));
end

CCE2.days = unique(CCE2.time);
for t = 1:length(CCE2.days)
    tmp_ind = isbetween(CCE2.time,CCE2.days(t),CCE2.days(t));
    CCE2.SST_daily(t) = nanmean(CCE2.SST(tmp_ind));
    CCE2.SSS_daily(t) = nanmean(CCE2.SSS(tmp_ind));
    CCE2.pCO2_daily(t) = nanmean(CCE2.pCO2(tmp_ind));
    CCE2.chl_daily(t) = nanmean(CCE2.chl(tmp_ind));
    CCE2.oxy_daily(t) = nanmean(CCE2.oxy(tmp_ind));
    CCE2.TA_daily(t) = nanmean(CCE2.TA(tmp_ind));
    CCE2.DIC_daily(t) = nanmean(CCE2.DIC(tmp_ind));
end

Arago.days = unique(Arago.time);
for t = 1:length(Arago.days)
    tmp_ind = isbetween(Arago.time,Arago.days(t),Arago.days(t));
    Arago.SST_daily(t) = nanmean(Arago.SST(tmp_ind));
    Arago.SSS_daily(t) = nanmean(Arago.SSS(tmp_ind));
    Arago.pCO2_daily(t) = nanmean(Arago.pCO2(tmp_ind));
    Arago.chl_daily(t) = nanmean(Arago.chl(tmp_ind));
    Arago.oxy_daily(t) = nanmean(Arago.oxy(tmp_ind));
    Arago.TA_daily(t) = nanmean(Arago.TA(tmp_ind));
    Arago.DIC_daily(t) = nanmean(Arago.DIC(tmp_ind));
end

Elizabeth.days = unique(Elizabeth.time);
for t = 1:length(Elizabeth.days)
    tmp_ind = isbetween(Elizabeth.time,Elizabeth.days(t),Elizabeth.days(t));
    Elizabeth.SST_daily(t) = nanmean(Elizabeth.SST(tmp_ind));
    Elizabeth.SSS_daily(t) = nanmean(Elizabeth.SSS(tmp_ind));
    Elizabeth.pCO2_daily(t) = nanmean(Elizabeth.pCO2(tmp_ind));
    Elizabeth.chl_daily(t) = nanmean(Elizabeth.chl(tmp_ind));
    Elizabeth.TA_daily(t) = nanmean(Elizabeth.TA(tmp_ind));
    Elizabeth.DIC_daily(t) = nanmean(Elizabeth.DIC(tmp_ind));
end

CHABA.days = unique(CHABA.time);
for t = 1:length(CHABA.days)
    tmp_ind = isbetween(CHABA.time,CHABA.days(t),CHABA.days(t));
    CHABA.SST_daily(t) = nanmean(CHABA.SST(tmp_ind));
    CHABA.SSS_daily(t) = nanmean(CHABA.SSS(tmp_ind));
    CHABA.pCO2_daily(t) = nanmean(CHABA.pCO2(tmp_ind));
    CHABA.chl_daily(t) = nanmean(CHABA.chl(tmp_ind));
    CHABA.oxy_daily(t) = nanmean(CHABA.oxy(tmp_ind));
    CHABA.TA_daily(t) = nanmean(CHABA.TA(tmp_ind));
    CHABA.DIC_daily(t) = nanmean(CHABA.DIC(tmp_ind));
end

GAKOA.days = unique(GAKOA.time);
for t = 1:length(GAKOA.days)
    tmp_ind = isbetween(GAKOA.time,GAKOA.days(t),GAKOA.days(t));
    GAKOA.SST_daily(t) = nanmean(GAKOA.SST(tmp_ind));
    GAKOA.SSS_daily(t) = nanmean(GAKOA.SSS(tmp_ind));
    GAKOA.pCO2_daily(t) = nanmean(GAKOA.pCO2(tmp_ind));
    GAKOA.chl_daily(t) = nanmean(GAKOA.chl(tmp_ind));
end

M2.days = unique(M2.time);
for t = 1:length(M2.days)
    tmp_ind = isbetween(M2.time,M2.days(t),M2.days(t));
    M2.SST_daily(t) = nanmean(M2.SST(tmp_ind));
    M2.SSS_daily(t) = nanmean(M2.SSS(tmp_ind));
    M2.pCO2_daily(t) = nanmean(M2.pCO2(tmp_ind));
    M2.chl_daily(t) = nanmean(M2.chl(tmp_ind));
end

NH10.days = unique(NH10.time);
for t = 1:length(NH10.days)
    tmp_ind = isbetween(NH10.time,NH10.days(t),NH10.days(t));
    NH10.SST_daily(t) = nanmean(NH10.SST(tmp_ind));
    NH10.SSS_daily(t) = nanmean(NH10.SSS(tmp_ind));
    NH10.pCO2_daily(t) = nanmean(NH10.pCO2(tmp_ind));
    NH10.chl_daily(t) = nanmean(NH10.chl(tmp_ind));
end

PAPA.days = unique(PAPA.time);
for t = 1:length(PAPA.days)
    tmp_ind = isbetween(PAPA.time,PAPA.days(t),PAPA.days(t));
    PAPA.SST_daily(t) = nanmean(PAPA.SST(tmp_ind));
    PAPA.SSS_daily(t) = nanmean(PAPA.SSS(tmp_ind));
    PAPA.pCO2_daily(t) = nanmean(PAPA.pCO2(tmp_ind));
    PAPA.chl_daily(t) = nanmean(PAPA.chl(tmp_ind));
    PAPA.TA_daily(t) = nanmean(PAPA.TA(tmp_ind));
    PAPA.DIC_daily(t) = nanmean(PAPA.DIC(tmp_ind));
end

% Test monthly averaging
mon_end = [31 28 31 30 31 30 31 31 30 31 30 31];
CCE1.years = min(year(CCE1.days)):1:max(year(CCE1.days));
for t = 1:length(CCE1.years)
    for m = 1:12
        tmp_ind = isbetween(CCE1.days,datetime(CCE1.years(t),m,1),datetime(CCE1.years(t),m,mon_end(m),23,59,59));
        CCE1.SST_monthly(m,t) = nanmean(CCE1.SST_daily(tmp_ind));
        CCE1.SSS_monthly(m,t) = nanmean(CCE1.SSS_daily(tmp_ind));
        CCE1.pCO2_monthly(m,t) = nanmean(CCE1.pCO2_daily(tmp_ind));
        CCE1.chl_monthly(m,t) = nanmean(CCE1.chl_daily(tmp_ind));
        CCE1.oxy_monthly(m,t) = nanmean(CCE1.oxy_daily(tmp_ind));
        CCE1.TA_monthly(m,t) = nanmean(CCE1.TA_daily(tmp_ind));
        CCE1.DIC_monthly(m,t) = nanmean(CCE1.DIC_daily(tmp_ind));
        CCE1.time_monthly(m,t) = nanmean(CCE1.days(tmp_ind));
    end
end

for t = 1:length(CCE1.years)
    for m = 1:12
        CCE1.pCO2_T(m,t) = nanmean(CCE1.pCO2_monthly(:,t),1) * exp(0.0413 * (CCE1.SST_monthly(m,t) - nanmean(CCE1.SST_monthly(:,t),1)));
        CCE1.pCO2_nonT(m,t) = CCE1.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(CCE1.SST_monthly(:,t),1) - CCE1.SST_monthly(m,t)));
    end
end

CCE2.years = min(year(CCE2.days)):1:max(year(CCE2.days));
for t = 1:length(CCE2.years)
    for m = 1:12
        tmp_ind = isbetween(CCE2.days,datetime(CCE2.years(t),m,1),datetime(CCE2.years(t),m,mon_end(m),23,59,59));
        CCE2.SST_monthly(m,t) = nanmean(CCE2.SST_daily(tmp_ind));
        CCE2.SSS_monthly(m,t) = nanmean(CCE2.SSS_daily(tmp_ind));
        CCE2.pCO2_monthly(m,t) = nanmean(CCE2.pCO2_daily(tmp_ind));
        CCE2.chl_monthly(m,t) = nanmean(CCE2.chl_daily(tmp_ind));
        CCE2.oxy_monthly(m,t) = nanmean(CCE2.oxy_daily(tmp_ind));
        CCE2.TA_monthly(m,t) = nanmean(CCE2.TA_daily(tmp_ind));
        CCE2.DIC_monthly(m,t) = nanmean(CCE2.DIC_daily(tmp_ind));
        CCE2.time_monthly(m,t) = nanmean(CCE2.days(tmp_ind));
    end
end

for t = 1:length(CCE2.years)
    for m = 1:12
        CCE2.pCO2_T(m,t) = nanmean(CCE2.pCO2_monthly(:,t),1) * exp(0.0413 * (CCE2.SST_monthly(m,t) - nanmean(CCE2.SST_monthly(:,t),1)));
        CCE2.pCO2_nonT(m,t) = CCE2.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(CCE2.SST_monthly(:,t),1) - CCE2.SST_monthly(m,t)));
    end
end

Arago.years = min(year(Arago.days)):1:max(year(Arago.days));
for t = 1:length(Arago.years)
    for m = 1:12
        tmp_ind = isbetween(Arago.days,datetime(Arago.years(t),m,1),datetime(Arago.years(t),m,mon_end(m),23,59,59));
        Arago.SST_monthly(m,t) = nanmean(Arago.SST_daily(tmp_ind));
        Arago.SSS_monthly(m,t) = nanmean(Arago.SSS_daily(tmp_ind));
        Arago.pCO2_monthly(m,t) = nanmean(Arago.pCO2_daily(tmp_ind));
        Arago.chl_monthly(m,t) = nanmean(Arago.chl_daily(tmp_ind));
        Arago.oxy_monthly(m,t) = nanmean(Arago.oxy_daily(tmp_ind));
        Arago.TA_monthly(m,t) = nanmean(Arago.TA_daily(tmp_ind));
        Arago.DIC_monthly(m,t) = nanmean(Arago.DIC_daily(tmp_ind));
        Arago.time_monthly(m,t) = nanmean(Arago.days(tmp_ind));
    end
end

for t = 1:length(Arago.years)
    for m = 1:12
        Arago.pCO2_T(m,t) = nanmean(Arago.pCO2_monthly(:,t),1) * exp(0.0413 * (Arago.SST_monthly(m,t) - nanmean(Arago.SST_monthly(:,t),1)));
        Arago.pCO2_nonT(m,t) = Arago.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(Arago.SST_monthly(:,t),1) - Arago.SST_monthly(m,t)));
    end
end

Elizabeth.years = min(year(Elizabeth.days)):1:max(year(Elizabeth.days));
for t = 1:length(Elizabeth.years)
    for m = 1:12
        tmp_ind = isbetween(Elizabeth.days,datetime(Elizabeth.years(t),m,1),datetime(Elizabeth.years(t),m,mon_end(m),23,59,59));
        Elizabeth.SST_monthly(m,t) = nanmean(Elizabeth.SST_daily(tmp_ind));
        Elizabeth.SSS_monthly(m,t) = nanmean(Elizabeth.SSS_daily(tmp_ind));
        Elizabeth.pCO2_monthly(m,t) = nanmean(Elizabeth.pCO2_daily(tmp_ind));
        Elizabeth.chl_monthly(m,t) = nanmean(Elizabeth.chl_daily(tmp_ind));
        Elizabeth.TA_monthly(m,t) = nanmean(Elizabeth.TA_daily(tmp_ind));
        Elizabeth.DIC_monthly(m,t) = nanmean(Elizabeth.DIC_daily(tmp_ind));
        Elizabeth.time_monthly(m,t) = nanmean(Elizabeth.days(tmp_ind));
    end
end

CHABA.years = min(year(CHABA.days)):1:max(year(CHABA.days));
for t = 1:length(CHABA.years)
    for m = 1:12
        tmp_ind = isbetween(CHABA.days,datetime(CHABA.years(t),m,1),datetime(CHABA.years(t),m,mon_end(m),23,59,59));
        CHABA.SST_monthly(m,t) = nanmean(CHABA.SST_daily(tmp_ind));
        CHABA.SSS_monthly(m,t) = nanmean(CHABA.SSS_daily(tmp_ind));
        CHABA.pCO2_monthly(m,t) = nanmean(CHABA.pCO2_daily(tmp_ind));
        CHABA.chl_monthly(m,t) = nanmean(CHABA.chl_daily(tmp_ind));
        CHABA.oxy_monthly(m,t) = nanmean(CHABA.oxy_daily(tmp_ind));
        CHABA.TA_monthly(m,t) = nanmean(CHABA.TA_daily(tmp_ind));
        CHABA.DIC_monthly(m,t) = nanmean(CHABA.DIC_daily(tmp_ind));
        CHABA.time_monthly(m,t) = nanmean(CHABA.days(tmp_ind));
    end
end

for t = 1:length(CHABA.years)
    for m = 1:12
        CHABA.pCO2_T(m,t) = nanmean(CHABA.pCO2_monthly(:,t),1) * exp(0.0413 * (CHABA.SST_monthly(m,t) - nanmean(CHABA.SST_monthly(:,t),1)));
        CHABA.pCO2_nonT(m,t) = CHABA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(CHABA.SST_monthly(:,t),1) - CHABA.SST_monthly(m,t)));
    end
end

GAKOA.years = min(year(GAKOA.days)):1:max(year(GAKOA.days));
for t = 1:length(GAKOA.years)
    for m = 1:12
        tmp_ind = isbetween(GAKOA.days,datetime(GAKOA.years(t),m,1),datetime(GAKOA.years(t),m,mon_end(m),23,59,59));
        GAKOA.SST_monthly(m,t) = nanmean(GAKOA.SST_daily(tmp_ind));
        GAKOA.SSS_monthly(m,t) = nanmean(GAKOA.SSS_daily(tmp_ind));
        GAKOA.pCO2_monthly(m,t) = nanmean(GAKOA.pCO2_daily(tmp_ind));
        GAKOA.chl_monthly(m,t) = nanmean(GAKOA.chl_daily(tmp_ind));
        GAKOA.time_monthly(m,t) = nanmean(GAKOA.days(tmp_ind));
    end
end

for t = 1:length(GAKOA.years)
    for m = 1:12
        GAKOA.pCO2_T(m,t) = nanmean(GAKOA.pCO2_monthly(:,t),1) * exp(0.0413 * (GAKOA.SST_monthly(m,t) - nanmean(GAKOA.SST_monthly(:,t),1)));
        GAKOA.pCO2_nonT(m,t) = GAKOA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(GAKOA.SST_monthly(:,t),1) - GAKOA.SST_monthly(m,t)));
    end
end

M2.years = min(year(M2.days)):1:max(year(M2.days));
for t = 1:length(M2.years)
    for m = 1:12
        tmp_ind = isbetween(M2.days,datetime(M2.years(t),m,1),datetime(M2.years(t),m,mon_end(m),23,59,59));
        M2.SST_monthly(m,t) = nanmean(M2.SST_daily(tmp_ind));
        M2.SSS_monthly(m,t) = nanmean(M2.SSS_daily(tmp_ind));
        M2.pCO2_monthly(m,t) = nanmean(M2.pCO2_daily(tmp_ind));
        M2.chl_monthly(m,t) = nanmean(M2.chl_daily(tmp_ind));
        M2.time_monthly(m,t) = nanmean(M2.days(tmp_ind));
    end
end

NH10.years = min(year(NH10.days)):1:max(year(NH10.days));
for t = 1:length(NH10.years)
    for m = 1:12
        tmp_ind = isbetween(NH10.days,datetime(NH10.years(t),m,1),datetime(NH10.years(t),m,mon_end(m),23,59,59));
        NH10.SST_monthly(m,t) = nanmean(NH10.SST_daily(tmp_ind));
        NH10.SSS_monthly(m,t) = nanmean(NH10.SSS_daily(tmp_ind));
        NH10.pCO2_monthly(m,t) = nanmean(NH10.pCO2_daily(tmp_ind));
        NH10.chl_monthly(m,t) = nanmean(NH10.chl_daily(tmp_ind));
        NH10.time_monthly(m,t) = nanmean(NH10.days(tmp_ind));
    end
end

PAPA.years = min(year(PAPA.days)):1:max(year(PAPA.days));
for t = 1:length(PAPA.years)
    for m = 1:12
        tmp_ind = isbetween(PAPA.days,datetime(PAPA.years(t),m,1),datetime(PAPA.years(t),m,mon_end(m),23,59,59));
        PAPA.SST_monthly(m,t) = nanmean(PAPA.SST_daily(tmp_ind));
        PAPA.SSS_monthly(m,t) = nanmean(PAPA.SSS_daily(tmp_ind));
        PAPA.pCO2_monthly(m,t) = nanmean(PAPA.pCO2_daily(tmp_ind));
        PAPA.chl_monthly(m,t) = nanmean(PAPA.chl_daily(tmp_ind));
        PAPA.TA_monthly(m,t) = nanmean(PAPA.TA_daily(tmp_ind));
        PAPA.DIC_monthly(m,t) = nanmean(PAPA.DIC_daily(tmp_ind));
        PAPA.time_monthly(m,t) = nanmean(PAPA.days(tmp_ind));
    end
end

for t = 1:length(PAPA.years)
    for m = 1:12
        PAPA.pCO2_T(m,t) = nanmean(PAPA.pCO2_monthly(:,t),1) * exp(0.0413 * (PAPA.SST_monthly(m,t) - nanmean(PAPA.SST_monthly(:,t),1)));
        PAPA.pCO2_nonT(m,t) = PAPA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(PAPA.SST_monthly(:,t),1) - PAPA.SST_monthly(m,t)));
    end
end

% Calculate monthly climatologies for model during years of mooring obs
tmp_ind = isbetween(model.time,datetime(CCE1.years(1),1,1),datetime(CCE1.years(end),12,31,23,59,59));
% Switched away from this method to monthly below in order to get the
% errorbars but leaving this code here for now.

% model_CCE1.SST_clim = climatology(model_CCE1.SST(tmp_ind),model.time(tmp_ind));
% model_CCE1.SSS_clim = climatology(model_CCE1.SSS(tmp_ind),model.time(tmp_ind));
% model_CCE1.pCO2_clim = climatology(model_CCE1.pCO2(tmp_ind),model.time(tmp_ind));
% model_CCE1.chl_clim = climatology(model_CCE1.chl(tmp_ind),model.time(tmp_ind));
% model_CCE1.oxy_clim = climatology(model_CCE1.oxy(tmp_ind),model.time(tmp_ind));
% model_CCE1.DIC_clim = climatology(model_CCE1.DIC(tmp_ind),model.time(tmp_ind));

for m = 1:12
    model_CCE1.SST_monavg(m) = monthly(model_CCE1.SST(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.SSS_monavg(m) = monthly(model_CCE1.SSS(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.pCO2_monavg(m) = monthly(model_CCE1.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.chl_monavg(m) = monthly(model_CCE1.chl(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.oxy_monavg(m) = monthly(model_CCE1.oxy(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.DIC_monavg(m) = monthly(model_CCE1.DIC(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.TA_monavg(m) = monthly(model_CCE1.TA(tmp_ind),model.time(tmp_ind),m);
    model_CCE1.SST_monstd(m) = monthly(model_CCE1.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.SSS_monstd(m) = monthly(model_CCE1.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.pCO2_monstd(m) = monthly(model_CCE1.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.chl_monstd(m) = monthly(model_CCE1.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.oxy_monstd(m) = monthly(model_CCE1.oxy(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.DIC_monstd(m) = monthly(model_CCE1.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE1.TA_monstd(m) = monthly(model_CCE1.TA(tmp_ind),model.time(tmp_ind),m,@std);
end


for t = 1:length(CCE1.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(CCE1.years(t),m,1),datetime(CCE1.years(t),m,mon_end(m),23,59,59));
        model_CCE1.SST_monthly(m,t) = nanmean(model_CCE1.SST(tmp_ind2));
        model_CCE1.pCO2_monthly(m,t) = nanmean(model_CCE1.pCO2(tmp_ind2));
    end
end

for t = 1:length(CCE1.years)
    for m = 1:12
        model_CCE1.pCO2_T(m,t) = nanmean(model_CCE1.pCO2_monthly(:,t),1) * exp(0.0413 * (model_CCE1.SST_monthly(m,t) - nanmean(model_CCE1.SST_monthly(:,t),1)));
        model_CCE1.pCO2_nonT(m,t) = model_CCE1.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_CCE1.SST_monthly(:,t),1) - model_CCE1.SST_monthly(m,t)));
    end
end


tmp_ind = isbetween(model.time,datetime(CCE2.years(1),1,1),datetime(CCE2.years(end),12,31,23,59,59));

for m = 1:12
    model_CCE2.SST_monavg(m) = monthly(model_CCE2.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_CCE2.SSS_monavg(m) = monthly(model_CCE2.SSS(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.pCO2_monavg(m) = monthly(model_CCE2.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.chl_monavg(m) = monthly(model_CCE2.chl(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.oxy_monavg(m) = monthly(model_CCE2.oxy(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.DIC_monavg(m) = monthly(model_CCE2.DIC(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.TA_monavg(m) = monthly(model_CCE2.TA(tmp_ind),model.time(tmp_ind),m);
    model_CCE2.SST_monstd(m) = monthly(model_CCE2.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.SSS_monstd(m) = monthly(model_CCE2.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.pCO2_monstd(m) = monthly(model_CCE2.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.chl_monstd(m) = monthly(model_CCE2.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.oxy_monstd(m) = monthly(model_CCE2.oxy(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.DIC_monstd(m) = monthly(model_CCE2.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_CCE2.TA_monstd(m) = monthly(model_CCE2.TA(tmp_ind),model.time(tmp_ind),m,@std);
end

for t = 1:length(CCE2.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(CCE2.years(t),m,1),datetime(CCE2.years(t),m,mon_end(m),23,59,59));
        model_CCE2.SST_monthly(m,t) = nanmean(model_CCE2.SST(tmp_ind2));
        model_CCE2.pCO2_monthly(m,t) = nanmean(model_CCE2.pCO2(tmp_ind2));
    end
end

for t = 1:length(CCE2.years)
    for m = 1:12
        model_CCE2.pCO2_T(m,t) = nanmean(model_CCE2.pCO2_monthly(:,t),1) * exp(0.0413 * (model_CCE2.SST_monthly(m,t) - nanmean(model_CCE2.SST_monthly(:,t),1)));
        model_CCE2.pCO2_nonT(m,t) = model_CCE2.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_CCE2.SST_monthly(:,t),1) - model_CCE2.SST_monthly(m,t)));
    end
end

tmp_ind = isbetween(model.time,datetime(Arago.years(1),1,1),datetime(Arago.years(end),12,31,23,59,59));

for m = 1:12
    model_Arago.SST_monavg(m) = monthly(model_Arago.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_Arago.SSS_monavg(m) = monthly(model_Arago.SSS(tmp_ind),model.time(tmp_ind),m);
    model_Arago.pCO2_monavg(m) = monthly(model_Arago.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_Arago.chl_monavg(m) = monthly(model_Arago.chl(tmp_ind),model.time(tmp_ind),m);
    model_Arago.oxy_monavg(m) = monthly(model_Arago.oxy(tmp_ind),model.time(tmp_ind),m);
    model_Arago.DIC_monavg(m) = monthly(model_Arago.DIC(tmp_ind),model.time(tmp_ind),m);
    model_Arago.TA_monavg(m) = monthly(model_Arago.TA(tmp_ind),model.time(tmp_ind),m);
    model_Arago.SST_monstd(m) = monthly(model_Arago.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.SSS_monstd(m) = monthly(model_Arago.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.pCO2_monstd(m) = monthly(model_Arago.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.chl_monstd(m) = monthly(model_Arago.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.oxy_monstd(m) = monthly(model_Arago.oxy(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.DIC_monstd(m) = monthly(model_Arago.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_Arago.TA_monstd(m) = monthly(model_Arago.TA(tmp_ind),model.time(tmp_ind),m,@std);
end

for t = 1:length(Arago.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(Arago.years(t),m,1),datetime(Arago.years(t),m,mon_end(m),23,59,59));
        model_Arago.SST_monthly(m,t) = nanmean(model_Arago.SST(tmp_ind2));
        model_Arago.pCO2_monthly(m,t) = nanmean(model_Arago.pCO2(tmp_ind2));
    end
end

for t = 1:length(Arago.years)
    for m = 1:12
        model_Arago.pCO2_T(m,t) = nanmean(model_Arago.pCO2_monthly(:,t),1) * exp(0.0413 * (model_Arago.SST_monthly(m,t) - nanmean(model_Arago.SST_monthly(:,t),1)));
        model_Arago.pCO2_nonT(m,t) = model_Arago.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_Arago.SST_monthly(:,t),1) - model_Arago.SST_monthly(m,t)));
    end
end

tmp_ind = isbetween(model.time,datetime(Elizabeth.years(1),1,1),datetime(Elizabeth.years(end),12,31,23,59,59));

for m = 1:12
    model_Elizabeth.SST_monavg(m) = monthly(model_Elizabeth.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_Elizabeth.SSS_monavg(m) = monthly(model_Elizabeth.SSS(tmp_ind),model.time(tmp_ind),m);
    model_Elizabeth.pCO2_monavg(m) = monthly(model_Elizabeth.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_Elizabeth.chl_monavg(m) = monthly(model_Elizabeth.chl(tmp_ind),model.time(tmp_ind),m);
    model_Elizabeth.DIC_monavg(m) = monthly(model_Elizabeth.DIC(tmp_ind),model.time(tmp_ind),m);
    model_Elizabeth.TA_monavg(m) = monthly(model_Elizabeth.TA(tmp_ind),model.time(tmp_ind),m);
    model_Elizabeth.SST_monstd(m) = monthly(model_Elizabeth.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_Elizabeth.SSS_monstd(m) = monthly(model_Elizabeth.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_Elizabeth.pCO2_monstd(m) = monthly(model_Elizabeth.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_Elizabeth.chl_monstd(m) = monthly(model_Elizabeth.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_Elizabeth.DIC_monstd(m) = monthly(model_Elizabeth.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_Elizabeth.TA_monstd(m) = monthly(model_Elizabeth.TA(tmp_ind),model.time(tmp_ind),m,@std);
end

tmp_ind = isbetween(model.time,datetime(CHABA.years(1),1,1),datetime(CHABA.years(end),12,31,23,59,59));

for m = 1:12
    model_CHABA.SST_monavg(m) = monthly(model_CHABA.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_CHABA.SSS_monavg(m) = monthly(model_CHABA.SSS(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.pCO2_monavg(m) = monthly(model_CHABA.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.chl_monavg(m) = monthly(model_CHABA.chl(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.oxy_monavg(m) = monthly(model_CHABA.oxy(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.DIC_monavg(m) = monthly(model_CHABA.DIC(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.TA_monavg(m) = monthly(model_CHABA.TA(tmp_ind),model.time(tmp_ind),m);
    model_CHABA.SST_monstd(m) = monthly(model_CHABA.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.SSS_monstd(m) = monthly(model_CHABA.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.pCO2_monstd(m) = monthly(model_CHABA.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.chl_monstd(m) = monthly(model_CHABA.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.oxy_monstd(m) = monthly(model_CHABA.oxy(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.DIC_monstd(m) = monthly(model_CHABA.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_CHABA.TA_monstd(m) = monthly(model_CHABA.TA(tmp_ind),model.time(tmp_ind),m,@std);
end

for t = 1:length(CHABA.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(CHABA.years(t),m,1),datetime(CHABA.years(t),m,mon_end(m),23,59,59));
        model_CHABA.SST_monthly(m,t) = nanmean(model_CHABA.SST(tmp_ind2));
        model_CHABA.pCO2_monthly(m,t) = nanmean(model_CHABA.pCO2(tmp_ind2));
    end
end

for t = 1:length(CHABA.years)
    for m = 1:12
        model_CHABA.pCO2_T(m,t) = nanmean(model_CHABA.pCO2_monthly(:,t),1) * exp(0.0413 * (model_CHABA.SST_monthly(m,t) - nanmean(model_CHABA.SST_monthly(:,t),1)));
        model_CHABA.pCO2_nonT(m,t) = model_CHABA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_CHABA.SST_monthly(:,t),1) - model_CHABA.SST_monthly(m,t)));
    end
end

tmp_ind = isbetween(model.time,datetime(GAKOA.years(1),1,1),datetime(GAKOA.years(end),12,31,23,59,59));

for m = 1:12
    model_GAKOA.SST_monavg(m) = monthly(model_GAKOA.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_GAKOA.SSS_monavg(m) = monthly(model_GAKOA.SSS(tmp_ind),model.time(tmp_ind),m);
    model_GAKOA.pCO2_monavg(m) = monthly(model_GAKOA.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_GAKOA.chl_monavg(m) = monthly(model_GAKOA.chl(tmp_ind),model.time(tmp_ind),m);
    model_GAKOA.DIC_monavg(m) = monthly(model_GAKOA.DIC(tmp_ind),model.time(tmp_ind),m);
    model_GAKOA.SST_monstd(m) = monthly(model_GAKOA.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_GAKOA.SSS_monstd(m) = monthly(model_GAKOA.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_GAKOA.pCO2_monstd(m) = monthly(model_GAKOA.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_GAKOA.chl_monstd(m) = monthly(model_GAKOA.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_GAKOA.DIC_monstd(m) = monthly(model_GAKOA.DIC(tmp_ind),model.time(tmp_ind),m,@std);
end

for t = 1:length(GAKOA.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(GAKOA.years(t),m,1),datetime(GAKOA.years(t),m,mon_end(m),23,59,59));
        model_GAKOA.SST_monthly(m,t) = nanmean(model_GAKOA.SST(tmp_ind2));
        model_GAKOA.pCO2_monthly(m,t) = nanmean(model_GAKOA.pCO2(tmp_ind2));
    end
end

for t = 1:length(GAKOA.years)
    for m = 1:12
        model_GAKOA.pCO2_T(m,t) = nanmean(model_GAKOA.pCO2_monthly(:,t),1) * exp(0.0413 * (model_GAKOA.SST_monthly(m,t) - nanmean(model_GAKOA.SST_monthly(:,t),1)));
        model_GAKOA.pCO2_nonT(m,t) = model_GAKOA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_GAKOA.SST_monthly(:,t),1) - model_GAKOA.SST_monthly(m,t)));
    end
end

tmp_ind = isbetween(model.time,datetime(M2.years(1),1,1),datetime(M2.years(end),12,31,23,59,59));

for m = 1:12
    model_M2.SST_monavg(m) = monthly(model_M2.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_M2.SSS_monavg(m) = monthly(model_M2.SSS(tmp_ind),model.time(tmp_ind),m);
    model_M2.pCO2_monavg(m) = monthly(model_M2.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_M2.chl_monavg(m) = monthly(model_M2.chl(tmp_ind),model.time(tmp_ind),m);
    model_M2.DIC_monavg(m) = monthly(model_M2.DIC(tmp_ind),model.time(tmp_ind),m);
    model_M2.SST_monstd(m) = monthly(model_M2.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_M2.SSS_monstd(m) = monthly(model_M2.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_M2.pCO2_monstd(m) = monthly(model_M2.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_M2.chl_monstd(m) = monthly(model_M2.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_M2.DIC_monstd(m) = monthly(model_M2.DIC(tmp_ind),model.time(tmp_ind),m,@std);
end

tmp_ind = isbetween(model.time,datetime(NH10.years(1),1,1),datetime(NH10.years(end),12,31,23,59,59));

for m = 1:12
    model_NH10.SST_monavg(m) = monthly(model_NH10.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_NH10.SSS_monavg(m) = monthly(model_NH10.SSS(tmp_ind),model.time(tmp_ind),m);
    model_NH10.pCO2_monavg(m) = monthly(model_NH10.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_NH10.chl_monavg(m) = monthly(model_NH10.chl(tmp_ind),model.time(tmp_ind),m);
    model_NH10.DIC_monavg(m) = monthly(model_NH10.DIC(tmp_ind),model.time(tmp_ind),m);
    model_NH10.SST_monstd(m) = monthly(model_NH10.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_NH10.SSS_monstd(m) = monthly(model_NH10.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_NH10.pCO2_monstd(m) = monthly(model_NH10.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_NH10.chl_monstd(m) = monthly(model_NH10.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_NH10.DIC_monstd(m) = monthly(model_NH10.DIC(tmp_ind),model.time(tmp_ind),m,@std);
end

tmp_ind = isbetween(model.time,datetime(PAPA.years(1),1,1),datetime(PAPA.years(end),12,31,23,59,59));

for m = 1:12
    model_PAPA.SST_monavg(m) = monthly(model_PAPA.SST(tmp_ind),model.time(tmp_ind),m); % This gives a very slighlty different answer than climatology
    model_PAPA.SSS_monavg(m) = monthly(model_PAPA.SSS(tmp_ind),model.time(tmp_ind),m);
    model_PAPA.pCO2_monavg(m) = monthly(model_PAPA.pCO2(tmp_ind),model.time(tmp_ind),m);
    model_PAPA.chl_monavg(m) = monthly(model_PAPA.chl(tmp_ind),model.time(tmp_ind),m);
    model_PAPA.DIC_monavg(m) = monthly(model_PAPA.DIC(tmp_ind),model.time(tmp_ind),m);
    model_PAPA.TA_monavg(m) = monthly(model_PAPA.TA(tmp_ind),model.time(tmp_ind),m);
    model_PAPA.SST_monstd(m) = monthly(model_PAPA.SST(tmp_ind),model.time(tmp_ind),m,@std);
    model_PAPA.SSS_monstd(m) = monthly(model_PAPA.SSS(tmp_ind),model.time(tmp_ind),m,@std);
    model_PAPA.pCO2_monstd(m) = monthly(model_PAPA.pCO2(tmp_ind),model.time(tmp_ind),m,@std);
    model_PAPA.chl_monstd(m) = monthly(model_PAPA.chl(tmp_ind),model.time(tmp_ind),m,@std);
    model_PAPA.DIC_monstd(m) = monthly(model_PAPA.DIC(tmp_ind),model.time(tmp_ind),m,@std);
    model_PAPA.TA_monstd(m) = monthly(model_PAPA.TA(tmp_ind),model.time(tmp_ind),m,@std);
end

for t = 1:length(PAPA.years)
    for m = 1:12
        tmp_ind2 = isbetween(model.time,datetime(PAPA.years(t),m,1),datetime(PAPA.years(t),m,mon_end(m),23,59,59));
        model_PAPA.SST_monthly(m,t) = nanmean(model_PAPA.SST(tmp_ind2));
        model_PAPA.pCO2_monthly(m,t) = nanmean(model_PAPA.pCO2(tmp_ind2));
    end
end

for t = 1:length(PAPA.years)
    for m = 1:12
        model_PAPA.pCO2_T(m,t) = nanmean(model_PAPA.pCO2_monthly(:,t),1) * exp(0.0413 * (model_PAPA.SST_monthly(m,t) - nanmean(model_PAPA.SST_monthly(:,t),1)));
        model_PAPA.pCO2_nonT(m,t) = model_PAPA.pCO2_monthly(m,t) * exp(0.0413 * (nanmean(model_PAPA.SST_monthly(:,t),1) - model_PAPA.SST_monthly(m,t)));
    end
end


%% 

if (plt_daily)

% Plot figures
% CCE1
figure(1); set(gcf, 'units','centimeters','position',[10 20 23 23]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
plot(CCE1.days,CCE1.SST_daily,'b.','Markersize',8)
hold on
plot(model.time,model_CCE1.SST,'k','Linewidth',2)
xlim([CCE1.days(1) CCE1.days(end)])
ylabel('Temperature ({\circ}C)','Fontsize',14); xlabel('Year','Fontsize',14) 
title('CCE1 SST','FontSize',16)

subplot(3,1,2)
plot(CCE1.days,CCE1.SSS_daily,'b.','Markersize',8)
hold on
plot(model.time,model_CCE1.SSS,'k','Linewidth',2)
xlim([CCE1.days(1) CCE1.days(end)])
ylabel('Salinity','Fontsize',14); xlabel('Year','Fontsize',14)
title('CCE1 SSS','FontSize',16)

subplot(3,1,3)
plot(CCE1.days,CCE1.pCO2_daily,'b.','Markersize',8)
hold on
plot(model.time,model_CCE1.pCO2,'k','Linewidth',2)
xlim([CCE1.days(1) CCE1.days(end)])
ylabel('pCO_2 ({\mu}atm)','Fontsize',14); xlabel('Year','Fontsize',14)
title('CCE1 pCO2','FontSize',16)

end % plt_daily
%% 
if (plt_monthly)

% Monthly averaged figures
% CCE1 monthly
figure(2); set(gcf, 'units','centimeters','position',[10 20 23 23]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
p1 = plot(mean(CCE1.SST_monthly,2,'omitnan'),'k','Linewidth',2);
hold on
errorbar(mean(CCE1.SST_monthly,2,'omitnan'),std(CCE1.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
p2 = shadedErrorBar([1:12],model_CCE1.SST_monavg,model_CCE1.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
ylabel('Temperature ({\circ}C)','FontSize',14)
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE1 SST','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Location','Northwest');

subplot(3,1,2)
errorbar(mean(CCE1.SSS_monthly,2,'omitnan'),std(CCE1.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.SSS_monavg,model_CCE1.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
ylabel('Salinity (psu)','Fontsize',14)
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE1 SSS','FontSize',16)

subplot(3,1,3)
errorbar(mean(CCE1.pCO2_monthly,2,'omitnan'),std(CCE1.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.pCO2_monavg,model_CCE1.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
ylabel('pCO2 ({\mu}atm)','Fontsize',14)
xlim([0.5 12.5])
xlabel('Month','Fontsize',14)
set(gca,'xtick',[1:12]);
title('CCE1 pCO2','FontSize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/CCE1_mooring_clim.jpg','Resolution',300);

figure(3); set(gcf, 'units','centimeters','position',[10 20 23 23]); set(gcf,'Color',[1 1 1]);
subplot(3,1,1)
plot(reshape(CHABA.time_monthly,[],1),reshape(CHABA.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CHABA.SST,'k','Linewidth',2)
xlim([CHABA.days(1) CHABA.days(end)])
ylabel('Temperature ({\circ}C)','Fontsize',14); xlabel('Year','Fontsize',14) 
title('CHABA SST','FontSize',16)
legend('Mooring','NEP10k','Location','Northwest')

subplot(3,1,2)
plot(reshape(CHABA.time_monthly,[],1),reshape(CHABA.SSS_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CHABA.SSS,'k','Linewidth',2)
xlim([CHABA.days(1) CHABA.days(end)])
ylabel('Salinity','Fontsize',14); xlabel('Year','Fontsize',14)
title('CHABA SSS','FontSize',16)

subplot(3,1,3)
plot(reshape(CHABA.time_monthly,[],1),reshape(CHABA.pCO2_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CHABA.pCO2,'k','Linewidth',2)
xlim([CHABA.days(1) CHABA.days(end)])
ylabel('pCO_2 ({\mu}atm)','Fontsize',14); xlabel('Year','Fontsize',14)
title('CHABA pCO2','FontSize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/CCE2_mooring_timeseries.jpg','Resolution',300);

figure(4); set(gcf, 'units','centimeters','position',[10 20 47 27]); set(gcf,'Color',[1 1 1]);
subplot(5,2,1)
plot(reshape(CCE1.time_monthly,[],1),reshape(CCE1.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CCE1.SST,'k','Linewidth',2)
xlim([CCE1.days(1) CCE1.days(end)])
title('CCE1 SST','FontSize',16)

subplot(5,2,2)
plot(reshape(CCE2.time_monthly,[],1),reshape(CCE2.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CCE2.SST,'k','Linewidth',2)
xlim([CCE2.days(1) CCE2.days(end)])
title('CCE2 SST','FontSize',16)

subplot(5,2,3)
plot(reshape(Arago.time_monthly,[],1),reshape(Arago.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_Arago.SST,'k','Linewidth',2)
xlim([Arago.days(1) Arago.days(end)])
title('Cape Arago SST','FontSize',16)

subplot(5,2,4)
plot(reshape(Elizabeth.time_monthly,[],1),reshape(Elizabeth.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_Elizabeth.SST,'k','Linewidth',2)
xlim([Elizabeth.days(1) Elizabeth.days(end)])
title('Cape Elizabeth SST','FontSize',16)

subplot(5,2,5)
plot(reshape(CHABA.time_monthly,[],1),reshape(CHABA.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_CHABA.SST,'k','Linewidth',2)
xlim([CHABA.days(1) CHABA.days(end)])
title('CHABA SST','FontSize',16)

subplot(5,2,6)
plot(reshape(GAKOA.time_monthly,[],1),reshape(GAKOA.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_GAKOA.SST,'k','Linewidth',2)
xlim([GAKOA.days(1) GAKOA.days(end)])
title('GAKOA SST','FontSize',16)

subplot(5,2,7)
plot(reshape(M2.time_monthly,[],1),reshape(M2.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_M2.SST,'k','Linewidth',2)
xlim([M2.days(1) M2.days(end)])
title('M2 SST','FontSize',16)

subplot(5,2,8)
plot(reshape(NH10.time_monthly,[],1),reshape(NH10.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_NH10.SST,'k','Linewidth',2)
xlim([NH10.days(1) NH10.days(end)])
title('NH10 SST','FontSize',16)

subplot(5,2,9)
plot(reshape(PAPA.time_monthly,[],1),reshape(PAPA.SST_monthly,[],1),'b','LineWidth',2)
hold on
plot(model.time,model_PAPA.SST,'k','Linewidth',2)
xlim([PAPA.days(1) PAPA.days(end)])
title('PAPA SST','FontSize',16)
lx = legend('OBS','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/SST_moorings_timeseries.jpg','Resolution',300);

figure(5); set(gcf, 'units','centimeters','position',[10 20 47 27]); set(gcf,'Color',[1 1 1]);
subplot(5,2,1)
errorbar(mean(CCE1.pCO2_monthly,2,'omitnan'),std(CCE1.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.pCO2_monavg,model_CCE1.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE1 pCO2','FontSize',16)

subplot(5,2,2)
errorbar(mean(CCE2.pCO2_monthly,2,'omitnan'),std(CCE2.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.pCO2_monavg,model_CCE2.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE2 pCO2','FontSize',16)

subplot(5,2,3)
errorbar(mean(Arago.pCO2_monthly,2,'omitnan'),std(Arago.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.pCO2_monavg,model_Arago.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Arago pCO2','FontSize',16)

subplot(5,2,4)
errorbar(mean(Elizabeth.pCO2_monthly,2,'omitnan'),std(Elizabeth.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.pCO2_monavg,model_Elizabeth.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Elizabeth pCO2','FontSize',16)

subplot(5,2,5)
errorbar(mean(CHABA.pCO2_monthly,2,'omitnan'),std(CHABA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.pCO2_monavg,model_CHABA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CHABA pCO2','FontSize',16)

subplot(5,2,6)
errorbar(mean(GAKOA.pCO2_monthly,2,'omitnan'),std(GAKOA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_GAKOA.pCO2_monavg,model_GAKOA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('GAKOA pCO2','FontSize',16)

subplot(5,2,7)
errorbar(mean(M2.pCO2_monthly,2,'omitnan'),std(M2.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_M2.pCO2_monavg,model_M2.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
ylim([200 500])
set(gca,'xtick',[1:12]);
title('M2 pCO2','FontSize',16)

subplot(5,2,8)
errorbar(mean(NH10.pCO2_monthly,2,'omitnan'),std(NH10.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_NH10.pCO2_monavg,model_NH10.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('NH10 pCO2','FontSize',16)

subplot(5,2,9)
p1 = plot(mean(PAPA.pCO2_monthly,2,'omitnan'),'k','Linewidth',2);
hold on
errorbar(mean(PAPA.pCO2_monthly,2,'omitnan'),std(PAPA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2);
p2 = shadedErrorBar([1:12],model_PAPA.pCO2_monavg,model_PAPA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('PAPA pCO2','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_moorings_timeseries_errbar.jpg','Resolution',300);

figure(6); set(gcf, 'units','centimeters','position',[10 20 47 27]); set(gcf,'Color',[1 1 1]);
subplot(5,2,1)
errorbar(mean(CCE1.SST_monthly,2,'omitnan'),std(CCE1.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.SST_monavg,model_CCE1.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE1 SST','FontSize',16)

subplot(5,2,2)
errorbar(mean(CCE2.SST_monthly,2,'omitnan'),std(CCE2.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.SST_monavg,model_CCE2.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE2 SST','FontSize',16)

subplot(5,2,3)
errorbar(mean(Arago.SST_monthly,2,'omitnan'),std(Arago.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.SST_monavg,model_Arago.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Arago SST','FontSize',16)

subplot(5,2,4)
errorbar(mean(Elizabeth.SST_monthly,2,'omitnan'),std(Elizabeth.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.SST_monavg,model_Elizabeth.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Elizabeth SST','FontSize',16)

subplot(5,2,5)
errorbar(mean(CHABA.SST_monthly,2,'omitnan'),std(CHABA.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.SST_monavg,model_CHABA.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CHABA SST','FontSize',16)

subplot(5,2,6)
errorbar(mean(GAKOA.SST_monthly,2,'omitnan'),std(GAKOA.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_GAKOA.SST_monavg,model_GAKOA.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('GAKOA SST','FontSize',16)

subplot(5,2,7)
errorbar(mean(M2.SST_monthly,2,'omitnan'),std(M2.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_M2.SST_monavg,model_M2.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('M2 SST','FontSize',16)

subplot(5,2,8)
errorbar(mean(NH10.SST_monthly,2,'omitnan'),std(NH10.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_NH10.SST_monavg,model_NH10.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('NH10 SST','FontSize',16)

subplot(5,2,9)
p1 = plot(mean(PAPA.SST_monthly,2,'omitnan'),'k','Linewidth',2);
hold on
errorbar(mean(PAPA.SST_monthly,2,'omitnan'),std(PAPA.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
p2 = shadedErrorBar([1:12],model_PAPA.SST_monavg,model_PAPA.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('PAPA SST','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/SST_moorings_timeseries_errbar.jpg','Resolution',300);

figure(7); set(gcf, 'units','centimeters','position',[10 20 47 27]); set(gcf,'Color',[1 1 1]);
subplot(5,2,1)
errorbar(mean(CCE1.SSS_monthly,2,'omitnan'),std(CCE1.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.SSS_monavg,model_CCE1.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE1 SSS','FontSize',16)

subplot(5,2,2)
errorbar(mean(CCE2.SSS_monthly,2,'omitnan'),std(CCE2.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.SSS_monavg,model_CCE2.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CCE2 SSS','FontSize',16)

subplot(5,2,3)
errorbar(mean(Arago.SSS_monthly,2,'omitnan'),std(Arago.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.SSS_monavg,model_Arago.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Arago SSS','FontSize',16)

subplot(5,2,4)
errorbar(mean(Elizabeth.SSS_monthly,2,'omitnan'),std(Elizabeth.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.SSS_monavg,model_Elizabeth.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('Cape Elizabeth SSS','FontSize',16)

subplot(5,2,5)
errorbar(mean(CHABA.SSS_monthly,2,'omitnan'),std(CHABA.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.SSS_monavg,model_CHABA.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('CHABA SSS','FontSize',16)

subplot(5,2,6)
errorbar(mean(GAKOA.SSS_monthly,2,'omitnan'),std(GAKOA.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_GAKOA.SSS_monavg,model_GAKOA.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('GAKOA SSS','FontSize',16)

subplot(5,2,7)
errorbar(mean(M2.SSS_monthly,2,'omitnan'),std(M2.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_M2.SSS_monavg,model_M2.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('M2 SSS','FontSize',16)

subplot(5,2,8)
errorbar(mean(NH10.SSS_monthly,2,'omitnan'),std(NH10.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_NH10.SSS_monavg,model_NH10.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('NH10 SSS','FontSize',16)

subplot(5,2,9)
p1 = plot(mean(PAPA.SSS_monthly,2,'omitnan'),'k','Linewidth',2);
hold on
errorbar(mean(PAPA.SSS_monthly,2,'omitnan'),std(PAPA.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
p2 = shadedErrorBar([1:12],model_PAPA.SSS_monavg,model_PAPA.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5])
set(gca,'xtick',[1:12]);
title('PAPA SSS','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/SSS_moorings_timeseries_errbar.jpg','Resolution',300);

figure(8); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(mean(CCE1.SST_monthly,2,'omitnan'),std(CCE1.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.SST_monavg,model_CCE1.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('CCE1','FontSize',16)

subplot(3,2,2)
errorbar(mean(CCE2.SST_monthly,2,'omitnan'),std(CCE2.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.SST_monavg,model_CCE2.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('CCE2','FontSize',16)

subplot(3,2,3)
errorbar(mean(Arago.SST_monthly,2,'omitnan'),std(Arago.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.SST_monavg,model_Arago.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(3,2,4)
errorbar(mean(Elizabeth.SST_monthly,2,'omitnan'),std(Elizabeth.SST_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.SST_monavg,model_Elizabeth.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(3,2,5)
p1 = errorbar(mean(CHABA.SST_monthly,2,'omitnan'),std(CHABA.SST_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.SST_monavg,model_CHABA.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('Cha Ba','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/SST_moorings_timeseries_errbar_CCS.jpg','Resolution',300);

figure(9); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(mean(CCE1.SSS_monthly,2,'omitnan'),std(CCE1.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.SSS_monavg,model_CCE1.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('CCE1','FontSize',16)

subplot(3,2,2)
errorbar(mean(CCE2.SSS_monthly,2,'omitnan'),std(CCE2.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.SSS_monavg,model_CCE2.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('CCE2','FontSize',16)

subplot(3,2,3)
errorbar(mean(Arago.SSS_monthly,2,'omitnan'),std(Arago.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.SSS_monavg,model_Arago.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(3,2,4)
errorbar(mean(Elizabeth.SSS_monthly,2,'omitnan'),std(Elizabeth.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.SSS_monavg,model_Elizabeth.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(3,2,5)
p1 = errorbar(mean(CHABA.SSS_monthly,2,'omitnan'),std(CHABA.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.SSS_monavg,model_CHABA.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('Cha Ba','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/SSS_moorings_timeseries_errbar_CCS.jpg','Resolution',300);

figure(10); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(mean(CCE1.pCO2_monthly,2,'omitnan'),std(CCE1.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.pCO2_monavg,model_CCE1.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('CCE1','FontSize',16)

subplot(3,2,2)
errorbar(mean(CCE2.pCO2_monthly,2,'omitnan'),std(CCE2.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.pCO2_monavg,model_CCE2.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('CCE2','FontSize',16)

subplot(3,2,3)
errorbar(mean(Arago.pCO2_monthly,2,'omitnan'),std(Arago.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.pCO2_monavg,model_Arago.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(3,2,4)
errorbar(mean(Elizabeth.pCO2_monthly,2,'omitnan'),std(Elizabeth.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Elizabeth.pCO2_monavg,model_Elizabeth.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(3,2,5)
p1 = errorbar(mean(CHABA.pCO2_monthly,2,'omitnan'),std(CHABA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.pCO2_monavg,model_CHABA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('Cha Ba','FontSize',16)
xlabel('Month','Fontsize',14)
%lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

subplot(3,2,6)
p1 = errorbar(mean(PAPA.pCO2_monthly,2,'omitnan'),std(PAPA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_PAPA.pCO2_monavg,model_PAPA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
title('PAPA','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.465 .001 .1 .1],'Orientation','horizontal');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_moorings_timeseries_errbar_CCS_V2.jpg','Resolution',300);

figure(11); set(gcf, 'units','centimeters','position',[10 20 23 23]); set(gcf,'Color',[1 1 1]);
subplot(2,1,1)
plot(M2.days,M2.pCO2_daily,'b.','Markersize',8)
hold on
plot(model.time,model_M2.pCO2,'k','Linewidth',2)
xlim([M2.days(1) M2.days(end)])
ylabel('pCO_2 ({\mu}atm)','Fontsize',14); xlabel('Year','Fontsize',14)
title('M2 pCO2','FontSize',16)
legend('Mooring','Model','Location','Northwest')

subplot(2,1,2)
plot(GAKOA.days,GAKOA.pCO2_daily,'b.','Markersize',8)
hold on
plot(model.time,model_GAKOA.pCO2,'k','Linewidth',2)
xlim([GAKOA.days(1) GAKOA.days(end)])
ylabel('pCO_2 ({\mu}atm)','Fontsize',14); xlabel('Year','Fontsize',14)
title('GAKOA pCO2','FontSize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_M2_GAKOA_daily.jpg','Resolution',300);

figure(12); set(gcf, 'units','centimeters','position',[10 20 23 23]); set(gcf,'Color',[1 1 1]);
m_proj('Mercator','long',[180 255],'lat',[10 66])
[C,h] = m_contourf(model.lon,model.lat,squeeze(mean(model.pCO2(:,:,1:end-6),3)),[300:10:500]);
set(h,'LineColor','none')
hold on
m_scatter([235.05 235.27 235.5 239.186 237.5 210.5 195.94],[47.97 47.35 43.3 34.324 33.5 59.85 56.87],'k','filled') % 5 CCS, M2, GAKOA
m_scatter([215.1],[50.1],'k','filled') % PAPA
m_scatter([235.7],[44.6],'k','filled') % NH10
caxis([300 500])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[160:20:210],'ytick',[50:8:66],'linestyle','none','color','k','Fontsize',6);
title('1993-2024 NEP Annual pCO2','Fontsize',12)
cb = colorbar;
ylabel(cb,'({\mu}atm)','Fontsize',14)

%NH10 44.6°N, 124.3°W

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_ann_mean_spatial.jpg','Resolution',300);
%% 

figure(13); set(gcf, 'units','centimeters','position',[10 20 13 19]); set(gcf,'Color',[1 1 1]);
m_proj('Mercator','long',[232  245],'lat',[30 50])
%tmp = squeeze(mean(model.SSS(:,:,1:end-6),3)); fi = find(tmp < 28); tmp(fi) = 28;
tmp = squeeze(mean(model.DIC(:,:,1:end-6),3)); fi = find(tmp < 1800); tmp(fi) = 1800;
[C,h] = m_contourf(model.lon,model.lat,tmp,[1800:20:2200]);
%[C,h] = m_contourf(model.lon,model.lat,squeeze(mean(model.DIC(:,:,1:end-6),3)),[1800:20:2400]);
set(h,'LineColor','none')
hold on
m_scatter([235.05 235.27 235.5 239.186 237.5],[47.97 47.35 43.3 34.324 33.5],'k','filled')
caxis([1800 2200])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',12);
title('1993-2024 NEP Annual DIC','Fontsize',12)
cb = colorbar;
ylabel(cb,'DIC ({\mu}mol/kg)','Fontsize',14)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/DIC_CCS_ann_mean_spatial.jpg','Resolution',300);
%% 

figure(14); set(gcf, 'units','centimeters','position',[10 20 19 11]); set(gcf,'Color',[1 1 1]);
%m_proj('Mercator','long',[232  245],'lat',[30 50])
m_proj('Mercator','long',[180 245],'lat',[50 66])
[C,h] = m_contourf(model.lon,model.lat,squeeze(mean(model.pCO2(:,:,1:end-6),3)),[300:10:500]);
set(h,'LineColor','none')
hold on
m_scatter([210.5 195.94],[59.85 56.87],'k','filled')
caxis([300 500])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[180:10:245],'ytick',[50:5:66],'linestyle','none','color','k','Fontsize',12);
title('1993-2024 NEP Annual pCO2','Fontsize',12)
cb = colorbar;
ylabel(cb,'({\mu}atm)','Fontsize',14)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_AK_ann_mean_spatial.jpg','Resolution',300);

figure(15); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(2,2,1)
errorbar(mean(CCE1.chl_monthly,2,'omitnan'),std(CCE1.chl_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE1.chl_monavg,model_CCE1.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',12); ylabel('Chl ({\mu}g/l)','Fontsize',14)
title('CCE1','FontSize',16)

subplot(2,2,2)
errorbar(mean(CCE2.chl_monthly,2,'omitnan'),std(CCE2.chl_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CCE2.chl_monavg,model_CCE2.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',12); ylabel('Chl ({\mu}g/l)','Fontsize',14)
title('CCE2','FontSize',16)

subplot(2,2,3)
errorbar(mean(Arago.chl_monthly,2,'omitnan'),std(Arago.chl_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.chl_monavg,model_Arago.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',12); ylabel('Chl ({\mu}g/l)','Fontsize',14)
title('Cape Arago','FontSize',16)
xlabel('Month','Fontsize',14)

subplot(2,2,4)
p1 = errorbar(mean(CHABA.chl_monthly,2,'omitnan'),std(CHABA.chl_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.chl_monavg,model_CHABA.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',12); ylabel('Chl ({\mu}g/l)','Fontsize',14)
title('Cha Ba','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.465 .001 .1 .1],'Orientation','horizontal');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/chl_moorings_timeseries_errbar_CCS.jpg','Resolution',300);
%% 

figure(16); set(gcf, 'units','centimeters','position',[10 10 25 16]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,3,1);
m_proj('Mercator','long',[232  245],'lat',[30 50])
[C,h] = m_contourf(model.lon,model.lat,squeeze(mean(model.SST(:,:,1:end-6),3)),[8:.25:20]);
set(h,'LineColor','none')
hold on
m_scatter([235.05 235.27 235.5 239.186 237.5],[47.97 47.35 43.3 34.324 33.5],'k','filled')
caxis([8 20])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
title('Annual SST','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(1).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[8:4:20],'fontsize',12); ylabel(cb,'{\circ}C','Fontsize',14)


ax(2) = subplot(1,3,2);
m_proj('Mercator','long',[232  245],'lat',[30 50])
tmp = squeeze(mean(model.SSS(:,:,1:end-6),3)); fi = find(tmp < 28); tmp(fi) = 28; % To help plot salinity < 28 without extreme low colorbar limit
[C,h] = m_contourf(model.lon,model.lat,tmp,[28:.25:34]);
set(h,'LineColor','none')
hold on
m_scatter([235.05 235.27 235.5 239.186 237.5],[47.97 47.35 43.3 34.324 33.5],'k','filled')
caxis([28 34])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
title('Annual SSS','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(2).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[28:2:34],'fontsize',12); ylabel(cb,'Salinity','Fontsize',14); 

ax(3) = subplot(1,3,3);
m_proj('Mercator','long',[232  245],'lat',[30 50])
[C,h] = m_contourf(model.lon,model.lat,squeeze(mean(model.pCO2(:,:,1:end-6),3)),[300:10:500]);
set(h,'LineColor','none')
hold on
m_scatter([235.05 235.27 235.5 239.186 237.5],[47.97 47.35 43.3 34.324 33.5],'k','filled')
caxis([300 500])
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
title('Annual pCO2','Fontsize',14)
cb = colorbar; set(cb,'position',[ax(3).Position(1) .1 .215 .03],'orientation','horizontal','Fontsize',12)
set(cb,'YTick',[300:50:500],'fontsize',12); ylabel(cb,'{\mu}atm','Fontsize',14); 

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/3var_ann_mean_spatial.jpg','Resolution',300);
%% 

figure(17); set(gcf, 'units','centimeters','position',[10 10 25 13]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(2,2,1);
p1 = errorbar(mean(CHABA.SST_monthly,2,'omitnan'),std(CHABA.SST_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.SST_monavg,model_CHABA.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('Cha Ba SST','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Location','NorthWest','Fontsize',14);

ax(2) = subplot(2,2,2);
errorbar(mean(CHABA.SSS_monthly,2,'omitnan'),std(CHABA.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.SSS_monavg,model_CHABA.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('Cha Ba SSS','FontSize',16)

ax(3) = subplot(2,2,3);
errorbar(mean(CHABA.pCO2_monthly,2,'omitnan'),std(CHABA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.pCO2_monavg,model_CHABA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO2 ({\mu}atm)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cha Ba pCO2','FontSize',16)

ax(4) = subplot(2,2,4);
errorbar(mean(CHABA.chl_monthly,2,'omitnan'),std(CHABA.chl_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_CHABA.chl_monavg,model_CHABA.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Chl ({\mu}g/l)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cha Ba Chl','FontSize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/CHABA_vars_timeseries.jpg','Resolution',300);
%% 

figure(18); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(3,2,1);
errorbar(mean(Arago.SST_monthly,2,'omitnan'),std(Arago.SST_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_Arago.SST_monavg,model_Arago.SST_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('SST ({\circ}C)','Fontsize',14)
title('Cape Arago SST','FontSize',16)

ax(2) = subplot(3,2,2);
errorbar(mean(Arago.SSS_monthly,2,'omitnan'),std(Arago.SSS_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.SSS_monavg,model_Arago.SSS_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Salinity','Fontsize',14)
title('Cape Arago SSS','FontSize',16)

ax(3) = subplot(3,2,3);
errorbar(mean(Arago.pCO2_monthly,2,'omitnan'),std(Arago.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.pCO2_monavg,model_Arago.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO2 ({\mu}atm)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cape Arago pCO2','FontSize',16)

ax(4) = subplot(3,2,4);
errorbar(mean(Arago.chl_monthly,2,'omitnan'),std(Arago.chl_monthly,0,2,'omitnan'),'k','Linewidth',2)
hold on
shadedErrorBar([1:12],model_Arago.chl_monavg,model_Arago.chl_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Chl ({\mu}g/l)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cape Arago Chl','FontSize',16)

ax(5) = subplot(3,2,5);
p1 = errorbar(mean(Arago.oxy_monthly,2,'omitnan'),std(Arago.oxy_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_Arago.oxy_monavg,model_Arago.oxy_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('Oxygen ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cape Arago Oxygen','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.57 .12 .1 .1]);

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/Arago_5vars_timeseries.jpg','Resolution',300);
%% 

figure(19); set(gcf, 'units','centimeters','position',[10 20 47 27]); set(gcf,'Color',[1 1 1]);
subplot(4,2,1)
p2 = shadedErrorBar([1:12],model_CCE1.DIC_monavg,model_CCE1.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('CCE1','FontSize',16)

subplot(4,2,2)
p2 = shadedErrorBar([1:12],model_CCE2.DIC_monavg,model_CCE2.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('CCE2','FontSize',16)

subplot(4,2,3)
p2 = shadedErrorBar([1:12],model_Arago.DIC_monavg,model_Arago.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(4,2,4)
p2 = shadedErrorBar([1:12],model_Elizabeth.DIC_monavg,model_Elizabeth.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(4,2,5)
p2 = shadedErrorBar([1:12],model_CHABA.DIC_monavg,model_CHABA.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('Cha Ba','FontSize',16)

subplot(4,2,6)
p2 = shadedErrorBar([1:12],model_GAKOA.DIC_monavg,model_GAKOA.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('GAKOA','FontSize',16)

subplot(4,2,7)
p2 = shadedErrorBar([1:12],model_M2.DIC_monavg,model_M2.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('M2','FontSize',16)

subplot(4,2,8)
p2 = shadedErrorBar([1:12],model_PAPA.DIC_monavg,model_PAPA.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14); xlabel('Month','Fontsize',14)
title('PAPA','FontSize',16)
%% 

figure(20); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(3,2,1);
plot([1:12],nanmean(CCE1.pCO2_T,2),'b','Linewidth',2)
hold on
plot([1:12],nanmean(CCE1.pCO2_nonT,2),'g','Linewidth',2)
plot([1:12],nanmean(model_CCE1.pCO2_T,2),'b--','Linewidth',2)
plot([1:12],nanmean(model_CCE1.pCO2_nonT,2),'g--','Linewidth',2)
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO_2 ({\mu}atm)','Fontsize',12)
title('CCE1','FontSize',16)

ax(2) = subplot(3,2,2);
plot([1:12],nanmean(CCE2.pCO2_T,2),'b','Linewidth',2)
hold on
plot([1:12],nanmean(CCE2.pCO2_nonT,2),'g','Linewidth',2)
plot([1:12],nanmean(model_CCE2.pCO2_T,2),'b--','Linewidth',2)
plot([1:12],nanmean(model_CCE2.pCO2_nonT,2),'g--','Linewidth',2)
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10);
title('CCE2','FontSize',16)

ax(3) = subplot(3,2,3);
plot([1:12],nanmean(Arago.pCO2_T,2),'b','Linewidth',2)
hold on
plot([1:12],nanmean(Arago.pCO2_nonT,2),'g','Linewidth',2)
plot([1:12],nanmean(model_Arago.pCO2_T,2),'b--','Linewidth',2)
plot([1:12],nanmean(model_Arago.pCO2_nonT,2),'g--','Linewidth',2)
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO2 ({\mu}atm)','Fontsize',12);
title('Cape Arago','FontSize',16)

ax(4) = subplot(3,2,4);
plot([1:12],nanmean(CHABA.pCO2_T,2),'b','Linewidth',2)
hold on
plot([1:12],nanmean(CHABA.pCO2_nonT,2),'g','Linewidth',2)
plot([1:12],nanmean(model_CHABA.pCO2_T,2),'b--','Linewidth',2)
plot([1:12],nanmean(model_CHABA.pCO2_nonT,2),'g--','Linewidth',2)
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10);
title('Cha Ba','FontSize',16)

ax(5) = subplot(3,2,5);
plot([1:12],nanmean(PAPA.pCO2_T,2),'b','Linewidth',2)
hold on
plot([1:12],nanmean(PAPA.pCO2_nonT,2),'g','Linewidth',2)
plot([1:12],nanmean(model_PAPA.pCO2_T,2),'b--','Linewidth',2)
plot([1:12],nanmean(model_PAPA.pCO2_nonT,2),'g--','Linewidth',2)
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('pCO2 ({\mu}atm)','Fontsize',12); xlabel('Month','Fontsize',12)
title('PAPA','FontSize',16)

ax(6) = subplot(3,2,6);
p1 = plot([1:12],nanmean(GAKOA.pCO2_T,2),'b','Linewidth',2);
hold on
p2 = plot([1:12],nanmean(GAKOA.pCO2_nonT,2),'g','Linewidth',2);
p3 = plot([1:12],nanmean(model_GAKOA.pCO2_T,2),'b--','Linewidth',2);
p4 = plot([1:12],nanmean(model_GAKOA.pCO2_nonT,2),'g--','Linewidth',2);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); xlabel('Month','Fontsize',12)
title('GAKOA','FontSize',16)

lx = legend([p1,p2,p3,p4],'Mooring pCO2-T','Mooring pCO2-nonT','Model pCO2-T','Model pCO2-nonT','Fontsize',12,'Position',[.1 .005 .8 .05]);
lx.Orientation = "horizontal";

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/pCO2_decomp.jpg','Resolution',300);
%% 

figure(21); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(mean(CCE1.DIC_monthly,2,'omitnan'),std(CCE1.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_CCE1.DIC_monavg,model_CCE1.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('CCE1','FontSize',16)

subplot(3,2,2)
errorbar(mean(CCE2.DIC_monthly,2,'omitnan'),std(CCE2.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_CCE2.DIC_monavg,model_CCE2.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('CCE2','FontSize',16)

subplot(3,2,3)
errorbar(mean(Arago.DIC_monthly,2,'omitnan'),std(Arago.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_Arago.DIC_monavg,model_Arago.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(3,2,4)
errorbar(mean(Elizabeth.DIC_monthly,2,'omitnan'),std(Elizabeth.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_Elizabeth.DIC_monavg,model_Elizabeth.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(3,2,5)
p1 = errorbar(mean(CHABA.DIC_monthly,2,'omitnan'),std(CHABA.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_CHABA.DIC_monavg,model_CHABA.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('Cha Ba','FontSize',16)

subplot(3,2,6)
p1 = errorbar(mean(PAPA.DIC_monthly,2,'omitnan'),std(PAPA.DIC_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_PAPA.DIC_monavg,model_PAPA.DIC_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('DIC ({\mu}mol/kg)','Fontsize',14)
title('PAPA','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.465 .001 .1 .1],'Orientation','horizontal');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/DIC_moorings_timeseries_errbar_CCS.jpg','Resolution',300);
%% 

figure(22); set(gcf, 'units','centimeters','position',[10 20 30 17]); set(gcf,'Color',[1 1 1]);
subplot(3,2,1)
errorbar(mean(CCE1.TA_monthly,2,'omitnan'),std(CCE1.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_CCE1.TA_monavg,model_CCE1.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('CCE1','FontSize',16)

subplot(3,2,2)
errorbar(mean(CCE2.TA_monthly,2,'omitnan'),std(CCE2.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_CCE2.TA_monavg,model_CCE2.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('CCE2','FontSize',16)

subplot(3,2,3)
errorbar(mean(Arago.TA_monthly,2,'omitnan'),std(Arago.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_Arago.TA_monavg,model_Arago.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('Cape Arago','FontSize',16)

subplot(3,2,4)
errorbar(mean(Elizabeth.TA_monthly,2,'omitnan'),std(Elizabeth.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_Elizabeth.TA_monavg,model_Elizabeth.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('Cape Elizabeth','FontSize',16)

subplot(3,2,5)
errorbar(mean(CHABA.TA_monthly,2,'omitnan'),std(CHABA.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
shadedErrorBar([1:12],model_CHABA.TA_monavg,model_CHABA.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('Cha Ba','FontSize',16)

subplot(3,2,6)
p1 = errorbar(mean(PAPA.TA_monthly,2,'omitnan'),std(PAPA.TA_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_PAPA.TA_monavg,model_PAPA.TA_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',10); ylabel('TA ({\mu}mol/kg)','Fontsize',14)
title('PAPA','FontSize',16)
xlabel('Month','Fontsize',14)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Position',[.465 .001 .1 .1],'Orientation','horizontal');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/TA_moorings_timeseries_errbar_CCS.jpg','Resolution',300);
%% 

figure(23); set(gcf, 'units','centimeters','position',[10 20 19 11]); set(gcf,'Color',[1 1 1]);
p1 = errorbar(mean(GAKOA.pCO2_monthly,2,'omitnan'),std(GAKOA.pCO2_monthly,0,2,'omitnan'),'k','Linewidth',2);
hold on
p2 = shadedErrorBar([1:12],model_GAKOA.pCO2_monavg,model_GAKOA.pCO2_monstd,{'Color',[0.0660 0.4430 0.7450],'Linewidth',2},1);
xlim([0.5 12.5]); set(gca,'xtick',[1:12],'Fontsize',12); ylabel('pCO_2 ({\mu}atm)','Fontsize',14)
xlabel('Month','Fontsize',14)
title('GAKOA pCO2','FontSize',16)
lx = legend([p1,p2.mainLine],'Mooring','Model','Fontsize',14,'Location','Southeast');

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/moorings/GAKOA_pCO2_1panel.jpg','Resolution',300);

end %plt_monthly