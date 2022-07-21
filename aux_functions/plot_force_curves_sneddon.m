function plot_force_curves_sneddon(i_a,f_exp, i_ac,fs_fit,es,r2s)

    scatter(i_a,f_exp,'DisplayName','Experimental');
    legend('-DynamicLegend');
    set(gca, 'XDir','reverse');
    hold on
    str=strcat('E=',sprintf('%g',round(es,2,'significant')),'kPa', '(R^2=',sprintf('%g',round(r2s,3,'significant')),')');
    plot(i_ac,fs_fit,'LineWidth',2.0,'DisplayName',['Sneddon model',newline,str]);
    xlabel('Indentation and Distance  (nm)');
    ylabel('Force (nN)');
end