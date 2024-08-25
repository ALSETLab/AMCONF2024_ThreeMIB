within ThreeMIB.Systems;
function bodeplot_GridIOsiso "Produces the Bode plot for the \"GridIOsiso\" model"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Time tlin = 30;
algorithm

  // turn off flags to avoid issues in the generated linear model
  Modelica.Utilities.Streams.print("Setting up things...");
  ThreeMIB.Utilities.SetupSolverSettings.Off();
  Advanced.SparseActivate :=false;
  Advanced.Translation.SparseActivateIntegrator :=false;
  Advanced.Translation.SparseActivateSystems :=false;
  OutputCPUtime :=false; // disable cpu time output so it doesn't screw up the sizes of the outputs

  // linearize and plot
  Modelica_LinearSystems2.ModelAnalysis.TransferFunctions(
  "ThreeMIB.Systems.GridIOsiso", simulationSetup=
  Modelica_LinearSystems2.Records.SimulationOptionsForLinearization(
  linearizeAtInitial=false,
  t_linearize=tlin));
end bodeplot_GridIOsiso;
