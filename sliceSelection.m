function [Xind,Yind,Zind]=sliceSelection(V)


%This function picks the top 3 slices in Sagittal, Coronal, and Axial
%directions based on entropy. Refer to the paper for further details
val=zeros(size(V,3),1);

parfor i=1:size(V,3)
    val(i)=entropy(V(:,:,i)/max(max(V(:,:,i)))); %has to be in the range of [0,1] for IMHIST
  
end

[~,Zind]=max(val);

val=zeros(size(V,2),1);
parfor i=1:size(V,2)
    val(i)=entropy(V(:,i,:)/max(max(V(:,i,:))));
  
end

[~,Yind]=max(val);

val=zeros(size(V,1),1);
parfor i=1:size(V,1)
    val(i)=entropy(V(i,:,:)/max(max(V(i,:,:))));
  
end

[~,Xind]=max(val);

% Xind=100;
% Yind=100;
% Zind=100;