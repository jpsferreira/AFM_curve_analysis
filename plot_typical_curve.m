scatter(ind_approach,def_approach*0.01,'b','DisplayName','Approach')
hold on
scatter(ind_withdraw,def_withdraw*0.01,'r','DisplayName','Withdraw')
hold on
legend('-DynamicLegend');
set(gca, 'XDir','reverse');
hold on 
vline(0.0)
hold on
xt = [0.4 0.3];
yt = [0.4 0.3];
annotation('textarrow',xt,yt,'String','Contact Point','FontSize',20)
hold on
xt = [0.5 0.47];
yt = [0.2 0.2];
annotation('textarrow',xt,yt,'String','Detachment Point','FontSize',20)
%text(xt,yt,str)
hold on 
plot(ind_approach_contact(1:i_lim),ffit_hertz,'k','LineWidth',4.0,'DisplayName','Contact model')
    xlabel('Indentation and Distance  (nm)');
    ylabel('Force (nN)');
ylim([-0.2,1.0]);
set(gca, 'FontSize', 24)
