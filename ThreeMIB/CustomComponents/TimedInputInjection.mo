within ThreeMIB.CustomComponents;
model TimedInputInjection
  "Model to inject a designed signal on specified time points."
  extends Modelica.Blocks.Interfaces.SO;
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.ContinuousClock clock
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=
       15)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Logical.Switch inputOn
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.Constant inputZero(k=0) annotation (
      Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold inputOff(threshold=
        1215)
             annotation (Placement(transformation(extent={{-60,40},{
            -40,60}})));
  InputData MultisineData
    annotation (Placement(transformation(extent={{-58,4},{-38,24}})));
equation
  connect(clock.y, greaterThreshold.u)
    annotation (Line(points={{-79,-20},{-62,-20}},
                                               color={0,0,127}));
  connect(greaterThreshold.y,inputOn. u2)
    annotation (Line(points={{-39,-20},{-2,-20}},
                                              color={255,0,255}));
  connect(const.y, inputOn.u3) annotation (Line(points={{-39,-50},{
          -20,-50},{-20,-28},{-2,-28}}, color={0,0,127}));
  connect(y, switch2.y)
    annotation (Line(points={{110,0},{81,0}}, color={0,0,127}));
  connect(inputOn.y, switch2.u3) annotation (Line(points={{21,-20},{
          48,-20},{48,-8},{58,-8}}, color={0,0,127}));
  connect(inputOff.u, greaterThreshold.u) annotation (Line(points={{
          -62,50},{-72,50},{-72,-20},{-62,-20}}, color={0,0,127}));
  connect(inputZero.y, switch2.u1) annotation (Line(points={{-39,80},
          {8,80},{8,8},{58,8}}, color={0,0,127}));
  connect(inputOff.y, switch2.u2) annotation (Line(points={{-39,50},{
          0,50},{0,0},{58,0}}, color={255,0,255}));
  connect(MultisineData.y[1], inputOn.u1) annotation (Line(points={
          {-37,14},{-22,14},{-22,-12},{-2,-12}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5),
        Line(
          points={{0,0},{0,50}},
          thickness=0.5),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
                          Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={255,170,255},
          smooth=Smooth.Bezier,
          origin={-12,17.9},
          rotation=90),   Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={162,29,33},
          smooth=Smooth.Bezier,
          origin={-6,-20.1},
          rotation=90),   Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          origin={-10,-2.1},
          rotation=90)}),preferredView="diagram");
end TimedInputInjection;
