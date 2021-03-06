/*
    This module is the for generating fresnel lens models and molds
*/
$fs = 0.01;

SPHERE_FACETS = 100;
CYLINDER_FACETS = 100;

LENS_R  = 25;
LENS_T  = 1;
BASE_T  = 2;
N_SECTIONS = 5;



module fresnel_lens( lens_radius    = LENS_R,
                     lens_thickness = LENS_T,
                     num_sections   = N_SECTIONS
                   )
{
  for (n = [1:num_sections])
  {
    t_n  = n*lens_thickness;
    a_n  = sqrt((2*lens_radius - t_n)*t_n);
    
    t_nm1 = (n-1)*lens_thickness;
    a_nm1 = sqrt((2*lens_radius - t_nm1)*t_nm1);
 
    intersection()
    {
      translate([0,0,-(lens_radius - t_n - BASE_T)])
      sphere(r=lens_radius, $fn=SPHERE_FACETS);
      difference(){
        cylinder(h=lens_radius, r=a_n,   $fn=CYLINDER_FACETS);
        cylinder(h=lens_radius, r=a_nm1, $fn=CYLINDER_FACETS);
      }
    }
  }
}

MOLD_THICKNESS = 3;

module fresnel_lens_mold( lens_radius    = LENS_R,
                          lens_thickness = LENS_T,
                          num_sections   = N_SECTIONS,
                          mold_thickness = MOLD_THICKNESS
                         )
{
  t_N  = num_sections*lens_thickness;
  a_N  = sqrt((2*lens_radius - t_N)*t_N);
  
  translate([0,0,mold_thickness])
  rotate(a=180, v=[1,0,0])
  difference(){
    translate([0,0,mold_thickness/2])
    cube([2.2*a_N,2.2*a_N, mold_thickness], center=true);
    translate([0,0,-lens_thickness/2])
    #fresnel_lens(lens_radius = lens_radius,
                 lens_thickness = lens_thickness,
                 num_sections = num_sections
                 );
  }
}
/******************************************************************************/
//rendering of part

//fresnel_lens();
fresnel_lens_mold();




