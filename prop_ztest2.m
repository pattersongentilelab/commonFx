function z_val=prop_ztest2(x1,x2)
% calculates proportional z-test for two populations
% x1 - sample 1
% x2 - sample 2

category = unique([x1;x2]);

    n1=length(x1);
    n2=length(x2);

    p1=length(find(x1==category(1)))/n1;
    p2=length(find(x2==category(1)))/n2;
    p_all=(length(find(x1==category(1)))+length(find(x2==category(1))))/(n1+n2);

    z_val = (p1-p2)/sqrt(p_all*(1-p_all)*((1/n1)+(1/n2)));
end