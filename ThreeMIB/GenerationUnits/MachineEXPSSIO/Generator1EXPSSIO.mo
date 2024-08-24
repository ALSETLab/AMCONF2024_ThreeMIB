within ThreeMIB.GenerationUnits.MachineEXPSSIO;
model Generator1EXPSSIO "Machine with Excitation System and Power System Stabilizer and IO for Generator1"
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
    vsmax=5,
    vsmin=-5,
    Kw=35,
    Tw=3,
    T1=0.134,
    T2=0.013,
    T3=0.134,
    T4=0.013,
    T5=0.197,
    T6=0.802)                                annotation (Placement(transformation(extent={{-122,60},{-68,96}})));
  Modelica.Blocks.Math.Feedback feedbackPSS annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-166,4})));
  Modelica.Blocks.Interfaces.RealInput uPSS annotation (Placement(
        transformation(extent={{-218,48},{-178,88}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput upm
    annotation (Placement(transformation(extent={{-228,-108},{-188,-68}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput uVsCRX annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={58,-134}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Math.Feedback feedbackSCRX
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={4,72})));
  Modelica.Blocks.Math.Gain gain_uPSS(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={38,48})));
  Modelica.Blocks.Math.Gain gain_uVsCRX(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-70})));
  Modelica.Blocks.Math.Feedback pm_fdbck annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-146,-46})));
  Modelica.Blocks.Math.Gain pmInputGain(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-126,-90})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{100,62},{120,82}}), iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{100,-102},{120,-82}}), iconTransformation(extent={{100,-80},{120,-60}})));

equation
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
  connect(uPSS, feedbackPSS.u1) annotation (Line(points={{-198,68},{-210,68},{-210,4},{-174,4}}, color={0,0,127}));
  connect(gain_uPSS.y, feedbackPSS.u2) annotation (Line(points={{27,48},{-140,48},{-140,-14},{-166,-14},{-166,-4}}, color={0,0,127}));
  connect(uVsCRX, gain_uVsCRX.u) annotation (Line(points={{58,-134},{58,-82}}, color={0,0,127}));
  connect(gain_uVsCRX.y, feedbackSCRX.u2) annotation (Line(points={{58,-59},{58,8},{62,8},{62,62},{18,62},{18,54},{4,54},{4,64}}, color={0,0,127}));
  connect(feedbackSCRX.y, sCRX.VOTHSG) annotation (Line(points={{13,72},{78,72},{78,-49},{-20.5,-49}}, color={0,0,127}));
  connect(upm, pm_fdbck.u1) annotation (Line(points={{-208,-88},{-180,-88},{-180,-46},{-154,-46}}, color={0,0,127}));
  connect(pmInputGain.y, pm_fdbck.u2) annotation (Line(points={{-137,-90},{-146,-90},{-146,-54}}, color={0,0,127}));
  connect(pmInputGain.u, gENSAE.PMECH0) annotation (Line(points={{-114,-90},{-106,-90},{-106,38},{8,38},{8,15},{-6.5,15}}, color={0,0,127}));
  connect(pm_fdbck.y, gENSAE.PMECH) annotation (Line(points={{-137,-46},{-116,-46},{-116,18},{-87,18}}, color={0,0,127}));
  connect(SCRXin, feedbackSCRX.y) annotation (Line(points={{110,72},{13,72}}, color={0,0,127}));
  connect(SCRXout, sCRX.EFD) annotation (Line(points={{110,-92},{84,-92},{84,-110},{-94,-110},{-94,-55},{-53.5,-55}}, color={0,0,127}));
  connect(gENSAE.SPEED, gain_uPSS.u) annotation (Line(points={{-6.5,21},{58,21},{58,48},{50,48}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vSI, feedbackPSS.y) annotation (Line(points={{
          -127.4,78},{-148,78},{-148,4},{-157,4}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, feedbackSCRX.u1) annotation (Line(points={{
          -65.3,78},{-32,78},{-32,72},{-4,72}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-52,40},{58,-48}},
          textColor={28,108,200},
          textString="G1")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{100,100}})));
end Generator1EXPSSIO;
