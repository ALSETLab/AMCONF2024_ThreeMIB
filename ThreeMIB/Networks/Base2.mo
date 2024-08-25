within ThreeMIB.Networks;
partial model Base2 "Partial ThreeMIB Model with SysData and simple load"

  OpenIPSL.Electrical.Buses.Bus B1(displayPF=false) annotation (Placement(transformation(extent={{-112,34},{-92,54}})));
  OpenIPSL.Electrical.Buses.Bus B3(displayPF=false) annotation (Placement(transformation(extent={{-112,-54},{-92,-34}})));
  OpenIPSL.Electrical.Buses.Bus B4(displayPF=false) annotation (Placement(transformation(extent={{-40,34},{-20,54}})));
  OpenIPSL.Electrical.Buses.Bus B2(displayPF=false) annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
  OpenIPSL.Electrical.Branches.PwLine line2(
    R=0.0010,
    X=0.12,
    G=0.0000,
    B=0.0000) annotation (Placement(transformation(extent={{-10,-54},{10,-34}})));
  OpenIPSL.Electrical.Loads.PSSE.Load Load1(
    P_0=pf.powerflow.loads.PL1,
    Q_0=pf.powerflow.loads.QL1,
    v_0=pf.powerflow.bus.v4,
    angle_0=pf.powerflow.bus.A4) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={4,41})));
  inner OpenIPSL.Electrical.SystemBase SysData annotation (Placement(transformation(extent={{14,76},{80,100}})));
  OpenIPSL.Electrical.Buses.Bus B5(displayPF=false) annotation (Placement(transformation(extent={{-38,-54},{-18,-34}})));
  OpenIPSL.Electrical.Buses.Bus B6(displayPF=false) annotation (Placement(transformation(extent={{20,-54},{40,-34}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF1(
    CZ=1,
    R=0.000000,
    X=0.006410,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=500000) annotation (Placement(transformation(extent={{-68,34},{-48,54}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF2(
    CZ=1,
    R=0.000000,
    X=0.006410,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=500000) annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF3(
    CZ=1,
    R=0.000000,
    X=0.011200,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=18000) annotation (Placement(transformation(extent={{-70,-54},{-50,-34}})));
  OpenIPSL.Electrical.Loads.PSSE.Load Load2(
    P_0=pf.powerflow.loads.PL2,
    Q_0=pf.powerflow.loads.QL2,
    v_0=pf.powerflow.bus.v5,
    angle_0=pf.powerflow.bus.A5) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-40,-75})));
  OpenIPSL.Electrical.Loads.PSSE.Load Load3(
    P_0=pf.powerflow.loads.PL3,
    Q_0=pf.powerflow.loads.QL3,
    v_0=pf.powerflow.bus.v6,
    angle_0=pf.powerflow.bus.A6) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={40,-75})));
  OpenIPSL.Electrical.Branches.PwLine line1(
    R=0,
    X=0.036,
    G=0,
    B=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-14,6})));
  GenerationUnits.InfiniteBus                                    infiniteBus(
    P_0=pf.powerflow.machines.PG4,
    Q_0=pf.powerflow.machines.QG4,
    v_0=pf.powerflow.bus.v6,
    angle_0=pf.powerflow.bus.A6,
    displayPF=false)                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-44})));
equation
  connect(TF1.n, B4.p) annotation (Line(points={{-47,44},{-30,44}}, color={0,0,255}));
  connect(B2.p, TF2.p) annotation (Line(points={{-102,0},{-69,0}},color={0,0,255}));
  connect(TF2.n, B4.p) annotation (Line(points={{-47,0},{-38,0},{-38,44},{-30,44}}, color={0,0,255}));
  connect(B3.p, TF3.p) annotation (Line(points={{-102,-44},{-71,-44}},color={0,0,255}));
  connect(TF3.n, B5.p) annotation (Line(points={{-49,-44},{-28,-44}}, color={0,0,255}));
  connect(B5.p, line2.p) annotation (Line(points={{-28,-44},{-9,-44}}, color={0,0,255}));
  connect(Load1.p, B4.p) annotation (Line(points={{4,47},{4,66},{-40,66},{-40,44},{-30,44}}, color={0,0,255}));
  connect(line2.n, B6.p) annotation (Line(points={{9,-44},{30,-44}}, color={0,0,255}));
  connect(Load2.p, B5.p) annotation (Line(points={{-40,-69},{-40,-44},{-28,-44}}, color={0,0,255}));
  connect(B4.p, line1.p) annotation (Line(points={{-30,44},{-14,44},{-14,15}}, color={0,0,255}));
  connect(line1.n, line2.p) annotation (Line(points={{-14,-3},{-14,-44},{-9,-44}}, color={0,0,255}));
  connect(infiniteBus.pwPin, B6.p) annotation (Line(points={{49,-44},{30,-44}}, color={0,0,255}));
  connect(Load3.p, B6.p) annotation (Line(points={{40,-69},{40,-44},{30,-44}}, color={0,0,255}));
  connect(B1.p, TF1.p) annotation (Line(points={{-102,44},{-69,44}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{80,100}}),
                                                                graphics={
          Rectangle(extent={{-120,100},{80,-100}},  lineColor={0,0,0},
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{80,100}})));
end Base2;
