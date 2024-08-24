within ThreeMIB.GenerationUnits.MachineEXPSS;
model Generator2EXPSS "Machine with Excitation System and Power System Stabilizer for Generator2"
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
    R_a=0.001900) annotation (Placement(transformation(extent={{-92,-28},{-24,28}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX sCRX(
    T_AT_B=1,
    T_B=1,
    K=100,
    T_E=0.05,
    E_MIN=-5,
    E_MAX=5,
    C_SWITCH=true,
    r_cr_fd=0) annotation (Placement(transformation(extent={{-38,-72},{-68,-42}})));
  Modelica.Blocks.Sources.Constant vuel(k=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={12,-80})));
  Modelica.Blocks.Sources.Constant voel(k=0)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-104,-78})));
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
    T6=0.802)                                annotation (Placement(transformation(extent={{16,50},{70,86}})));
equation
  connect(gENSAE.PMECH, gENSAE.PMECH0) annotation (Line(points={{-98.8,16.8},{-120,16.8},{-120,40},{-6,40},{-6,14},{-20.6,14}},
                                                                                                                             color={0,0,127}));
  connect(gENSAE.p, pwPin) annotation (Line(points={{-24,0},{110,0}},              color={0,0,255}));
  connect(gENSAE.EFD, sCRX.EFD) annotation (Line(points={{-98.8,-16.8},{-114,-16.8},{-114,-57},{-69.5,-57}},
                                                                                                           color={0,0,127}));
  connect(sCRX.XADIFD, gENSAE.XADIFD) annotation (Line(points={{-65,-73.5},{-65,-88},{-10,-88},{-10,-25.2},{-20.6,-25.2}},
                                                                                                                      color={0,0,127}));
  connect(gENSAE.ETERM, sCRX.ECOMP) annotation (Line(points={{-20.6,-8.4},{4,-8.4},{4,-57},{-36.5,-57}}, color={0,0,127}));
  connect(gENSAE.EFD0, sCRX.EFD0) annotation (Line(points={{-20.6,-14},{0,-14},{0,-63},{-36.5,-63}}, color={0,0,127}));
  connect(voel.y, sCRX.VOEL) annotation (Line(points={{-93,-78},{-53,-78},{-53,-73.5}},
                                                                                    color={0,0,127}));
  connect(sCRX.VUEL, vuel.y) annotation (Line(points={{-47,-73.5},{-47,-80},{1,-80}},
                                                                                   color={0,0,127}));
  connect(gENSAE.SPEED, pSSTypeIIExtraLeadLag.vSI) annotation (Line(points={{-20.6,19.6},{-12,19.6},{-12,68},{10.6,68}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, sCRX.VOTHSG) annotation (Line(points={{72.7,68},{78,68},{78,-51},{-36.5,-51}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-160,-120},{100,100}})), Icon(coordinateSystem(extent={{-160,-120},{100,100}}), graphics={Text(
          extent={{-54,32},{54,-34}},
          textColor={28,108,200},
          textString="G2")}));
end Generator2EXPSS;
