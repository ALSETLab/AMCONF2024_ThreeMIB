within ThreeMIB.CustomComponents.TestCustomComponents;
model TestTimedNoiseInjection "Test the TimedNoiseInjection block"
  extends Modelica.Icons.Example;
  TimedNoiseInjection              timedNoiseInjection annotation (
      Placement(transformation(extent={{-90,-2},{-70,18}})));
  Modelica.Blocks.Math.Add3 add3_1(k3=-1)
                               annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Pulse pulseup(
    amplitude=0.4,
    width=100,
    period=1/60,
    nperiod=1,
    offset=0,
    startTime=1290) annotation (Placement(transformation(extent={{-90,-34},{-70,
            -14}})));
  Modelica.Blocks.Sources.Pulse pulsedown(
    amplitude=0.4,
    width=100,
    period=1/60,
    nperiod=1,
    offset=0,
    startTime=1290 + 2*3/60) annotation (Placement(transformation(
          extent={{-90,-74},{-70,-54}})));
  Modelica.Blocks.Interfaces.RealOutput y1
                          "Connector of Real output signal"
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));
equation
  connect(add3_1.u1,timedNoiseInjection. y) annotation (Line(points={{-52,8},{-69,
          8}},                    color={0,0,127}));
  connect(pulseup.y,add3_1. u2) annotation (Line(points={{-69,-24},{-60,-24},{-60,
          0},{-52,0}},                      color={0,0,127}));
  connect(pulsedown.y,add3_1. u3) annotation (Line(points={{-69,-64},{-56,-64},{
          -56,-8},{-52,-8}},                 color={0,0,127}));
  connect(add3_1.y, y1)
    annotation (Line(points={{-29,0},{12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1320),preferredView="diagram");
end TestTimedNoiseInjection;
