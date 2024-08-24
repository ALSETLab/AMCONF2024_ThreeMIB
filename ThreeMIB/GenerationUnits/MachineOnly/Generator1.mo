within ThreeMIB.GenerationUnits.MachineOnly;
model Generator1 "Machine-only Generator1"
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
    R_a=0.001900) annotation (Placement(transformation(extent={{-14,-30},{56,30}})));
equation
  connect(gENSAE.p, pwPin) annotation (Line(points={{56,0},{110,0}},               color={0,0,255}));
  connect(gENSAE.PMECH, gENSAE.PMECH0) annotation (Line(points={{-21,18},{-40,18},{-40,58},{74,58},{74,15},{59.5,15}}, color={0,0,127}));
  connect(gENSAE.EFD, gENSAE.EFD0) annotation (Line(points={{-21,-18},{-40,-18},{-40,-56},{74,-56},{74,-15},{59.5,-15}}, color={0,0,127}));
end Generator1;
