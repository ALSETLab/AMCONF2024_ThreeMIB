within ThreeMIB.Systems;
function root_locus "Function for executing the root locus analysis for tuning the AVR gain in Example 1"
  extends Modelica.Icons.Function;
  import Modelica_LinearSystems2.StateSpace;
  import Modelica_LinearSystems2.TransferFunction;
  input String pathToPlantModel="OpenIPSL.ThreeMIB.Systems.GridIO" "Model in which root locus will be performed";
  output Modelica_LinearSystems2.StateSpace ss "Object with ABCD matrices of linearized model";
algorithm
  // LINEARIZE the model
  ss := Modelica_LinearSystems2.ModelAnalysis.Linearize("OpenIPSL.ThreeMIB.Systems.GridIO");
  // Modelica.Utilities.Streams.print(String(ss));
  // Check eigenvalues of the open-loop
  Modelica.Math.Matrices.eigenValues(ss.A);
  // Carry out root locus
  Modelica_LinearSystems2.Utilities.Plot.rootLocusOfModel("OpenIPSL.ThreeMIB.Systems.GridIO", {
    Modelica_LinearSystems2.Records.ParameterVariation(
    Name="G1.pSSTypeIIExtraLeadLag.Kw",
    grid=Modelica_LinearSystems2.Types.Grid.Equidistant,
    Value=15,
    Min=0,
    Max=40,
    nPoints=50)});
  annotation (Documentation(info="<html>
<p>This function varies the AVR gain and, for each value, it linearizes the equations of the example system and extracts the eigenvalues from the state matrix A. By doing so, it stores all the poles of the system and how their loci change with the parametric variation corresponding to AVR gain.</p>
<p>The main goal of this function is to identify for what values of the AVR gain, the system is stable and the poles have adequate damping.</p>
</html>"));
end root_locus;
