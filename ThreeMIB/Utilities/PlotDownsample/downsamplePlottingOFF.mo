within ThreeMIB.Utilities.PlotDownsample;
function downsamplePlottingOFF "Disable flag for downsampling"
  extends Modelica.Icons.Function;
algorithm
  Advanced.Beta.Plot.DownsampleLimit := 0;
  Modelica.Utilities.Streams.print("Plotting downsampling is disabled.");
end downsamplePlottingOFF;
