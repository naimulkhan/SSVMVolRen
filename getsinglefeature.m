function feature=getsinglefeature(V,XPos,YPos,ZPos)

feature=-1*ones(1,5);
siz=size(V);


if(XPos<2 || XPos >siz(1)-2 || YPos<2 || YPos >siz(2)-2 || ZPos<2 || ZPos >siz(3)-2) %ignoring boundary stuff
    return;
end

feature(1)=V(XPos,YPos,ZPos);
feature(2)=sqrt(((V(XPos,YPos,ZPos)-V(XPos-1,YPos,ZPos))/2).^2+((V(XPos,YPos,ZPos)-V(XPos,YPos-1,ZPos))/2).^2+((V(XPos,YPos,ZPos)-V(XPos,YPos,ZPos-1))/2).^2);
feature(3)=V(XPos-1,YPos,ZPos)+V(XPos-1,YPos-1,ZPos)+V(XPos-1,YPos+1,ZPos)+V(XPos,YPos+1,ZPos)+V(XPos,YPos-1,ZPos)+V(XPos+1,YPos,ZPos)+V(XPos+1,YPos-1,ZPos)+V(XPos+1,YPos+1,ZPos)/8;
feature(4)=V(XPos-1,YPos,ZPos)+V(XPos-1,YPos,ZPos-1)+V(XPos-1,YPos,ZPos+1)+V(XPos,YPos,ZPos+1)+V(XPos,YPos,ZPos-1)+V(XPos+1,YPos,ZPos)+V(XPos+1,YPos,ZPos-1)+V(XPos+1,YPos,ZPos+1)/8;
feature(5)=V(XPos,YPos-1,ZPos)+V(XPos,YPos-1,ZPos-1)+V(XPos,YPos-1,ZPos+1)+V(XPos,YPos,ZPos+1)+V(XPos,YPos,ZPos-1)+V(XPos,YPos+1,ZPos)+V(XPos,YPos+1,ZPos-1)+V(XPos,YPos+1,ZPos+1)/8;
end