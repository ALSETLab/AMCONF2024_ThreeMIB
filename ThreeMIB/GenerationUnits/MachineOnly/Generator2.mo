within ThreeMIB.GenerationUnits.MachineOnly;
model Generator2 "Machine-only Generator2"
  extends .OpenIPSL.Interfaces.Generator;
  OpenIPSL.Electrical.Machines.PSSE.GENSAE gENSAE(
    V_b=18000,
    P_0=P_0,
    Q_0=Q_0,
    v_0=v_0,
    angle_0=angle_0,
    M_b=1560000000,
    Tpd0=5.1000,
    Tppd0=0.0600,
    Tppq0=0.0940,
    H=4.5000,
    D=0.0000,
    Xd=0.8900,
    Xq=0.6600,
    Xpd=0.3600,
    Xppd=0.2900,
    Xppq=0.2900,
    Xl=0.2800,
    S10=0.0870,
    S12=0.2570,
    R_a=0.001900) annotation (Placement(transformation(extent={{-36,-24},{32,28}})));
equation
  connect(gENSAE.PMECH, gENSAE.PMECH0) annotation (Line(points={{-42.8,17.6},{-64,17.6},{-64,40},{50,40},{50,15},{35.4,15}}, color={0,0,127}));
  connect(gENSAE.EFD, gENSAE.EFD0) annotation (Line(points={{-42.8,-13.6},{-64,-13.6},{-64,-40},{54,-40},{54,-11},{35.4,-11}}, color={0,0,127}));
  connect(gENSAE.p, pwPin) annotation (Line(points={{32,2},{96,2},{96,0},{110,0}}, color={0,0,255}));
end Generator2;
