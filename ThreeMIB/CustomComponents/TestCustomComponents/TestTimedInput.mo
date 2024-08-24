within ThreeMIB.CustomComponents.TestCustomComponents;
model TestTimedInput "Test the TimedInputInjection block"
  extends Modelica.Icons.Example;
  TimedInputInjection timedInputInjection
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),experiment(
      StopTime=1320),preferredView="diagram");
end TestTimedInput;
