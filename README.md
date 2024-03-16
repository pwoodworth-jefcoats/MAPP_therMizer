# MAPP_therMizer
This repository is home to the code used to run therMizer simulations
for a UH-NOAA MAPP collaboration.  It's currently being built out, so
if you don't see a file that's mentioned know that it'll be available
soon.  

## Climate Forcing
therMizer is forced by both temperature and plankton data. These data
come from members of the CESM2 earth system model large ensemble (LENS).  `MAPP_forcing_visualization.Rmd` was used to visualize some of the LENS 
data that was used to force therMizer.

### Temperature data
Temperature was vertically averaged over depth ranges representative of 
species' vertical habitat use.  It was then horizontally averaged over the
model domain. 

Temperatures from the World Ocean Atlas were used as a baseline to which
the LENS-projected change in temperature were applied.  Change was 
measured as the difference between 2015 and the years 2016 - 2100.

Further details about processing the temperature data can be found in
`Workflow_Temperature.Rmd`.

### Plankton data
Plankton carbon was vertically integrated over the upper 150 m of the water
column and then summed over the model domain.  This was done for small 
phytoplankton, diatoms, diazotrophs, and zooplankton, individually.  Within
each class of plankton, total carbon was converted to numerical abundance and
used to calculate a resource spectra which sets the prey available at each
time step in the therMizer simulation.

Further details about processing the plankton data can be found in
`Workflow_Plankton.Rmd`.

## Fishing Forcing
A static fishing simulation is used to assess the effects of climate variability 
and change.  Several dynamic fishing simulations are run to assess the potential 
effects of changing fishing mortality.

Further details about preparing these simulation forcings can be found in
`Workflow_Fishing.Rmd`.

## therMizer Simulations
`MAPP_run_therMizer_Baseline.Rmd` was used to run baseline therMizer simulations.  Ten baseline simulations were run, one each with input from each LENS ensemble member, all with fishing mortality set a 0.2.  `MAPP_baseline_results.Rmd` was used to visualize simulation results.

Further information, including all code, for the [mizer](https://sizespectrum.org/mizer/) food web model and 
the [therMizer](https://github.com/sizespectrum/therMizer) model extension is available online.

---

## Questions?  Comments?  Corrections?
Please open an issue or email Phoebe.Woodworth-Jefcoats@noaa.gov

---

### Disclaimer
This repository is a scientific product and is not official communication 
of the National Oceanic and Atmospheric Administration, or the United 
States Department of Commerce. All NOAA GitHub project code is provided on 
an ‘as is’ basis and the user assumes responsibility for its use. Any 
claims against the Department of Commerce or Department of Commerce bureaus 
stemming from the use of this GitHub project will be governed by all 
applicable Federal law. Any reference to specific commercial products, 
processes, or services by service mark, trademark, manufacturer, or otherwise, 
does not constitute or imply their endorsement, recommendation or favoring by 
the Department of Commerce. The Department of Commerce seal and logo, or the 
seal and logo of a DOC bureau, shall not be used in any manner to imply 
endorsement of any commercial product or activity by DOC or the United 
States Government.

### License
This repository uses the GNU General Public License v3.0 (GPL-3).
Additionally, Software code created by U.S. Government employees 
is not subject to copyright in the United States (17 U.S.C. §105). 
The United States/Department of Commerce reserves all rights to 
seek and obtain copyright protection in countries other than the 
United States for Software authored in its entirety by the Department 
of Commerce. To this end, the Department of Commerce hereby grants 
to Recipient a royalty-free, nonexclusive license to use, copy, and 
create derivative works of the Software outside of the United States.
See LICENSE for further details.
