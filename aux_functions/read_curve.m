function data = read_curve(file_name)

  all_data=load(file_name)

  data.t_interval=all_data.Tinterval;
  data.ramp_time=t_interval*size(all_data.A,1);
  data.ramp_rate=1/ramp_time;
  data.speed = 2*ramp_size*ramp_rate; %[nm/s]

  data.length=all_data.Length;

  data.v=all_data.A;
  data.t_start=all_data.Tstart;
  data.i_peak=find(v == max(v));
  data.t_peak=t_start+i_peak*t_interval;
  data.t_end=t_start+ramp_time;

  data.zpiezo=zeros(length,1);


end
