within ThreeMIB.Utilities.PlotDownsample;
function downsamplePlottingON "Enable flag for downsampling"
  extends Modelica.Icons.Function;
algorithm
  Advanced.Beta.Plot.DownsampleLimit :=4;
  Modelica.Utilities.Streams.print("Plotting downsampling is enabled.");
end downsamplePlottingON;
