% Aug2016
% Update March 2020
% Navid Haghdadi
% This file is used for importing data from text file to my new mat files

InputFolderPath='C:\Codes\Solar-Data-Analysis\Input'; % this folder should have folders: HOURLY_GHI and HOURLY_DNI and in
% each folder, each year should be in a folder
OutputFolderPath='C:\Codes\Solar-Data-Analysis\Output'; % the outputs will be saved in this folder

%listYears=dir('C:\Users\Navid\Dropbox\Database\Weather\BOM_Weather_Data\Grid Satellite Hourly DNI GHI\HOURLY_GHI');
listYears=dir([InputFolderPath,'\HOURLY_GHI']);

listYears=listYears(3:end);
[Long1,Lat1]=meshgrid(112.025:0.05:153.95,-10.075:-0.05:-43.975000);


stre='%f';
for i=1:838
    stre=[stre,' %f'];
end

% GHI
for ij=1:size(listYears,1)
    for m=1:12
        mm=['0',num2str(m)];mm=mm(end-1:end);
        list2=dir([InputFolderPath,'\HOURLY_GHI\',listYears(ij).name,'\solar_ghi_',listYears(ij).name,mm,'*']);
        clear TimeStamp SolarData
        if size(list2,1)>0
            for i=1:size(list2,1)
                [1 ij m i]
                FI=fopen([InputFolderPath,'\HOURLY_GHI\',listYears(ij).name,'\',list2(i).name]);
                N=12;
                C_text = textscan(FI,'%s',N,'Delimiter',' ');
                C_data0 = textscan(FI,stre,'Delimiter',' ','CollectOutput',1);
                SolarData(:,:,i)=C_data0{1,1};
                fclose(FI);
                TimeStamp(i,1) = datetime(list2(i).name(11:end-6),'InputFormat','yyyyMMdd_HH');
            end
        save([OutputFolderPath,'\GHI_',listYears(ij).name,'_',mm,'.mat'],'TimeStamp','SolarData','-v7.3');
        end
    end
    
end

% DNI

for ij=1:size(listYears,1)
    for m=1:12
        mm=['0',num2str(m)];mm=mm(end-1:end);
        list2=dir([InputFolderPath,'\HOURLY_DNI\',listYears(ij).name,'\solar_dni_',listYears(ij).name,mm,'*']);
        clear TimeStamp SolarData
        if size(list2,1)>0
            for i=1:size(list2,1)
                [2 ij m i]
                FI=fopen([InputFolderPath,'\HOURLY_DNI\',listYears(ij).name,'\',list2(i).name]);
                N=12;
                C_text = textscan(FI,'%s',N,'Delimiter',' ');
                C_data0 = textscan(FI,stre,'Delimiter',' ','CollectOutput',1);
                SolarData(:,:,i)=C_data0{1,1};
                fclose(FI);
                TimeStamp(i,1) = datetime(list2(i).name(11:end-6),'InputFormat','yyyyMMdd_HH');
            end
        save([OutputFolderPath,'\DNI_',listYears(ij).name,'_',mm,'.mat'],'TimeStamp','SolarData','-v7.3');
        end
    end
end