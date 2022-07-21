function [x_wc]=withdraw_contact(i_dp,x_w)
    %
      range= 1:(i_dp-1);
      x_wc = x_w(range);
end