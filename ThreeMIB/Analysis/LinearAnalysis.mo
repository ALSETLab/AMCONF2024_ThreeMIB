within ThreeMIB.Analysis;
package LinearAnalysis
  "Shows how to linearize the model, simulate the obtained linear model and compare it against the nonlinear model's response."

  package CustomFunctions
    "Custom functions for automated analysis, including linearization and simulation, and their comparison"
    extends Modelica.Icons.FunctionsPackage;
    function LinearizeSimple
      "Linearize the model at any point in time tlin"
      // Import things needed for the calculations
      import Modelica_LinearSystems2.StateSpace; // to create and manipulate state space objects
      // Declare outputs to display
      output Real A[:,:] "A-matrix";
      output Real B[:,:] "B-matrix";
      output Real C[:,:] "C-matrix";
      output Real D[:,:] "D-matrix";
      output String inputNames[:] "Modelica names of inputs";
      output String outputNames[:] "Modelica names of outputs";
      output String stateNames[:] "Modelica names of states";
      // Declare reconfigurable inputs
      input Modelica.Units.SI.Time tlin=60 "t for model linearization";
      input Modelica.Units.SI.Time tsim=60 "Simulation time";
      input String pathToNonlinearPlantModel = "ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_Linearization" "Nonlinear model for linearization";
      input String pathToNonlinearExperiment = "ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_NonlinExperiment" "Nonlinear Model for simulation";
    algorithm
      // Make sure DAE mode is off!
      Advanced.Define.DAEsolver := false;
      Modelica.Utilities.Streams.print("DAE Mode is turned off.");
      Advanced.Define.GlobalOptimizations :=0;
      Modelica.Utilities.Streams.print("Global optimization is disabled.");
      Advanced.SparseActivate :=false;
      Advanced.Translation.SparseActivateIntegrator :=false;
      Advanced.Translation.SparseActivateSystems :=false;
      Modelica.Utilities.Streams.print("Sparse options disabled.");
      OutputCPUtime :=false; // disable cpu time output so it doesn't scre up the sizes of the outputs
      // Start the linearization process
      Modelica.Utilities.Streams.print("Linearization and Nonlinear Model Comparison is starting...");
      // Compute and display the ABCD matrices, etc
      Modelica.Utilities.Streams.print("Linearized Model");
      (A,B,C,D,inputNames,outputNames,stateNames) :=
        Modelica_LinearSystems2.Utilities.Import.linearize(
        pathToNonlinearPlantModel,tlin);
      nx := size(A, 1); //number of states
      Modelica.Utilities.Streams.print("Number of states: " + String(nx));
      // Now we want to extract the initial value of the outputs to use it in our
      // linear model response
      Modelica.Utilities.Streams.print("Simulating nonlinear model");
      simulateModel(
        pathToNonlinearExperiment,
        stopTime=tsim,
        numberOfIntervals=1000, tolerance = 1e-6,
        resultFile="res_nl");
       ylen :=DymolaCommands.Trajectories.readTrajectorySize("res_nl.mat");
       ny := size(C, 1);
       y0 := DymolaCommands.Trajectories.readTrajectory(
         "res_nl.mat",
         {outputNames[i] for i in 1:ny},
         DymolaCommands.Trajectories.readTrajectorySize("res_nl.mat"));
       DataFiles.writeMATmatrix(
         "MyData.mat",
         "y0",
         [y0[1:ny,ylen]],
         append=true);
      // Print y0's last values which is needed for the linear response model
      y0out := y0[:,ylen]; // we only want the last few elements
      Modelica.Utilities.Streams.print("y0 = ");
      Modelica.Math.Vectors.toString(y0out,name="y0 = ",significantDigits=24);
      annotation(__Dymola_interactive=true, Documentation(info="<html>
<p>This function linearizes the non-linear model at any point in time specified by the user. </p>
<p>The results are displayed in the Commands Window.</p>
<p>The obtained linear model can be used in any other environment. The linear model is available in the file, <span style=\"font-family: Courier New;\">dslin.mat</span>, that will appear under your Dymola working directory. It can be loaded in MATLAB using the Dymola function:</p>
<p><span style=\"font-family: Courier New;\">[A,B,C,D,xName,uName,yName] = tloadlin(&apos;dslin.mat&apos;)</span></p>
<p>Add to the MATLAB workspace the directory and sub-directories under: <span style=\"font-family: Courier New;\">C:\\Program Files\\Dymola 2024x\\Mfiles</span></p>
<p>In addition, the file <span style=\"font-family: Courier New;\">MyData.mat</span> contains the <span style=\"font-family: Courier New;\">y0</span> vector, which corresponds to the output vector at the point in time where linearization is performed. </p>
<p><i><b><span style=\"font-family: Arial;\">Usage</span></b></i></p>
<ol>
<li><span style=\"font-family: Arial;\">In the Package Browser, right click on the function and select &quot;Call function...&quot;. This will open the function&apos;s window.</span></li>
<li><span style=\"font-family: Arial;\">Leave the default parameters on first use. Alternatively, modify the tlin and tsim parameters, note that tsim should be greater or equal to tlin.</span></li>
<li><span style=\"font-family: Arial;\">Go to the bottom of the window and click on &quot;Execute&quot;, if successful, messages/results are displayed in the command window.</span></li>
<li><span style=\"font-family: Arial;\">Go back to the function&apos;s own window and click on &quot;Close&quot;.</span> </li>
</ol>
<p><br><i><b>Sample Output</b></i></p>
<p>Executing the function gives the following results in the &quot;Commands&quot; window.</p>
<p><b><span style=\"font-family: Courier New; font-size: 10pt;\">ThreeMIB.Analysis.LinearAnalysis.CustomFunctions.LinearizeSimple();</span></b></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">DAE&nbsp;Mode&nbsp;is&nbsp;turned&nbsp;off.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Global&nbsp;optimization&nbsp;is&nbsp;disabled.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Warning: Script using obsolete flag Advanced.SparseActivate. Flag is now called Advanced.Translation.SparseActivate.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Sparse&nbsp;options&nbsp;disabled.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Linearization&nbsp;and&nbsp;Nonlinear&nbsp;Model&nbsp;Comparison&nbsp;is&nbsp;starting...</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Linearized&nbsp;Model</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Integer&nbsp;nx&nbsp;;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Number&nbsp;of&nbsp;states:&nbsp;37</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;nonlinear&nbsp;model</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Integer&nbsp;ylen&nbsp;;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Integer&nbsp;ny&nbsp;;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Real&nbsp;y0&nbsp;[5,&nbsp;1004];</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Real&nbsp;y0out&nbsp;[5];</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;&quot;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;=&nbsp;&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.04010999202728271484375&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.01289199250231831683777e-08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.69924986362457275390625&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.65143496100306208518305e-10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.278906673192977905273438&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&quot;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0018522008424100133,&nbsp;0.0,&nbsp;-0.010667194751376403,&nbsp;-0.10017324122069504,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.17089256581647125,&nbsp;-0.015159942341530225,&nbsp;-0.1061195962471122,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.1276904257692333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.1465419304189624,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0025283655600312712,&nbsp;0.01769855900610642,&nbsp;-0.12625673399290213,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.022498434728774507,&nbsp;-0.0029950027077677408,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.004591119808084861,&nbsp;-0.009764212542951947,&nbsp;-0.01953079162183833,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;314.15926535897927,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0017233864279171968,&nbsp;0.0,&nbsp;0.00023080298419404145,&nbsp;0.0,&nbsp;-0.010951723199558115,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.3673104612770817,&nbsp;0.8945130456437131,&nbsp;-0.045806324491108094,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.19607843139653255,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0052270633642785645,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0018873336265140717,&nbsp;0.013211335167105143,&nbsp;-0.001626905716792271,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.004001273218937416,&nbsp;-0.0003301098304959462,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.001102892290693528,&nbsp;0.002345587790855513,&nbsp;-0.0021526907562014,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.17689098859771069,&nbsp;0.0,&nbsp;0.023689968316140477,&nbsp;0.0,&nbsp;-1.1241013843577579,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;16.433040768783922,&nbsp;-18.302047953470716,&nbsp;-0.18364372743036406,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.5365136738699301,&nbsp;0.19371876965494278,&nbsp;1.3560313850800294,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.1669880701408694,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.4106967228080221,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.033883011588873226,&nbsp;0.11320252905430424,&nbsp;0.2407546736381073,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.22095543260089906,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.04613862785197092,&nbsp;0.0,&nbsp;0.35001008016101404,&nbsp;0.0,&nbsp;4.719160383154787,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.1450384645653808,&nbsp;-1.015269253523192,&nbsp;-18.45177991264146,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-4.299180562906219,&nbsp;0.03477895583908227,&nbsp;0.24345268695230576,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;3.8784609740218645,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.46611845266480906,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.07432930984181439,&nbsp;0.211485163094187,&nbsp;0.4497783036669626,&nbsp;0.48471078523579714,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-3.6628012996999604E-05,&nbsp;0.0,&nbsp;-1.50275968345167E-05,&nbsp;0.39147678141987874,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;8.520102833040585E-05,&nbsp;-6.888083527270883E-05,&nbsp;-0.00048216584614484267,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00018601375139655686,&nbsp;-0.0009999999998466444,&nbsp;0.0,&nbsp;-0.023566512711367685,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0022863034695914494,&nbsp;-0.39147678141977155,&nbsp;0.0007543640899297687,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1.959214750542203E-05,&nbsp;-3.964882583232441E-05,&nbsp;-0.0002775417803547215,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-8.088486040000423E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-6.816516366989835E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;4.5676069971613555E-06,&nbsp;-2.879710427053156E-05,&nbsp;-6.124454589959452E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.9785922042335492E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-73.25602599399943,&nbsp;0.0,&nbsp;-30.05519366903436,&nbsp;782953.5628425331,&nbsp;170.4020566608094,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-137.7616705454181,&nbsp;-964.331692289685,&nbsp;-372.0275027931165,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-20.000000002446317,&nbsp;-47133.02541995887,&nbsp;-4572.606938628757,&nbsp;-782953.5628417634,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;1508.728179581574,&nbsp;0.0,&nbsp;39.184295010845375,&nbsp;-79.29765166464851,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-555.0835607094435,&nbsp;-161.76972080001076,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-136.33032733980014,&nbsp;9.13521399433497,&nbsp;-57.594208541062855,&nbsp;-122.48909179918871,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;59.571844084669046,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-76.92307692307693,&nbsp;0.0,&nbsp;-1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-715.9763313609473,&nbsp;-76.92307692307699,&nbsp;-11893.491124260356,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.33333333333333326,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.3333333333333333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539748,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-119.6269680827518,&nbsp;-11.605601381162492,&nbsp;-1987.1917838539746,&nbsp;-1.2468827930174573,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0018522008550070268,&nbsp;0.0,&nbsp;-0.010667194751376403,&nbsp;0.0,&nbsp;0.1465419304599377,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.002528365570598926,&nbsp;0.017698558951017507,&nbsp;-0.12625673410208346,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.10017324122069307,&nbsp;-0.1708925657754888,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.015159942309828119,&nbsp;-0.10611959625814078,&nbsp;0.1276904257692113,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.022498434416687575,&nbsp;-0.002995002927510571,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.004591119789444499,&nbsp;-0.00976421253204411,&nbsp;-0.01953079162183833,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;314.1592653589793,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.001723386427917197,&nbsp;0.0,&nbsp;0.00023080302750306815,&nbsp;0.0,&nbsp;0.005227063364280099,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0018873336265138587,&nbsp;0.013211335167103756,&nbsp;-0.0016269059094271047,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0109517231995549,&nbsp;-1.3673104612399376,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.8945130455660372,&nbsp;-0.045806323913196535,&nbsp;0.0,&nbsp;0.19607843139657907,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.004001272943566596,&nbsp;-0.00033010905493301694,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.001102892290693528,&nbsp;0.002345587790855513,&nbsp;-0.0021526907562014,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.1768909884796137,&nbsp;0.0,&nbsp;0.02368996831614048,&nbsp;0.0,&nbsp;0.5365136738700876,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.19371876866417645,&nbsp;1.3560313842535807,&nbsp;-0.1669880737226969,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-1.1241013862761289,&nbsp;16.433040767993184,&nbsp;-18.30204795409237,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.18364372743033242,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.41069672207656843,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.033883007468695145,&nbsp;0.11320252879217416,&nbsp;0.24075467466071704,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.22095543260089906,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0461386272489224,&nbsp;0.0,&nbsp;0.350010080161014,&nbsp;0.0,&nbsp;-4.299180564867006,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.034778955839078335,&nbsp;0.24345268800713857,&nbsp;3.878460974022533,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;4.719160381193877,&nbsp;-0.14503846510292875,&nbsp;-1.0152692543474071,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-18.451779909862115,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.4661184451946433,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.07432930984181439,&nbsp;0.211485163094187,&nbsp;0.44977830471133,&nbsp;0.4847107869657624,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-3.6628013223745465E-05,&nbsp;0.0,&nbsp;-1.50275968345167E-05,&nbsp;0.0,&nbsp;1.9592148978993223E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-3.96488252616514E-05,&nbsp;-0.00027754177975975245,&nbsp;-8.088485941758361E-05,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.39147678141640185,&nbsp;8.52010298039408E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-6.888083527271661E-05,&nbsp;-0.0004821658463432068,&nbsp;-0.00018601375139652482,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0009999999998466461,&nbsp;0.0,&nbsp;-0.023566512714835685,&nbsp;-0.0022863034730613314,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.3914767814163088,&nbsp;0.0007543640899297374,&nbsp;0.0,&nbsp;-6.816516647868116E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.567599086432894E-06,&nbsp;-2.8797104270530933E-05,&nbsp;-6.124454570325377E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.978592139186723E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-73.25602644749192,&nbsp;0.0,&nbsp;-30.05519366903436,&nbsp;0.0,&nbsp;39.18429795798179,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-79.29765052330195,&nbsp;-555.083559519505,&nbsp;-161.76971883516617,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;782953.562833636,&nbsp;170.40205960788427,&nbsp;-137.76167054543367,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-964.3316926864131,&nbsp;-372.02750279305246,&nbsp;0.0,&nbsp;-20.00000000245106,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-47133.02542883824,&nbsp;-4572.606947510247,&nbsp;-782953.5628328946,&nbsp;1508.7281795815113,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;-136.33033295736485,&nbsp;9.135198172851172,&nbsp;-57.594208541062855,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-122.48909140650656,&nbsp;59.57184278373516,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1153.8461538461534,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-76.92307692307693,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;11893.491124260354,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-715.9763313609475,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-76.92307692307695,&nbsp;-11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.33333333333333326,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.3333333333333333,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1987.1917838539744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-119.62696808275183,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-11.605601381162469,&nbsp;-1987.1917838539748,&nbsp;-1.246882793017455,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.04214933451273178,&nbsp;0.0,&nbsp;-0.0303372350007868,&nbsp;0.0,&nbsp;0.06767465574148963,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.004965237105531911,&nbsp;0.03475665952099592,&nbsp;-0.05222810506397486,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.06767465564600705,&nbsp;0.004965237130179133,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.034756659610931794,&nbsp;-0.052228105191257417,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.11646494761715402,&nbsp;-0.17749864604131832,&nbsp;0.015279517517127583,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.04290110163540943,&nbsp;-0.09124037115997022,&nbsp;0.09963966776572583,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;314.1592653589793,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-0.031526158701099635,&nbsp;0.0,&nbsp;0.047330120188631974,&nbsp;0.0,&nbsp;-0.0786451900727682,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0025053884877752606,&nbsp;-0.017537718968758546,&nbsp;0.06592034940949157,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0786451900727451,&nbsp;-0.002505388335597199,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.017537719127411092,&nbsp;0.06592034901650572,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.1888165395179117,&nbsp;-4.417105172096734,&nbsp;-1.9231460283787938,&nbsp;-4.090071130690461,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.1959569543606567,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.03058470237160829,&nbsp;0.0,&nbsp;0.016578952064260716,&nbsp;0.0,&nbsp;0.005207337288488181,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005495691801891701,&nbsp;0.03846984277019302,&nbsp;0.004166336295567079,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.005207337288486652,&nbsp;0.005495691801892322,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.03846984277019706,&nbsp;0.004166336295566362,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.04099937535188583,&nbsp;-0.10021508441116066,&nbsp;-1.9370249587599504,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.4914140113794023,&nbsp;-0.6535152367377465,&nbsp;0.0,&nbsp;0.1886792452614397,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1.9027239385809525,&nbsp;0.0,&nbsp;1.0314034990884224,&nbsp;0.0,&nbsp;0.3239568655877369,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.34189590303326106,&nbsp;2.3932713183760095,&nbsp;0.25919450109614733,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3239568713437452,&nbsp;0.3418959045194163,&nbsp;2.393271319925584,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.2591944959792473,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-2.550637675199632,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.17661930260865508,&nbsp;19.07466726468525,&nbsp;-24.57359497433762,&nbsp;-1.1517569837765282,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-1.3640881238188471,&nbsp;0.0,&nbsp;2.047901104766663,&nbsp;0.0,&nbsp;-3.4028557485350275,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.10840428371264056,&nbsp;-0.7588299774340104,&nbsp;2.8522715548967454,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-3.402855742952353,&nbsp;-0.10840428515373562,&nbsp;-0.7588299811900253,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;2.8522715586176037,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;8.169799629342247,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;13.488852697923182,&nbsp;0.3074887995115382,&nbsp;0.6539550546875682,&nbsp;-25.99394768193609,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-9.530122776061512E-05,&nbsp;0.0,&nbsp;-0.00010655272285093912,&nbsp;0.0,&nbsp;4.621536511802614E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.9816699281185113E-05,&nbsp;-0.00013871689430342205,&nbsp;-7.281378430880555E-05,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;4.6215364381240835E-05,&nbsp;-1.9816699281187352E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.00013871689430343663,&nbsp;-7.281378430879301E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.3914767814173548,&nbsp;2.8704969281476185E-06,&nbsp;-1.8781679460690547E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00017495152177946817,&nbsp;-0.00037207999681924356,&nbsp;-0.00012247768575392268,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0010000000000796004,&nbsp;0.0,&nbsp;-0.02356651271243895,&nbsp;-0.002286303472674415,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.3914767814184195,&nbsp;0.0007543640894193767;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-285.9036832818363,&nbsp;0.0,&nbsp;-319.6581685616487,&nbsp;0.0,&nbsp;138.6460953835576,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-59.450097835945066,&nbsp;-416.1506829102663,&nbsp;-218.44135288714168,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;138.64609314370196,&nbsp;-59.450097851169616,&nbsp;-416.1506829103101,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-218.44135288710405,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1174430.3442651068,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;8.611490784418748,&nbsp;-56.34503854041662,&nbsp;-524.8545653451064,&nbsp;-1116.2399904577212,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-367.4330572357634,&nbsp;0.0,&nbsp;-19.999999997712607,&nbsp;-70699.53814579226,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-6858.910421755459,&nbsp;-1174430.3442562488,&nbsp;2263.0922689585263;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461536,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-76.92307692307689,&nbsp;0.0,&nbsp;-1153.846153846154,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260354,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-715.9763313609462,&nbsp;-76.92307692307693,&nbsp;-11893.491124260356,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3333333333333333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.3333333333333333,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539741,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-119.6269680827516,&nbsp;-11.605601381162481,&nbsp;-1987.1917838539748,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.2468827930174557],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.11111112030448567,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0029538347076949224,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.0005497824417943775,&nbsp;-3.0839528461845806E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.00021538326677728037,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00020018844969528135,&nbsp;-3.483052627531991E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.02210615949553118,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.020547452628250085,&nbsp;-3.527271067826401E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07998861620343233,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005182025021854164,&nbsp;-1.0629794916642538E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.3914767814222619,&nbsp;0.0,&nbsp;0.0009999999994733926,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.0525803277086137E-06,&nbsp;3.944400361570619E-06,&nbsp;7.327471922821363E-09;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">782953.5628411932,&nbsp;0.0,&nbsp;2000.0000011677341,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.105160655853979,&nbsp;7.888800723776511,&nbsp;0.014654943925052065;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1153.846153846154,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.33333333333333326,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1987.1917838539748,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.11111112030448567,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0029538347076949224,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.000549794777605762,&nbsp;-3.3306690738754696E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.00021538326677728037,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00020018844969507457,&nbsp;-3.4830526254640395E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.022106159495530974,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.020547452628250085,&nbsp;-3.527271067826401E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07998861620343233,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005182025021854164,&nbsp;-1.0629794916642538E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.39147678141879266,&nbsp;0.0,&nbsp;0.0010000000029434153,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.0525803285357943E-06,&nbsp;3.944178317342888E-06,&nbsp;7.327471922821363E-09;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;782953.5628367523,&nbsp;0.0,&nbsp;2000.0000056086262,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.105160655853979,&nbsp;7.888356634566661,&nbsp;0.014654943925052065;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260354,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.33333333333333337,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.12956725612080472,&nbsp;0.0,&nbsp;-0.0015965893201110488,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.0059991170132388414,&nbsp;-8.285675851050595E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0016555645743210334,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005242650757964094,&nbsp;6.039613254209005E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0004358777489887465,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00316995905415984,&nbsp;-6.032910020339302E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.027116619135310927,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.19720856891947136,&nbsp;-0.00038337388819087437;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07163377635174221,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.22683454441384948,&nbsp;0.00026409850737266563;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3914767814187902,&nbsp;0.0,&nbsp;0.0009999999994717383,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;3.3040237334605645E-07,&nbsp;8.194778186769167E-06,&nbsp;1.9317883381334802E-08;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1174430.3442462466,&nbsp;0.0,&nbsp;2999.9999995311555,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.9912071163853396,&nbsp;24.584334568089616,&nbsp;0.057962523669630166;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260356,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3333333333333333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.191783853974,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.03662801299699971,&nbsp;0.0,&nbsp;0.01502759683451718,&nbsp;0.0,&nbsp;-0.08520102833040469,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.06888083527270905,&nbsp;0.4821658461448425,&nbsp;0.18601375139655826,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.019592147505422687,&nbsp;0.03964882583232426,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.27754178035472177,&nbsp;0.08088486040000538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.06816516366990007,&nbsp;-0.004567606997167485,&nbsp;0.028797104270531428,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.061244545899594355,&nbsp;-0.02978592204233452,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;391.476781419233,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-23.566512712302103,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-2.2863034720890103,&nbsp;-391.47678141923296,&nbsp;0.7543640897755622,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.000000000122316,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.9999999998475839,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0020525803279269894,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.003944400361888256,&nbsp;-7.327471962526032E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">391.476781419233,&nbsp;0.0,&nbsp;0.999999999999999,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;{&quot;uPSS1&quot;,&nbsp;&quot;uPm1&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;uvs1&quot;,&nbsp;&quot;uPSS2&quot;,&nbsp;&quot;uPm2&quot;,&nbsp;&quot;uvs2&quot;,&nbsp;&quot;uPSS3&quot;,&nbsp;&quot;uPm3&quot;,&nbsp;&quot;uvs3&quot;,&nbsp;&quot;uPload1&quot;,&nbsp;&quot;uPload2&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;uPload3&quot;},&nbsp;{&quot;Vt&quot;,&nbsp;&quot;SCRXin&quot;,&nbsp;&quot;SCRXout&quot;,&nbsp;&quot;SPEED&quot;,&nbsp;&quot;ANGLE&quot;},&nbsp;{&quot;Plant.infiniteBus.gENCLS.delta&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.infiniteBus.gENCLS.omega&quot;,&nbsp;&quot;Plant.infiniteBus.gENCLS.eq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.gENSAE.w&quot;,&nbsp;&quot;Plant.G1.gENSAE.delta&quot;,&nbsp;&quot;Plant.G1.gENSAE.Epq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.gENSAE.PSIkd&quot;,&nbsp;&quot;Plant.G1.gENSAE.PSIppq&quot;,&nbsp;&quot;Plant.G1.sCRX.imLeadLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G2.gENSAE.w&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.gENSAE.delta&quot;,&nbsp;&quot;Plant.G2.gENSAE.Epq&quot;,&nbsp;&quot;Plant.G2.gENSAE.PSIkd&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G2.gENSAE.PSIppq&quot;,&nbsp;&quot;Plant.G2.sCRX.imLeadLag.TF.x_scaled[1]&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G2.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G3.gENROE.w&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.gENROE.delta&quot;,&nbsp;&quot;Plant.G3.gENROE.Epd&quot;,&nbsp;&quot;Plant.G3.gENROE.Epq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G3.gENROE.PSIkd&quot;,&nbsp;&quot;Plant.G3.gENROE.PSIkq&quot;,&nbsp;&quot;Plant.G3.sCRX.imLeadLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;}</span></p>
</html>"),    preferredView = "info");
    end LinearizeSimple;

    function LinearizeAndCompare
      "Linearize the model, simulate the linear model obtained and compare with the nonlinear model response."
      // See the Documentation for an explanation of the goals.
      // IMPORTING FUNCTIONS
      // Import things needed for the calculations
      import Modelica_LinearSystems2.StateSpace; // to create and manipulate state space objects
      // OUTPUTS OF THEFUNCTION - FOR DISPLAY
      // Declare outputs to display
      output Real A[:,:] "A-matrix";
      output Real B[:,:] "B-matrix";
      output Real C[:,:] "C-matrix";
      output Real D[:,:] "D-matrix";
      output String inputNames[:] "Modelica names of inputs";
      output String outputNames[:] "Modelica names of outputs";
      output String stateNames[:] "Modelica names of states";
      output Real y0out[:] "Initial value of the output variables";
      // INPUTS TO THE FUNCTION
      // Declare reconfigurable simulation parameters
      input Modelica.Units.SI.Time tlin=40 "t for model linearization";
      input Modelica.Units.SI.Time tsim=120 "Simulation time";
      input Real numberOfIntervalsin=10000 "No. of intervals";
      input String methodin = "DASSL" "Solver";
      input Real fixedstepsizein= 1e-6 "Time step - needed only for fixed time step solvers";
      //
      // DEFINING THE NONLINEAR PLANT, NONLINEAR EXPERIMENT, AND LINEAR EXPERIMENT MODELS
      //
      // 1) NONLINEAR PLANT:
      // This is the model that will be linearized, i.e. the nonlinear plant model
       input String pathToNonlinearPlantModel = "ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_Linearization" "Nonlinear plant model";
      //
      //
      // 2) NONLINEAR EXPERIMENT: this is a model which applies a change to the input of the nonlinear model.
      // It must match the nonlinar plant above.
      // This model will be simulated, and the simulation results will be compared to the simulation of the corresponding linearized model.
      input String pathToNonlinearExperiment= "ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_NonlinExperiment" "Nonlinear experiment model";
      //
      //
      // 3) LINEAR EXPERIMENT: this is a template that can be used for all three cases, so it is not necessary to create other cases here
      input String pathToLinearExperiment = "ThreeMIB.Analysis.LinearAnalysis.LinearModelGeneral" "Linear model for simulation";

    algorithm
      // Keep simulation output files
      Advanced.Plot.FilesToKeep :=10;
      // Make sure DAE mode is off!
      Advanced.Define.DAEsolver := false;
      Modelica.Utilities.Streams.print("DAE Mode is turned off.");
      Advanced.Define.GlobalOptimizations :=0;
      Modelica.Utilities.Streams.print("Global optimization is disabled.");
      Advanced.SparseActivate :=false;
      Advanced.Translation.SparseActivateIntegrator :=false;
      Advanced.Translation.SparseActivateSystems :=false;
      Modelica.Utilities.Streams.print("Sparse options disabled.");
      OutputCPUtime :=false; // disable cpu time output so it doesn't scre up the sizes of the outputs
      // Start the linearization process
      Modelica.Utilities.Streams.print("Linearization and Nonlinear Model Comparison is starting...");
      // Compute and display the ABCD matrices, etc
      (A,B,C,D,inputNames,outputNames,stateNames) :=
        Modelica_LinearSystems2.Utilities.Import.linearize(
        pathToNonlinearPlantModel,tlin);
      // LINEARIZE plant model at t_lin
      // This is the same as above, however, it stores it in a StateSpace object
      ss := Modelica_LinearSystems2.ModelAnalysis.Linearize(
        pathToNonlinearPlantModel, simulationSetup=
        Modelica_LinearSystems2.Records.SimulationOptionsForLinearization(
        linearizeAtInitial=false, t_linearize=tlin));
      // SAVE the data in a mat file
      DataFiles.writeMATmatrix(
        "MyData.mat",
        "ABCD",
        [ss.A, ss.B; ss.C, ss.D],
        append=false);
      nx := size(ss.A, 1);
      DataFiles.writeMATmatrix(
        "MyData.mat",
        "nx",
        [nx],
        append=true);
      Modelica.Utilities.Streams.print("Simulating nonlinear model");
      simulateModel(
        pathToNonlinearExperiment,
        stopTime=tsim,
        numberOfIntervals=numberOfIntervalsin, method = methodin, fixedstepsize=fixedstepsizein,
        resultFile="res_nl");

       simulateModel(
         pathToNonlinearExperiment,
         stopTime=tlin,
         numberOfIntervals=numberOfIntervalsin, method = methodin, fixedstepsize=fixedstepsizein,
         resultFile="res_nl_beforedist");
        ny := size(ss.C, 1);
        ylen :=DymolaCommands.Trajectories.readTrajectorySize("res_nl_beforedist.mat");
        y0 := DymolaCommands.Trajectories.readTrajectory(
          "res_nl_beforedist.mat",
          {ss.yNames[i] for i in 1:ny},
          DymolaCommands.Trajectories.readTrajectorySize("res_nl_beforedist.mat"));
        DataFiles.writeMATmatrix(
          "MyData.mat",
          "y0_beforedist",
          [y0[1:ny,ylen-100]],
          append=true);

      // Print y0's first values which is needed for the linear response model
      y0out := y0[1:ny,ylen]; // we only want the elements at ylen
      Modelica.Utilities.Streams.print("y0 before disturbance =");
      Modelica.Math.Vectors.toString(y0out);
      //
      // We now simulate the linear model, which requires y0
      Modelica.Utilities.Streams.print("Simulating linear model");
      simulateModel(
        pathToLinearExperiment,
        stopTime=tsim,
        numberOfIntervals=numberOfIntervalsin, method = methodin, fixedstepsize=fixedstepsizein,
        resultFile="res_lin");

    // Plot commands
    removePlots(false);
    Advanced.FilesToKeep :=10;
    createPlot(id=1, position={105, 105, 894, 548}, y={"Vt"}, range={0.0, 120.0, 1.0392000000000001, 1.0408000000000002}, erase=false, grid=true, filename="res_nl.mat", colors={{28,108,200}}, timeUnit="s", displayUnits={"1"});
    createPlot(id=1, position={105, 105, 894, 548}, y={"Vt"}, range={0.0, 120.0, 1.0392000000000001, 1.0408000000000002}, erase=false, grid=true, filename="res_lin.mat", colors={{238,46,47}}, timeUnit="s");



      annotation(__Dymola_interactive=true, Documentation(info="<html>
<p>This function can linearize the model at initialization or at a user provided point in time. Once the model is linearized, linear model and the nonlinear models are simulated.</p>
<p>The response of both models is then plotted/compared to check the quality of the linear model.</p>
<p>The function uses the following models:</p>
<ul>
<li>Non-linear model for linearization: <span style=\"font-family: Courier New;\">ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_Linearization</span></li>
<li>Non-linear model for simulation: <span style=\"font-family: Courier New;\">ThreeMIB.Analysis.LinearAnalysis.NonlinModel_for_NonlinExperiment</span></li>
<li>Linear model for simualtion: <span style=\"font-family: Courier New;\">ThreeMIB.Analysis.LinearAnalysis.LinearModelGeneral</span></li>
</ul>
<p>After executing the function the results are displayed in the command window. </p>
<p><br>For post-processing, the follwing <span style=\"font-family: Courier New;\">.mat</span> files are generated with time simulation responses are produced:</p>
<ul>
<li><span style=\"font-family: Courier New;\">res_lin.mat</span>, containing the time response of the linear model obtained by linearizing the linear model for simulation.</li>
<li><span style=\"font-family: Courier New;\">res_nl.mat</span>, containing the time response of the non-linear model.</li>
<li><span style=\"font-family: Courier New;\">res_nl_beforedist.mat</span>, containing the time response of the non-linear model up to the poin in time where the model is linearized. This is used to extract the <span style=\"font-family: Courier New;\">y0</span> output vector that is used in the linear model for simulation.</li>
<li>These files can be opened in MATLAB using the <span style=\"font-family: Courier New;\">dymbrowse</span> tool. Add to the MATLAB workspace the directory and sub-directories under: <span style=\"font-family: Courier New;\">C:\\Program Files\\Dymola 2024x\\Mfiles</span>, and in the command window of MATLAB enter: <span style=\"font-family: Courier New;\">dymbrowse</span> and selected the data to plot.</li>
</ul>
<p><br>The linearized model is contained in the following .mat files:</p>
<ul>
<li><span style=\"font-family: Courier New;\">MyData.mat</span> contains the <span style=\"font-family: Courier New;\">y0</span> vector, which corresponds to the output vector at the point in time where linearization is performed.</li>
<li><span style=\"font-family: Courier New;\">dslin.mat</span> contains the linear model obtained at the specified point for lineariation.</li>
<li>The obtained linear model can be used in any other environment. The linear model is available in the file, <span style=\"font-family: Courier New;\">dslin.mat</span>. It can be loaded in MATLAB using the Dymola function <span style=\"font-family: Courier New;\">[A,B,C,D,xName,uName,yName] = tloadlin(&apos;dslin.mat&apos;)</span></li>
</ul>
<p><i><b><span style=\"font-family: Arial;\">Usage</span></b></i></p>
<ol>
<li><span style=\"font-family: Arial;\">In the Package Browser, right click on the function and select &quot;Call function...&quot;. This will open the function&apos;s window.</span></li>
<li><span style=\"font-family: Arial;\">Leave the default parameters on first use. Alternatively, modify the tlin and tsim parameters, note that tsim should be greater or equal to tlin.</span></li>
<li><span style=\"font-family: Arial;\">Go to the bottom of the window and click on &quot;Execute&quot;, if successful, messages/results are displayed in the command window.</span></li>
<li><span style=\"font-family: Arial;\">Go back to the function&apos;s own window and click on &quot;Close&quot;.</span> </li>
</ol>
<p><br><i><b>Sample Output</b></i></p>
<p>Executing the function gives the following plot is produced in the &quot;Simulation&quot; window and the following results in the &quot;Commands&quot; window.</p>
<p><b><span style=\"font-family: Courier New; font-size: 10pt;\">ThreeMIB.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare();</span></b></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">DAE&nbsp;Mode&nbsp;is&nbsp;turned&nbsp;off.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Global&nbsp;optimization&nbsp;is&nbsp;disabled.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Warning: Script using obsolete flag Advanced.SparseActivate. Flag is now called Advanced.Translation.SparseActivate.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Sparse&nbsp;options&nbsp;disabled.</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Linearization&nbsp;and&nbsp;Nonlinear&nbsp;Model&nbsp;Comparison&nbsp;is&nbsp;starting...</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;Modelica_LinearSystems2.StateSpace&nbsp;ss&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;nonlinear&nbsp;model</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Redeclaring&nbsp;variable:&nbsp;Real&nbsp;y0&nbsp;[5,&nbsp;10003];</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;before&nbsp;disturbance&nbsp;=</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;&quot;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.04009&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-1.84622e-05&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.69891&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-4.16656e-06&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.278821&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&quot;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;linear&nbsp;model</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0018522019131561652,&nbsp;0.0,&nbsp;-0.010667194591854822,&nbsp;-0.10017322096061068,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.17089257044803982,&nbsp;-0.015159942256269874,&nbsp;-0.10611959565930629,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.12769042902574537,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.146541932792295,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0025283655757525974,&nbsp;0.01769855908431923,&nbsp;-0.1262567353853507,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.02249843539079445,&nbsp;-0.0029950025975001896,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00459111945990742,&nbsp;-0.009764211785586533,&nbsp;-0.01953079242986482,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;314.1592653589793,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.001723386472377245,&nbsp;0.0,&nbsp;0.00023080311412112048,&nbsp;0.0,&nbsp;-0.010951723043568796,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.3673104628912238,&nbsp;0.8945130355436972,&nbsp;-0.04580632552920175,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.19607843136188122,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.005227063506560059,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0018873336145837159,&nbsp;0.013211335216546117,&nbsp;-0.0016269057262953566,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.004001273353690362,&nbsp;-0.0003301105696849787,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.001102892298849089,&nbsp;0.002345587874577992,&nbsp;-0.0021526907018729756,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.17689098824341967,&nbsp;0.0,&nbsp;0.023689981200575885,&nbsp;0.0,&nbsp;-1.1241013795186858,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;16.433040770620615,&nbsp;-18.302047953366735,&nbsp;-0.18364372645628768,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.5365136761073426,&nbsp;0.19371876932206303,&nbsp;1.3560313834858146,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.16698807520976472,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.41069671600675856,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.033883014035672336,&nbsp;0.11320253172631389,&nbsp;0.24075468046413043,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.2209554253306233,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.04613859287515668,&nbsp;0.0,&nbsp;0.35001008074845025,&nbsp;0.0,&nbsp;4.7191604980019015,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.14503847218583651,&nbsp;-1.0152693065515683,&nbsp;-18.451779967834725,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-4.299180608883913,&nbsp;0.0347789535955867,&nbsp;0.24345267708572338,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;3.8784609809995656,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.466118476048029,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.07432930165169088,&nbsp;0.21148515216504882,&nbsp;0.4497782804140681,&nbsp;0.4847108127921336,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-3.6628012090015325E-05,&nbsp;0.0,&nbsp;-1.50275992641539E-05,&nbsp;0.39147678142010733,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;8.520102679226937E-05,&nbsp;-6.888083521774856E-05,&nbsp;-0.00048216584683387896,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0001860137485533241,&nbsp;-0.0009999999999755198,&nbsp;0.0,&nbsp;-0.023566512714739956,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0022863034733448563,&nbsp;-0.3914767814192084,&nbsp;0.0007543640876318953,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1.9592147017909902E-05,&nbsp;-3.9648825962139176E-05,&nbsp;-0.0002775417803072587,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-8.088485694272715E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-6.81651621711076E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;4.567602538506658E-06,&nbsp;-2.8797104315714E-05,&nbsp;-6.124454646789558E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.9785919339212488E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-73.25602418002947,&nbsp;0.0,&nbsp;-30.05519852830714,&nbsp;782953.5628391054,&nbsp;170.40205358453915,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-137.76167043549745,&nbsp;-964.3316936677589,&nbsp;-372.027497106645,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-19.999999998911882,&nbsp;-47133.02543058999,&nbsp;-4572.606950020261,&nbsp;-782953.5628392503,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;1508.7281758196705,&nbsp;0.0,&nbsp;39.184294035817565,&nbsp;-79.29765192427791,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-555.0835606145165,&nbsp;-161.76971388545056,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-136.3303243422122,&nbsp;9.135205077012136,&nbsp;-57.59420863142842,&nbsp;-122.48909293579072,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;59.5718386784261,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-76.92307692307685,&nbsp;0.0,&nbsp;-1153.846153846154,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-715.9763313609462,&nbsp;-76.92307692307693,&nbsp;-11893.491124260356,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.33333333333333326,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.33333333333333337,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539753,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-119.62696808275159,&nbsp;-11.605601381162487,&nbsp;-1987.1917838539746,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.2468827930174542,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.001852201925753179,&nbsp;0.0,&nbsp;-0.01066719457958393,&nbsp;0.0,&nbsp;0.14654193283322356,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0025283655863205666,&nbsp;0.017698559139406465,&nbsp;-0.12625673527618927,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.10017322096061206,&nbsp;-0.17089257032524724,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.015159942245701764,&nbsp;-0.10611959565930519,&nbsp;0.12769042902574726,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.022498435546837864,&nbsp;-0.002995002377757383,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.004591119441267059,&nbsp;-0.00976421179649437,&nbsp;-0.01953079242986482,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;314.1592653589794,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.001723386472377245,&nbsp;0.0,&nbsp;0.00023080315743014777,&nbsp;0.0,&nbsp;0.005227063362092979,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0018873336145837371,&nbsp;0.013211335177661277,&nbsp;-0.0016269057262953326,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.010951723043569075,&nbsp;-1.3673104628539097,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.8945130355436879,&nbsp;-0.04580632552920243,&nbsp;0.0,&nbsp;0.1960784313618723,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.004001273078319628,&nbsp;-0.0003301097941221497,&nbsp;0.001102892298849089,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0023455879130762423,&nbsp;-0.0021526907018729756,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.17689098753483767,&nbsp;0.0,&nbsp;0.023689982235932303,&nbsp;0.0,&nbsp;0.5365136734211466,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.1937187691239163,&nbsp;1.356031384208846,&nbsp;-0.1669880736747057,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-1.1241013791349743,&nbsp;16.433040770422277,&nbsp;-18.30204795295339,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.1836437264562904,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.41069671600675856,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.03388301403567232,&nbsp;0.11320253172631389,&nbsp;0.24075467985056456,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.2209554253306233,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.04613859287515669,&nbsp;0.0,&nbsp;0.35001008074845025,&nbsp;0.0,&nbsp;-4.299180608883803,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.03477895359558709,&nbsp;0.24345267603086757,&nbsp;3.878460978386646,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;4.719160496042496,&nbsp;-0.14503847250202992,&nbsp;-1.0152693066504508,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-18.451779962282664,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.46611848351819246,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.07432929113208844,&nbsp;0.21148515171886997,&nbsp;0.44977827989188424,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.4847108127921336,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-3.662801209001448E-05,&nbsp;0.0,&nbsp;-1.50275992641539E-05,&nbsp;0.0,&nbsp;1.959214628112648E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-3.964882577191631E-05,&nbsp;-0.00027754178050557463,&nbsp;-8.088485694272596E-05,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.39147678141664355,&nbsp;8.520102679227154E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-6.888083521774779E-05,&nbsp;-0.0004821658470321885,&nbsp;-0.0001860137495357614,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.000999999999975571,&nbsp;0.0,&nbsp;-0.023566512711272504,&nbsp;-0.0022863034698759797,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.3914767814192058,&nbsp;0.0007543640911018983,&nbsp;0.0,&nbsp;-6.81651621711076E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.567606493885187E-06,&nbsp;-2.8797104315714E-05,&nbsp;-6.124454607521335E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.9785919989678307E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-73.25602418002947,&nbsp;0.0,&nbsp;-30.05519852830714,&nbsp;0.0,&nbsp;39.1842925622537,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-79.29765154383294,&nbsp;-555.0835610111491,&nbsp;-161.76971388544817,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;782953.5628346753,&nbsp;170.40205358454347,&nbsp;-137.76167043549592,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-964.3316940643757,&nbsp;-372.0274990715229,&nbsp;0.0,&nbsp;-19.999999998910972,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-47133.02542171337,&nbsp;-4572.606941139146,&nbsp;-782953.5628392451,&nbsp;1508.7281802605792,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;-136.3303243422122,&nbsp;9.135212987753164,&nbsp;-57.59420863142842,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-122.4890921504264,&nbsp;59.57183997935995,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1153.8461538461536,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-76.9230769230769,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1153.846153846154,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;11893.491124260354,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-715.9763313609451,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-76.92307692307713,&nbsp;-11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.33333333333333337,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.3333333333333333,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1987.1917838539744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-119.62696808275143,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-11.6056013811625,&nbsp;-1987.1917838539748,&nbsp;-1.246882793017459,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.04214933631953328,&nbsp;0.0,&nbsp;-0.030337232568231343,&nbsp;0.0,&nbsp;0.0676746567566648,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.004965236926265929,&nbsp;0.03475665839394035,&nbsp;-0.05222810581456046,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.06767465675666653,&nbsp;0.004965236963235865,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.03475665835539761,&nbsp;-0.05222810562362389,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.11646495724495634,&nbsp;-0.17749864971511978,&nbsp;0.015279516858496342,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.042901102180884866,&nbsp;-0.09124037231198018,&nbsp;0.09963966988643122,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;314.1592653589793,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-0.031526160968562075,&nbsp;0.0,&nbsp;0.047330118863375764,&nbsp;0.0,&nbsp;-0.07864519026200728,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0025053880914924606,&nbsp;-0.017537717003433827,&nbsp;0.0659203501875078,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.07864519055672185,&nbsp;-0.0025053881675816043,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.017537716924108295,&nbsp;0.0659203494015598,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.18881654325922764,&nbsp;-4.417105161615785,&nbsp;-1.9231460262932996,&nbsp;-4.090071126318779,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.1959569382278397,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0305847011737036,&nbsp;0.0,&nbsp;0.016578953564550768,&nbsp;0.0,&nbsp;0.005207338169465385,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005495691767152601,&nbsp;0.03846984291026136,&nbsp;0.004166334836980103,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.005207338169465517,&nbsp;0.005495691767152539,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0384698427605905,&nbsp;0.004166334836980165,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.04099937746344413,&nbsp;-0.10021508530950253,&nbsp;-1.937024925603509,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.49141394141688,&nbsp;-0.6535152354631605,&nbsp;0.0,&nbsp;0.18867924527176064,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1.9027238807134215,&nbsp;0.0,&nbsp;1.031403595721688,&nbsp;0.0,&nbsp;0.32395695690693554,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.34189590235820194,&nbsp;2.393271323945332,&nbsp;0.259194433532559,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.32395695306954053,&nbsp;0.34189590285357024,&nbsp;2.393271322912425,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.25919443864941816,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-2.550637783102256,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.17661933464972454,&nbsp;19.07466726374962,&nbsp;-24.573594978332814,&nbsp;-1.1517569665665899,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-1.3640882268853216,&nbsp;0.0,&nbsp;2.0479010420177888,&nbsp;0.0,&nbsp;-3.4028557749971164,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.10840427077819684,&nbsp;-0.7588298902118102,&nbsp;2.852271578999606,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-3.4028557777880413,&nbsp;-0.10840427293981983,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.7588298879582414,&nbsp;2.852271571556949,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;8.169799774330599,&nbsp;13.48885276980326,&nbsp;0.3074887986079922,&nbsp;0.6539550521004882,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-25.993947683773747,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-9.530122118497087E-05,&nbsp;0.0,&nbsp;-0.00010655272771021516,&nbsp;0.0,&nbsp;4.6215360925838035E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.9816699346141237E-05,&nbsp;-0.00013871689576749253,&nbsp;-7.281378080435908E-05,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;4.621536092583921E-05,&nbsp;-1.9816699346141017E-05,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.0001387168957674911,&nbsp;-7.281378080436016E-05,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.39147678141803055,&nbsp;2.8704988458150026E-06,&nbsp;-1.878167343587408E-05,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0001749515210600196,&nbsp;-0.0003720799959227689,&nbsp;-0.00012247768981803932,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0009999999999983447,&nbsp;0.0,&nbsp;-0.023566512710976893,&nbsp;-0.0022863034731198475,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.39147678141781067,&nbsp;0.0007543640902812988;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">-285.90366354584324,&nbsp;0.0,&nbsp;-319.6581831394671,&nbsp;0.0,&nbsp;138.64608277752623,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-59.4500980384297,&nbsp;-416.1506872945384,&nbsp;-218.44134245242108,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;138.64608277752976,&nbsp;-59.45009803842903,&nbsp;-416.15068729453407,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-218.4413424524243,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1174430.3442567335,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;8.611496537529385,&nbsp;-56.34502030759961,&nbsp;-524.8545631733518,&nbsp;-1116.2399877683092,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-367.43306945411746,&nbsp;0.0,&nbsp;-19.999999998806622,&nbsp;-70699.53813501836,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-6858.910408677101,&nbsp;-1174430.3442502415,&nbsp;2263.092278904324;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461536,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-76.9230769230768,&nbsp;0.0,&nbsp;-1153.846153846154,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260354,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-715.9763313609459,&nbsp;-76.92307692307703,&nbsp;-11893.491124260356,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3333333333333333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.3333333333333333,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539746,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-119.62696808275155,&nbsp;-11.6056013811625,&nbsp;-1987.1917838539748,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-1.246882793017456],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.11111112030448567,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0029538717151290773,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.0005497947776057637,&nbsp;-3.207310960013869E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.00021538326677728037,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00020014491153735967,&nbsp;-3.4830526254640395E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.022106159495530558,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.020547452628250085,&nbsp;-3.5157062447014745E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07998920674759442,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005182025021854112,&nbsp;-1.0629794916694238E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.39147678141879266,&nbsp;0.0,&nbsp;0.0009999999994742199,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.052802372763525E-06,&nbsp;3.944178317342888E-06,&nbsp;7.327471922821363E-09;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">782953.5628367523,&nbsp;0.0,&nbsp;2000.0000011677341,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.105604745063829,&nbsp;7.888356634566661,&nbsp;0.014654943925052065;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">11893.491124260356,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.3333333333333333,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">1987.1917838539744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.11111112030448567,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.002953834707694919,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.0005498071134171498,&nbsp;-3.207310960013869E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.00021533972861873828,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.00020018844969507457,&nbsp;-3.4830526254640395E-07;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.022106159495531387,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0205473369800178,&nbsp;-3.527271067764362E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07998861620343238,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005182025021854112,&nbsp;-1.0629794916694238E-05;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.39147678141879266,&nbsp;0.0,&nbsp;0.0010000000029434153,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;2.052802372763525E-06,&nbsp;3.944400362397799E-06,&nbsp;7.327471922821363E-09;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;782953.5628367523,&nbsp;0.0,&nbsp;2000.0000056086262,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;4.105604745063829,&nbsp;7.888800723776511,&nbsp;0.014654943925052065;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.846153846154,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260358,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.33333333333333337,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539748,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.12956725612080472,&nbsp;0.0,&nbsp;-0.0015965893201110469,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-0.005999131398092748,&nbsp;-8.285675851047767E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0016555645743210334,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.005242473122279989,&nbsp;5.950795412156275E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0004358777489887465,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.0031699590541606677,&nbsp;-6.032910021166483E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.027116619135310927,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.19720856891947136,&nbsp;-0.00038337388819087437;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.07163377635174221,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.22683538549189786,&nbsp;0.0002640985073730792;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.3914767814187902,&nbsp;0.0,&nbsp;0.0009999999994717383,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;3.306244150922453E-07,&nbsp;8.194334096659344E-06,&nbsp;1.9539925127523637E-08;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1174430.3442640102,&nbsp;0.0,&nbsp;2999.9999995311555,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.9918643684159177,&nbsp;24.583002300460066,&nbsp;0.05861977570020826;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1153.8461538461538,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;11893.491124260356,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.33333333333333337,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1987.1917838539744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.03662801209001474,&nbsp;0.0,&nbsp;0.015027599264153571,&nbsp;0.0,&nbsp;-0.08520102679226957,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.06888083521774872,&nbsp;0.4821658468338795,&nbsp;0.18601374855332248,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.019592147017908783,&nbsp;0.03964882596213896,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.27754178030725823,&nbsp;0.08088485694272528,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0681651621711061,&nbsp;-0.004567602538506068,&nbsp;0.02879710431571421,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.06124454646789536,&nbsp;-0.029785919339213048,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;391.476781419233,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-23.566512712302064,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;-2.2863034720890076,&nbsp;-391.47678141923296,&nbsp;0.7543640897755619,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.9999999999455941,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.999999999887137,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.0020528023725319144,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.003944178317283331,&nbsp;-7.327471962526032E-06;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">391.4767814192329,&nbsp;0.0,&nbsp;1.0000000000000022,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;{&quot;uPSS1&quot;,&nbsp;&quot;uPm1&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;uvs1&quot;,&nbsp;&quot;uPSS2&quot;,&nbsp;&quot;uPm2&quot;,&nbsp;&quot;uvs2&quot;,&nbsp;&quot;uPSS3&quot;,&nbsp;&quot;uPm3&quot;,&nbsp;&quot;uvs3&quot;,&nbsp;&quot;uPload1&quot;,&nbsp;&quot;uPload2&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;uPload3&quot;},&nbsp;{&quot;Vt&quot;,&nbsp;&quot;SCRXin&quot;,&nbsp;&quot;SCRXout&quot;,&nbsp;&quot;SPEED&quot;,&nbsp;&quot;ANGLE&quot;},&nbsp;{&quot;Plant.infiniteBus.gENCLS.delta&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.infiniteBus.gENCLS.omega&quot;,&nbsp;&quot;Plant.infiniteBus.gENCLS.eq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.gENSAE.w&quot;,&nbsp;&quot;Plant.G1.gENSAE.delta&quot;,&nbsp;&quot;Plant.G1.gENSAE.Epq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.gENSAE.PSIkd&quot;,&nbsp;&quot;Plant.G1.gENSAE.PSIppq&quot;,&nbsp;&quot;Plant.G1.sCRX.imLeadLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G2.gENSAE.w&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.gENSAE.delta&quot;,&nbsp;&quot;Plant.G2.gENSAE.Epq&quot;,&nbsp;&quot;Plant.G2.gENSAE.PSIkd&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G2.gENSAE.PSIppq&quot;,&nbsp;&quot;Plant.G2.sCRX.imLeadLag.TF.x_scaled[1]&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G2.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G2.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G3.gENROE.w&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.gENROE.delta&quot;,&nbsp;&quot;Plant.G3.gENROE.Epd&quot;,&nbsp;&quot;Plant.G3.gENROE.Epq&quot;,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G3.gENROE.PSIkd&quot;,&nbsp;&quot;Plant.G3.gENROE.PSIkq&quot;,&nbsp;&quot;Plant.G3.sCRX.imLeadLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.sCRX.simpleLagLim.state&quot;,&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imLeadLag2.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.derivativeLag.TF.x_scaled[1]&quot;,</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G3.pSSTypeIIExtraLeadLag.imleadLag3.TF.x_scaled[1]&quot;},&nbsp;{</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;1.0400943756103516,&nbsp;-1.8462231309968047E-05,&nbsp;1.6989123821258545,&nbsp;</span></p>
<p><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-4.1665584831207525E-06,&nbsp;0.27882149815559387}</span></p>
</html>"),    preferredView="info",
        __Dymola_Commands(file="../../../../Downloads/test.mos" "test"));
    end LinearizeAndCompare;

    annotation (Documentation(info="<html>
<p>This package contains two functions for automated analysis:</p>
<ul>
<li>Simple linearization workflow: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeSimple</span></li>
<li>Extended linearization workflow: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare</span></li>
</ul>
</html>"),  preferredView = "info");
  end CustomFunctions;

  model NonlinModel_for_Linearization "Non-linear model for linearization"

    Systems.GridIO Plant(t1=0.5, opening=2) annotation (Placement(transformation(extent={{-104,-140},{154,118}})));

  public
    Modelica.Blocks.Interfaces.RealOutput Vt annotation (Placement(transformation(extent={{242,-40},{324,42}}),iconTransformation(extent={{240,-28},{292,24}})));
    Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{240,-168},{326,-82}}),  iconTransformation(extent={{242,-184},{298,-128}})));
    Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{240,-308},{322,-226}}), iconTransformation(extent={{242,-300},{296,-246}})));
    Modelica.Blocks.Interfaces.RealOutput
               SPEED "Machine speed deviation from nominal [pu]"
      annotation (Placement(transformation(extent={{240,102},{314,176}}), iconTransformation(extent={{240,110},{294,164}})));
    Modelica.Blocks.Interfaces.RealOutput
               ANGLE "Machine relative rotor angle"
      annotation (Placement(transformation(extent={{240,222},{310,292}}), iconTransformation(extent={{240,246},{290,296}})));
    Modelica.Blocks.Interfaces.RealInput uPSS1 annotation (Placement(transformation(extent={{-332,208},{-280,260}}), iconTransformation(extent={{-328,230},{-288,270}})));
    Modelica.Blocks.Interfaces.RealInput uPm1 annotation (Placement(transformation(extent={{-332,150},{-278,204}}), iconTransformation(extent={{-328,170},{-288,210}})));
    Modelica.Blocks.Interfaces.RealInput uvs1 annotation (Placement(transformation(extent={{-330,94},{-280,144}}), iconTransformation(extent={{-328,110},{-288,150}})));
    Modelica.Blocks.Interfaces.RealInput uPSS2
      annotation (Placement(transformation(extent={{-336,28},{-282,82}}),
          iconTransformation(extent={{-328,54},{-288,94}})));
    Modelica.Blocks.Interfaces.RealInput uPm2 annotation (Placement(transformation(extent={{-340,-30},{-280,30}}),
                                                                                                                 iconTransformation(extent={{-328,-8},{-288,32}})));
    Modelica.Blocks.Interfaces.RealInput uvs2 annotation (Placement(transformation(extent={{-332,-80},{-280,-28}}),iconTransformation(extent={{-328,-64},{-288,-24}})));
    Modelica.Blocks.Interfaces.RealInput uPSS3
      annotation (Placement(transformation(extent={{-328,-130},{-280,-82}}),
          iconTransformation(extent={{-328,-116},{-288,-76}})));
    Modelica.Blocks.Interfaces.RealInput uPm3 annotation (Placement(transformation(extent={{-334,-182},{-282,-130}}),
                                                                                                                    iconTransformation(extent={{-328,-172},{-288,-132}})));
    Modelica.Blocks.Interfaces.RealInput uvs3 annotation (Placement(transformation(extent={{-326,-228},{-282,-184}}),iconTransformation(extent={{-328,-228},{-288,-188}})));
    Modelica.Blocks.Interfaces.RealInput uPload1
                                                annotation (Placement(
          transformation(extent={{-340,266},{-280,326}}),
          iconTransformation(extent={{-324,282},{-286,320}})));
    Modelica.Blocks.Interfaces.RealInput uPload2
                                                annotation (Placement(
          transformation(extent={{-330,-280},{-282,-232}}),
          iconTransformation(extent={{-326,-280},{-288,-242}})));
    Modelica.Blocks.Interfaces.RealInput uPload3
                                                annotation (Placement(
          transformation(extent={{-330,-336},{-282,-288}}),
          iconTransformation(extent={{-326,-330},{-288,-292}})));
  equation
    connect(Plant.ANGLE, ANGLE) annotation (Line(points={{164.32,42.0743},{192,
            42.0743},{192,257},{275,257}},                                                                     color={0,0,127}));
    connect(Plant.SPEED, SPEED) annotation (Line(points={{164.965,15.1686},{216,
            15.1686},{216,139},{277,139}},                                                                     color={0,0,127}));
    connect(Plant.Vt, Vt) annotation (Line(points={{164.32,-11},{232,-11},{232,1},{283,1}},              color={0,0,127}));
    connect(Plant.SCRXin, SCRXin) annotation (Line(points={{165.61,-39.7486},{
            214,-39.7486},{214,-125},{283,-125}},                                                                    color={0,0,127}));
    connect(Plant.SCRXout, SCRXout) annotation (Line(points={{166.255,-67.3914},
            {166.255,-104},{190,-104},{190,-267},{281,-267}},                                                                 color={0,0,127}));
    connect(uPload1, Plant.uPload1) annotation (Line(points={{-310,296},{-218,
            296},{-218,95.5171},{-117.545,95.5171}},                                                                   color={0,0,127}));
    connect(uPSS1, Plant.uPSS1) annotation (Line(points={{-306,234},{-232,234},{-232,76.72},{-116.9,76.72}},       color={0,0,127}));
    connect(uPm1, Plant.uPm1) annotation (Line(points={{-305,177},{-244,177},{
            -244,54.6057},{-116.9,54.6057}},                                                                     color={0,0,127}));
    connect(uvs1, Plant.uvs1) annotation (Line(points={{-305,119},{-252,119},{
            -252,32.4914},{-116.9,32.4914}},                                                                     color={0,0,127}));
    connect(uPSS2, Plant.uPSS2) annotation (Line(points={{-309,55},{-248,55},{
            -248,11.8514},{-116.9,11.8514}},                                                                     color={0,0,127}));
    connect(uPm2, Plant.uPm2) annotation (Line(points={{-310,0},{-240,0},{-240,-11},{-116.9,-11}},             color={0,0,127}));
    connect(uvs2, Plant.uvs2) annotation (Line(points={{-306,-54},{-248,-54},{-248,-31.64},{-116.9,-31.64}},       color={0,0,127}));
    connect(uPSS3, Plant.uPSS3) annotation (Line(points={{-304,-106},{-242,-106},
            {-242,-50.8057},{-116.9,-50.8057}},                                                                        color={0,0,127}));
    connect(uPm3, Plant.uPm3) annotation (Line(points={{-308,-156},{-240,-156},
            {-240,-71.4457},{-116.9,-71.4457}},                                                                      color={0,0,127}));
    connect(uvs3, Plant.uvs3) annotation (Line(points={{-304,-206},{-268,-206},
            {-268,-208},{-230,-208},{-230,-92.0857},{-116.9,-92.0857}},                                                                      color={0,0,127}));
    connect(uPload2, Plant.uPload2) annotation (Line(points={{-306,-256},{-266,-256},{-266,-254},{-216,-254},{-216,-111.62},{-117.545,-111.62}},   color={0,0,127}));
    connect(uPload3, Plant.uPload3) annotation (Line(points={{-306,-312},{-256,
            -312},{-256,-310},{-117.545,-310},{-117.545,-130.049}},                                                                    color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-340},{240,320}}), graphics={Rectangle(
            extent={{-276,320},{238,-340}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid), Text(
            extent={{-162,132},{132,-144}},
            textColor={255,255,255},
            textString="GridIO")}),                                Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-280,-340},{240,320}})),
      Documentation(info="<html>
<p>This is a model is used to perform linearization using the inputs and outputs defined in the top layer.</p>
<p>In <i><b>automated analysis</b></i>, it is used by the following functions:</p>
<ul>
<li>Simple linearization workflow: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeSimple</span></li>
<li>Extended linearization workflow: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare</span></li>
</ul>
<h4>Individual Usage:</h4>
<p>To use this model on its own to perform linearization, enter the following command in the &quot;Commands&quot; window:</p>
<p><span style=\"font-family: Courier New;\">Modelica_LinearSystems2.ModelAnalysis.Linearize(&quot;Example1.Analysis.LinearAnalysis.NonlinModel_for_Linearization&quot;);</span></p>
<p>Alternatively, right click on the model and select &quot;Simulation Model&quot;. Then go to Tools &gt; Linear Analysis &gt; Linearize and select &quot;OK&quot;.</p>
<p><br>To obtain linearizations at different power flow conditions, go to the &quot;Plant&quot; component within the model, click on the &quot;Power Flow Scenario&quot; and select the data for a different scneario.</p>
<p><br>After running the command, the results should be obtained using default settings:</p>
<p><span style=\"font-family: Courier New;\">ss.A&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;376.991118389&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;-0.176108793576&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.195861482328&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.0551541639775&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;-0.255877828569&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.125000000027&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.266763048065&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.0011594921127&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.125000000002&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0.426590454939&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.99999999994&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.00788324318104&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-1.49010437572&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;-3.36902858341&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;33.3333333324&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-36.845682718&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.0152665123009&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;2.42546406571&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;14.2857142849&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.0448217322083&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-22.7579962497&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;-8.93488653992&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;29.3032553076&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;33.1230756059&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-66.6666666672&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18999999.9962&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-2000000.00001&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10000.0008274&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-10000.0000002&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-18999999.9962&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.00949999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.001&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.00949999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.00949999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.001&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.00949999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.709219858078&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.709219858078&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">ss.B&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPSS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPload&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uvsAVR</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.142857154677&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.0316071454723&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.0404287159306&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.100932817659&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.532307068794&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.573873488412&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-1.02476545768&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;18999998.0194&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2000000.16548&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0.00949999900968&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0.00949999900968&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;0.709219916837&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">ss.C&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ma&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.av&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Plant.G1.ps</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vt&nbsp;-0.134023298099&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.439548829614&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.496846134088&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Q&nbsp;&nbsp;0.304306680099&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.45372599861&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.766588787789&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P&nbsp;&nbsp;1.22532664533&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.36432443251&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.382542875478&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;w&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.99999999989&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;delta&nbsp;&nbsp;0.999999999938&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AVRin&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9.49999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-9.49999999812&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AVRout&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.00000000002&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">ss.D&nbsp;=&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPSS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uPload&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uvsAVR</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vt&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-0.0153714818651&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Q&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.0212035111691&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.219995022199&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;w&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;delta&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AVRin&nbsp;&nbsp;9.49999900968&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AVRout&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
</html>"),  preferredView="diagram");
  end NonlinModel_for_Linearization;

  model NonlinModel_for_NonlinExperiment "Non-linear model for simulation"
    extends Modelica.Icons.Example;
    Modelica.Blocks.Sources.Constant PSSchange1(k=0) annotation (Placement(transformation(extent={{-192,58},{-180,70}})));
    Modelica.Blocks.Sources.Constant Pmchange1(k=0) annotation (Placement(transformation(extent={{-192,36},{-182,46}})));
    Modelica.Blocks.Sources.Step Ploadchange1(
      height=0.1,
      offset=0,
      startTime=30.5) annotation (Placement(transformation(extent={{-192,84},{-182,94}})));
    Systems.GridIO Plant(t1=0.5, opening=1) annotation (Placement(transformation(extent={{-72,-58},{36,50}})));
    Modelica.Blocks.Sources.Constant sCRXRchange1(k=0) annotation (Placement(transformation(extent={{-192,16},{-182,26}})));
  public
    Modelica.Blocks.Interfaces.RealOutput Vt annotation (Placement(transformation(extent={{100,-18},{136,18}}),
                                                                                                              iconTransformation(extent={{100,-32},{120,-12}})));
    Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{100,-82},{132,-50}}),   iconTransformation(extent={{100,-86},{120,-66}})));
    Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{100,-128},{128,-100}}), iconTransformation(extent={{100,-122},{120,-102}})));
    Modelica.Blocks.Interfaces.RealOutput
               SPEED "Machine speed deviation from nominal [pu]"
      annotation (Placement(transformation(extent={{100,26},{132,58}}),   iconTransformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealOutput
               ANGLE "Machine relative rotor angle"
      annotation (Placement(transformation(extent={{100,66},{130,96}}),   iconTransformation(extent={{100,68},{120,88}})));
    Modelica.Blocks.Sources.Constant PSSchange2(k=0) annotation (Placement(transformation(extent={{-192,-4},{-182,6}})));
    Modelica.Blocks.Sources.Constant PSSchange3(k=0) annotation (Placement(transformation(extent={{-192,-66},{-182,-56}})));
    Modelica.Blocks.Sources.Constant Pmchange2(k=0) annotation (Placement(transformation(extent={{-192,-24},{-182,-14}})));
    Modelica.Blocks.Sources.Constant sCRXRchange2(k=0) annotation (Placement(transformation(extent={{-192,-46},{-182,-36}})));
    Modelica.Blocks.Sources.Constant Pmchange3(k=0) annotation (Placement(transformation(extent={{-192,-88},{-182,-78}})));
    Modelica.Blocks.Sources.Constant sCRXRchange3(k=0) annotation (Placement(transformation(extent={{-192,-106},{-182,-96}})));
    Modelica.Blocks.Sources.Step Ploadchange2(
      height=0,
      offset=0,
      startTime=0) annotation (Placement(transformation(extent={{-192,-126},{-182,-116}})));
    Modelica.Blocks.Sources.Step Ploadchange3(
      height=0,
      offset=0,
      startTime=0) annotation (Placement(transformation(extent={{-190,-146},{-180,-136}})));
  equation
    connect(Plant.Vt, Vt) annotation (Line(points={{40.32,-4},{96,-4},{96,0},{118,0}},               color={0,0,127}));
    connect(Plant.SCRXin, SCRXin) annotation (Line(points={{40.86,-16.0343},{94,
            -16.0343},{94,-66},{116,-66}},                                                                       color={0,0,127}));
    connect(Plant.SCRXout, SCRXout) annotation (Line(points={{41.13,-27.6057},{
            92,-27.6057},{92,-114},{114,-114}},                                                                      color={0,0,127}));
    connect(Plant.ANGLE, ANGLE) annotation (Line(points={{40.32,18.2171},{94,
            18.2171},{94,81},{115,81}},                                                                    color={0,0,127}));
    connect(Plant.SPEED, SPEED) annotation (Line(points={{40.59,6.95429},{96,6.95429},{96,42},{116,42}},   color={0,0,127}));
    connect(Ploadchange1.y, Plant.uPload1) annotation (Line(points={{-181.5,89},
            {-136,89},{-136,40.5886},{-77.67,40.5886}},                                                                       color={0,0,127}));
    connect(PSSchange1.y, Plant.uPSS1) annotation (Line(points={{-179.4,64},{-136,64},{-136,32.72},{-77.4,32.72}},        color={0,0,127}));
    connect(Pmchange1.y, Plant.uPm1) annotation (Line(points={{-181.5,41},{-152,
            41},{-152,23.4629},{-77.4,23.4629}},                                                                        color={0,0,127}));
    connect(sCRXRchange1.y, Plant.uvs1) annotation (Line(points={{-181.5,21},{
            -154,21},{-154,14.2057},{-77.4,14.2057}},                                                                      color={0,0,127}));
    connect(PSSchange2.y, Plant.uPSS2) annotation (Line(points={{-181.5,1},{-160,1},{-160,5.56571},{-77.4,5.56571}},    color={0,0,127}));
    connect(Pmchange2.y, Plant.uPm2) annotation (Line(points={{-181.5,-19},{-158,-19},{-158,-4},{-77.4,-4}},                color={0,0,127}));
    connect(sCRXRchange2.y, Plant.uvs2) annotation (Line(points={{-181.5,-41},{-152,-41},{-152,-12.64},{-77.4,-12.64}},        color={0,0,127}));
    connect(PSSchange3.y, Plant.uPSS3) annotation (Line(points={{-181.5,-61},{
            -144,-61},{-144,-20.6629},{-77.4,-20.6629}},                                                                      color={0,0,127}));
    connect(Pmchange3.y, Plant.uPm3) annotation (Line(points={{-181.5,-83},{
            -136,-83},{-136,-29.3029},{-77.4,-29.3029}},                                                                    color={0,0,127}));
    connect(sCRXRchange3.y, Plant.uvs3) annotation (Line(points={{-181.5,-101},
            {-128,-101},{-128,-37.9429},{-77.4,-37.9429}},                                                                       color={0,0,127}));
    connect(Ploadchange2.y, Plant.uPload2) annotation (Line(points={{-181.5,-121},{-120,-121},{-120,-46.12},{-77.67,-46.12}},       color={0,0,127}));
    connect(Ploadchange3.y, Plant.uPload3) annotation (Line(points={{-179.5,
            -141},{-77.67,-141},{-77.67,-53.8343}},                                                                     color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{100,100}})),
                                                                   Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{100,100}})),
      experiment(
        StopTime=40),
      Documentation(info="<html>
<p>This is a model is used to perform nonlinear time-simulations by specifying a change in the inputs through sources. The default simulation is a load change modeled with a step source called <span style=\"font-family: Courier New;\">Ploadchange</span>.</p>
<p>In automated analysis, it is used by the following function: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare. </span>The function will use this model and the<span style=\"font-family: Courier New;\"> Example1.Analysis.LinearAnalysis.NonlinModel_for_Linearization </span>model to automatically perform linearization, simulation and comparison of the linear and non-linear models.</p>
<p><i><b>Individual Usage:</b></i></p>
<p>To use this model on its own to perform a simulation, right click on the model and select &quot;Simulation Model&quot;. Then go to the Simulation tab and click on &quot;Simulate&quot;.</p>
</html>"),  preferredView="diagram");
  end NonlinModel_for_NonlinExperiment;

  model LinearModelGeneral
    "Generic linear model for simulation, is simulated by running the function \"LinearizeAndCompare\"."
    extends ThreeMIB.Utilities.Icons.FunctionDependentExample;
    extends ThreeMIB.Interfaces.OutputInterface;
    // The following definitions are very important to couple the linear model
    // to the linearization of the nonlinear model and the simulation
    parameter Real[:] y0=vector(DataFiles.readMATmatrix("MyData.mat", "y0_beforedist")) annotation (Evaluate=false);
    // The following has to be imported in order to be able to interpret and manipulate the StateSpace types
    import Modelica_LinearSystems2.StateSpace;
    parameter StateSpace ss=StateSpace.Import.fromFile("MyData.mat", "ABCD");
    parameter Integer ny=size(ss.C, 1);
    inner Modelica_LinearSystems2.Controller.SampleClock sampleClock
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
    Modelica.Blocks.Routing.DeMultiplex5   demultiplex2_2
      annotation (Placement(transformation(extent={{48,-20},{88,20}})));
    Modelica.Blocks.Math.Add addy[ny]
      annotation (Placement(transformation(extent={{6,-10},{26,10}})));
    Modelica.Blocks.Sources.Constant y0_initial[ny](k=y0)      annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,-32})));
    Modelica_LinearSystems2.Controller.StateSpace stateSpace(system=ss)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Modelica.Blocks.Sources.Constant uVec[12](each k=0)
      annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  equation
    connect(addy.y, demultiplex2_2.u)
      annotation (Line(points={{27,0},{44,0}},                 color={0,0,127}));
    connect(y0_initial.y, addy.u2)
      annotation (Line(points={{0,-21},{0,-6},{4,-6}},   color={0,0,127}));
    connect(stateSpace.y, addy.u1)
      annotation (Line(points={{-19,0},{-8,0},{-8,6},{4,6}},
                                               color={0,0,127}));
    connect(uVec.y, stateSpace.u)
      annotation (Line(points={{-77,0},{-42,0}}, color={0,0,127}));
    connect(demultiplex2_2.y1[1], Vt) annotation (Line(points={{90,16},{156,16},
            {156,0},{234,0}}, color={0,0,127}));
    connect(demultiplex2_2.y2[1], SCRXin) annotation (Line(points={{90,8},{140,
            8},{140,-56},{178,-56},{178,-81},{235,-81}}, color={0,0,127}));
    connect(demultiplex2_2.y3[1], SCRXout) annotation (Line(points={{90,0},{126,
            0},{126,-156},{233,-156},{233,-167}}, color={0,0,127}));
    connect(demultiplex2_2.y4[1], SPEED) annotation (Line(points={{90,-8},{162,
            -8},{162,75},{233,75}}, color={0,0,127}));
    connect(demultiplex2_2.y5[1], ANGLE) annotation (Line(points={{90,-16},{148,
            -16},{148,147},{231,147}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,
              200}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{200,
              160}}),                                      graphics={
          Text(
            extent={{-58,34},{-44,14}},
            lineColor={238,46,47},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={255,0,0},
            textString="du",
            fontSize=24),
          Text(
            extent={{-12,20},{-2,4}},
            lineColor={238,46,47},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={255,0,0},
            textString="dy",
            fontSize=24),
          Text(
            extent={{-38,-18},{-22,-38}},
            lineColor={238,46,47},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={255,0,0},
            textString="y0",
            fontSize=24),
          Text(
            extent={{30,20},{40,4}},
            lineColor={238,46,47},
            fillPattern=FillPattern.VerticalCylinder,
            fillColor={255,0,0},
            fontSize=24,
            textString="y"),
          Text(
            extent={{-92,90},{-12,70}},
            lineColor={85,170,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={28,108,200},
            horizontalAlignment=TextAlignment.Left,
            textString="Note: the addy[] and y0_initial[] blocks 
are defined with ny, where ny is 
an integer of the size of the output matrix. 
This is visible in the Text layer only."),
          Text(
            extent={{-82,-52},{78,-72}},
            lineColor={85,170,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={28,108,200},
            horizontalAlignment=TextAlignment.Left,
            textString="Notice the change in the order of the outputs w.r.t. the nonlinear model.
They have to be rearranged based on the order provided by the linearization function."),
          Line(
            points={{-4,68},{24,48},{18,18}},
            color={0,0,255},
            thickness=0.5,
            arrow={Arrow.None,Arrow.Filled},
            smooth=Smooth.Bezier),   Text(
            extent={{-120,-120},{80,-140}},
            textColor={238,46,47},
            horizontalAlignment=TextAlignment.Left,
            textString="Note: 
Click on \"Documentation\" to see the intended usage of this block.
This model can only be run by excecuting the function \"LinearizeAndCompare\".")}),
      experiment(
        StopTime=15),
      Documentation(info="<html>
<p>This is a generic linear model who&apos;s </p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p><br>See the associated function to run: &quot;LinearizeAndCompare&quot;.</p>
</html>"),  preferredView="diagram");
  end LinearModelGeneral;
  annotation(preferredView = "info", Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,140,72},
          lineThickness=1,
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          radius=25),
        Text(
          lineColor={0,140,72},
          extent={{-100,-48},{100,52}},
          textString="Lin")}),
    Documentation(info="<html>
<p>To perform automated analysis the following function is provided: <span style=\"font-family: Courier New;\"><a href=\"Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare\">LinearizeAndCompare </a></span></p>
</html>"));
end LinearAnalysis;
