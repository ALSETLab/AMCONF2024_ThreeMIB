within ThreeMIB.GenerationUnits.MachineOnly;
model Generator3 "Machine-only Generator3"
  extends .OpenIPSL.Interfaces.Generator;
  OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE(
    V_b=18000,
    P_0=P_0,
    Q_0=Q_0,
    v_0=v_0,
    angle_0=angle_0,
    M_b=890000000,
    Tpd0=5.3000,
    Tppd0=0.0480,
    Tppq0=0.0660,
    H=3.8590,
    D=0.0000,
    Xd=1.7200,
    Xq=1.6790,
    Xpd=0.4880,
    Xppd=0.3370,
    Xppq=0.3370,
    Xl=0.2660,
    S10=0.1300,
    S12=1.0670,
    R_a=0,
    Xpq=0.80000,
    Tpq0=0.6250) annotation (Placement(transformation(extent={{-10,-28},{54,30}})));
equation
  connect(gENROE.p, pwPin) annotation (Line(points={{54,1},{54,0},{110,0}}, color={0,0,255}));
  connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-16.4,18.4},{-32,18.4},{-32,44},{72,44},{72,15.5},{57.2,15.5}}, color={0,0,127}));
  connect(gENROE.EFD, gENROE.EFD0) annotation (Line(points={{-16.4,-16.4},{-30,-16.4},{-30,-42},{72,-42},{72,-13.5},{57.2,-13.5}}, color={0,0,127}));
end Generator3;
