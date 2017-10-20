function outclass = mysvmclassify(svmStruct,sample,sigma)

%sampleOrig = sample;
    if ~isempty(svmStruct.ScaleData)
        for c = 1:size(sample, 2)
            sample(:,c) = svmStruct.ScaleData.scaleFactor(c) * ...
                (sample(:,c) +  svmStruct.ScaleData.shift(c));
        end
    end
classified = mysvmdecision(sample,svmStruct,sigma);
classified(classified == -1) = 2;
outclass = classified;
groupnames = svmStruct.GroupNames; 
[g,groupString] = grp2idx(groupnames);
if isnumeric(groupnames) || islogical(groupnames)
        groupString = str2num(char(groupString)); %#ok
        outclass = groupString(outclass);
    elseif ischar(groupnames)
        groupString = char(groupString);
        outclass = groupString(outclass,:);
    else %if iscellstr(groupnames)
        outclass = groupString(outclass);
end