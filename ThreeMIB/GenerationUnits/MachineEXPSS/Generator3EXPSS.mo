within ThreeMIB.GenerationUnits.MachineEXPSS;
model Generator3EXPSS "Machine with Excitation System and Power System Stabilizer for Generator3"
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
    Tpq0=0.6250) annotation (Placement(transformation(extent={{-96,-26},{-30,26}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX sCRX(
    T_AT_B=1,
    T_B=1,
    K=150,
    T_E=0.05,
    E_MIN=-5,
    E_MAX=5,
    C_SWITCH=true,
    r_cr_fd=0) annotation (Placement(transformation(extent={{-48,-70},{-78,-40}})));
  Modelica.Blocks.Sources.Constant vuel(k=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-82})));
  Modelica.Blocks.Sources.Constant voel(k=0)                      annotation (Placement(transformation(extent={{-114,-92},{-94,-72}})));
  CustomComponents.PSSTypeIIExtraLeadLag
                                     pSSTypeIIExtraLeadLag(
    vsmax=0.2,
    vsmin=-0.2,
    Kw=35,
    Tw=3,
    T1=0.134,
    T2=0.013,
    T3=0.134,
    T4=0.013,
    T5=0.197,
    T6=0.802)                                annotation (Placement(transformation(extent={{24,48},{78,84}})));
equation
  connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-102.6,15.6},{-132,15.6},{-132,52},{-8,52},{-8,13},{-26.7,13}},
                                                                                                                             color={0,0,127}));
  connect(gENROE.p, pwPin) annotation (Line(points={{-30,0},{110,0}},color={0,0,255}));
  connect(sCRX.EFD, gENROE.EFD) annotation (Line(points={{-79.5,-55},{-128,-55},{-128,-15.6},{-102.6,-15.6}},
                                                                                                           color={0,0,127}));
  connect(gENROE.ETERM, sCRX.ECOMP) annotation (Line(points={{-26.7,-7.8},{-10,-7.8},{-10,-55},{-46.5,-55}},
                                                                                                         color={0,0,127}));
  connect(gENROE.EFD0, sCRX.EFD0) annotation (Line(points={{-26.7,-13},{0,-13},{0,-61},{-46.5,-61}}, color={0,0,127}));
  connect(gENROE.XADIFD, sCRX.XADIFD) annotation (Line(points={{-26.7,-23.4},{-14,-23.4},{-14,-78},{-75,-78},{-75,-71.5}},
                                                                                                                        color={0,0,127}));
  connect(sCRX.VUEL, vuel.y) annotation (Line(points={{-57,-71.5},{-57,-82},{-1,-82}},
                                                                                   color={0,0,127}));
  connect(sCRX.VOEL, voel.y) annotation (Line(points={{-63,-71.5},{-63,-82},{-93,-82}},
                                                                                      color={0,0,127}));
  connect(gENROE.SPEED, pSSTypeIIExtraLeadLag.vSI) annotation (Line(points={{-26.7,18.2},{2,18.2},{2,66},{18.6,66}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, sCRX.VOTHSG) annotation (Line(points={{80.7,66},{92,66},{92,-49},{-46.5,-49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-160,-120},{100,100}})), Icon(coordinateSystem(extent={{-160,-120},{100,100}}), graphics={Text(
          extent={{-62,30},{66,-34}},
          textColor={28,108,200},
          textString="G3")}));
end Generator3EXPSS;
