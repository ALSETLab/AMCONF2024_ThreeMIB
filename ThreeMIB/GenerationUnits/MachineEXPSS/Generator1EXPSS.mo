within ThreeMIB.GenerationUnits.MachineEXPSS;
model Generator1EXPSS "Machine with Excitation System and Power System Stabilizer for Generator1"
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
    R_a=0.001900) annotation (Placement(transformation(extent={{-80,-30},{-10,30}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX sCRX(
    T_AT_B=1,
    T_B=1,
    K=100,
    T_E=0.05,
    E_MIN=-5,
    E_MAX=5,
    C_SWITCH=true,
    r_cr_fd=0) annotation (Placement(transformation(extent={{-22,-70},{-52,-40}})));
  Modelica.Blocks.Sources.Constant vuel(k=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={16,-82})));
  Modelica.Blocks.Sources.Constant voel(k=0)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,-82})));
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
    T6=0.802)                                annotation (Placement(transformation(extent={{26,50},{80,86}})));
equation
  connect(gENSAE.PMECH, gENSAE.PMECH0) annotation (Line(points={{-87,18},{-106,18},{-106,42},{16,42},{16,15},{-6.5,15}},   color={0,0,127}));
  connect(gENSAE.p, pwPin) annotation (Line(points={{-10,0},{110,0}},              color={0,0,255}));
  connect(sCRX.ECOMP, gENSAE.ETERM) annotation (Line(points={{-20.5,-55},{-20.5,-56},{10,-56},{10,-9},{-6.5,-9}},   color={0,0,127}));
  connect(gENSAE.EFD, sCRX.EFD) annotation (Line(points={{-87,-18},{-104,-18},{-104,-55},{-53.5,-55}},
                                                                                                     color={0,0,127}));
  connect(gENSAE.EFD0, sCRX.EFD0) annotation (Line(points={{-6.5,-15},{22,-15},{22,-61},{-20.5,-61}},  color={0,0,127}));
  connect(sCRX.VUEL, vuel.y) annotation (Line(points={{-31,-71.5},{-31,-82},{5,-82}},
                                                                                   color={0,0,127}));
  connect(sCRX.VOEL, voel.y) annotation (Line(points={{-37,-71.5},{-37,-82},{-61,-82}},
                                                                                    color={0,0,127}));
  connect(gENSAE.XADIFD, sCRX.XADIFD) annotation (Line(points={{-6.5,-27},{0,-27},{0,-88},{-49,-88},{-49,-71.5}}, color={0,0,127}));
  connect(gENSAE.SPEED, pSSTypeIIExtraLeadLag.vSI) annotation (Line(points={{-6.5,21},{2,21},{2,68},{20.6,68}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, sCRX.VOTHSG) annotation (Line(points={{82.7,68},{90,68},{90,-49},{-20.5,-49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-160,-120},{100,100}})), Icon(coordinateSystem(extent={{-160,-120},{100,100}}), graphics={Text(
          extent={{-62,36},{68,-42}},
          textColor={28,108,200},
          textString="G1"), Polygon(points={{-18,-16},{-18,-16}}, lineColor={28,108,200})}));
end Generator1EXPSS;
