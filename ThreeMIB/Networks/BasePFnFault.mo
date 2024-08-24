within ThreeMIB.Networks;
model BasePFnFault
  extends Base(
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
    infiniteBus(
      P_0=pf.powerflow.machines.PG4,
      Q_0=pf.powerflow.machines.QG4,
      v_0=pf.powerflow.bus.v4,
      angle_0=pf.powerflow.bus.A4,
      displayPF=false));
  PF_Data.Power_Flow pf(redeclare record PowerFlow = ThreeMIB.PF_Data.PF_00000)          annotation (Placement(transformation(extent={{52,60},{72,80}})));
  OpenIPSL.Electrical.Events.PwFault pwFault(
    R=0.01,
    X=0.1,
    t1=2,
    t2=2.15) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={13,-75})));
equation
  connect(pwFault.p, B6.p) annotation (Line(points={{13,-66.8333},{13,-44},{30,-44}}, color={0,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,120}})), Icon(coordinateSystem(extent={{-120,-100},{100,120}})));
end BasePFnFault;
