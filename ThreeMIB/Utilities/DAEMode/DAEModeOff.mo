within ThreeMIB.Utilities.DAEMode;
function DAEModeOff "Turns off DAE Mode"
  extends Modelica.Icons.Function;
algorithm
  Advanced.Define.DAEsolver := false;
  Modelica.Utilities.Streams.print("DAE Mode is turned off.");
  Advanced.Define.GlobalOptimizations :=0;
  Modelica.Utilities.Streams.print("Global optimization is disabled.");
end DAEModeOff;
