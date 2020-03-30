
% This exmaple shows how to extract data for specific locations
% Fist the ImportData should be run (with proper input and output folder)
% To convert the txt files to Mat files
% Then the GriddedDataExtractor should be run:

% Example:
StartDate=20020101;
EndDate=20020305;
Lat=-30.016667;
Long=148.116667;
Datafolder='C:\Codes\Solar-Data-Analysis\Output';
[GriddedData,NearestPoint]=GriddedDataExtractor(Lat,Long,StartDate,EndDate,Datafolder);