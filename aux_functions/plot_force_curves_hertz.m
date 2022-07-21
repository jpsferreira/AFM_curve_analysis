function plot_force_curves_hertz(i_a,f_exp, i_ac, f_fit,e,r2)

    scatter(i_a,f_exp,'DisplayName','Experimental');
    legend('-DynamicLegend');
    set(gca, 'XDir','reverse');
    hold on
    str=strcat('E=',sprintf('%g',round(e,2,'significant')),'kPa', '(R^2=',sprintf('%g',round(r2,3,'significant')),')');
    plot(i_ac,f_fit,'LineWidth',2.0,'DisplayName',['Hertz model',newline,str]);
    xlabel('Indentation and Distance  (nm)');
    ylabel('Force (nN)');
end