function label_sensitivity(value,v_curve,ramp_size)

txt= ['sensitivity = ',num2str(value), ' nm/V'];
    tt=text(0.8*ramp_size,0.8*min(v_curve),txt);
    tt.FontSize = 12;
end