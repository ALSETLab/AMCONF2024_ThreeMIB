within ThreeMIB.GenerationUnits.Figures;
model GenIO "GenIO for documentation/paper figure"
  extends OpenIPSL.Interfaces.Generator;
  OpenIPSL.Electrical.Machines.PSSE.GENSAE machine(
    V_b=V_b,
    D=0,
    P_0=P_0,
    Q_0=Q_0,
    angle_0=angle_0) annotation (Placement(transformation(extent={{8,-26},{74,26}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX avr annotation (Placement(transformation(extent={{-78,-20},{-32,26}})));
  CustomComponents.PSSTypeIIExtraLeadLag          pss
          annotation (Placement(transformation(extent={{-188,-16},{-144,28}})));
  Modelica.Blocks.Interfaces.RealInput uPSS annotation (Placement(
        transformation(extent={{-300,-14},{-260,26}}),iconTransformation(
          extent={{-302,54},{-262,94}})));
  Modelica.Blocks.Math.Feedback intoPSS annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-224,6})));
  Modelica.Blocks.Math.Gain gain_uPSS(k=-1) annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-3,59})));
  Modelica.Blocks.Math.Gain gain_pmInputGain(k=-1) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-96,-62})));
  Modelica.Blocks.Math.Feedback pm_fdbck annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-162,-40})));
  Modelica.Blocks.Interfaces.RealInput upm
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
        iconTransformation(extent={{-300,-42},{-260,-2}})));
  Modelica.Blocks.Math.Feedback feedbackSCRX annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-112,6})));
  Modelica.Blocks.Math.Gain gain_uVsCRX(k=-1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-194,-96})));
  Modelica.Blocks.Interfaces.RealInput uVsCRX annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-280,-96}), iconTransformation(extent={{-20,-20},{20,20}}, origin={-280,-108})));
  parameter Real Kw=9.5 "Stabilizer gain (pu/pu)" annotation (Dialog(group="PSS"));
  parameter Real Tw=1.41 "Wash-out time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T1=0 "First stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T2=0 "Second stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T3=0 "Third stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T4=0 "Fourth stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real vfmax=7.0 "max lim." annotation (Dialog(group="AVR"));
  parameter Real vfmin=-6.40 "min lim." annotation (Dialog(group="AVR"));
  parameter Real K0=200 "regulator gain" annotation (Dialog(group="AVR"));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{100,-126},{122,-104}}), iconTransformation(extent={{100,-92},{122,-70}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{100,-98},{122,-76}}), iconTransformation(extent={{100,-66},{122,-44}})));
  Modelica.Blocks.Sources.RealExpression fdbkSCRX(y=feedbackSCRX.y) annotation (Placement(transformation(extent={{30,-98},{82,-76}})));
  Modelica.Blocks.Sources.RealExpression EFDSCRX(y=SCRX.y)
                                                          annotation (Placement(transformation(extent={{44,-124},{70,-106}})));
  Modelica.Blocks.Sources.Constant voel(k=0)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-26,-94})));
  Modelica.Blocks.Sources.Constant vuel(k=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-94})));
equation
  connect(gain_pmInputGain.y, pm_fdbck.u2) annotation (Line(
      points={{-102.6,-62},{-162,-62},{-162,-48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(upm, pm_fdbck.u1) annotation (Line(points={{-280,-40},{-170,-40}},
                               color={0,0,127}));
  connect(gain_uPSS.y, intoPSS.u2)
    annotation (Line(points={{-8.5,59},{-224,59},{-224,14}}, color={0,0,127}));
  connect(uPSS, intoPSS.u1)
    annotation (Line(points={{-280,6},{-232,6}}, color={0,0,127}));
  connect(uVsCRX, gain_uVsCRX.u) annotation (Line(points={{-280,-96},{-201.2,-96}}, color={0,0,127}));
  connect(EFDSCRX.y, SCRXout) annotation (Line(points={{71.3,-115},{111,-115}}, color={0,0,127}));
  connect(machine.p, pwPin)
    annotation (Line(points={{74,0},{110,0}}, color={0,0,255}));
  connect(feedbackSCRX.y, avr.VOTHSG) annotation (Line(points={{-97.6,6},{-94,6},{-94,12},{-80.3,12},{-80.3,12.2}}, color={0,0,127}));
  connect(gain_uVsCRX.y, feedbackSCRX.u2) annotation (Line(points={{-187.4,-96},{-184,-96},{-184,-22},{-112,-22},{-112,-6.8}}, color={0,0,127}));
  connect(pm_fdbck.y, machine.PMECH) annotation (Line(points={{-153,-40},{-14,-40},{-14,15.6},{1.4,15.6}}, color={0,0,127}));
  connect(machine.ETERM, avr.ECOMP) annotation (Line(points={{77.3,-7.8},{90,-7.8},{90,-48},{-94,-48},{-94,3},{-80.3,3}}, color={0,0,127}));
  connect(avr.EFD0, machine.EFD0) annotation (Line(points={{-80.3,-6.2},{-86,-6.2},{-86,-44},{86,-44},{86,-13},{77.3,-13}}, color={0,0,127}));
  connect(avr.VUEL, vuel.y) annotation (Line(points={{-64.2,-22.3},{-64,-24},{-64,-83}}, color={0,0,127}));
  connect(avr.VOEL, voel.y) annotation (Line(points={{-55,-22.3},{-56,-22.3},{-56,-78},{-26,-78},{-26,-83}}, color={0,0,127}));
  connect(machine.XADIFD, avr.XADIFD) annotation (Line(points={{77.3,-23.4},{82,-23.4},{82,-36},{-36.6,-36},{-36.6,-22.3}}, color={0,0,127}));
  connect(avr.EFD, machine.EFD) annotation (Line(points={{-29.7,3},{-20,3},{-20,-15.6},{1.4,-15.6}}, color={0,0,127}));
  connect(machine.PMECH0, gain_pmInputGain.u) annotation (Line(points={{77.3,13},{92,13},{92,-62},{-88.8,-62}}, color={0,0,127}));
  connect(machine.PELEC, gain_uPSS.u) annotation (Line(points={{77.3,7.8},{86,7.8},{86,59},{3,59}}, color={0,0,127}));
  connect(fdbkSCRX.y, SCRXin) annotation (Line(points={{84.6,-87},{111,-87}}, color={0,0,127}));
  connect(intoPSS.y, pss.vSI) annotation (Line(points={{-215,6},{-192.4,6}}, color={0,0,127}));
  connect(pss.vs, feedbackSCRX.u1) annotation (Line(points={{-141.8,6},{-124.8,6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-140},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-140},{100,100}})),
    Documentation(info="<html>
<p>Do not use for simulation purposes, created only to generate a figure for documentation/papers.</p>
</html>"));
end GenIO;
