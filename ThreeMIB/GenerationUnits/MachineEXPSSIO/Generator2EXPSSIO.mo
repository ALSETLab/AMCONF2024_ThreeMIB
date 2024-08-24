within ThreeMIB.GenerationUnits.MachineEXPSSIO;
model Generator2EXPSSIO "Machine with Excitation System and Power System Stabilizer and IO for Generator2"
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
    vsmax=5,
    vsmin=-5,
    Kw=35,
    Tw=3,
    T1=0.134,
    T2=0.013,
    T3=0.134,
    T4=0.013,
    T5=0.197,
    T6=0.802)                                annotation (Placement(transformation(extent={{-162,60},{-108,96}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{100,-108},{120,-88}}), iconTransformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Interfaces.RealInput uPSS annotation (Placement(
        transformation(extent={{-260,54},{-220,94}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput upm
    annotation (Placement(transformation(extent={{-266,-112},{-226,-72}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput uVsCRX annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={48,-138}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{100,62},{120,82}}), iconTransformation(extent={{100,58},{120,78}})));
  Modelica.Blocks.Math.Feedback feedbackPSS annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-204,18})));
  Modelica.Blocks.Math.Feedback pm_fdbck annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-36})));
  Modelica.Blocks.Math.Gain pmInputGain(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-172,-82})));
  Modelica.Blocks.Math.Gain gain_uVsCRX(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,-88})));
  Modelica.Blocks.Math.Gain gain_uPSS(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,52})));
  Modelica.Blocks.Math.Feedback feedbackSCRX
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,72})));

equation
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
  connect(uPSS, feedbackPSS.u1) annotation (Line(points={{-240,74},{-252,74},{-252,18},{-212,18}}, color={0,0,127}));
  connect(feedbackPSS.u2, gain_uPSS.y) annotation (Line(points={{-204,10},{-204,2},{-122,2},{-122,48},{28,48},{28,52},{33,52}}, color={0,0,127}));
  connect(feedbackSCRX.y, sCRX.VOTHSG) annotation (Line(points={{-9,72},{82,72},{82,-51},{-36.5,-51}}, color={0,0,127}));
  connect(SCRXin, feedbackSCRX.y) annotation (Line(points={{110,72},{-9,72}}, color={0,0,127}));
  connect(feedbackSCRX.u2, gain_uVsCRX.y) annotation (Line(points={{-18,64},{-18,52},{18,52},{18,-36},{48,-36},{48,-77}}, color={0,0,127}));
  connect(gain_uVsCRX.u, uVsCRX) annotation (Line(points={{48,-100},{48,-138}}, color={0,0,127}));
  connect(upm, pm_fdbck.u1) annotation (Line(points={{-246,-92},{-218,-92},{-218,-36},{-202,-36}}, color={0,0,127}));
  connect(pm_fdbck.y, gENSAE.PMECH) annotation (Line(points={{-185,-36},{-160,-36},{-160,-34},{-140,-34},{-140,16.8},{-98.8,16.8}}, color={0,0,127}));
  connect(pmInputGain.y, pm_fdbck.u2) annotation (Line(points={{-183,-82},{-194,-82},{-194,-44}}, color={0,0,127}));
  connect(gENSAE.PMECH0, pmInputGain.u) annotation (Line(points={{-20.6,14},{-6,14},{-6,36},{-132,36},{-132,-82},{-160,-82}}, color={0,0,127}));
  connect(SCRXout, sCRX.EFD) annotation (Line(points={{110,-98},{90,-98},{90,-114},{-84,-114},{-84,-57},{-69.5,-57}}, color={0,0,127}));
  connect(feedbackPSS.y, pSSTypeIIExtraLeadLag.vSI) annotation (Line(points={{-195,18},{-184,18},{-184,20},{-182,20},{-182,78},{-167.4,78}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, feedbackSCRX.u1) annotation (Line(points={{-105.3,78},{-36,78},{-36,72},{-26,72}}, color={0,0,127}));
  connect(gENSAE.SPEED, gain_uPSS.u) annotation (Line(points={{-20.6,19.6},{70,19.6},{70,52},{56,52}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-68,38},{62,-36}},
          textColor={28,108,200},
          textString="G2")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-160},{100,100}})));
end Generator2EXPSSIO;
