%by Dr. Rex Cheung
%cheung.r100@gmail.com
%This simple utility program reads a 3D raw image and show the mid cross-section
%of the raw volume image data for verification

function volumeData = read3DRawImage(filename, Xdim, Ydim, Zdim, voxelType)

fid = fopen(filename); %open the file
volumeDataTemp = fread(fid,[Xdim*Ydim Zdim],voxelType); %each slice will be a column
volumeData = reshape(volumeDataTemp,[Xdim Ydim Zdim]); %reshape to the original dimensions before returning the result
fclose(fid); %clean the memory

