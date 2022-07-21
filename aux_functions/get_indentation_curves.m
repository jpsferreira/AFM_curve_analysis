function [i_a,i_w,i_ac,i_wc] = ...
    get_indentation_curves(z_a,z_w,dd_a,dd_w,zcp,icp,ipeak)

    %whole curves
    %approach
    i_a=(z_a-zcp)-dd_a;
    %withdraw
    i_w=(z_w-zcp)-dd_w;

    %contact parts
    %approach
    i_ac=i_a(icp:ipeak-1);

    %withdraw
    eval=10;
    j=0;
    %
    while eval > 0
        j=j+1;
        eval=i_w(j);
        i_wc(j)=i_w(j);
    end
end
