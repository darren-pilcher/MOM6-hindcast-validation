% Script used to compare MOM6-NEP output to West Coast Ocean Acidification (WCOA) cruise data
% Start with surface and bottom for now since that's model output that is available
% created by DJP 01/25

close all
clear

% Uncomment to select variable and assorted plotting features/labels

var = 'oxy'; NEP_var = 'btm_o2'; depth = 1; cax(1) = 0; cax(2) = 160; cax(3) = -100; cax(4) = 100; cint = 5; sax(1) = 0; sax(2) = 250; conv = 10^6; ...
  s1 = 'Bottom O2'; s2 = 'O2'; s3 = '({\mu}mol/kg)'; t1 = 5; t2 = 245; t3 = 230; t4 = 215;

% var = 'temp'; NEP_var = 'tob'; depth = 1; cax(1) = 0; cax(2) = 14; cax(3) = -4; cax(4) = 4; cint = .25; sax(1) = 0; sax(2) = 19; conv = 1; ...
%   s1 = 'Bottom Temp'; s2 = 'Temp'; s3 = '({\circ}C)'; t1 = 0.5; t2 = 18.5; t3 = 17.5; t4 = 16.5;

% var = 'temp'; NEP_var = 'tos'; depth = 2; cax(1) = 6; cax(2) = 20; cax(3) = -4; cax(4) = 4; cint = .25; sax(1) = 6; sax(2) = 22; conv = 1; ...
%     s1 = 'Surface Temp'; s2 = 'Temp'; s3 = '({\circ}C)'; t1 = 6.5; t2 = 21.5; t3 = 20.5; t4 = 19.5;

% var = 'NO3'; NEP_var = 'no3os'; depth = 2; cax(1) = 0; cax(2) = 40; cax(3) = -10; cax(4) = 10; cint = .5; sax(1) = 0; sax(2) = 40; conv = 1000/1.025; ...
%   s1 = 'Surface NO3'; s2 = 'NO3'; s3 = '({\mu}mol/kg)'; t1 = 33; t2 = 6; t3 = 4; t4 = 2;

PLOT = true;  % Logical switch for plotting all the figures

MODEL_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/northeast_pacific/hindcast/daily/r20250912';
OBS_DIR = '/Users/darrenpilcher/Desktop/Work/CEFI/obs/WCOA';

% Load WCOA data 
tmp = readmatrix([OBS_DIR,'/W01_WCOA2007R_djg_v2.xlsx']);
WCOA2007.st = tmp(:,3); WCOA2007.niskin = tmp(:,5); WCOA2007.month = tmp(:,11); WCOA2007.day = tmp(:,12);
WCOA2007.lat = tmp(:,14); WCOA2007.lon = tmp(:,15); WCOA2007.maxdepth = tmp(:,16); WCOA2007.depth = tmp(:,17);
WCOA2007.temp = tmp(:,18); WCOA2007.salt = tmp(:,19); WCOA2007.salt_flag = tmp(:,20); WCOA2007.oxy = tmp(:,23); 
WCOA2007.oxy_flag = tmp(:,24); WCOA2007.NO3 = tmp(:,33); WCOA2007.NO3_flag = tmp(:,34);
WCOA2007.datenums = datenum(tmp(:,10),tmp(:,11),tmp(:,12)) + tmp(:,13); % Add fractional day at end 
clear tmp
WCOA2007.lon = WCOA2007.lon + 360;

% Remove questionable, bad, and missing data
fi = find(WCOA2007.salt_flag == 3 | WCOA2007.salt_flag == 4 | WCOA2007.salt_flag ==9); WCOA2007.salt_(fi) = nan;
fi = find(WCOA2007.oxy_flag == 3 | WCOA2007.oxy_flag == 4 | WCOA2007.oxy_flag ==9); WCOA2007.oxy(fi) = nan;
fi = find(WCOA2007.NO3_flag == 3 | WCOA2007.NO3_flag == 4 | WCOA2007.NO3_flag ==9); WCOA2007.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/W02_WCOA2011R_djg_v2.xlsx']);
WCOA2011.st = tmp(:,3); WCOA2011.niskin = tmp(:,5); WCOA2011.month = tmp(:,11); WCOA2011.day = tmp(:,12); 
WCOA2011.lat = tmp(:,14); WCOA2011.lon = tmp(:,15); WCOA2011.maxdepth = tmp(:,16); WCOA2011.depth = tmp(:,17); 
WCOA2011.temp = tmp(:,18); WCOA2011.salt = tmp(:,19); WCOA2011.salt_flag = tmp(:,20); WCOA2011.oxy = tmp(:,23); 
WCOA2011.oxy_flag = tmp(:,24); WCOA2011.NO3 = tmp(:,35); WCOA2011.NO3_flag = tmp(:,39);
WCOA2011.datenums = datenum(tmp(:,10),tmp(:,11),tmp(:,12)) + tmp(:,13); % Add fractional day at end 
clear tmp
WCOA2011.lon = WCOA2011.lon + 360;

fi = find(WCOA2011.salt_flag == 3 | WCOA2011.salt_flag == 4 | WCOA2011.salt_flag ==9); WCOA2011.salt(fi) = nan;
fi = find(WCOA2011.oxy_flag == 3 | WCOA2011.oxy_flag == 4 | WCOA2011.oxy_flag ==9); WCOA2011.oxy(fi) = nan;
fi = find(WCOA2011.NO3_flag == 3 | WCOA2011.NO3_flag == 4 | WCOA2011.NO3_flag ==9); WCOA2011.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/W03_WCOA2012R_djg_v2.xlsx']);
WCOA2012.st = tmp(:,3); WCOA2012.niskin = tmp(:,5); WCOA2012.month = tmp(:,11); WCOA2012.day = tmp(:,12);
WCOA2012.lat = tmp(:,14); WCOA2012.lon = tmp(:,15); WCOA2012.maxdepth = tmp(:,16); WCOA2012.depth = tmp(:,17);
WCOA2012.temp = tmp(:,18); WCOA2012.salt = tmp(:,19); WCOA2012.salt_flag = tmp(:,20); WCOA2012.oxy = tmp(:,23); 
WCOA2012.oxy_flag = tmp(:,24); WCOA2012.NO3 = tmp(:,32); WCOA2012.NO3_flag = tmp(:,36);
WCOA2012.datenums = datenum(tmp(:,10),tmp(:,11),tmp(:,12)) + tmp(:,13); % Add fractional day at end
clear tmp
WCOA2012.lon = WCOA2012.lon + 360;

fi = find(WCOA2012.salt_flag == 3 | WCOA2012.salt_flag == 4 | WCOA2012.salt_flag ==9); WCOA2012.salt(fi) = nan;
fi = find(WCOA2012.oxy_flag == 3 | WCOA2012.oxy_flag == 4 | WCOA2012.oxy_flag ==9); WCOA2012.oxy(fi) = nan;
fi = find(WCOA2012.NO3_flag == 3 | WCOA2012.NO3_flag == 4 | WCOA2012.NO3_flag ==9); WCOA2012.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/W04_WCOA2013R_Leg1_djg_v2.xlsx']);
WCOA2013L1.st = tmp(:,3); WCOA2013L1.cast = tmp(:,4); WCOA2013L1.niskin = tmp(:,5); WCOA2013L1.month = tmp(:,11); WCOA2013L1.day = tmp(:,12);
WCOA2013L1.lat = tmp(:,14); WCOA2013L1.lon = tmp(:,15); WCOA2013L1.maxdepth = tmp(:,16); WCOA2013L1.depth = tmp(:,17);
WCOA2013L1.temp = tmp(:,18); WCOA2013L1.salt = tmp(:,19); WCOA2013L1.salt_flag = tmp(:,20); WCOA2013L1.oxy = tmp(:,23); 
WCOA2013L1.oxy_flag = tmp(:,24); WCOA2013L1.NO3 = tmp(:,39); WCOA2013L1.NO3_flag = tmp(:,40);
WCOA2013L1.datenums = datenum(tmp(:,10),tmp(:,11),tmp(:,12)) + tmp(:,13); % Add fractional day at end
clear tmp
WCOA2013L1.lon = WCOA2013L1.lon + 360;

% For 2013 L1, there are 2 versions of station 44 (1 that's noted as 44a.  Since stations start at 11, I'll move 1 of the station 44 versions to a new station 10 and keep the other as is
id = (WCOA2013L1.st == 44) & (WCOA2013L1.cast == 1); WCOA2013L1.st(id) = 10;

fi = find(WCOA2013L1.salt_flag == 3 | WCOA2013L1.salt_flag == 4 | WCOA2013L1.salt_flag ==9); WCOA2013L1.salt(fi) = nan;
fi = find(WCOA2013L1.oxy_flag == 3 | WCOA2013L1.oxy_flag == 4 | WCOA2013L1.oxy_flag ==9); WCOA2013L1.oxy(fi) = nan;
fi = find(WCOA2013L1.NO3_flag == 3 | WCOA2013L1.NO3_flag == 4 | WCOA2013L1.NO3_flag ==9); WCOA2013L1.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/W04_WCOA2013R_Leg2_djg_v2.xlsx']);
WCOA2013L2.st = tmp(:,3); WCOA2013L2.niskin = tmp(:,5); WCOA2013L2.month = tmp(:,11); WCOA2013L2.day = tmp(:,12);
WCOA2013L2.lat = tmp(:,14); WCOA2013L2.lon = tmp(:,15); WCOA2013L2.maxdepth = tmp(:,16); WCOA2013L2.depth = tmp(:,17);
WCOA2013L2.temp = tmp(:,18); WCOA2013L2.salt = tmp(:,19); WCOA2013L2.salt_flag = tmp(:,20); WCOA2013L2.oxy = tmp(:,23); 
WCOA2013L2.oxy_flag = tmp(:,24);  WCOA2013L2.NO3 = tmp(:,39); WCOA2013L2.NO3_flag = tmp(:,40);
WCOA2013L2.datenums = datenum(tmp(:,10),tmp(:,11),tmp(:,12)) + tmp(:,13); % Add fractional day at end
clear tmp
WCOA2013L2.lon = WCOA2013L2.lon + 360;

fi = find(WCOA2013L2.salt_flag == 3 | WCOA2013L2.salt_flag == 4 | WCOA2013L2.salt_flag ==9); WCOA2013L2.salt(fi) = nan;
fi = find(WCOA2013L2.oxy_flag == 3 | WCOA2013L2.oxy_flag == 4 | WCOA2013L2.oxy_flag ==9); WCOA2013L2.oxy(fi) = nan;
fi = find(WCOA2013L2.NO3_flag == 3 | WCOA2013L2.NO3_flag == 4 | WCOA2013L2.NO3_flag ==9); WCOA2013L2.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/W05_WCOA2016R_djg_v2.xlsx']);
WCOA2016.st = tmp(:,3); WCOA2016.niskin = tmp(:,5); WCOA2016.month = tmp(:,10); WCOA2016.day = tmp(:,11);
WCOA2016.lat = tmp(:,13); WCOA2016.lon = tmp(:,14); WCOA2016.maxdepth = tmp(:,15); WCOA2016.depth = tmp(:,16);
WCOA2016.temp = tmp(:,17); WCOA2016.salt = tmp(:,18); WCOA2016.oxy = tmp(:,21); WCOA2016.NO3 = tmp(:,35); WCOA2016.NO3_flag = tmp(:,39);
WCOA2016.datenums = datenum(tmp(:,9),tmp(:,10),tmp(:,11)) + tmp(:,12); % Add fractional day at end
clear tmp
WCOA2016.lon = WCOA2016.lon + 360;

% No CTD salinity, oxy flags here
fi = find(WCOA2016.NO3_flag == 3 | WCOA2016.NO3_flag == 4 | WCOA2016.NO3_flag ==9); WCOA2016.NO3(fi) = nan;

% NOTE: This original file had a different system for station naming than previoulsy (alphanumeric rather than just numeric) so I manually added new row in 
% spreadsheet with station numbers for each unique station (just going incrementally 1-51)
tmp = readmatrix([OBS_DIR,'/W06_SH1709R_djg_v2_DJP.xlsx']);
WCOA2017.st = tmp(:,4); WCOA2017.niskin = tmp(:,5); WCOA2017.month = tmp(:,9); WCOA2017.day = tmp(:,10);
WCOA2017.lat = tmp(:,12); WCOA2017.lon = tmp(:,13); WCOA2017.depth = tmp(:,14);
WCOA2017.temp = tmp(:,15); WCOA2017.salt = tmp(:,16); WCOA2017.salt_flag = tmp(:,17); WCOA2017.oxy = tmp(:,18); 
WCOA2017.oxy_flag = tmp(:,20); WCOA2017.NO3 = tmp(:,33); WCOA2017.NO3_flag = tmp(:,41);
WCOA2017.datenums = datenum(tmp(:,8),tmp(:,9),tmp(:,10)) + tmp(:,11); % Add fractional day at end
clear tmp
WCOA2017.lon = WCOA2017.lon + 360;

fi = find(WCOA2017.salt_flag == 3 | WCOA2017.salt_flag == 4 | WCOA2017.salt_flag ==9); WCOA2017.salt(fi) = nan;
fi = find(WCOA2017.oxy_flag == 3 | WCOA2017.oxy_flag == 4 | WCOA2017.oxy_flag ==9); WCOA2017.oxy(fi) = nan;
fi = find(WCOA2017.NO3_flag == 3 | WCOA2017.NO3_flag == 4 | WCOA2017.NO3_flag ==9); WCOA2017.NO3(fi) = nan;

tmp = readmatrix([OBS_DIR,'/WCOA2021_Data_forSDIS_2022_09-28.xlsx']);
WCOA2021.st = tmp(:,4); WCOA2021.niskin = tmp(:,6); WCOA2021.month = tmp(:,13); WCOA2021.day = tmp(:,14);
WCOA2021.lat = tmp(:,17); WCOA2021.lon = tmp(:,18); WCOA2021.maxdepth = tmp(:,19); WCOA2021.depth = tmp(:,20);
WCOA2021.temp = tmp(:,22); WCOA2021.salt = tmp(:,23); WCOA2021.salt_flag = tmp(:,24); WCOA2021.oxy = tmp(:,27); 
WCOA2021.oxy_flag = tmp(:,28); WCOA2021.NO3 = tmp(:,44); WCOA2021.NO3_flag = tmp(:,45);
WCOA2021.datenums = datenum(tmp(:,12),tmp(:,13),tmp(:,14)) + tmp(:,15); % Add fractional day at end
clear tmp
WCOA2021.lon = WCOA2021.lon + 360;

fi = find(WCOA2021.salt_flag == 3 | WCOA2021.salt_flag == 4 | WCOA2021.salt_flag ==9); WCOA2021.salt(fi) = nan;
fi = find(WCOA2021.oxy_flag == 3 | WCOA2021.oxy_flag == 4 | WCOA2021.oxy_flag ==9); WCOA2021.oxy(fi) = nan;
fi = find(WCOA2021.NO3_flag == 3 | WCOA2021.NO3_flag == 4 | WCOA2021.NO3_flag ==9); WCOA2021.NO3(fi) = nan;

% Double check for missing values, since there are a couple that aren't flagged as 9
fi = find(WCOA2007.(var) == -999); WCOA2007.(var)(fi) = nan;
fi = find(WCOA2011.(var) == -999); WCOA2011.(var)(fi) = nan;
fi = find(WCOA2012.(var) == -999); WCOA2012.(var)(fi) = nan;
fi = find(WCOA2013L1.(var) == -999); WCOA2013L1.(var)(fi) = nan;
fi = find(WCOA2013L2.(var) == -999); WCOA2013L2.(var)(fi) = nan;
fi = find(WCOA2016.(var) == -999); WCOA2016.(var)(fi) = nan;
fi = find(WCOA2017.(var) == -999); WCOA2017.(var)(fi) = nan;
fi = find(WCOA2021.(var) == -999); WCOA2021.(var)(fi) = nan;

WCOA2007.stations = unique(WCOA2007.st);
WCOA2011.stations = unique(WCOA2011.st);
WCOA2012.stations = unique(WCOA2012.st);
WCOA2013L1.stations = unique(WCOA2013L1.st);
WCOA2013L2.stations = unique(WCOA2013L2.st);
WCOA2016.stations = unique(WCOA2016.st);
WCOA2017.stations = unique(WCOA2017.st);
WCOA2021.stations = unique(WCOA2021.st);

% Find surface or bottom data points

for s = 1:length(WCOA2007.stations)
    fi = find(WCOA2007.st == WCOA2007.stations(s)); tmp = WCOA2007.niskin(fi);
    if depth == 1;
        id = (WCOA2007.st == WCOA2007.stations(s)) & (WCOA2007.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2007.st == WCOA2007.stations(s)) & (WCOA2007.depth >= 0) & (WCOA2007.depth <= 6);
    end
    WCOA2007_bot.(var)(s,1) = nanmean(WCOA2007.(var)(id));
    WCOA2007_bot.lat(s,1) = nanmean(WCOA2007.lat(id));
    WCOA2007_bot.lon(s,1) = nanmean(WCOA2007.lon(id));
    WCOA2007_bot.datenums(s,1) = nanmean(WCOA2007.datenums(id));
end

for s = 1:length(WCOA2011.stations)
    fi = find(WCOA2011.st == WCOA2011.stations(s)); tmp = WCOA2011.niskin(fi);
    if depth == 1;
        id = (WCOA2011.st == WCOA2011.stations(s)) & (WCOA2011.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2011.st == WCOA2011.stations(s)) & (WCOA2011.depth >= 0) & (WCOA2011.depth <= 6);
    end
    WCOA2011_bot.(var)(s,1) = nanmean(WCOA2011.(var)(id));
    WCOA2011_bot.lat(s,1) = nanmean(WCOA2011.lat(id));
    WCOA2011_bot.lon(s,1) = nanmean(WCOA2011.lon(id));
    WCOA2011_bot.datenums(s,1) = nanmean(WCOA2011.datenums(id));
end

for s = 1:length(WCOA2012.stations)
    fi = find(WCOA2012.st == WCOA2012.stations(s)); tmp = WCOA2012.niskin(fi);
    if depth == 1;
        id = (WCOA2012.st == WCOA2012.stations(s)) & (WCOA2012.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2012.st == WCOA2012.stations(s)) & (WCOA2012.depth >= 0) & (WCOA2012.depth <= 6);
    end
    WCOA2012_bot.(var)(s,1) = nanmean(WCOA2012.(var)(id));
    WCOA2012_bot.lat(s,1) = nanmean(WCOA2012.lat(id));
    WCOA2012_bot.lon(s,1) = nanmean(WCOA2012.lon(id));
    WCOA2012_bot.datenums(s,1) = nanmean(WCOA2012.datenums(id));
end

for s = 1:length(WCOA2013L1.stations)
    fi = find(WCOA2013L1.st == WCOA2013L1.stations(s)); tmp = WCOA2013L1.niskin(fi);
    if depth == 1;
        id = (WCOA2013L1.st == WCOA2013L1.stations(s)) & (WCOA2013L1.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2013L1.st == WCOA2013L1.stations(s)) & (WCOA2013L1.depth >= 0) & (WCOA2013L1.depth <= 6);
    end
    WCOA2013L1_bot.(var)(s,1) = nanmean(WCOA2013L1.(var)(id));
    WCOA2013L1_bot.lat(s,1) = nanmean(WCOA2013L1.lat(id));
    WCOA2013L1_bot.lon(s,1) = nanmean(WCOA2013L1.lon(id));
    WCOA2013L1_bot.datenums(s,1) = nanmean(WCOA2013L1.datenums(id));
end

for s = 1:length(WCOA2013L2.stations)
    fi = find(WCOA2013L2.st == WCOA2013L2.stations(s)); tmp = WCOA2013L2.niskin(fi);
    if depth == 1;
        id = (WCOA2013L2.st == WCOA2013L2.stations(s)) & (WCOA2013L2.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2013L2.st == WCOA2013L2.stations(s)) & (WCOA2013L2.depth >= 0) & (WCOA2013L2.depth <= 6);
    end
    WCOA2013L2_bot.(var)(s,1) = nanmean(WCOA2013L2.(var)(id));
    WCOA2013L2_bot.lat(s,1) = nanmean(WCOA2013L2.lat(id));
    WCOA2013L2_bot.lon(s,1) = nanmean(WCOA2013L2.lon(id));
    WCOA2013L2_bot.datenums(s,1) = nanmean(WCOA2013L2.datenums(id));
end

for s = 1:length(WCOA2016.stations)
    fi = find(WCOA2016.st == WCOA2016.stations(s)); tmp = WCOA2016.niskin(fi);
    if depth == 1;
        id = (WCOA2016.st == WCOA2016.stations(s)) & (WCOA2016.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2016.st == WCOA2016.stations(s)) & (WCOA2016.depth >= 0) & (WCOA2016.depth <= 6);
    end
    WCOA2016_bot.(var)(s,1) = nanmean(WCOA2016.(var)(id));
    WCOA2016_bot.lat(s,1) = nanmean(WCOA2016.lat(id));
    WCOA2016_bot.lon(s,1) = nanmean(WCOA2016.lon(id));
    WCOA2016_bot.datenums(s,1) = nanmean(WCOA2016.datenums(id));
end

for s = 1:length(WCOA2017.stations)
    fi = find(WCOA2017.st == WCOA2017.stations(s)); tmp = WCOA2017.niskin(fi);
     if depth == 1;
        id = (WCOA2017.st == WCOA2017.stations(s)) & (WCOA2017.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2017.st == WCOA2017.stations(s)) & (WCOA2017.depth >= 0) & (WCOA2017.depth <= 6);
     end
    WCOA2017_bot.(var)(s,1) = nanmean(WCOA2017.(var)(id));
    WCOA2017_bot.lat(s,1) = nanmean(WCOA2017.lat(id));
    WCOA2017_bot.lon(s,1) = nanmean(WCOA2017.lon(id));
    WCOA2017_bot.datenums(s,1) = nanmean(WCOA2017.datenums(id));
end

for s = 1:length(WCOA2021.stations)
    fi = find(WCOA2021.st == WCOA2021.stations(s)); tmp = WCOA2021.niskin(fi);
     if depth == 1;
        id = (WCOA2021.st == WCOA2021.stations(s)) & (WCOA2021.niskin == tmp(1));
    elseif depth == 2;
        id = (WCOA2021.st == WCOA2021.stations(s)) & (WCOA2021.depth >= 0) & (WCOA2021.depth <= 6);
     end
    WCOA2021_bot.(var)(s,1) = nanmean(WCOA2021.(var)(id));
    WCOA2021_bot.lat(s,1) = nanmean(WCOA2021.lat(id));
    WCOA2021_bot.lon(s,1) = nanmean(WCOA2021.lon(id));
    WCOA2021_bot.datenums(s,1) = nanmean(WCOA2021.datenums(id));
end

st = (365*11) + (366*3); % To start model loading in 2007

model_bot.var = ncread([MODEL_DIR,'/',NEP_var,'.nep.full.hcast.daily.raw.r20250912.199301-202506.nc'],NEP_var,[1 1 st],[Inf Inf Inf]);
model_bot.time = ncread([MODEL_DIR,'/',NEP_var,'.nep.full.hcast.daily.raw.r20250912.199301-202506.nc'],'time',[st],[Inf]);
model_bot.lat = ncread([MODEL_DIR,'/ocean_static.nc'],'geolat');
model_bot.lon = ncread([MODEL_DIR,'/ocean_static.nc'],'geolon');

model_bot.time = model_bot.time + datenum('01/01/1993','mm/dd/yyyy');
model_bot.time = datetime(model_bot.time,'ConvertFrom','datenum');
model_bot.datenums = datenum(model_bot.time);

% Required unit conversion
model_bot.var = model_bot.var * conv;

% Find closest model grid cell to each observation
latlim = minmax(model_bot.lat);
lonlim = minmax(model_bot.lon);

[xrho, yrho, zrho] = geodetic2enu(model_bot.lat, model_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));
[xobs, yobs, zobs] = geodetic2enu(WCOA2007_bot.lat, WCOA2007_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2007_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2007.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2007.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    % These are just checks to make sure it's grabbing closest lat-lon points
    cmp_WCOA2007.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2007_bot.lat(p);
    cmp_WCOA2007.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2007_bot.lon(p);
end


[xobs, yobs, zobs] = geodetic2enu(WCOA2011_bot.lat, WCOA2011_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2011_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2011.datenums(p)));
    dmin(p) = index_day;
	cmp_WCOA2011.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
	cmp_WCOA2011.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2011_bot.lat(p);
	cmp_WCOA2011.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2011_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2012_bot.lat, WCOA2012_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2012_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2012.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2012.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2012.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2012_bot.lat(p);
    cmp_WCOA2012.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2012_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2013L1_bot.lat, WCOA2013L1_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2013L1_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2013L1.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2013L1.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2013L1.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2013L1_bot.lat(p);
    cmp_WCOA2013L1.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2013L1_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2013L2_bot.lat, WCOA2013L2_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2013L2_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2013L2.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2013L2.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2013L2.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2013L2_bot.lat(p);
    cmp_WCOA2013L2.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2013L2_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2016_bot.lat, WCOA2016_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2016_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2016.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2016.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2016.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2016_bot.lat(p);
    cmp_WCOA2016.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2016_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2017_bot.lat, WCOA2017_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2017_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2017.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2017.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2017.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2017_bot.lat(p);
    cmp_WCOA2017.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2017_bot.lon(p);
end

[xobs, yobs, zobs] = geodetic2enu(WCOA2021_bot.lat, WCOA2021_bot.lon, 0, mean(mean(latlim)), mean(mean(lonlim)), 0, referenceEllipsoid('earth'));

[d, imin] = pdist2([xrho(:) yrho(:)], [xobs yobs], 'euclidean', 'smallest', 1);

% Convert to subscript indicies
[rowmin,colmin] = ind2sub([342 816],imin);

for p = 1:length(WCOA2021_bot.datenums)
    [c index_day] = min(abs(model_bot.datenums - WCOA2021.datenums(p)));
    dmin(p) = index_day;
    cmp_WCOA2021.var(p) = model_bot.var(rowmin(p),colmin(p),dmin(p));
    cmp_WCOA2021.lat(p) = model_bot.lat(rowmin(p),colmin(p)) - WCOA2021_bot.lat(p);
    cmp_WCOA2021.lon(p) = model_bot.lon(rowmin(p),colmin(p)) - WCOA2021_bot.lon(p);
end


% Combine all years into 1 comparison.
cmp_WCOA_full.var = [cmp_WCOA2007.var cmp_WCOA2011.var cmp_WCOA2012.var cmp_WCOA2013L1.var cmp_WCOA2013L2.var cmp_WCOA2016.var cmp_WCOA2017.var cmp_WCOA2021.var];
WCOA_full_bot.(var) = [WCOA2007_bot.(var)' WCOA2011_bot.(var)' WCOA2012_bot.(var)' WCOA2013L1_bot.(var)' WCOA2013L2_bot.(var)' WCOA2016_bot.(var)' WCOA2017_bot.(var)' WCOA2021_bot.(var)'];

% Compute statistics
cmp_WCOA2007.R = corrcoef(cmp_WCOA2007.var,WCOA2007_bot.(var)','rows','complete');
cmp_WCOA2007.bias = nanmean(cmp_WCOA2007.var) - nanmean(WCOA2007_bot.(var));
cmp_WCOA2007.RMSE = sqrt(nanmean((cmp_WCOA2007.var - WCOA2007_bot.(var)').^2));

cmp_WCOA2011.R = corrcoef(cmp_WCOA2011.var,WCOA2011_bot.(var)','rows','complete');
cmp_WCOA2011.bias = nanmean(cmp_WCOA2011.var) - nanmean(WCOA2011_bot.(var));
cmp_WCOA2011.RMSE = sqrt(nanmean((cmp_WCOA2011.var - WCOA2011_bot.(var)').^2));

cmp_WCOA2012.R = corrcoef(cmp_WCOA2012.var,WCOA2012_bot.(var)','rows','complete');
cmp_WCOA2012.bias = nanmean(cmp_WCOA2012.var) - nanmean(WCOA2012_bot.(var));
cmp_WCOA2012.RMSE = sqrt(nanmean((cmp_WCOA2012.var - WCOA2012_bot.(var)').^2));

cmp_WCOA2013L1.R = corrcoef(cmp_WCOA2013L1.var,WCOA2013L1_bot.(var)','rows','complete');
cmp_WCOA2013L1.bias = nanmean(cmp_WCOA2013L1.var) - nanmean(WCOA2013L1_bot.(var));
cmp_WCOA2013L1.RMSE = sqrt(nanmean((cmp_WCOA2013L1.var - WCOA2013L1_bot.(var)').^2));

cmp_WCOA2013L2.R = corrcoef(cmp_WCOA2013L2.var,WCOA2013L2_bot.(var)','rows','complete');
cmp_WCOA2013L2.bias = nanmean(cmp_WCOA2013L2.var) - nanmean(WCOA2013L2_bot.(var));
cmp_WCOA2013L2.RMSE = sqrt(nanmean((cmp_WCOA2013L2.var - WCOA2013L2_bot.(var)').^2));

cmp_WCOA2016.R = corrcoef(cmp_WCOA2016.var,WCOA2016_bot.(var)','rows','complete');
cmp_WCOA2016.bias = nanmean(cmp_WCOA2016.var) - nanmean(WCOA2016_bot.(var));
cmp_WCOA2016.RMSE = sqrt(nanmean((cmp_WCOA2016.var - WCOA2016_bot.(var)').^2));

cmp_WCOA2017.R = corrcoef(cmp_WCOA2017.var,WCOA2017_bot.(var)','rows','complete');
cmp_WCOA2017.bias = nanmean(cmp_WCOA2017.var) - nanmean(WCOA2017_bot.(var));
cmp_WCOA2017.RMSE = sqrt(nanmean((cmp_WCOA2017.var - WCOA2017_bot.(var)').^2));

cmp_WCOA2021.R = corrcoef(cmp_WCOA2021.var,WCOA2021_bot.(var)','rows','complete');
cmp_WCOA2021.bias = nanmean(cmp_WCOA2021.var) - nanmean(WCOA2021_bot.(var));
cmp_WCOA2021.RMSE = sqrt(nanmean((cmp_WCOA2021.var - WCOA2021_bot.(var)').^2));

cmp_WCOA_full.R = corrcoef(cmp_WCOA_full.var,WCOA_full_bot.(var),'rows','complete');
cmp_WCOA_full.bias = nanmean(cmp_WCOA_full.var) - nanmean(WCOA_full_bot.(var));
cmp_WCOA_full.RMSE = sqrt(nanmean((cmp_WCOA_full.var - WCOA_full_bot.(var)).^2));


cmap = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'}); % pastel jet
cmap2 = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'}); % redblue

if (PLOT)

% Make Figures
% Spatial plots
tmp_ind = isbetween(model_bot.time,datetime(2007,5,14),datetime(2007,6,12,23,59,59));

figure(1); set(gcf, 'units','centimeters','position',[10 10 21 18]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2007_bot.lon,WCOA2007_bot.lat,[],WCOA2007_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2007 May 14 - June 12 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
m_scatter(WCOA2007_bot.lon,WCOA2007_bot.lat,[],(cmp_WCOA2007.var - WCOA2007_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2007 May 14 - June 12',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2007.jpg','Resolution',300);

figure(2); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2007.var,WCOA2007_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2007.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2007.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2007.bias,2)],'Fontsize',12)
title(['WCOA 2007 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2007.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2011,8,12),datetime(2011,8,30,23,59,59));

figure(3); set(gcf, 'units','centimeters','position',[10 10 21 18]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[232  245],'lat',[31 49])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2011_bot.lon,WCOA2011_bot.lat,[],WCOA2011_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2011 Aug 12-30 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[232  245],'lat',[31 49])
m_scatter(WCOA2011_bot.lon,WCOA2011_bot.lat,[],(cmp_WCOA2011.var - WCOA2011_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2011 Aug 12-30 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2011.jpg','Resolution',300);

figure(4); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2011.var,WCOA2011_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2011.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2011.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2011.bias,2)],'Fontsize',12)
title(['WCOA 2011 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2011.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2012,9,5),datetime(2012,9,16,23,59,59));

figure(5); set(gcf, 'units','centimeters','position',[10 10 21 18]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[232  245],'lat',[31 49])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2012_bot.lon,WCOA2012_bot.lat,[],WCOA2012_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2012 Sep 5-16 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[232  245],'lat',[31 49])
m_scatter(WCOA2012_bot.lon,WCOA2012_bot.lat,[],(cmp_WCOA2012.var - WCOA2012_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2012 Sep 5-16 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2012.jpg','Resolution',300);

figure(6); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2012.var,WCOA2012_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2012.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2012.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2012.bias,2)],'Fontsize',12)
title(['WCOA 2012 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2012.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2013,8,5),datetime(2013,8,10,23,59,59));

figure(7); set(gcf, 'units','centimeters','position',[10 10 21 15]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[232  237],'lat',[44 49])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2013L1_bot.lon,WCOA2013L1_bot.lat,[],WCOA2013L1_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:237],'ytick',[44:2:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2013 Leg 1 Aug 5-10 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[232  237],'lat',[44 49])
m_scatter(WCOA2013L1_bot.lon,WCOA2013L1_bot.lat,[],(cmp_WCOA2013L1.var - WCOA2013L1_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:237],'ytick',[44:2:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2013 Leg 1 Aug 5-10 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2013L1.jpg','Resolution',300);

figure(8); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2013L1.var,WCOA2013L1_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2013L1.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2013L1.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2013L1.bias,2)],'Fontsize',12)
title(['WCOA 2013 Leg 1 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2013L1.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2013,8,21),datetime(2013,8,28,23,59,59));

figure(9); set(gcf, 'units','centimeters','position',[10 10 21 17]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[232  240],'lat',[36 46])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2013L2_bot.lon,WCOA2013L2_bot.lat,[],WCOA2013L2_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:240],'ytick',[36:2:46],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2013 Leg 2 Aug 21-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[232  240],'lat',[36 46])
m_scatter(WCOA2013L2_bot.lon,WCOA2013L2_bot.lat,[],(cmp_WCOA2013L2.var - WCOA2013L2_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:240],'ytick',[36:2:46],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2013 Leg 2 Aug 21-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2013L2.jpg','Resolution',300);

figure(10); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2013L2.var,WCOA2013L2_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2013L2.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2013L2.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2013L2.bias,2)],'Fontsize',12)
title(['WCOA 2013 Leg 2 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2013L2.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2016,5,8),datetime(2016,6,6,23,59,59));

figure(11); set(gcf, 'units','centimeters','position',[10 10 21 18]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2016_bot.lon,WCOA2016_bot.lat,[],WCOA2016_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2016 May 8 - June 6 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
m_scatter(WCOA2016_bot.lon,WCOA2016_bot.lat,[],(cmp_WCOA2016.var - WCOA2016_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2016 May 8 - June 6 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2016.jpg','Resolution',300);

figure(12); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2016.var,WCOA2016_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2016.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2016.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2016.bias,2)],'Fontsize',12)
title(['WCOA 2016 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2016.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2017,9,18),datetime(2017,9,28,23,59,59));

figure(13); set(gcf, 'units','centimeters','position',[10 10 21 15]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[232  238],'lat',[44 49])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2017_bot.lon,WCOA2017_bot.lat,[],WCOA2017_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2017 Sep 18-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[232  238],'lat',[44 49])
m_scatter(WCOA2017_bot.lon,WCOA2017_bot.lat,[],(cmp_WCOA2017.var - WCOA2017_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2017 Sep 18-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2017.jpg','Resolution',300);

figure(14); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2017.var,WCOA2017_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2017.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2017.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2017.bias,2)],'Fontsize',12)
title(['WCOA 2017 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2017.jpg','Resolution',300);

tmp_ind = isbetween(model_bot.time,datetime(2021,6,25),datetime(2021,7,23,23,59,59));

figure(15); set(gcf, 'units','centimeters','position',[10 10 21 18]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(1,2,1);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2021_bot.lon,WCOA2021_bot.lat,[],WCOA2021_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2021 June 25 - July 23 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(1).Position(1) ax(1).Position(2) ax(1).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(2) = subplot(1,2,2);
m_proj('albers equal-area','long',[229  248],'lat',[25 53])
m_scatter(WCOA2021_bot.lon,WCOA2021_bot.lat,[],(cmp_WCOA2021.var - WCOA2021_bot.(var)'),'filled','MarkerEdgeColor','none')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[234:4:245],'ytick',[30:5:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2021 June 25 - July 26 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(2).Position(1) ax(2).Position(2) ax(2).Position(3) .04],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_spatial_2021.jpg','Resolution',300);

figure(16); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
scatter(cmp_WCOA2021.var,WCOA2021_bot.(var),'filled')
hold on
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA2021.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA2021.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA2021.bias,2)],'Fontsize',12)
title(['WCOA 2021 ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_2021.jpg','Resolution',300);

tmp_cmp = [cmp_WCOA2013L1.var cmp_WCOA2013L2.var]; tmp_WCOA = [WCOA2013L1_bot.(var)' WCOA2013L2_bot.(var)'];

figure(17); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
[p1] = scatter(cmp_WCOA2007.var,WCOA2007_bot.(var),'filled');
hold on
[p2] = scatter(cmp_WCOA2011.var,WCOA2011_bot.(var),'filled');
[p3] = scatter(cmp_WCOA2012.var,WCOA2012_bot.(var),'filled');
[p4] = scatter(tmp_cmp,tmp_WCOA,'filled');
[p5] = scatter(cmp_WCOA2016.var,WCOA2016_bot.(var),'filled');
[p6] = scatter(cmp_WCOA2017.var,WCOA2017_bot.(var),'filled');
[p7] = scatter(cmp_WCOA2021.var,WCOA2021_bot.(var),'filled');
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'k','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA_full.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA_full.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA_full.bias,2)],'Fontsize',12)
legend([p1,p2,p3,p4,p5,p6,p7],'2007','2011','2012','2013','2016','2017','2021','Fontsize',12,'Location','Southeast')
title(['WCOA ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250509/WCOA/temp_bot_prop_full.jpg','Resolution',300);
%% 

tmp_cmp = [cmp_WCOA2013L1.var cmp_WCOA2013L2.var]; tmp_WCOA = [WCOA2013L1_bot.(var)' WCOA2013L2_bot.(var)'];

figure(18); set(gcf, 'units','centimeters','position',[10 10 18 13]); set(gcf,'Color',[1 1 1]);
[p1] = scatter(cmp_WCOA2007.var,WCOA2007_bot.(var),12,'filled','k');
hold on
[p2] = scatter(cmp_WCOA2011.var,WCOA2011_bot.(var),12,'filled','k');
[p3] = scatter(cmp_WCOA2012.var,WCOA2012_bot.(var),12,'filled','k');
[p4] = scatter(tmp_cmp,tmp_WCOA,12,'filled','k');
[p5] = scatter(cmp_WCOA2016.var,WCOA2016_bot.(var),12,'filled','k');
[p6] = scatter(cmp_WCOA2017.var,WCOA2017_bot.(var),12,'filled','k');
[p7] = scatter(cmp_WCOA2021.var,WCOA2021_bot.(var),12,'filled','k');
plot([sax(1):1:sax(2)],[sax(1):1:sax(2)],'b','Linewidth',2)
ylabel(['WCOA ',s3],'Fontsize',16)
xlabel(['Model ',s3],'Fontsize',16)
axis([sax(1) sax(2) sax(1) sax(2)])
text(t1,t2,['R = ',num2str(cmp_WCOA_full.R(1,2),2)],'Fontsize',12)
text(t1,t3,['RMSE = ',num2str(cmp_WCOA_full.RMSE,2)],'Fontsize',12)
text(t1,t4,['Bias = ',num2str(cmp_WCOA_full.bias,2)],'Fontsize',12)
%legend([p1,p2,p3,p4,p5,p6,p7],'2007','2011','2012','2013','2016','2017','2021','Fontsize',12,'Location','Southeast')
title(['WCOA ',s1],'Fontweight','bold','Fontsize',16)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/WCOA/temp_surf_prop_full.jpg','Resolution',300);
%% 

% Try sub-dividing the surveys into different sections for easier viewing
tmp_ind = isbetween(model_bot.time,datetime(2013,8,5),datetime(2013,8,10,23,59,59));
figure(19); set(gcf, 'units','centimeters','position',[10 30 23 25]); set(gcf,'Color',[1 1 1]);
ax(1) = subplot(2,2,1);
m_proj('albers equal-area','long',[232  237],'lat',[44 49])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2013L1_bot.lon,WCOA2013L1_bot.lat,[],WCOA2013L1_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:237],'ytick',[44:2:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(1),flipud(cmap))
colormap(ax(1),cmap)
title(['WCOA 2013 Leg 1 Aug 5-10 ',s1],'Fontsize',12)

ax(2) = subplot(2,2,2);
m_proj('albers equal-area','long',[232  237],'lat',[44 49])
m_scatter(WCOA2013L1_bot.lon,WCOA2013L1_bot.lat,[],(cmp_WCOA2013L1.var - WCOA2013L1_bot.(var)'),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:237],'ytick',[44:2:50],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(2),cmap2)
title(['WCOA 2013 Leg 1 Aug 5-10 ',s1],'Fontsize',12)

tmp_ind = isbetween(model_bot.time,datetime(2013,8,21),datetime(2013,8,28,23,59,59));
ax(3) = subplot(2,2,3); set(ax(3),'Position',[.13 .18 .3347 .3412])
m_proj('albers equal-area','long',[233  240],'lat',[36 45])
[C,h] = m_contourf(model_bot.lon,model_bot.lat,squeeze(nanmean(model_bot.var(:,:,tmp_ind),3)),[cax(1):cint:cax(2)]);
set(h,'LineColor','none')
hold on
m_scatter(WCOA2013L2_bot.lon,WCOA2013L2_bot.lat,[],WCOA2013L2_bot.(var),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:240],'ytick',[36:2:46],'linestyle','none','color','k','Fontsize',10);
caxis([cax(1) cax(2)])
%colormap(ax(3),flipud(cmap))
colormap(ax(3),cmap)
title(['WCOA 2013 Leg 2 Aug 21-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(3).Position(1) .12 ax(3).Position(3) .03],'orientation','horizontal','Fontsize',10)
ylabel(cb,[s2,' ',s3],'Fontsize',10)

ax(4) = subplot(2,2,4); set(ax(4),'Position',[.5703 .18 .3347 .3412])
m_proj('albers equal-area','long',[233  240],'lat',[36 45])
m_scatter(WCOA2013L2_bot.lon,WCOA2013L2_bot.lat,[],(cmp_WCOA2013L2.var - WCOA2013L2_bot.(var)'),'filled','MarkerEdgeColor','k')
m_gshhs_i('patch',[0.5 0.5 0.5]);
m_grid('xtick',[232:2:240],'ytick',[36:2:46],'linestyle','none','color','k','Fontsize',10);
caxis([cax(3) cax(4)])
colormap(ax(4),cmap2)
title(['WCOA 2013 Leg 2 Aug 21-28 ',s1],'Fontsize',12)
cb = colorbar; set(cb,'position',[ax(4).Position(1) .12 ax(4).Position(3) .03],'orientation','horizontal','Fontsize',10)
ylabel(cb,['{\Delta}',s2,' ',s3],'Fontsize',10)

%f = gcf; exportgraphics(f,'/Users/darrenpilcher/Desktop/Work/CEFI/figures/NEP/model_comparisons/r20250912/WCOA/NO3_surf_spatial_2013.jpg','Resolution',300);






end % PLOT
