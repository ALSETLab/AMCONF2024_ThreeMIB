within ThreeMIB.Analysis.NonlinSimulationsMultipleInputs;
model C_randomload "Same as \"B_\" above, but removing the load disturbance."

  extends Modelica.Icons.Example;
  Modelica.Blocks.Interfaces.RealOutput Vt
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));
public
  Modelica.Blocks.Interfaces.RealOutput Q
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput w
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput delta
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.Constant PSSchange(k=0)
    annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
  Modelica.Blocks.Sources.Constant Pmchange(k=0)
    annotation (Placement(transformation(extent={{-100,6},{-80,26}})));
  Example1.Base.Systems.gridIO Plant(t1=0.5, t2=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed(useAutomaticSeed=
        false)
    annotation (Placement(transformation(extent={{-96,72},{-76,92}})));
  Modelica.Blocks.Interfaces.RealOutput AVRin annotation (Placement(
        transformation(extent={{100,-110},{120,-90}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput AVRout annotation (Placement(
        transformation(extent={{100,-130},{120,-110}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Example1.CustomComponents.TimedNoiseInjection loadnoise annotation (Placement(transformation(extent={{-160,2},{-140,22}})));
  Modelica.Blocks.Math.Add uload annotation (Placement(transformation(
          extent={{-120,-22},{-100,-2}})));
  Modelica.Blocks.Sources.Constant
                                uloaddist(k=0)
                    annotation (Placement(transformation(extent={{-160,
            -38},{-140,-18}})));
  Modelica.Blocks.Sources.Constant uAVR(k=0)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
equation
  connect(Plant.uPSS, PSSchange.y) annotation (Line(points={{-44,36},{
          -62.8572,36},{-62.8572,46},{-79,46}},      color={0,0,127}));
  connect(Plant.uPm, Pmchange.y) annotation (Line(points={{-44.4,12},{-62,12},
          {-62,16},{-79,16}},              color={0,0,127}));
  connect(Plant.Vt, Vt) annotation (Line(points={{42,32},{72.4286,32},{
          72.4286,80},{110,80}},              color={0,0,127}));
  connect(Plant.P, P) annotation (Line(points={{42,24},{73.4286,24},{73.4286,
          40},{110,40}},              color={0,0,127}));
  connect(Plant.Q, Q) annotation (Line(points={{42,16},{76,16},{76,0},{110,0}},
                       color={0,0,127}));
  connect(Plant.w, w) annotation (Line(points={{42,0},{73.4286,0},{73.4286,
          -40},{110,-40}},              color={0,0,127}));
  connect(Plant.delta, delta) annotation (Line(points={{42,-16},{72.4286,-16},
          {72.4286,-80},{110,-80}},               color={0,0,127}));
  connect(AVRin, Plant.AVRin) annotation (Line(points={{110,-100},{60,-100},{
          60,-24},{42,-24}},             color={0,0,127}));
  connect(AVRout, Plant.AVRout) annotation (Line(points={{110,-120},{52,-120},
          {52,-32},{42,-32}},                   color={0,0,127}));
  connect(uload.u1, loadnoise.y) annotation (Line(points={{-122,-6},{
          -132,-6},{-132,12},{-139,12}}, color={0,0,127}));
  connect(uloaddist.y, uload.u2) annotation (Line(points={{-139,-28},
          {-132,-28},{-132,-18},{-122,-18}}, color={0,0,127}));
  connect(uload.y, Plant.uPload) annotation (Line(points={{-99,-12},{-72.5,
          -12},{-72.5,-12},{-44,-12}},          color={0,0,127}));
  connect(uAVR.y, Plant.uvs) annotation (Line(points={{-79,-40},{-54,-40},{
          -54,-36},{-44,-36}},      color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{100,100}}),
                               graphics={Text(
          extent={{-96,-80},{44,-102}},
          lineColor={162,29,33},
          textString="Note: see the block uloaddist on the load disturbance data specification.
Click on the \"Plant\" block to specify controller parameters.",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(
      StopTime=1320,
      Interval=60,
      __Dymola_fixedstepsize=0.01,
      __Dymola_Algorithm="Dassl"),preferredView="diagram");
end C_randomload;
