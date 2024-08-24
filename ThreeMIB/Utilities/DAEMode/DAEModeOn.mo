within ThreeMIB.Utilities.DAEMode;
function DAEModeOn "Turns on DAE Mode"
  extends Modelica.Icons.Function;
algorithm
  Advanced.Define.DAEsolver := true;
  Modelica.Utilities.Streams.print("DAE Mode is turned on.");
  Advanced.Define.GlobalOptimizations :=2;
  Modelica.Utilities.Streams.print("Global optimization is enabled.");
end DAEModeOn;
