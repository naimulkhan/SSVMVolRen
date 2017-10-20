function mask=classifyVolume(F,alreadySelected,totClusters)

%wanna use intensity, gradient magnitude, neighboring voxel values

%first get the indices

siz=size(alreadySelected);

% for j=1:totClusters-1
%     selectInd=find(alreadySelected==j);
%     
%     [Ix,Iy,Iz]=ind2sub(siz,selectInd);
%     
%     for i=1:length(Ix)
%   
%         classes{j}.trainingfeatures(i,:)=squeeze(F(Ix(i),Iy(i),Iz(i),:))';
%         
%     end
% end

testdata=reshape(F,siz(1)*siz(2)*siz(3),5); %with reshape, index X changes first, then Y, then Z, cuz its column-wise

 clear F;

totalrun=nchoosek(1:totClusters-1,2);

votecount=uint8(zeros(length(testdata),totClusters-1));
%training and classification
options = optimset('maxiter',1000000);
tic;

for i=1:size(totalrun,1)
    
    %SVMStruct=svmtrain([classes{totalrun(i,1)}.trainingfeatures;classes{totalrun(i,2)}.trainingfeatures],[totalrun(i,1)*ones(size(classes{totalrun(i,1)}.trainingfeatures,1),1);totalrun(i,2)*ones(size(classes{totalrun(i,2)}.trainingfeatures,1),1)],'kernel_function','rbf','quadprog_opts',options);
   
    ind1=alreadySelected==totalrun(i,1);
   
    ind2=alreadySelected==totalrun(i,2);
    SVMStruct=svmtrain([testdata(ind1,:);testdata(ind2,:)],[totalrun(i,1)*ones(size(testdata(ind1,:),1),1);totalrun(i,2)*ones(size(testdata(ind2,:),1),1)],'kernel_function','rbf','quadprog_opts',options);
    result=svmclassify(SVMStruct,testdata);
  
    for j=1:totClusters-1
        votecount(:,j)=votecount(:,j)+uint8(result==j);
    
    end
end 

cputime=toc;
cputime

%clear classes;
    
[~,votecount]=max(votecount,[],2);

mask=reshape(votecount,siz(1),siz(2),siz(3));
 






%disp('starting classification...');
clear testdata;



%mask=false(siz(1),siz(2),siz(3));

%disp('DONE!');
% label=ones(size(testset_a1d,1),1);
%     
%     labelres=svmclassify(SVMStruct,testset_a1d);
%     FN=sum(abs(label-labelres));
%     TP=size(testset_a1d,1)-FN;
%     
%     label=2*ones(size(testset_b1d,1),1);
%     labelres=svmclassify(SVMStruct,testset_b1d);



%save('dinga.mat','RGBA');
end
