within ThreeMIB.Analysis.NonlinSimulationsMultipleInputs;
model E_no_noise_no_inputs
  "Used to test the \"Plant\" block with constant (zero) inputs."
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
  Modelica.Blocks.Sources.Constant AVRchange(k=0)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Constant Ploadchange(k=0) annotation (Placement(
        transformation(extent={{-100,-26},{-80,-6}})));
  Modelica.Blocks.Interfaces.RealOutput AVRin annotation (Placement(
        transformation(extent={{100,-110},{120,-90}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput AVRout annotation (Placement(
        transformation(extent={{100,-130},{120,-110}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
equation
  connect(Plant.uPSS, PSSchange.y) annotation (Line(points={{-44,36},{-62.8572,
          36},{-62.8572,46},{-79,46}}, color={0,0,127}));
  connect(Plant.uPm, Pmchange.y) annotation (Line(points={{-44.4,12},{-62,12},{
          -62,16},{-79,16}}, color={0,0,127}));
  connect(Plant.Vt, Vt) annotation (Line(points={{42,32},{72.4286,32},{72.4286,
          80},{110,80}}, color={0,0,127}));
  connect(Plant.P, P) annotation (Line(points={{42,24},{73.4286,24},{73.4286,40},
          {110,40}}, color={0,0,127}));
  connect(Plant.Q, Q) annotation (Line(points={{42,16},{76,16},{76,0},{110,0}},
        color={0,0,127}));
  connect(Plant.w, w) annotation (Line(points={{42,0},{73.4286,0},{73.4286,-40},
          {110,-40}}, color={0,0,127}));
  connect(Plant.delta, delta) annotation (Line(points={{42,-16},{72.4286,-16},{
          72.4286,-80},{110,-80}}, color={0,0,127}));
  connect(AVRchange.y, Plant.uvs) annotation (Line(points={{-79,-50},{-64,-50},
          {-64,-36},{-44,-36}}, color={0,0,127}));
  connect(Ploadchange.y, Plant.uPload) annotation (Line(points={{-79,-16},{-64,
          -16},{-64,-12},{-44,-12}}, color={0,0,127}));
  connect(Plant.AVRin, AVRin) annotation (Line(points={{42,-24},{68,-24},{68,-100},
          {110,-100}}, color={0,0,127}));
  connect(Plant.AVRout, AVRout) annotation (Line(points={{42,-32},{58,-32},{58,
          -120},{110,-120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={
            {-120,-100},{100,100}})),                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -140},{100,100}}), graphics={Text(
          extent={{-92,-80},{48,-102}},
          lineColor={162,29,33},
          horizontalAlignment=TextAlignment.Left,
          textString="Note: 
Click on the \"Plant\" block to specify controller parameters.")}),
    experiment(
      StopTime=360,
      __Dymola_NumberOfIntervals=10000,
      Tolerance=1e-06,
      __Dymola_fixedstepsize=0.01,
      __Dymola_Algorithm="Dassl"),preferredView="diagram");
end E_no_noise_no_inputs;
