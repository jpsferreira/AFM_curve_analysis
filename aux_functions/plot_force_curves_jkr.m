function plot_force_curves_jkr(i_w,f_exp, i_wc, f_fit)

    scatter(i_w,f_exp,'DisplayName','Experimental');
    legend('-DynamicLegend');
    set(gca, 'XDir','reverse');
    hold on
    plot(i_wc,f_fit,'LineWidth',2.0,'DisplayName','JKR model');
    xlabel('Indentation and Distance  (nm)');
    ylabel('Force (nN)');
end