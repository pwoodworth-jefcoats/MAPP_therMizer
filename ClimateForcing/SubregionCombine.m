%%% SubregionCombine
% The purpose of this script is to combine the two different geographic 
% region files for each variable into a single netCDF.  This will entai:
% Load lat and lon for each sub-regon
% Create a grid of NaNs spanning the full domain
% Drop data from each sub-region into the full domain**
%     The 150W data are repeated across both files, so only use data from 
%     one sub-region for this meridian
% Assign dimension variables
% Save file for full domain
% We're also going to convert the depth from centimeters to meters.
% Note that the script was revised for each individual ensemble member.

% Load data
lat1 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain1.yearlyave.2015-2100.nc", "lat");
lat2 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain2.yearlyave.2015-2100.nc", "lat");

lon1 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain1.yearlyave.2015-2100.nc", "lon");
lon2 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain2.yearlyave.2015-2100.nc", "lon");

depth = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain1.yearlyave.2015-2100.nc", "z_t");
time = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain1.yearlyave.2015-2100.nc", "time");

TEMP1 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain1.yearlyave.2015-2100.nc", "TEMP");
TEMP2 = ncread("b.e21.BSSP370cmip6.f09_g17.LE2-1181.010.pop.h.TEMP.1x1grid.subdomain2.yearlyave.2015-2100.nc", "TEMP");

% Dimensions of the data are:
% lon x lat x depth x time

% Create new lon variable
lon = min(lon1):1:max(lon2);

% Recycle lat1 for lat, since it covers the full domain
lat = lat1;

% Create new empty array
TEMP(1:length(lon), 1:length(lat), 1:length(depth), 1:length(time)) = NaN;

lat2_s = find(lat1 == (min(lat2)));
lat2_e = find(lat1 == (max(lat2)));

% Fill it
TEMP(1:length(lon1)-1, :, :, :) = TEMP1(1:length(lon1)-1, :, :, :);
TEMP(length(lon1):length(lon), lat2_s:lat2_e, :, :) = TEMP2(:,:,:,:);

% Save final file
% This approach seems overly tedius because common dimensions and variables
% have to be recreated for each file...
% And we can only do one file at a time.

% Create file, noting NOT to overwrite an exsiting file
ncid1 = netcdf.create('LE2-1181-010-TEMP.nc','NOCLOBBER');

% Define dimensions
dimid_lon1 = netcdf.defDim(ncid1,'lon',length(lon));
dimid_lat1 = netcdf.defDim(ncid1,'lat',length(lat));
dimid_z1 = netcdf.defDim(ncid1,'depth',length(depth));
dimid_yr1 = netcdf.defDim(ncid1,'time',length(time));

% Define variables
varid_lon1 = netcdf.defVar(ncid1,'lon','double',dimid_lon1);
varid_lat1 = netcdf.defVar(ncid1,'lat','double',dimid_lat1);
varid_z1 = netcdf.defVar(ncid1,'depth','double',dimid_z1);
varid_yr1 = netcdf.defVar(ncid1,'time','double',dimid_yr1);

varid_TEMP = netcdf.defVar(ncid1,'TEMP','double',[dimid_lon1 dimid_lat1 dimid_z1 dimid_yr1]);

% Define attributes
netcdf.putAtt(ncid1,varid_lon1,'standard_name','longitude');
netcdf.putAtt(ncid1,varid_lon1,'long_name','longitude');
netcdf.putAtt(ncid1,varid_lon1,'units','degrees_east');
netcdf.putAtt(ncid1,varid_lon1,'axis','X');

netcdf.putAtt(ncid1,varid_lat1,'standard_name','latitude');
netcdf.putAtt(ncid1,varid_lat1,'long_name','latitude');
netcdf.putAtt(ncid1,varid_lat1,'units','degrees_north');
netcdf.putAtt(ncid1,varid_lat1,'axis','Y');

netcdf.putAtt(ncid1,varid_z1,'standard_name','depth');
netcdf.putAtt(ncid1,varid_z1,'long_name','depth from surface to midpoint of layer');
netcdf.putAtt(ncid1,varid_z1,'units','meters');
netcdf.putAtt(ncid1,varid_z1,'positive','down');
netcdf.putAtt(ncid1,varid_z1,'axis','Z')

netcdf.putAtt(ncid1,varid_yr1,'standard_name','time');
netcdf.putAtt(ncid1,varid_yr1,'long_name','time');
netcdf.putAtt(ncid1,varid_yr1,'units','days since 0000-01-01 00:00:00');
netcdf.putAtt(ncid1,varid_yr1,'calendar','365_day');
netcdf.putAtt(ncid1,varid_yr1,'axis','T');

netcdf.putAtt(ncid1,varid_TEMP,'standard_name','TEMP');
netcdf.putAtt(ncid1,varid_TEMP,'long_name','Potential Temperature');
netcdf.putAtt(ncid1,varid_TEMP,'units','degC');

netcdf.endDef(ncid1)
% netcdf.reDef(ncid1) in case it's necessary to reenter define mode.

% Put the data in the file
netcdf.putVar(ncid1,varid_lon1,lon);
netcdf.putVar(ncid1,varid_lat1,lat);
netcdf.putVar(ncid1,varid_z1,depth/100); % Convert from cm to m
netcdf.putVar(ncid1,varid_yr1,time);
netcdf.putVar(ncid1,varid_TEMP,TEMP);

% Close the files so they can be used
netcdf.close(ncid1)
