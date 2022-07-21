function c_b = get_base(z_ref,v_ref,z_a,r)

delimiter=round(size(z_a,1)*r*0.5);
final=size(z_a,1);

b = linearFit(z_ref(delimiter:final-delimiter),v_ref(delimiter:final-delimiter));

c_b = [ones(size(z_a,1),1) z_a]*b;

end