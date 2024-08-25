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
      input Modelica.Units.SI.Time tlin=40 "t for model linearization";
      input Modelica.Units.SI.Time tsim=40 "Simulation time";
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
<p><img src=\"modelica://Example1/Resources/Images/linsimple (Small).png\"/></p>
<li><span style=\"font-family: Arial;\">Leave the default parameters on first use. Alternatively, modify the tlin and tsim parameters, note that tsim should be greater or equal to tlin.</span></li>
<li><span style=\"font-family: Arial;\">Go to the bottom of the window and click on &quot;Execute&quot;, if successful, messages/results are displayed in the command window.</span></li>
<li><span style=\"font-family: Arial;\">Go back to the function&apos;s own window and click on &quot;Close&quot;.</span> </li>
</ol>
<p><br><i><b>Sample Output</b></i></p>
<p>Executing the function gives the following results in the &quot;Commands&quot; window.</p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeSimple();</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">DAE&nbsp;Mode&nbsp;is&nbsp;turned&nbsp;off.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Global&nbsp;optimization&nbsp;is&nbsp;disabled.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Sparse&nbsp;options&nbsp;disabled.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Linearization&nbsp;and&nbsp;Nonlinear&nbsp;Model&nbsp;Comparison&nbsp;is&nbsp;starting...</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Linearized&nbsp;Model</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Number&nbsp;of&nbsp;states:&nbsp;12</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;nonlinear&nbsp;model</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Redeclaring&nbsp;variable:&nbsp;Real&nbsp;y0&nbsp;[7,&nbsp;1012];</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Declaring&nbsp;variable:&nbsp;Real&nbsp;y0out&nbsp;[7];</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;=&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;&quot;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;=&nbsp;&nbsp;=&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.000024318695068359375&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.196186602115631103515625&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.900009691715240478515625&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.28431034088134765625&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.50904435006304993294179e-07&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.120034694671630859375&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&quot;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;376.9911183891212,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-0.17610876763748942,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.19586150145880193,&nbsp;0.05515410219837237,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-0.25587785362300375,&nbsp;0.0,&nbsp;-0.12499999997574654,&nbsp;0.0,&nbsp;-0.2667630481888344,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.001159492170868593,&nbsp;0.0,&nbsp;0.0,&nbsp;0.12499999999488744,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.4265899899207167,&nbsp;0.0,&nbsp;0.0,&nbsp;-1.0000000000939857,&nbsp;0.007883244407403102,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.4901043751184482,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-3.3690289136967633,&nbsp;0.0,&nbsp;33.3333333351218,&nbsp;0.0,&nbsp;-36.84568272027127,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.015266513308270566,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">2.4254614215865864,&nbsp;0.0,&nbsp;0.0,&nbsp;14.285714287056937,&nbsp;0.04482173884230768,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-22.75799624545071,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-8.934890956417721,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;29.303251383490004,&nbsp;33.12307890942945,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-66.66666667217629,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-1.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;18999999.999786172,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-2000000.0001652886,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;10000.00082740371,&nbsp;-9999.999999590995,&nbsp;0.0,&nbsp;0.0,&nbsp;-18999999.99980534;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.009499999999893087,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.001,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.009499999999902671;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.009499999999893087,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.001,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.009499999999902671;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.7092198580776662,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.7092198581570424],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.14285715467719584,&nbsp;-0.03160725649463204,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-0.04042882695287631,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.10093337277083947,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-0.532308225276168,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.5738762639698587,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-1.0247506547026812,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">19000001.57206705,&nbsp;0.0,&nbsp;0.0,&nbsp;2000000.1654807418;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.009500000786033523,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.009500000786033523,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.7092199168371426,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[-0.13402336434626583,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.43954877075235005,&nbsp;0.4968461836414418,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.3043068141629995,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.4537261850177308,&nbsp;0.7665888604391177,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">1.2253264601006595,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.3643245623264468,&nbsp;-0.38254244268485077,&nbsp;0.0,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.9999999998895094,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">1.0000000001010991,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;9.499999999893086,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-9.49999999990267;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.9999999999590995,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;-0.015371259820540216,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.02120334463562301,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.21999579935538804,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">9.500000786033524,&nbsp;0.0,&nbsp;0.0,&nbsp;1.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;{&quot;uPSS&quot;,&nbsp;&quot;uPm&quot;,&nbsp;&quot;uPload&quot;,&nbsp;&quot;uvsAVR&quot;},&nbsp;{&quot;Vt&quot;,&nbsp;&quot;Q&quot;,&nbsp;&quot;P&quot;,&nbsp;&quot;w&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;delta&quot;,&nbsp;&quot;AVRin&quot;,&nbsp;&quot;AVRout&quot;},&nbsp;{&quot;Plant.G1.machine.delta&quot;,&nbsp;&quot;Plant.G1.machine.w&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.machine.e1q&quot;,&nbsp;&quot;Plant.G1.machine.e1d&quot;,&nbsp;&quot;Plant.G1.machine.e2q&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.machine.e2d&quot;,&nbsp;&quot;Plant.G1.avr.vm&quot;,&nbsp;&quot;Plant.G1.avr.vr&quot;,&nbsp;&quot;Plant.G1.avr.vf1&quot;,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pss.imLeadLag.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G1.pss.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pss.derivativeLag.TF.x_scaled[1]&quot;}</span></p>
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
      input Modelica.Units.SI.Time tlin=30.5 "t for model linearization";
      input Modelica.Units.SI.Time tsim=40 "Simulation time";
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
        // Plot
    removePlots(true);
    createPlot(id=1, position={-2, 1, 584, 782}, y={"Vt"}, range={0.0, 20.0, 0.998, 1.002}, grid=true, filename="res_nl.mat", colors={{28,108,200}}, displayUnits={"1"});
    createPlot(id=1, position={-2, 1, 584, 782}, y={"Q"}, range={0.0, 20.0, 0.18, 0.21}, grid=true, subPlot=102, colors={{28,108,200}}, displayUnits={"1"});
    createPlot(id=1, position={-2, 1, 584, 782}, y={"P"}, range={0.0, 20.0, 0.86, 0.94}, grid=true, subPlot=103, colors={{28,108,200}}, displayUnits={"1"});

    createPlot(id=1, position={-2, 1, 584, 782}, y={"Vt"}, range={0.0, 20.0, 0.998, 1.002}, erase=false, grid=true, filename="res_lin.mat", colors={{238,46,47}});
    createPlot(id=1, position={-2, 1, 584, 782}, y={"Q"}, range={0.0, 20.0, 0.18, 0.21}, erase=false, grid=true, subPlot=102, colors={{238,46,47}});
    createPlot(id=1, position={-2, 1, 584, 782}, y={"P"}, range={0.0, 20.0, 0.86, 0.94}, erase=false, grid=true, subPlot=103, colors={{238,46,47}});

      annotation(__Dymola_interactive=true, Documentation(info="<html>
<p>This function can linearize the model at initialization or at a user provided point in time. Once the model is linearized, linear model and the nonlinear models are simulated.</p>
<p>The response of both models is then plotted/compared to check the quality of the linear model.</p>
<p>The function uses the following models:</p>
<ul>
<li>Non-linear model for linearization: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.NonlinModel_for_Linearization</span></li>
<li>Non-linear model for simulation: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.NonlinModel_for_NonlinExperiment</span></li>
<li>Linear model for simualtion: <span style=\"font-family: Courier New;\">Example1.Analysis.LinearAnalysis.LinearModelGeneral</span></li>
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
<p><img src=\"modelica://Example1/Resources/Images/lincompare (Small).png\"/></p>
<li><span style=\"font-family: Arial;\">Leave the default parameters on first use. Alternatively, modify the tlin and tsim parameters, note that tsim should be greater or equal to tlin.</span></li>
<li><span style=\"font-family: Arial;\">Go to the bottom of the window and click on &quot;Execute&quot;, if successful, messages/results are displayed in the command window.</span></li>
<li><span style=\"font-family: Arial;\">Go back to the function&apos;s own window and click on &quot;Close&quot;.</span> </li>
</ol>
<p><br><i><b>Sample Output</b></i></p>
<p>Executing the function gives the following plot is produced in the &quot;Simulation&quot; window and the following results in the &quot;Commands&quot; window.</p>
<p><img src=\"modelica://Example1/Resources/Images/LinearizeAndCompare.png\"/></p>
<p style=\"margin-left: 30px;\"><br><span style=\"font-family: Courier New; font-size: 10pt;\">Example1.Analysis.LinearAnalysis.CustomFunctions.LinearizeAndCompare();</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">DAE&nbsp;Mode&nbsp;is&nbsp;turned&nbsp;off.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Global&nbsp;optimization&nbsp;is&nbsp;disabled.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Sparse&nbsp;options&nbsp;disabled.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Linearization&nbsp;and&nbsp;Nonlinear&nbsp;Model&nbsp;Comparison&nbsp;is&nbsp;starting...</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;nonlinear&nbsp;model</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">y0&nbsp;before&nbsp;disturbance&nbsp;=</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;&quot;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.998271&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.203063&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0.921617&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.29897&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-3.55698e-11&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.12495&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&quot;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">Simulating&nbsp;linear&nbsp;model</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;true</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;1</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;=&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;376.99111838906373,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-0.17610876767279915,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.19586150142483613,&nbsp;0.05515410219997556,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-0.25587785359503384,&nbsp;0.0,&nbsp;-0.12500000002903436,&nbsp;0.0,&nbsp;-0.2667630481021101,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.001159492170902296,&nbsp;0.0,&nbsp;0.0,&nbsp;0.12500000001466172,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.42658999050935953,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.9999999998908723,&nbsp;0.007883244274318683,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-1.4901043751617613,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-3.369028913176898,&nbsp;0.0,&nbsp;33.33333333281978,&nbsp;0.0,&nbsp;-36.84568271688989,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.015266512953637873,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">2.425461424825778,&nbsp;0.0,&nbsp;0.0,&nbsp;14.285714284155317,&nbsp;0.0448217383657263,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-22.75799624611222,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">-8.934890939628422,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;29.303251372407868,&nbsp;33.1230788990298,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-66.66666667021094,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-1.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;18999999.999783278,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-2000000.0001063284,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;10000.00082740371,&nbsp;-10000.000001172937,&nbsp;0.0,&nbsp;0.0,&nbsp;-18999999.996308953;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.00949999999989164,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.001,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.009499999998154478;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.00949999999989164,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;-0.001,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.009499999998154478;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.7092198580775582,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-0.7092198580803518],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.14285715467719584,&nbsp;-0.03160719305331635,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-0.040428715930573844,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.10093331725968824,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-0.5323070687938507,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.5738766604780818,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;-1.024765457676343,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">19000001.57206705,&nbsp;0.0,&nbsp;0.0,&nbsp;2000000.1654807418;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.009500000786033523,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.009500000786033523,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.7092199168371426,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[-0.1340233640944263,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.43954877058611797,&nbsp;0.496846183485447,&nbsp;0.0,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.3043068137697762,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.4537261847736198,&nbsp;0.7665888603335728,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">1.2253264605206322,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.364324561691764,&nbsp;-0.38254244286640693,&nbsp;0.0,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.9999999998893571,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">1.0000000001610603,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;9.499999999891639,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-9.499999998154477;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;1.0000000001172937,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">[0.0,&nbsp;0.0,&nbsp;-0.01537148186514514,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.02120284503526193,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.21999546628848066,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">9.500000786033524,&nbsp;0.0,&nbsp;0.0,&nbsp;1.0;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">0.0,&nbsp;0.0,&nbsp;0.0,&nbsp;0.0],&nbsp;{&quot;uPSS&quot;,&nbsp;&quot;uPm&quot;,&nbsp;&quot;uPload&quot;,&nbsp;&quot;uvsAVR&quot;},&nbsp;{&quot;Vt&quot;,&nbsp;&quot;Q&quot;,&nbsp;&quot;P&quot;,&nbsp;&quot;w&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;delta&quot;,&nbsp;&quot;AVRin&quot;,&nbsp;&quot;AVRout&quot;},&nbsp;{&quot;Plant.G1.machine.delta&quot;,&nbsp;&quot;Plant.G1.machine.w&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.machine.e1q&quot;,&nbsp;&quot;Plant.G1.machine.e1d&quot;,&nbsp;&quot;Plant.G1.machine.e2q&quot;,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&quot;Plant.G1.machine.e2d&quot;,&nbsp;&quot;Plant.G1.avr.vm&quot;,&nbsp;&quot;Plant.G1.avr.vr&quot;,&nbsp;&quot;Plant.G1.avr.vf1&quot;,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pss.imLeadLag.TF.x_scaled[1]&quot;,&nbsp;&quot;Plant.G1.pss.imLeadLag1.TF.x_scaled[1]&quot;,</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;&nbsp;&quot;Plant.G1.pss.derivativeLag.TF.x_scaled[1]&quot;},&nbsp;{0.9982708096504211,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;0.20306333899497986,&nbsp;0.9216165542602539,&nbsp;1.0,&nbsp;1.2989709377288818,&nbsp;</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: Courier New; font-size: 10pt;\">&nbsp;&nbsp;-3.5569769352150615E-11,&nbsp;2.124945878982544}</span></p>
</html>"),    preferredView="info");
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
    connect(Plant.ANGLE, ANGLE) annotation (Line(points={{164.32,42.0743},{192,42.0743},{192,257},{275,257}},  color={0,0,127}));
    connect(Plant.SPEED, SPEED) annotation (Line(points={{164.965,15.1686},{216,15.1686},{216,139},{277,139}}, color={0,0,127}));
    connect(Plant.Vt, Vt) annotation (Line(points={{164.32,-11},{232,-11},{232,1},{283,1}},              color={0,0,127}));
    connect(Plant.SCRXin, SCRXin) annotation (Line(points={{165.61,-39.7486},{214,-39.7486},{214,-125},{283,-125}},  color={0,0,127}));
    connect(Plant.SCRXout, SCRXout) annotation (Line(points={{166.255,-67.3914},{166.255,-104},{190,-104},{190,-267},{281,-267}},
                                                                                                                              color={0,0,127}));
    connect(uPload1, Plant.uPload1) annotation (Line(points={{-310,296},{-218,296},{-218,95.5171},{-117.545,95.5171}}, color={0,0,127}));
    connect(uPSS1, Plant.uPSS1) annotation (Line(points={{-306,234},{-232,234},{-232,76.72},{-116.9,76.72}},       color={0,0,127}));
    connect(uPm1, Plant.uPm1) annotation (Line(points={{-305,177},{-244,177},{-244,54.6057},{-116.9,54.6057}},   color={0,0,127}));
    connect(uvs1, Plant.uvs1) annotation (Line(points={{-305,119},{-252,119},{-252,32.4914},{-116.9,32.4914}},   color={0,0,127}));
    connect(uPSS2, Plant.uPSS2) annotation (Line(points={{-309,55},{-248,55},{-248,11.8514},{-116.9,11.8514}},   color={0,0,127}));
    connect(uPm2, Plant.uPm2) annotation (Line(points={{-310,0},{-240,0},{-240,-11},{-116.9,-11}},             color={0,0,127}));
    connect(uvs2, Plant.uvs2) annotation (Line(points={{-306,-54},{-248,-54},{-248,-31.64},{-116.9,-31.64}},       color={0,0,127}));
    connect(uPSS3, Plant.uPSS3) annotation (Line(points={{-304,-106},{-242,-106},{-242,-50.8057},{-116.9,-50.8057}},   color={0,0,127}));
    connect(uPm3, Plant.uPm3) annotation (Line(points={{-308,-156},{-240,-156},{-240,-71.4457},{-116.9,-71.4457}},   color={0,0,127}));
    connect(uvs3, Plant.uvs3) annotation (Line(points={{-304,-206},{-268,-206},{-268,-208},{-230,-208},{-230,-92.0857},{-116.9,-92.0857}},   color={0,0,127}));
    connect(uPload2, Plant.uPload2) annotation (Line(points={{-306,-256},{-266,-256},{-266,-254},{-216,-254},{-216,-111.62},{-117.545,-111.62}},   color={0,0,127}));
    connect(uPload3, Plant.uPload3) annotation (Line(points={{-306,-312},{-256,-312},{-256,-310},{-117.545,-310},{-117.545,-130.049}}, color={0,0,127}));
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
    connect(Plant.SCRXin, SCRXin) annotation (Line(points={{40.86,-16.0343},{94,-16.0343},{94,-66},{116,-66}},   color={0,0,127}));
    connect(Plant.SCRXout, SCRXout) annotation (Line(points={{41.13,-27.6057},{92,-27.6057},{92,-114},{114,-114}},   color={0,0,127}));
    connect(Plant.ANGLE, ANGLE) annotation (Line(points={{40.32,18.2171},{94,18.2171},{94,81},{115,81}},   color={0,0,127}));
    connect(Plant.SPEED, SPEED) annotation (Line(points={{40.59,6.95429},{96,6.95429},{96,42},{116,42}},   color={0,0,127}));
    connect(Ploadchange1.y, Plant.uPload1) annotation (Line(points={{-181.5,89},{-136,89},{-136,40.5886},{-77.67,40.5886}},   color={0,0,127}));
    connect(PSSchange1.y, Plant.uPSS1) annotation (Line(points={{-179.4,64},{-136,64},{-136,32.72},{-77.4,32.72}},        color={0,0,127}));
    connect(Pmchange1.y, Plant.uPm1) annotation (Line(points={{-181.5,41},{-152,41},{-152,23.4629},{-77.4,23.4629}},    color={0,0,127}));
    connect(sCRXRchange1.y, Plant.uvs1) annotation (Line(points={{-181.5,21},{-154,21},{-154,14.2057},{-77.4,14.2057}},    color={0,0,127}));
    connect(PSSchange2.y, Plant.uPSS2) annotation (Line(points={{-181.5,1},{-160,1},{-160,5.56571},{-77.4,5.56571}},    color={0,0,127}));
    connect(Pmchange2.y, Plant.uPm2) annotation (Line(points={{-181.5,-19},{-158,-19},{-158,-4},{-77.4,-4}},                color={0,0,127}));
    connect(sCRXRchange2.y, Plant.uvs2) annotation (Line(points={{-181.5,-41},{-152,-41},{-152,-12.64},{-77.4,-12.64}},        color={0,0,127}));
    connect(PSSchange3.y, Plant.uPSS3) annotation (Line(points={{-181.5,-61},{-144,-61},{-144,-20.6629},{-77.4,-20.6629}},    color={0,0,127}));
    connect(Pmchange3.y, Plant.uPm3) annotation (Line(points={{-181.5,-83},{-136,-83},{-136,-29.3029},{-77.4,-29.3029}},    color={0,0,127}));
    connect(sCRXRchange3.y, Plant.uvs3) annotation (Line(points={{-181.5,-101},{-128,-101},{-128,-37.9429},{-77.4,-37.9429}},    color={0,0,127}));
    connect(Ploadchange2.y, Plant.uPload2) annotation (Line(points={{-181.5,-121},{-120,-121},{-120,-46.12},{-77.67,-46.12}},       color={0,0,127}));
    connect(Ploadchange3.y, Plant.uPload3) annotation (Line(points={{-179.5,-141},{-77.67,-141},{-77.67,-53.8343}},     color={0,0,127}));
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
