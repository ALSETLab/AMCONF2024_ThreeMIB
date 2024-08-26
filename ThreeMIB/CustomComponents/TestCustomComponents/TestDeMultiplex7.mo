within ThreeMIB.CustomComponents.TestCustomComponents;
model TestDeMultiplex7 "Tes the DeMultiplex7 block"
  extends Modelica.Icons.Example;
  extends Example1.Interfaces.OutputsInterfaceWEfdAndAVRout;
  DeMultiplex7 deMultiplex7_1
    annotation (Placement(transformation(extent={{-100,-60},{20,60}})));
  Modelica.Blocks.Sources.Ramp ramp[7](each duration=5, each startTime=1)
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
equation
  connect(deMultiplex7_1.u, ramp.y)
    annotation (Line(points={{-112,0},{-159,0}}, color={0,0,127}));
  connect(deMultiplex7_1.y1[1], Vt) annotation (Line(points={{26,54},{52,54},{
          52,160},{210,160}}, color={0,0,127}));
  connect(deMultiplex7_1.y2[1], P) annotation (Line(points={{26,32.4},{46,32.4},
          {46,32},{64,32},{64,120},{210,120}}, color={0,0,127}));
  connect(w, deMultiplex7_1.y4[1]) annotation (Line(points={{210,0},{48,0},{48,
          -10.8},{26,-10.8}}, color={0,0,127}));
  connect(Q, deMultiplex7_1.y3[1]) annotation (Line(points={{208,80},{184,80},{
          184,86},{98,86},{98,12},{26,12},{26,10.8}},   color={0,0,127}));
  connect(delta, deMultiplex7_1.y5[1]) annotation (Line(points={{210,-80},{192,
          -80},{192,-82},{166,-82},{166,-32.4},{26,-32.4}}, color={0,0,127}));
  connect(AVRin, deMultiplex7_1.y6[1]) annotation (Line(points={{210,-120},{142,
          -120},{142,-54},{26,-54}}, color={0,0,127}));
  connect(AVRout, deMultiplex7_1.y7[1]) annotation (Line(points={{210,-160},{90,
          -160},{90,-70.8},{26,-70.8}}, color={0,0,127}));
annotation(preferredView="diagram",experiment(StopTime=10),
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}})));
end TestDeMultiplex7;
