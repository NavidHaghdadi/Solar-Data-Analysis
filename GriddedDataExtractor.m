% Update: March 2020
% Navid Haghdadi

function [GriddedData,NearestPoint]=GriddedDataExtractor(Lat,Long,StartDate,EndDate)
% To extract solar data for one location

% Example:
% StartDate=20020101;
% EndDate=20020305;
% Lat=-30.016667;
% Long=148.116667;
% [GriddedData,NearestPoint]=GriddedDataExtractor(Lat,Long,StartDate,EndDate)
Lat=Lat(:);
Long=Long(:);
[Long1,Lat1]=meshgrid(112.025:0.05:153.95,-10.075:-0.05:-43.975000);

for i_ll=1:size(Lat,1)
    
    Location.Lat=Lat(i_ll);
    Location.Long=Long(i_ll);
    
    [~,Lat_ind2]=min((Long1-Location.Long).^2+(Lat1-Location.Lat).^2);
    [~,Long_ind2]=min(min((Long1-Location.Long).^2+(Lat1-Location.Lat).^2));
    Lat_ind2=Lat_ind2(1);
    
    NearestPoint.Long(i_ll,1)=Long1(Lat_ind2,Long_ind2);
    NearestPoint.Lat(i_ll,1)=Lat1(Lat_ind2,Long_ind2);
    Lat_ind(i_ll,1)=Lat_ind2;
    Long_ind(i_ll,1)=Long_ind2;
    
end

SD=datetime(num2str(StartDate),'InputFormat','yyyyMMdd');
ED=datetime(num2str(EndDate),'InputFormat','yyyyMMdd');
ED.Day=ED.Day+1;
TS=[SD:hours(1):ED]';
TS.Format='yyyy-MMM-dd HH:mm';

GriddedGHI=nan(size(TS,1),size(Lat,1));
GriddedDNI=nan(size(TS,1),size(Lat,1));
AllYM=unique([TS.Year,TS.Month],'rows');

for i=1:size(AllYM,1)
    i
    mm=['0',num2str(AllYM(i,2))];mm=mm(end-1:end);
    try
        NewData=load(['d:\Database\BOM_Weather_Data\Grid Satellite Hourly DNI GHI\NewMatFiles\GHI_',num2str(AllYM(i,1)),'_',mm,'.mat']);
        [~,bT,cT]=intersect(TS,NewData.TimeStamp);
        for i_ll=1:size(Lat,1)
            GriddedGHI(bT,i_ll)=NewData.SolarData(Lat_ind(i_ll,1),Long_ind(i_ll,1),cT);
        end
    catch
    end
    
    try
        NewData=load(['d:\Database\BOM_Weather_Data\Grid Satellite Hourly DNI GHI\NewMatFiles\DNI_',num2str(AllYM(i,1)),'_',mm,'.mat']);
        [~,bT,cT]=intersect(TS,NewData.TimeStamp);
        for i_ll=1:size(Lat,1)
            
            GriddedDNI(bT,i_ll)=NewData.SolarData(Lat_ind(i_ll,1),Long_ind(i_ll,1),cT);
        end
    catch
    end
end

GriddedData=table;
GriddedData.TimeStamp=TS;
GriddedData.GHI=GriddedGHI;
GriddedData.DNI=GriddedDNI;

%
% % Visualising data
% figure
% for i3=1:100
% imagesc(SolarData(:,:,i3))
% pause
% end