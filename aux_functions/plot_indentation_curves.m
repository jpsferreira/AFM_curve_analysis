function plot_indentation_curves(x_data,y_data,xx_data,yy_data)
 
 plot(x_data,y_data,'-','LineWidth',2,'MarkerSize',10,'DisplayName','Approach');
 legend('-DynamicLegend');
 set(gca, 'XDir','reverse');
 hold on
 plot(xx_data,yy_data,'-','LineWidth',2,'MarkerSize',10,'DisplayName','Witdrawn');
 xlabel('Indentation and Distance  (nm)');
 ylabel('Deflection (nm)');

 vline(0)
end