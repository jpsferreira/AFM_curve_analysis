# Analysis of force curves from Atomic Force Microscopy (AFM) using MATLAB


A standard AFM in contact mode has a flexible cantilever that contains probe with a tip to contact the sample surface in a raster pattern. A piezoelectric ceramic scanner controls the lateral and the vertical position of the AFM probe relative to the surface. As the AFM tip engages features of different height and stiffness the deflection of the AFM cantilever changes. This deflection is tracked by a laser beam reflected from the back side of the AFM cantilever and directed into a position sensitive photodetector [^1].


AFM can measure physical properties of soft samples. These properties are extracted from the so-called force-distance curves and include elasticity, adhesion forces, and friction. To obtain a force curve, the cantilever is moved towards the surface in the normal direction until a maximum force is reached. Then, its direction is reversed, and the cantilever moves away from the sample. Each cycle of motion is called a ramp. It contains both **approach** and **withdraw** parts, according to the direction of motion of the cantilever with respect to the sample [^2]. The cantilever behaves as a Hookean spring whose stiffness $k$ can be readily determined. Thus, the cantilever deflection $d$ is easily converted into forces ($F$) acting on the cantilever tip, as follows
$$F = kd $$

The indentation $i$ of the sample is given by the difference between the vertical position of the
cantilever $z$ and the corresponding deflection, calculated as
$$i = z - d - (z_{CP} - d_{CP})$$
where $z_{CP}$ and $d_{CP}$ are the vertical position and deflection at the contact point (CP).

In a AFM force curve, raw data corresponds to the Photovoltage potential $\Delta V$ as a function of time.
<p align="center">
<img src="https://user-images.githubusercontent.com/11409748/180245328-3cb2081d-15b5-41a2-bdee-20ec548a5a58.gif" width="800">
</p>


After calibration of the deflection sensitivity, one can obtain force-distance curve on the sample. Soft samples deform when the cantilever is brought into contact. Change in the tip-sample contact area make the force curve non linear. Retraction curves show negative force peaks due to adhesion, and lower deflections due to dissipative behaviors of the sample. Any appropriate contact model can be applied to eith approach or withdraw portion of the curve. 
<p align="center">
<img src="https://user-images.githubusercontent.com/11409748/180231272-2d1de43b-41cb-43cf-9f5c-0af1ed9fe628.png" width="400">
</p>
# MATLAB code


📦AFM_curve_analysis_in_MATLAB
 ┣ 📂aux_functions  - helper functions
 ┣ 📂sample - raw data
 ┣ 📂sensitivity - raw data sensitivity
 ┣ 📜README.md
 ┣ 📜analyse_samples_curves.m
 ┣ 📜analyse_sensitivity_curves.m
 ┣ 📜plot_typical_curve.m
 ┣ 📜run_analysis.m
 ┣ 📜run_statistics.m
 ┗ 📜sample_example.png


This code processes the raw data signals and apply a contact model to determine sample stiffness. I have implemented the following contact models:

- Hertz model
- Sneddon model
- JKR model

### Run sensitivity and sample analsyses:
```
run_analysis()
```


**Output example:**
<p align="center">
<img src="https://user-images.githubusercontent.com/11409748/180245394-5c91a77d-b54d-4f55-9890-1ac9ed3cfa3b.png" width="500">
</p>


### Run statistics for the analysed curves:
```
run_statistics()
```




[^1]: [NanoAndMore](https://www.nanoandmore.com/what-is-atomic-force-microscopy)
[^2]: [MyPhdThesis](https://repositorio-aberto.up.pt/handle/10216/127484)
