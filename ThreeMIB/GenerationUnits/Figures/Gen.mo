within ThreeMIB.GenerationUnits.Figures;
model Gen "Gen for documentation/paper figure"
  extends OpenIPSL.Interfaces.Generator;
  OpenIPSL.Electrical.Machines.PSSE.GENSAE machine(
    V_b=V_b,
    D=0,
    P_0=P_0,
    Q_0=Q_0,
    angle_0=angle_0) annotation (Placement(transformation(extent={{8,-26},{74,26}})));
  OpenIPSL.Electrical.Controls.PSSE.ES.SCRX avr annotation (Placement(transformation(extent={{-78,-20},{-32,26}})));
  CustomComponents.PSSTypeIIExtraLeadLag          pss
          annotation (Placement(transformation(extent={{-170,-10},{-126,34}})));
  parameter Real Kw=9.5 "Stabilizer gain (pu/pu)" annotation (Dialog(group="PSS"));
  parameter Real Tw=1.41 "Wash-out time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T1=0 "First stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T2=0 "Second stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T3=0 "Third stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real T4=0 "Fourth stabilizer time constant (s)" annotation (Dialog(group="PSS"));
  parameter Real vfmax=7.0 "max lim." annotation (Dialog(group="AVR"));
  parameter Real vfmin=-6.40 "min lim." annotation (Dialog(group="AVR"));
  parameter Real K0=200 "regulator gain" annotation (Dialog(group="AVR"));
  Modelica.Blocks.Sources.Constant voel(k=0)                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-26,-94})));
  Modelica.Blocks.Sources.Constant vuel(k=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-94})));
equation
  connect(machine.p, pwPin)
    annotation (Line(points={{74,0},{110,0}}, color={0,0,255}));
  connect(machine.ETERM, avr.ECOMP) annotation (Line(points={{77.3,-7.8},{90,-7.8},{90,-48},{-94,-48},{-94,3},{-80.3,3}}, color={0,0,127}));
  connect(avr.EFD0, machine.EFD0) annotation (Line(points={{-80.3,-6.2},{-86,-6.2},{-86,-44},{86,-44},{86,-13},{77.3,-13}}, color={0,0,127}));
  connect(avr.VUEL, vuel.y) annotation (Line(points={{-64.2,-22.3},{-64,-24},{-64,-83}}, color={0,0,127}));
  connect(avr.VOEL, voel.y) annotation (Line(points={{-55,-22.3},{-56,-22.3},{-56,-78},{-26,-78},{-26,-83}}, color={0,0,127}));
  connect(machine.XADIFD, avr.XADIFD) annotation (Line(points={{77.3,-23.4},{82,-23.4},{82,-36},{-36.6,-36},{-36.6,-22.3}}, color={0,0,127}));
  connect(avr.EFD, machine.EFD) annotation (Line(points={{-29.7,3},{-20,3},{-20,-15.6},{1.4,-15.6}}, color={0,0,127}));
  connect(pss.vs, avr.VOTHSG) annotation (Line(points={{-123.8,12},{-122,12.2},{-80.3,12.2}}, color={0,0,127}));
  connect(machine.SPEED, pss.vSI) annotation (Line(points={{77.3,18.2},{96,18.2},{96,54},{-182,54},{-182,12},{-174.4,12}}, color={0,0,127}));
  connect(machine.PMECH, machine.PMECH0) annotation (Line(points={{1.4,15.6},{-12,15.6},{-12,34},{92,34},{92,13},{77.3,13}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{100,100}})),
    Documentation(info="<html>
<p>Do not use for simulation purposes, created only to generate a figure for documentation/papers.</p>
</html>"));
end Gen;
