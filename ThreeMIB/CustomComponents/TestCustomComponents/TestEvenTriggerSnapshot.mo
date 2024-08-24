within ThreeMIB.CustomComponents.TestCustomComponents;
model TestEvenTriggerSnapshot "Test EvenTriggerSnapshot model"
  extends Modelica.Icons.Example;
  EventTriggerSnapshot eventTriggerSnapshot
    annotation (Placement(transformation(extent={{-40,-20},{20,40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),preferredView="diagram",experiment(StopTime=1250));
end TestEvenTriggerSnapshot;
