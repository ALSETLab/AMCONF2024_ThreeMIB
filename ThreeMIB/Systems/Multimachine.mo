within ThreeMIB.Systems;
model Multimachine "3MIB Plant model"
  extends Networks.Base2(
    infiniteBus(
      P_0=pf.powerflow.machines.PG4,
      Q_0=pf.powerflow.machines.QG4,
      v_0=pf.powerflow.bus.v6,
      angle_0=pf.powerflow.bus.A6,
      displayPF=false),
    Load1(
      P_0=pf.powerflow.loads.PL1,
      Q_0=pf.powerflow.loads.QL1,
      v_0=pf.powerflow.bus.v4,
      angle_0=pf.powerflow.bus.A4),
    Load2(
      P_0=pf.powerflow.loads.PL2,
      Q_0=pf.powerflow.loads.QL2,
      v_0=pf.powerflow.bus.v5,
      angle_0=pf.powerflow.bus.A5),
    Load3(
      P_0=pf.powerflow.loads.PL3,
      Q_0=pf.powerflow.loads.QL3,
      v_0=pf.powerflow.bus.v6,
      angle_0=pf.powerflow.bus.A6),
    B1(
      v_0=pf.powerflow.bus.v1,
      angle_0=pf.powerflow.bus.A1,
      displayPF=false),
    B2(
      v_0=pf.powerflow.bus.v2,
      angle_0=pf.powerflow.bus.A2,
      displayPF=false),
    B3(
      v_0=pf.powerflow.bus.v3,
      angle_0=pf.powerflow.bus.A3,
      displayPF=false),
    B4(
      v_0=pf.powerflow.bus.v4,
      angle_0=pf.powerflow.bus.A4,
      displayPF=false),
    B5(
      v_0=pf.powerflow.bus.v5,
      angle_0=pf.powerflow.bus.A5,
      displayPF=false),
    B6(
      v_0=pf.powerflow.bus.v6,
      angle_0=pf.powerflow.bus.A6,
      displayPF=false));
  GenerationUnits.MachineEXPSS.Generator1EXPSS generator1EXPSS(
    P_0=pf.powerflow.machines.PG1,
    Q_0=pf.powerflow.machines.QG1,
    v_0=pf.powerflow.bus.v1,
    angle_0=pf.powerflow.bus.A1,
    displayPF=false) annotation (Placement(transformation(extent={{-162,32},{-136,54}})));
  PF_Data.Power_Flow pf(redeclare record PowerFlow = ThreeMIB.PF_Data.PF_00000)          annotation (Placement(transformation(extent={{34,22},{54,42}})));
  OpenIPSL.Electrical.Events.PwFault pwFault(
    R=0.01,
    X=0.1,
    t1=2,
    t2=2.15) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={13,-77})));
equation
  connect(generator1EXPSS.pwPin, B1.p) annotation (Line(points={{-135,44},{-102,44}}, color={0,0,255}));
  connect(generator2EXPSS.pwPin, B2.p) annotation (Line(points={{-135,0},{-102,0}}, color={0,0,255}));
  connect(generator3EXPSS.pwPin, B3.p) annotation (Line(points={{-133,-44},{-102,-44}}, color={0,0,255}));
  connect(pwFault.p, B6.p) annotation (Line(points={{13,-68.8333},{13,-44},{30,-44}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(extent={{-180,-100},{80,100}}), graphics={Rectangle(
          extent={{-180,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid), Text(
          extent={{-200,58},{120,-80}},
          textColor={255,255,255},
          textString="3MIB")}), Diagram(coordinateSystem(extent={{-180,-100},{80,100}})));
end Multimachine;
