function newcolors = roll_chrome(olddata,X)
%% Simulate a single roll for a chromatic orb

nsockets = sum(olddata(4:6));
oldorder = zeros(1,nsockets);
oldcolors = olddata(4:6);

oldorder(1:oldcolors(1)) = 1;
oldorder(oldcolors(1)+1:oldcolors(1)+oldcolors(2)) = 2;
oldorder(oldcolors(1)+oldcolors(2)+1:nsockets) = 3;

neworder = oldorder;

while neworder == oldorder
    red_thresh = olddata(1) + X;
    green_thresh = olddata(1) + olddata(2) + 2*X;
    r = randi(sum(olddata(1:3))+3*X,1,nsockets);
    neworder(r<=red_thresh) = 1;
    neworder(r<=green_thresh & r>red_thresh) = 2;
    neworder(r>green_thresh) = 3;
end

for i = 1:3
    newcolors(i) = sum(neworder == i);
end

end