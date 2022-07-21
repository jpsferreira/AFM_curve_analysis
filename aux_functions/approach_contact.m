function [x_ac]=approach_contact(i_cp,x_a)
   
    range= i_cp:size(x_a,1);
    x_ac = x_a(range);
end