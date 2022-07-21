function [all,x,y,xx,yy,i_peak,data] = get_curves(data,ramp_size)

    t_interval=data.Tinterval;
    ramp_time=t_interval*size(data.A,1);
    ramp_rate=1/ramp_time;
    speed = 2*ramp_size*ramp_rate; %[nm/s]

    
    v=data.A;
    v=v(~isnan(v));
    length=size(v,1);
    
    %v=detrend(v,1);

    t_start=data.Tstart;
    i_peak=find(v == max(v));
    i_peak=round(mean(i_peak));
    t_peak=t_start+i_peak*t_interval;
    t_end=t_start+ramp_time;

    all=zeros(length,1);

    time=t_start;
    for i=1:size(v)
        time=time+t_interval;
        if i < i_peak
            all(i) = ramp_size*(time-t_start)/(t_peak-t_start);
        else
            all(i) = ramp_size*(time-t_end)/(t_peak-t_end);
        end

    end
    %build approach and withdraw curves
    x=all(1:i_peak-1);
    y=v(1:size(x,1));
    y=detrend(y,1);
    xx=all(i_peak:length);
    yy=v(i_peak:i_peak+size(xx,1)-1);
    yy=detrend(yy,1);
    
    %update data file with new fields
    data(:).ramp_time=ramp_time;
    data(:).ramp_rate=ramp_rate;
    data(:).speed=speed;
end