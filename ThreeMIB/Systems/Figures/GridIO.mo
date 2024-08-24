within ThreeMIB.Systems.Figures;
partial model GridIO "Partial ThreeMIB Model with SysData and ext_in load"

  OpenIPSL.Electrical.Buses.Bus B1(displayPF=true) annotation (Placement(transformation(extent={{-192,78},{-172,98}})));
  OpenIPSL.Electrical.Buses.Bus B3(displayPF=true) annotation (Placement(transformation(extent={{-192,-44},{-172,-24}})));
  OpenIPSL.Electrical.Buses.Bus B4(displayPF=true) annotation (Placement(transformation(extent={{-114,78},{-94,98}})));
  OpenIPSL.Electrical.Buses.Bus B2(displayPF=true) annotation (Placement(transformation(extent={{-192,16},{-172,36}})));
  OpenIPSL.Electrical.Branches.PwLine line2(
    R=0.0010,
    X=0.12,
    G=0.0000,
    B=0.0000) annotation (Placement(transformation(extent={{-48,-44},{-28,-24}})));
  OpenIPSL.Electrical.Loads.PSSE.Load_ExtInput Load1(P_0=1400000000, Q_0=100000000) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-22,41})));
  inner OpenIPSL.Electrical.SystemBase SysData annotation (Placement(transformation(extent={{-300,138},{-208,180}})));
  OpenIPSL.Electrical.Buses.Bus B5(displayPF=true) annotation (Placement(transformation(extent={{-110,-44},{-90,-24}})));
  OpenIPSL.Electrical.Buses.Bus B6(displayPF=true) annotation (Placement(transformation(extent={{16,-44},{36,-24}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF1(
    CZ=1,
    R=0.000000,
    X=0.006410,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=500000) annotation (Placement(transformation(extent={{-160,76},{-138,100}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF2(
    CZ=1,
    R=0.000000,
    X=0.006410,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=500000) annotation (Placement(transformation(extent={{-158,14},{-136,38}})));
  OpenIPSL.Electrical.Branches.PSSE.TwoWindingTransformer TF3(
    CZ=1,
    R=0.000000,
    X=0.011200,
    G=0.000000,
    B=0.000000,
    CW=1,
    VNOM1=18000,
    VNOM2=18000) annotation (Placement(transformation(extent={{-158,-46},{-134,-22}})));
  OpenIPSL.Electrical.Loads.PSSE.Load_ExtInput Load2(P_0=2000000000, Q_0=100000000) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-118,-77})));
  OpenIPSL.Electrical.Loads.PSSE.Load_ExtInput Load3(P_0=10000000000, Q_0=2000000000) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={46,-77})));
  OpenIPSL.Electrical.Branches.PwLine line1(
    R=0,
    X=0.036,
    G=0,
    B=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-74,28})));
  GenerationUnits.InfiniteBus                                    infiniteBus(
    P_0=pf.powerflow.machines.PG4,
    Q_0=pf.powerflow.machines.QG4,
    v_0=pf.powerflow.bus.v6,
    angle_0=pf.powerflow.bus.A6,
    displayPF=false)                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,-34})));
  GenerationUnits.MachineEXPSSIO.Generator1EXPSSIO generator1EXPSSIO(displayPF=false) annotation (Placement(transformation(extent={{-230,78},{-210,98}})));
  GenerationUnits.MachineEXPSSIO.Generator2EXPSSIO generator2EXPSSIO(displayPF=false) annotation (Placement(transformation(extent={{-230,16},{-210,36}})));
  GenerationUnits.MachineEXPSSIO.Generator3EXPSSIO generator3EXPSSIO(displayPF=false) annotation (Placement(transformation(extent={{-230,-44},{-210,-24}})));
  OpenIPSL.Electrical.Events.PwFault pwFault(
    R=Rfault,
    X=Xfault,
    t1=t1fault,
    t2=t2fault) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={21,1})));
  PF_Data.Power_Flow pf annotation (Placement(transformation(extent={{60,0},{88,28}})));
public
  Modelica.Blocks.Interfaces.RealOutput ANGLE annotation (Placement(transformation(extent={{6,80},{26,100}}), iconTransformation(extent={{200,150},{220,170}})));
  Modelica.Blocks.Interfaces.RealOutput SPEED annotation (Placement(transformation(extent={{46,82},{66,102}}), iconTransformation(extent={{200,110},{220,130}})));
  Modelica.Blocks.Interfaces.RealOutput Vt annotation (Placement(transformation(extent={{6,60},{26,80}}), iconTransformation(extent={{200,70},{220,90}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{30,60},{50,80}}), iconTransformation(extent={{200,-10},{220,10}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{60,60},{80,80}}), iconTransformation(extent={{200,-90},{220,-70}})));
equation
  connect(B1.p, TF1.p) annotation (Line(points={{-182,88},{-161.1,88}},
                                                                    color={0,0,255}));
  connect(TF1.n, B4.p) annotation (Line(points={{-136.9,88},{-104,88}},
                                                                    color={0,0,255}));
  connect(B2.p, TF2.p) annotation (Line(points={{-182,26},{-159.1,26}},
                                                                  color={0,0,255}));
  connect(TF2.n, B4.p) annotation (Line(points={{-134.9,26},{-124,26},{-124,88},{-104,88}},
                                                                                    color={0,0,255}));
  connect(B3.p, TF3.p) annotation (Line(points={{-182,-34},{-159.2,-34}},
                                                                      color={0,0,255}));
  connect(TF3.n, B5.p) annotation (Line(points={{-132.8,-34},{-100,-34}},
                                                                      color={0,0,255}));
  connect(B5.p, line2.p) annotation (Line(points={{-100,-34},{-47,-34}},
                                                                       color={0,0,255}));
  connect(Load1.p, B4.p) annotation (Line(points={{-22,47},{-22,88},{-104,88}},              color={0,0,255}));
  connect(line2.n, B6.p) annotation (Line(points={{-29,-34},{26,-34}},
                                                                     color={0,0,255}));
  connect(Load2.p, B5.p) annotation (Line(points={{-118,-71},{-118,-34},{-100,-34}},
                                                                                  color={0,0,255}));
  connect(B4.p, line1.p) annotation (Line(points={{-104,88},{-74,88},{-74,37}},color={0,0,255}));
  connect(line1.n, line2.p) annotation (Line(points={{-74,19},{-74,-34},{-47,-34}},color={0,0,255}));
  connect(infiniteBus.pwPin, B6.p) annotation (Line(points={{65,-34},{26,-34}}, color={0,0,255}));
  connect(Load3.p, B6.p) annotation (Line(points={{46,-71},{46,-34},{26,-34}}, color={0,0,255}));
  connect(generator1EXPSSIO.pwPin, B1.p) annotation (Line(points={{-209,88},{-182,88}}, color={0,0,255}));
  connect(generator2EXPSSIO.pwPin, B2.p) annotation (Line(points={{-209,26},{-182,26}}, color={0,0,255}));
  connect(generator3EXPSSIO.pwPin, TF3.p) annotation (Line(points={{-209,-34},{-159.2,-34}}, color={0,0,255}));
  connect(pwFault.p, B6.p) annotation (Line(points={{12.8333,1},{0,1},{0,-34},{26,-34}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-120},{120,180}}),
                                                                graphics={
          Rectangle(extent={{-300,200},{120,-120}}, lineColor={135,135,135},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-120},{120,180}}),
                                                     graphics={
        Rectangle(
          extent={{-274,100},{-238,-50}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-268,118},{-242,100}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Inputs"),
                         Text(
          extent={{-268,84},{-244,70}},
          lineColor={0,0,117},
          textString="uPm1"),
                         Text(
          extent={{-270,24},{-244,12}},
          lineColor={0,0,117},
          textString="uPm2"),
                         Text(
          extent={{-268,-34},{-242,-46}},
          lineColor={0,0,117},
          textString="uPm3"),
                         Text(
          extent={{-270,98},{-242,84}},
          lineColor={0,0,117},
          textString="uPSS1"),
                         Text(
          extent={{-270,42},{-242,26}},
          lineColor={0,0,117},
          textString="uPSS2"),
                         Text(
          extent={{-270,-18},{-242,-34}},
          lineColor={0,0,117},
          textString="uPSS3"),
        Rectangle(
          extent={{-232,-52},{-206,-70}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-236,-54},{-202,-66}},
          lineColor={0,0,117},
          textString="uvs2"),
                         Text(
          extent={{-234,-74},{-204,-82}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
        Rectangle(
          extent={{-232,10},{-206,-6}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-236,8},{-204,-4}},
          lineColor={0,0,117},
          textString="uvs2"),
                         Text(
          extent={{-234,-8},{-204,-16}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
        Rectangle(
          extent={{-232,72},{-206,56}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-236,70},{-204,58}},
          lineColor={0,0,117},
          textString="uvs1"),
                         Text(
          extent={{-234,54},{-204,46}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
        Rectangle(
          extent={{0,104},{110,60}},
          lineColor={244,125,35},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{68,98},{100,88}},
          lineColor={244,125,35},
          textStyle={TextStyle.Bold},
          textString="Outputs"),
                         Text(
          extent={{-158,-68},{-128,-78}},
          lineColor={0,0,117},
          textString="uPload2"),
        Rectangle(
          extent={{-162,-66},{-124,-80}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-152,-58},{-132,-66}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
                         Text(
          extent={{-62,50},{-30,40}},
          lineColor={0,0,117},
          textString="uPload1"),
        Rectangle(
          extent={{-64,52},{-26,38}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{-54,60},{-34,52}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
                         Text(
          extent={{8,-68},{38,-78}},
          lineColor={0,0,117},
          textString="uPload3"),
        Rectangle(
          extent={{6,-66},{42,-80}},
          lineColor={0,140,72},
          fillColor={170,213,255},
          fillPattern=FillPattern.None),
                         Text(
          extent={{14,-58},{34,-66}},
          lineColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Input"),
        Text(
          extent={{-224,138},{52,118}},
          textColor={0,0,0},
          fontSize=12,
          textStyle={TextStyle.Bold},
          fontName="Arial",
          textString="Three Machine Infinite Bus Model with IO Interface")}));
end GridIO;
