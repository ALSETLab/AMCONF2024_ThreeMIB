within ThreeMIB.Systems;
model GridIOsiso "Single input single output variant of GridIO"
  ThreeMIB.Systems.GridIO GridIO(
    t1=t1,
    t2=t2,
    opening=opening) annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Sources.RealExpression zeros
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  parameter Modelica.Units.SI.Time t1=0.5 "Time of line removal"
    annotation (Dialog(group="Line Removal Parameters"));
  parameter Modelica.Units.SI.Time t2=0.57 "Line re-insertion time"
    annotation (Dialog(group="Line Removal Parameters"));
  parameter Integer opening=1
    "Type of opening (1: removes both ends at same time, 2: removes sending end, 3: removes receiving end)"
    annotation (Dialog(group="Line Removal Parameters"));
  Modelica.Blocks.Interfaces.RealOutput Vt
    annotation (Placement(transformation(extent={{38,-10},{58,10}}),   iconTransformation(extent={{60,-14},{90,16}})));
  Modelica.Blocks.Interfaces.RealInput uvs
    annotation (Placement(transformation(extent={{-102,-18},{-66,18}}),  iconTransformation(extent={{-180,-20},{-140,20}})));
  // allow replaceable records for power flow data
  replaceable record Bus =
        OpenIPSL.Examples.Tutorial.Example_5.PFData.BusData.PFBus00000 constrainedby OpenIPSL.Examples.Tutorial.Example_5.PFData.BusData.BusTemplate
                                                              "Power flow results for buses"                     annotation (
      choicesAllMatching=true,Dialog(group="Power Flow Data", tab="Power Flow Scenario"));
  replaceable record Load =
        OpenIPSL.Examples.Tutorial.Example_5.PFData.LoadData.PFLoad00000 constrainedby OpenIPSL.Examples.Tutorial.Example_5.PFData.LoadData.LoadTemplate
      "Power flow results for loads"                                                                                     annotation (
      choicesAllMatching=true,Dialog(group="Power Flow Data", tab="Power Flow Scenario"));
  replaceable record Trafo =
        OpenIPSL.Examples.Tutorial.Example_5.PFData.TrafoData.PFTrafo00000 constrainedby OpenIPSL.Examples.Tutorial.Example_5.PFData.TrafoData.TrafoTemplate
      "Power flow results for transformers"                                                                                   annotation (
      choicesAllMatching=true,Dialog(group="Power Flow Data", tab="Power Flow Scenario"));
  replaceable record Machine =
        OpenIPSL.Examples.Tutorial.Example_5.PFData.MachineData.PFMachine00000 constrainedby OpenIPSL.Examples.Tutorial.Example_5.PFData.MachineData.MachineTemplate
      "Power flow results for machines"
    annotation (choicesAllMatching=true,Dialog(group="Power Flow Data", tab="Power Flow Scenario"));
equation
  connect(uvs, GridIO.uvs1) annotation (Line(points={{-84,0},{-48,0},{-48,
          6.74286},{-22,6.74286}},                                                                       color={0,140,72},
      thickness=1));

  connect(zeros.y, GridIO.uPload1) annotation (Line(points={{-39,20},{-34,20},{
          -34,16.5143},{-22.1,16.5143}}, color={0,0,127}));
  connect(GridIO.uPSS1, zeros.y) annotation (Line(points={{-22,13.6},{-34,13.6},
          {-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPm1, zeros.y) annotation (Line(points={{-22,10.1714},{-34,
          10.1714},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPSS2, zeros.y) annotation (Line(points={{-22,3.54286},{-34,
          3.54286},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPm2, zeros.y) annotation (Line(points={{-22,0},{-34,0},{-34,
          20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uvs2, zeros.y) annotation (Line(points={{-22,-3.2},{-34,-3.2},
          {-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPSS3, zeros.y) annotation (Line(points={{-22,-6.17143},{-34,
          -6.17143},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPm3, zeros.y) annotation (Line(points={{-22,-9.37143},{-34,
          -9.37143},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uvs3, zeros.y) annotation (Line(points={{-22,-12.5714},{-34,
          -12.5714},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPload2, zeros.y) annotation (Line(points={{-22.1,-15.6},{-34,
          -15.6},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.uPload3, zeros.y) annotation (Line(points={{-22.1,-18.4571},{
          -34,-18.4571},{-34,20},{-39,20}}, color={0,0,127}));
  connect(GridIO.Vt, Vt)
    annotation (Line(points={{21.6,0},{48,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-140,-80},{60,80}}),
                   graphics={                                        Rectangle(
          extent={{-140,-80},{60,80}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,20},{100,-20}},
          textColor={28,108,200},
          textString="%name"),            Text(
          extent={{-98,30},{24,-36}},
          textColor={255,255,255},
          textString="SISO")}));
end GridIOsiso;
