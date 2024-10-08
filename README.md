# AMCONF2024_ThreeMIB
Models used in the paper "Building Power System Models for Stability and Control Design  Analysis using Modelica and the OpenIPSL" by S. Bhattacharjee, L. Vanfretti, and F. Fachini for the American Modelica Conference 2024.
## General Information

This repository contains the power system Models used in the paper "Building Power System Models for Stability and Control Design  Analysis using Modelica and the OpenIPSL" by S. Bhattacharjee, L. Vanfretti, and F. Fachini submitted to the American Modelica Conference 2024.

The models were developed and tested with **Dymola 2024X** under MS Windows 10. 
### Dependencies
- [OpenIPSL v.3.0.1](https://github.com/OpenIPSL/OpenIPSL/releases/tag/v3.0.1), please download it from this version's library release, [here](https://github.com/OpenIPSL/OpenIPSL/releases/tag/v3.0.1)
- **Modelica Standard Library v.4.0.0** (shipped with Dymola 2024X)
- **Modelica_LinearSystems2 v2.4.0** (shipped with Dymola 2024X)
- **DataFiles v1.1.0** (shipped with Dymola 2024X)
- **DymolaCommands v1.16** (shipped with Dymola 2024X)
- **LinearAnalysis v1.0.1** (Shipped with Dymola 2024X)
### How to Run

To run the time domain simulation to observe the rotor speed of the generator under a load disturbance, simulate the model _ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_NonlinExperiment_ for 40 sec.

## Acknowledment
The development of these models is based upon work supported by the U.S. Department of Energy’s Office of Energy Efficiency and Renewable Energy (EERE) under the Advanced Manufacturing Office, Award Number DE-EE0009139.
