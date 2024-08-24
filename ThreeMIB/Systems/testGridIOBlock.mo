within ThreeMIB.Systems;
model testGridIOBlock "Test the gridIO model"
  extends Modelica.Icons.Example;
  GridIO grid(
    t1=7.5,
    t2=Modelica.Constants.inf,
    t1fault=0.5,
    t2fault=0.57) annotation (Placement(transformation(extent={{-20,-18},{20,22}})));
  Modelica.Blocks.Sources.Pulse    pulse(
    amplitude=1,
    width=50,
    period=0.1,
    nperiod=1,
    startTime=20)
    annotation (Placement(transformation(extent={{-98,24},{-70,52}})));
  Modelica.Blocks.Sources.RealExpression zero
    annotation (Placement(transformation(extent={{-104,-32},{-68,2}})));
equation
  connect(pulse.y, grid.uPload1) annotation (Line(points={{-68.6,38},{-42,38},{
          -42,18.5143},{-22.1,18.5143}},                                                                         color={0,0,127}));
  connect(zero.y, grid.uPSS1) annotation (Line(points={{-66.2,-15},{-66.2,-16},
          {-62,-16},{-62,-4},{-58,-4},{-58,20},{-42,20},{-42,15.6},{-22,15.6}},                                                                                 color={0,0,127}));
  connect(grid.uPm1, zero.y) annotation (Line(points={{-22,12.1714},{-22,20},{
          -58,20},{-58,-4},{-62,-4},{-62,-15},{-66.2,-15}},                                                                               color={0,0,127}));
  connect(grid.uvs1, zero.y) annotation (Line(points={{-22,8.74286},{-22,14},{
          -58,14},{-58,-4},{-62,-4},{-62,-15},{-66.2,-15}},                                                                               color={0,0,127}));
  connect(grid.uPSS2, zero.y) annotation (Line(points={{-22,5.54286},{-22,8},{
          -56,8},{-56,2},{-58,2},{-58,-4},{-62,-4},{-62,-15},{-66.2,-15}},                                                                               color={0,0,127}));
  connect(grid.uPm2, zero.y) annotation (Line(points={{-22,2},{-58,2},{-58,-4},
          {-62,-4},{-62,-15},{-66.2,-15}},                                                                                       color={0,0,127}));
  connect(grid.uvs2, zero.y) annotation (Line(points={{-22,-1.2},{-62,-1.2},{
          -62,-15},{-66.2,-15}},                                                                                 color={0,0,127}));
  connect(grid.uPSS3, zero.y) annotation (Line(points={{-22,-4.17143},{-62,
          -4.17143},{-62,-15},{-66.2,-15}},                                                                       color={0,0,127}));
  connect(grid.uPm3, zero.y) annotation (Line(points={{-22,-7.37143},{-60,
          -7.37143},{-60,-10},{-58,-10},{-58,-9.15789},{-62,-9.15789},{-62,-15},
          {-66.2,-15}},                                                                                                                                            color={0,0,127}));
  connect(grid.uvs3, zero.y) annotation (Line(points={{-22,-10.5714},{-60,
          -10.5714},{-60,-10},{-58,-10},{-58,-9.15789},{-62,-9.15789},{-62,-15},
          {-66.2,-15}},                                                                                                                                            color={0,0,127}));
  connect(grid.uPload2, zero.y) annotation (Line(points={{-22.1,-13.6},{-60,
          -13.6},{-60,-10},{-58,-10},{-58,-9.15789},{-62,-9.15789},{-62,-15},{
          -66.2,-15}},                                                                                                                                                color={0,0,127}));
  connect(grid.uPload3, zero.y) annotation (Line(points={{-22.1,-16.4571},{-60,
          -16.4571},{-60,-10},{-58,-10},{-58,-9.15789},{-62,-9.15789},{-62,-15},
          {-66.2,-15}},                                                                                                                                               color={0,0,127}));
  annotation (experiment(StopTime=30, __Dymola_Algorithm="Dassl"),
    Diagram(coordinateSystem(extent={{-120,-40},{40,60}})));
end testGridIOBlock;
