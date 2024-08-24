within ThreeMIB.Utilities.SetupSolverSettings;
function On
  "Setups up the solver settings, enabling flags that include options on DAE and Sparsity"
  extends Modelica.Icons.Function;
  input Integer corenum = 12 "Number of processor cores to use";
algorithm
  Advanced.Define.DAEsolver := true;
  Modelica.Utilities.Streams.print("DAE Mode is turned on.");
  Advanced.Define.GlobalOptimizations :=2;
  Modelica.Utilities.Streams.print("Global optimization is enabled.");
  Advanced.SparseActivate :=true;
  Advanced.Translation.SparseActivateIntegrator :=true;
  Advanced.Translation.SparseActivateSystems :=true;
  Advanced.SparseMaximumDensity := 25;
  Advanced.SparseMinimumStates := 50;
  Modelica.Utilities.Streams.print("Sparse options enabled.");
  Advanced.NumberOfCores := corenum;
  Modelica.Utilities.Streams.print("If available, the following number of cores will be used:" + String(corenum));
annotation(preferredView="text");
end On;
