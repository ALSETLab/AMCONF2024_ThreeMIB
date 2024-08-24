within ThreeMIB.Utilities.SetupSolverSettings;
function Off
  "Setups up the solver settings, disabling flags that include options on DAE and Sparsity"
  extends Modelica.Icons.Function;
algorithm
  Advanced.Define.DAEsolver := false;
  Modelica.Utilities.Streams.print("DAE Mode is turned off.");
  Advanced.Define.GlobalOptimizations :=0;
  Modelica.Utilities.Streams.print("Global optimization is disabled.");
  Advanced.SparseActivate :=false;
  Advanced.Translation.SparseActivateIntegrator :=false;
  Advanced.Translation.SparseActivateSystems :=false;
  Modelica.Utilities.Streams.print("Sparse options disabled.");
  Advanced.NumberOfCores := 1;
  Modelica.Utilities.Streams.print("Number of cores reset to default:" + String(Advanced.NumberOfCores));
annotation(preferredView="text");
end Off;
