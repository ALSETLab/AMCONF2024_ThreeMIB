within ThreeMIB.GenerationUnits.MachineEXPSSIO;
model Generator3EXPSSIO "Machine with Excitation System and Power System Stabilizer and IO for Generator3"
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
    vsmax=5,
    vsmin=-5,
    Kw=35,
    Tw=3,
    T1=0.134,
    T2=0.013,
    T3=0.134,
    T4=0.013,
    T5=0.197,
    T6=0.802)                                annotation (Placement(transformation(extent={{-146,72},{-92,108}})));
  Modelica.Blocks.Interfaces.RealInput uPSS annotation (Placement(
        transformation(extent={{-250,66},{-210,106}}),iconTransformation(
          extent={{-142,40},{-102,80}})));
  Modelica.Blocks.Interfaces.RealInput upm
    annotation (Placement(transformation(extent={{-250,-154},{-210,-114}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput uVsCRX annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,-170}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{100,76},{120,96}}), iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{100,-144},{120,-124}}), iconTransformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Math.Feedback feedbackPSS annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-202,-4})));
  Modelica.Blocks.Math.Feedback pm_fdbck annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-176,-102})));
  Modelica.Blocks.Math.Gain pmInputGain(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-146,-142})));
  Modelica.Blocks.Math.Feedback feedbackSCRX
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-4,86})));
  Modelica.Blocks.Math.Gain gain_uPSS(k=-1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={18,52})));
  Modelica.Blocks.Math.Gain gain_uVsCRX(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,-108})));

equation
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
  connect(upm, pm_fdbck.u1) annotation (Line(points={{-230,-134},{-194,-134},{-194,-102},{-184,-102}}, color={0,0,127}));
  connect(pm_fdbck.y, gENROE.PMECH) annotation (Line(points={{-167,-102},{-138,-102},{-138,15.6},{-102.6,15.6}}, color={0,0,127}));
  connect(pm_fdbck.u2, pmInputGain.y) annotation (Line(points={{-176,-110},{-176,-142},{-157,-142}}, color={0,0,127}));
  connect(gENROE.PMECH0, pmInputGain.u) annotation (Line(points={{-26.7,13},{-8,13},{-8,38},{-132,38},{-132,-130},{-116,-130},{-116,-142},{-134,-142}}, color={0,0,127}));
  connect(uPSS, feedbackPSS.u1) annotation (Line(points={{-230,86},{-242,86},{-242,-4},{-210,-4}}, color={0,0,127}));
  connect(feedbackPSS.u2, gain_uPSS.y) annotation (Line(points={{-202,-12},{-202,-24},{-146,-24},{-146,52},{7,52}}, color={0,0,127}));
  connect(feedbackSCRX.y, sCRX.VOTHSG) annotation (Line(points={{5,86},{46,86},{46,-49},{-46.5,-49}}, color={0,0,127}));
  connect(SCRXin, feedbackSCRX.y) annotation (Line(points={{110,86},{5,86}}, color={0,0,127}));
  connect(uVsCRX, gain_uVsCRX.u) annotation (Line(points={{50,-170},{50,-128},{48,-128},{48,-120}}, color={0,0,127}));
  connect(SCRXout, sCRX.EFD) annotation (Line(points={{110,-134},{-90,-134},{-90,-55},{-79.5,-55}}, color={0,0,127}));
  connect(feedbackSCRX.u2, gain_uVsCRX.y) annotation (Line(points={{-4,78},{-4,68},{48,68},{48,-97}}, color={0,0,127}));
  connect(feedbackPSS.y, pSSTypeIIExtraLeadLag.vSI) annotation (Line(points={{-193,-4},{-174,-4},{-174,90},{-151.4,90}}, color={0,0,127}));
  connect(pSSTypeIIExtraLeadLag.vs, feedbackSCRX.u1) annotation (Line(points={{-89.3,90},{-22,90},{-22,86},{-12,86}}, color={0,0,127}));
  connect(gENROE.SPEED, gain_uPSS.u) annotation (Line(points={{-26.7,18.2},{36,18.2},{36,52},{30,52}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-74,34},{68,-36}},
          textColor={28,108,200},
          textString="G3")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-200},{100,120}})));
end Generator3EXPSSIO;
