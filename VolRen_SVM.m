function varargout = VolRen_SVM(varargin)
% VOLREN_SVM MATLAB code for VolRen_SVM.fig
%      VOLREN_SVM, by itself, creates a new VOLREN_SVM or raises the existing
%      singleton*.
%
%      H = VOLREN_SVM returns the handle to a new VOLREN_SVM or the handle to
%      the existing singleton*.
%
%      VOLREN_SVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLREN_SVM.M with the given input arguments.
%
%      VOLREN_SVM('Property','Value',...) creates a new VOLREN_SVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VolRen_SVM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VolRen_SVM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VolRen_SVM

% Last Modified by GUIDE v2.5 14-Jun-2013 12:50:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VolRen_SVM_OpeningFcn, ...
                   'gui_OutputFcn',  @VolRen_SVM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VolRen_SVM is made visible.
function VolRen_SVM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VolRen_SVM (see VARARGIN)

% Choose default command line output for VolRen_SVM
handles.output = hObject;
% handles.curdata='Carp';
% handles.curdir='../../MyVTKData/';
% fid = fopen(strcat(handles.curdir,'filename.txt'), 'w','l');
% fprintf(fid,'%s\n',handles.curdata);
% fclose(fid);

handles.totClusters=1; %how many clusters is the user defining? Gets updated when a class labeling is
                        %finalized
% fid = fopen(strcat(handles.curdir,'filename.txt'), 'w','l');
% fprintf(fid,'%s\n',handles.curdata);
% fclose(fid);
%load(strcat(handles.curdir,handles.curdata,'mask.mat'));

%Features have been extracted through FeatureExtraction.m beforehand
load('Lobster_features_svm.mat'); 

%This data is probably not appropriate for segmentation test, find a better
%dataset
V=double(read3DRawImage('Lobster.raw',301,324,56,'uchar'));

handles.alreadySelected=zeros(size(V)); %variable keeps track of which voxels have been already selected
handles.alreadySelected=uint16(handles.alreadySelected);
handles.V=V;
siz=size(handles.V);
handles.F=reshape(F,siz(1)*siz(2)*siz(3),5); %holds the features

[handles.Ix,handles.Iy,handles.Iz]=sliceSelection(V); %this function picks the top 3 slices along 3 directions
                                                       % and shows GUI for
                                                       % selection
colormap(gray);
imagesc(squeeze(V(handles.Ix,:,:)), 'Parent',handles.XSlice); %show slice in sagittal
axis(handles.XSlice,'off');
imagesc(squeeze(V(:,handles.Iy,:)), 'Parent',handles.YSlice); %show slice in coronal
axis(handles.YSlice,'off');
imagesc(squeeze(V(:,:,handles.Iz)), 'Parent',handles.ZSlice); %show slice in axial
axis(handles.ZSlice,'off');
clear V;
clear F;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes VolRen_SVM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VolRen_SVM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectFromX.
function selectFromX_Callback(hObject, eventdata, handles)
% hObject    handle to selectFromX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hFH = imfreehand(handles.XSlice); %imfreehand helps drawing ROI around object
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
binaryImage=xor(squeeze(handles.alreadySelected(handles.Ix,:,:))==handles.totClusters,binaryImage);
handles.alreadySelected(handles.Ix,:,:)=squeeze(handles.alreadySelected(handles.Ix,:,:)) + handles.totClusters*uint16(binaryImage);
%figure;imshow(squeeze(handles.alreadySelected(handles.Ix,:,:)));

guidata(hObject, handles);

% --- Executes on button press in selectFromY.
function selectFromY_Callback(hObject, eventdata, handles)
hFH = imfreehand(handles.YSlice);
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
binaryImage=xor(squeeze(handles.alreadySelected(:,handles.Iy,:))==handles.totClusters,binaryImage);
handles.alreadySelected(:,handles.Iy,:)=squeeze(handles.alreadySelected(:,handles.Iy,:)) + handles.totClusters*uint16(binaryImage);
%figure;imshow(squeeze(handles.alreadySelected(:,handles.Iy,:)));

guidata(hObject, handles);

% --- Executes on button press in selectFromZ.
function selectFromZ_Callback(hObject, eventdata, handles)
hFH = imfreehand(handles.ZSlice);
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
binaryImage=xor(squeeze(handles.alreadySelected(:,:,handles.Iz))==handles.totClusters,binaryImage);

handles.alreadySelected(:,:,handles.Iz)=squeeze(handles.alreadySelected(:,:,handles.Iz)) + handles.totClusters*uint16(binaryImage);
%figure;imshow(squeeze(handles.alreadySelected(:,:,handles.Iz)));

guidata(hObject, handles);


% hObject    handle to selectFromZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in classifybutton.
function classifybutton_Callback(hObject, eventdata, handles)
% hObject    handle to classifybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mask=classifyVolume(hObject, eventdata, handles);
%size(handles.mask)
%sum(sum(sum(handles.mask==0)))
%sum(sum(sum(handles.mask==1)))
%sum(sum(sum(handles.mask==2)))
%figure;imagesc(handles.V(:,:,128));

%figure;imagesc(handles.mask(:,:,128));
guidata(hObject, handles);




% --- Executes on button press in defineClass.
function defineClass_Callback(hObject, eventdata, handles)
% hObject    handle to defineClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.totClusters=handles.totClusters+1; % a class has been defined, update number of clusters
nnz(handles.alreadySelected)
guidata(hObject, handles);

function mask=classifyVolume(hObject, eventdata, handles)
%this function does the actual SVM classification 

load(strcat('Lobstermask.mat'));

%wanna use intensity, gradient magnitude, neighboring voxel values

%first get the indices

siz=size(handles.alreadySelected);

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

%testdata=reshape(handles.F,siz(1)*siz(2)*siz(3),5); %with reshape, index X changes first, then Y, then Z, cuz its column-wise

%one-vs-one classification: each two classes are paired up against
%one another. Final class of a voxel is decided through voting. 
%Read this: https://www.quora.com/Whats-an-intuitive-explanation-of-one-versus-one-classification-for-support-vector-machines
totalrun=nchoosek(1:handles.totClusters-1,2); 
%votecount keeps track of how many times is a voxel being classified to 
%a particular class
%
votecount=uint8(zeros(length(handles.F),handles.totClusters-1)); 
size(votecount)
%training and classification
options = optimset('maxiter',1000000);
tic;

for i=1:size(totalrun,1)
    
    %SVMStruct=svmtrain([classes{totalrun(i,1)}.trainingfeatures;classes{totalrun(i,2)}.trainingfeatures],[totalrun(i,1)*ones(size(classes{totalrun(i,1)}.trainingfeatures,1),1);totalrun(i,2)*ones(size(classes{totalrun(i,2)}.trainingfeatures,1),1)],'kernel_function','rbf','quadprog_opts',options);
   
    ind1=handles.alreadySelected==totalrun(i,1);
   
    ind2=handles.alreadySelected==totalrun(i,2);
    SVMStruct=svmtrain([handles.F(ind1,:);handles.F(ind2,:)],[totalrun(i,1)*ones(size(handles.F(ind1,:),1),1);totalrun(i,2)*ones(size(handles.F(ind2,:),1),1)],'kernel_function','rbf','quadprog_opts',options);
    
    %switch to mysvmclassify for our SN-SVM classifier. But first just do
    %it with traditional SVM
    result=svmclassify(SVMStruct,handles.F(~J(:),:));
  
    for j=1:handles.totClusters-1
        votecount(~J(:),j)=votecount(~J(:),j)+uint8(result==j);
    
    end
    clear result;
end 


cputime=toc;
cputime

clear ind1;
clear ind2;
 %we are keeping the INDEX of the max votecount foe each row,
 %because the index of max decides which class a voxel belongs to
 %the actual votecount doesn't matter
 will dec
[~,votecount]=max(votecount,[],2);

%set the voxels that belong to the background to zero
votecount(J(:))=0;
%reshape into a 3D matrix so that it can act as a classification result
%for the whole volume
mask=reshape(votecount,siz(1),siz(2),siz(3));

%from this point onward, this mask was being used to render the volume.
% We would like to do segmentation instead.

clear votecount; 






%disp('starting classification...');




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
