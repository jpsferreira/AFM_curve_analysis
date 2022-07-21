function draw_fit_line(x,yfit)
    hold on
    yfit = yfit+4*mean(yfit);
    plot(x,yfit,'-.','DisplayName','Fit','LineWidth',1.5);
end