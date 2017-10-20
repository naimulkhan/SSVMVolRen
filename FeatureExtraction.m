


    V=double(mha_read_volume('lobster.mha'));

siz=size(V);
F=zeros(siz(1),siz(2),siz(3),5);
for i=1:siz(1)
    for j=1:siz(2)
        for k=1:siz(3)
            
            F(i,j,k,:)=getsinglefeature(V,i,j,k);
            
        end
    end
end

save('lobster_features_svm.mat'),'F');