within ThreeMIB.CustomComponents;
model PSSTypeIIExtraLeadLag "PSAT PSS TypeII - Adding a imLeadLag Block"
  parameter OpenIPSL.Types.PerUnit vsmax "Max stabilizer output signal";
  parameter OpenIPSL.Types.PerUnit vsmin "Min stabilizer output signal";
  parameter Real Kw "Stabilizer gain [pu/pu]";
  parameter OpenIPSL.Types.Time Tw "Wash-out time constant";
  parameter OpenIPSL.Types.Time T1 "First stabilizer time constant";
  parameter OpenIPSL.Types.Time T2 "Second stabilizer time constant";
  parameter OpenIPSL.Types.Time T3 "Third stabilizer time constant";
  parameter OpenIPSL.Types.Time T4 "Fourth stabilizer time constant";
  Modelica.Blocks.Interfaces.RealInput vSI "PSS input signal "
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput vs "PSS output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag imLeadLag1(
    K=1,
    T1=T1,
    T2=T2,
    y_start=0) annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag imLeadLag2(
    K=1,
    T1=T3,
    T2=T4,
    y_start=0) annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=vsmax, uMin=vsmin)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  OpenIPSL.NonElectrical.Continuous.DerivativeLag derivativeLag(
    K=Kw*Tw,
    T=Tw,
    y_start=0,
    x_start=0) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  OpenIPSL.NonElectrical.Continuous.LeadLag imleadLag3(
    K=1,
    T1=T5,
    T2=T6,
    y_start=0) annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  parameter OpenIPSL.Types.Time T5=0.1 "Fifth Lead time constant";
  parameter OpenIPSL.Types.Time T6=0.1 "Sixth Lag time constant";
equation
  connect(vs, limiter.y)
    annotation (Line(points={{110,0},{96,0},{81,0}}, color={0,0,127}));
  connect(imLeadLag1.y, imLeadLag2.u) annotation (Line(points={{-7,0},{2,0}}, color={0,0,127}));
  connect(vSI, derivativeLag.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(derivativeLag.y, imLeadLag1.u) annotation (Line(points={{-39,0},{-30,0}}, color={0,0,127}));
  connect(imLeadLag2.y, imleadLag3.u)
    annotation (Line(points={{25,0},{30,0}}, color={0,0,127}));
  connect(limiter.u, imleadLag3.y)
    annotation (Line(points={{58,0},{53,0}}, color={0,0,127}));
  annotation ( Documentation(revisions="<html>
<table cellspacing=\"1\" cellpadding=\"1\" border=\"1\">
<tr>
<td><p>Reference</p></td>
<td>PSAT manual</td>
</tr>
<tr>
<td><p>Last update</p></td>
<td>2015-08-24</td>
</tr>
<tr>
<td><p>Author</p></td>
<td><p><a href=\"https://github.com/tinrabuzin\">@tinrabuzin</a></p></td>
</tr>
<tr>
<td><p>Contact</p></td>
<td><p>see <a href=\"modelica://OpenIPSL.UsersGuide.Contact\">UsersGuide.Contact</a></p></td>
</tr>
</table>
</html>", info="<html>
<p>
For more information see <a href=\"modelica://OpenIPSL.UsersGuide.References\">[Milano2013]</a>, section \"18.4.2
Type II\".
</p>
</html>"), Icon(graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-140,-100},{140,-160}},
          lineColor={0,0,255},
          textString="%name")}));
end PSSTypeIIExtraLeadLag;
