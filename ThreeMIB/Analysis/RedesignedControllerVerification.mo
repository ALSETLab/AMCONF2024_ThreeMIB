within ThreeMIB.Analysis;
package RedesignedControllerVerification
  "Controller verification simulation examples."

  function C012_simulate_plot_compare
    "Simulates and plots the response of three models with different control designs."
    extends Modelica.Icons.Function;
    input String modelname1 = "Example1.Analysis.RedesignedControllerVerification.C0_8cycles" "Model name - default controller";
    input String modelname2 = "Example1.Analysis.RedesignedControllerVerification.C1_8cycles" "Model name - controller re-design 1";
    input String modelname3 = "Example1.Analysis.RedesignedControllerVerification.C2_8cycles" "Model name - controller re-design 2";

  algorithm
    // turn of DAE mode et al
    Example1.Utilities.SetupSolverSettings.On();
    // Simulate the model
    simulateModel(
    modelname1,
    stopTime=1260,
    numberOfIntervals=20000,
    tolerance=1e-03,
    resultFile="C0_8cycles");
    // Simulate the model
    simulateModel(
    modelname2,
    stopTime=1260,
    numberOfIntervals=20000,
    tolerance=1e-03,
    resultFile="C1_8cycles");
    // Simulate the model
    simulateModel(
    modelname3,
    stopTime=1260,
    numberOfIntervals=20000,
    tolerance=1e-03,
    resultFile="C2_8cycles");
    // Plot
  removePlots(false);
  Advanced.FilenameInLegend :=true;
  Advanced.FilesToKeep :=10;
  createPlot(id=1, position={40, 40, 826, 766}, y={"Vt"}, range={1240.0, 1260.0, 0.8500000000000001, 1.05}, autoscale=false, grid=true, filename="C0_8cycles.mat", subPlot=101, colors={{28,108,200}}, timeUnit="s", displayUnits={"1"});
  createPlot(id=1, position={40, 40, 826, 766}, y={"w"}, range={1240.0, 1260.0, 0.994, 1.006}, autoscale=false, grid=true, subPlot=102, colors={{28,108,200}}, timeUnit="s", displayUnits={"1"});
  createPlot(id=1, position={40, 40, 826, 766}, y={"Vt"}, range={1240.0, 1260.0, 0.8500000000000001, 1.05}, erase=false, autoscale=false, grid=true, filename="C1_8cycles.mat", subPlot=101, colors={{238,46,47}}, timeUnit="s", displayUnits={"1"});
  createPlot(id=1, position={40, 40, 826, 766}, y={"w"}, range={1240.0, 1260.0, 0.994, 1.006}, erase=false, autoscale=false, grid=true, subPlot=102, colors={{238,46,47}}, timeUnit="s", displayUnits={"1"});
  createPlot(id=1, position={40, 40, 826, 766}, y={"Vt"}, range={1240.0, 1260.0, 0.8500000000000001, 1.05}, erase=false, autoscale=false, grid=true, filename="C2_8cycles.mat", subPlot=101, colors={{0,140,72}}, timeUnit="s", displayUnits={"1"});
  createPlot(id=1, position={40, 40, 826, 766}, y={"w"}, range={1240.0, 1260.0, 0.994, 1.006}, erase=false, autoscale=false, grid=true, subPlot=102, colors={{0,140,72}}, timeUnit="s", displayUnits={"1"});
    annotation (Documentation(info="<html>
<p><i><b><span style=\"font-family: Arial;\">Usage</span></b></i></p>
<ol>
<li><span style=\"font-family: Arial;\">In the Package Browser, right click on the function and select &quot;Call function...&quot;. This will open the function&apos;s window.</span></li>
<p><img src=\"modelica://Example1/Resources/Images/c012_simulate_plot_compare (Small).png\"/></p>
<li><span style=\"font-family: Arial;\">Leave the default model names without change, these correspond to the three models within the package.</span></li>
<li><span style=\"font-family: Arial;\">Go to the bottom of the window and click on &quot;Execute&quot;.</span></li>
<li><span style=\"font-family: Arial;\">Go back to the function&apos;s own window and click on &quot;Close&quot;.</span></li>
</ol>
<p><br><i><b>Sample Output</b></i></p>
<p>Executing the function will produce the following plot.</p>
<p><img src=\"modelica://Example1/Resources/Images/C012_simulate_plot_compare_output.png\"/></p>
</html>"));
  end C012_simulate_plot_compare;

  model C0_8cycles "Default controller with kw=9.5 and tw=1.41."

    extends Modelica.Icons.Example;
    Modelica.Blocks.Interfaces.RealOutput Vt
      annotation (Placement(transformation(extent={{100,70},{120,90}}),
          iconTransformation(extent={{100,70},{120,90}})));
  public
    Modelica.Blocks.Interfaces.RealOutput Q
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput P
      annotation (Placement(transformation(extent={{100,30},{120,50}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput w
      annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
          iconTransformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.RealOutput delta
      annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant PSSchange(k=0)
      annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
    Modelica.Blocks.Sources.Constant Pmchange(k=0)
      annotation (Placement(transformation(extent={{-100,6},{-80,26}})));
    Example1.Base.Systems.gridIO Plant(
      t1=0.5, t2=Modelica.Constants.inf)
      annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
    Modelica.Blocks.Interfaces.RealOutput AVRin annotation (Placement(
          transformation(extent={{100,-110},{120,-90}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.RealOutput AVRout annotation (Placement(
          transformation(extent={{100,-130},{120,-110}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant loadnoise(k=0) annotation (
        Placement(transformation(extent={{-160,2},{-140,22}})));
    Modelica.Blocks.Math.Add uload annotation (Placement(transformation(
            extent={{-120,-22},{-100,-2}})));
    Modelica.Blocks.Sources.Constant uARVinput(k=0) annotation (
        Placement(transformation(extent={{-102,-50},{-82,-30}})));
    Modelica.Blocks.Sources.Pulse uloaddist(
      amplitude=1.25,
      width=100,
      period=8/60,
      nperiod=1,
      offset=0,
      startTime=1245) annotation (Placement(transformation(extent={{-160,-40},{-140,
              -20}})));
  equation
    connect(Plant.uPSS, PSSchange.y) annotation (Line(points={{-44,36},{
            -62.8572,36},{-62.8572,46},{-79,46}},      color={0,0,127}));
    connect(Plant.uPm, Pmchange.y) annotation (Line(points={{-44.4,12},{-62,12},
            {-62,16},{-79,16}},              color={0,0,127}));
    connect(Plant.Vt, Vt) annotation (Line(points={{42,32},{72.4286,32},{
            72.4286,80},{110,80}},              color={0,0,127}));
    connect(Plant.P, P) annotation (Line(points={{42,24},{73.4286,24},{73.4286,
            40},{110,40}},              color={0,0,127}));
    connect(Plant.Q, Q) annotation (Line(points={{42,16},{76,16},{76,0},{110,0}},
                         color={0,0,127}));
    connect(Plant.w, w) annotation (Line(points={{42,0},{73.4286,0},{73.4286,
            -40},{110,-40}},              color={0,0,127}));
    connect(Plant.delta, delta) annotation (Line(points={{42,-16},{72.4286,-16},
            {72.4286,-80},{110,-80}},               color={0,0,127}));
    connect(AVRin, Plant.AVRin) annotation (Line(points={{110,-100},{60,-100},{
            60,-24},{42,-24}},             color={0,0,127}));
    connect(AVRout, Plant.AVRout) annotation (Line(points={{110,-120},{52,-120},
            {52,-32},{42,-32}},                   color={0,0,127}));
    connect(uload.u1, loadnoise.y) annotation (Line(points={{-122,-6},{
            -132,-6},{-132,12},{-139,12}}, color={0,0,127}));
    connect(uload.y, Plant.uPload) annotation (Line(points={{-99,-12},{-72.5,
            -12},{-72.5,-12},{-44,-12}},          color={0,0,127}));
    connect(uARVinput.y, Plant.uvs) annotation (Line(points={{-81,-40},{-64,-40},
            {-64,-36},{-44,-36}},                color={0,0,127}));
    connect(uloaddist.y, uload.u2) annotation (Line(points={{-139,-30},{-132,-30},
            {-132,-18},{-122,-18}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{100,100}}),
                                 graphics={Text(
            extent={{-100,-80},{40,-102}},
            lineColor={162,29,33},
            textString="Note: see the block uloaddist on the load disturbance data specification.
Click on the \"Plant\" block to specify controller parameters.",
            horizontalAlignment=TextAlignment.Left)}),
      experiment(
        StopTime=1260,
        __Dymola_NumberOfIntervals=20000,
        Tolerance=1e-05,
        __Dymola_fixedstepsize=0.01,
        __Dymola_Algorithm="Dassl"),preferredView="diagram");
  end C0_8cycles;

  model C1_8cycles "Re-designed controller 1 with k2=22.4455 and tw=0.5217."

    extends Modelica.Icons.Example;
    Modelica.Blocks.Interfaces.RealOutput Vt
      annotation (Placement(transformation(extent={{100,70},{120,90}}),
          iconTransformation(extent={{100,70},{120,90}})));
  public
    Modelica.Blocks.Interfaces.RealOutput Q
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput P
      annotation (Placement(transformation(extent={{100,30},{120,50}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput w
      annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
          iconTransformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.RealOutput delta
      annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant PSSchange(k=0)
      annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
    Modelica.Blocks.Sources.Constant Pmchange(k=0)
      annotation (Placement(transformation(extent={{-100,6},{-80,26}})));
    Example1.Base.Systems.gridIO Plant(
      t1=0.5,
      t2=Modelica.Constants.inf,
      Kw=22.4455,
      Tw=0.5217)
      annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
    Modelica.Blocks.Interfaces.RealOutput AVRin annotation (Placement(
          transformation(extent={{100,-110},{120,-90}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.RealOutput AVRout annotation (Placement(
          transformation(extent={{100,-130},{120,-110}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant loadnoise(k=0) annotation (
        Placement(transformation(extent={{-160,2},{-140,22}})));
    Modelica.Blocks.Math.Add uload annotation (Placement(transformation(
            extent={{-120,-22},{-100,-2}})));
    Modelica.Blocks.Sources.Pulse uloaddist(
      amplitude=1.25,
      width=100,
      period=8/60,
      nperiod=1,
      offset=0,
      startTime=1245) annotation (Placement(transformation(extent={{
              -160,-40},{-140,-20}})));
    Modelica.Blocks.Sources.Constant uARVinput(k=0) annotation (
        Placement(transformation(extent={{-102,-50},{-82,-30}})));
  equation
    connect(Plant.uPSS, PSSchange.y) annotation (Line(points={{-44,36},{-62.8572,36},
            {-62.8572,46},{-79,46}},                   color={0,0,127}));
    connect(Plant.uPm, Pmchange.y) annotation (Line(points={{-44.4,12},{-62,12},{-62,
            16},{-79,16}},                   color={0,0,127}));
    connect(Plant.Vt, Vt) annotation (Line(points={{42,32},{72.4286,32},{72.4286,80},
            {110,80}},                          color={0,0,127}));
    connect(Plant.P, P) annotation (Line(points={{42,24},{73.4286,24},{73.4286,40},
            {110,40}},                  color={0,0,127}));
    connect(Plant.Q, Q) annotation (Line(points={{42,16},{76,16},{76,0},{110,0}},
                         color={0,0,127}));
    connect(Plant.w, w) annotation (Line(points={{42,0},{73.4286,0},{73.4286,-40},
            {110,-40}},                   color={0,0,127}));
    connect(Plant.delta, delta) annotation (Line(points={{42,-16},{72.4286,-16},{72.4286,
            -80},{110,-80}},                        color={0,0,127}));
    connect(AVRin, Plant.AVRin) annotation (Line(points={{110,-100},{60,-100},{60,
            -24},{42,-24}},                color={0,0,127}));
    connect(AVRout, Plant.AVRout) annotation (Line(points={{110,-120},{52,-120},{52,
            -32},{42,-32}},                       color={0,0,127}));
    connect(uload.u1, loadnoise.y) annotation (Line(points={{-122,-6},{
            -132,-6},{-132,12},{-139,12}}, color={0,0,127}));
    connect(uloaddist.y, uload.u2) annotation (Line(points={{-139,-30},
            {-132,-30},{-132,-18},{-122,-18}}, color={0,0,127}));
    connect(uload.y, Plant.uPload) annotation (Line(points={{-99,-12},{-72.5,-12},
            {-72.5,-12},{-44,-12}},               color={0,0,127}));
    connect(uARVinput.y, Plant.uvs) annotation (Line(points={{-81,-40},{-64,-40},{
            -64,-36},{-44,-36}},                 color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{100,100}}),
                                 graphics={Text(
            extent={{-100,-80},{40,-102}},
            lineColor={162,29,33},
            textString="Note: see the block uloaddist on the load disturbance data specification.
Click on the \"Plant\" block to specify controller parameters.",
            horizontalAlignment=TextAlignment.Left)}),
      experiment(
        StopTime=1320,
        __Dymola_NumberOfIntervals=20000,
        __Dymola_fixedstepsize=0.01,
        __Dymola_Algorithm="Dassl"),preferredView="diagram");
  end C1_8cycles;

  model C2_8cycles "Re-designed controller 2 with kw=12.6924 and tw=0.5602."

    extends Modelica.Icons.Example;
    Modelica.Blocks.Interfaces.RealOutput Vt
      annotation (Placement(transformation(extent={{100,70},{120,90}}),
          iconTransformation(extent={{100,70},{120,90}})));
  public
    Modelica.Blocks.Interfaces.RealOutput Q
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput P
      annotation (Placement(transformation(extent={{100,30},{120,50}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput w
      annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
          iconTransformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.RealOutput delta
      annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant PSSchange(k=0)
      annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
    Modelica.Blocks.Sources.Constant Pmchange(k=0)
      annotation (Placement(transformation(extent={{-100,6},{-80,26}})));
    Modelica.Blocks.Interfaces.RealOutput AVRin annotation (Placement(
          transformation(extent={{100,-110},{120,-90}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.RealOutput AVRout annotation (Placement(
          transformation(extent={{100,-130},{120,-110}}),
          iconTransformation(extent={{100,-90},{120,-70}})));
    Example1.Base.Systems.gridIO Plant(
      t1=0.5,
      t2=Modelica.Constants.inf,
      Kw=12.6924,
      Tw=0.5602)
      annotation (Placement(transformation(extent={{-40,-40},{40,40}})));
    Modelica.Blocks.Sources.Constant loadnoise(k=0) annotation (
        Placement(transformation(extent={{-160,2},{-140,22}})));
    Modelica.Blocks.Math.Add uload annotation (Placement(transformation(
            extent={{-120,-22},{-100,-2}})));
    Modelica.Blocks.Sources.Constant uARVinput(k=0) annotation (
        Placement(transformation(extent={{-102,-50},{-82,-30}})));
    Modelica.Blocks.Sources.Pulse uloaddist(
      amplitude=1.25,
      width=100,
      period=8/60,
      nperiod=1,
      offset=0,
      startTime=1245) annotation (Placement(transformation(extent={{-160,-40},{-140,
              -20}})));
  equation
    connect(Plant.uPSS, PSSchange.y) annotation (Line(points={{-44,36},{-62.8572,36},
            {-62.8572,46},{-79,46}},                   color={0,0,127}));
    connect(Plant.uPm, Pmchange.y) annotation (Line(points={{-44.4,12},{-62,12},{-62,
            16},{-79,16}},                   color={0,0,127}));
    connect(Plant.Vt, Vt) annotation (Line(points={{42,32},{72.4286,32},{72.4286,80},
            {110,80}},                          color={0,0,127}));
    connect(Plant.P, P) annotation (Line(points={{42,24},{73.4286,24},{73.4286,40},
            {110,40}},                  color={0,0,127}));
    connect(Plant.Q, Q) annotation (Line(points={{42,16},{76,16},{76,0},{110,0}},
                         color={0,0,127}));
    connect(Plant.w, w) annotation (Line(points={{42,0},{73.4286,0},{73.4286,-40},
            {110,-40}},                   color={0,0,127}));
    connect(Plant.delta, delta) annotation (Line(points={{42,-16},{72.4286,-16},{72.4286,
            -80},{110,-80}},                        color={0,0,127}));
    connect(AVRin, Plant.AVRin) annotation (Line(points={{110,-100},{60,-100},{60,
            -24},{42,-24}},                color={0,0,127}));
    connect(AVRout, Plant.AVRout) annotation (Line(points={{110,-120},{52,-120},{52,
            -32},{42,-32}},                       color={0,0,127}));
    connect(uload.u1, loadnoise.y) annotation (Line(points={{-122,-6},{
            -132,-6},{-132,12},{-139,12}}, color={0,0,127}));
    connect(uload.y, Plant.uPload) annotation (Line(points={{-99,-12},{-72.5,-12},
            {-72.5,-12},{-44,-12}},               color={0,0,127}));
    connect(uARVinput.y, Plant.uvs) annotation (Line(points={{-81,-40},{-64,-40},{
            -64,-36},{-44,-36}},                 color={0,0,127}));
    connect(uloaddist.y, uload.u2) annotation (Line(points={{-139,-30},{-134,-30},
            {-134,-18},{-122,-18}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{100,100}}),
                                 graphics={Text(
            extent={{-100,-80},{40,-102}},
            lineColor={162,29,33},
            textString="Note: see the block uloaddist on the load disturbance data specification.
Click on the \"Plant\" block to specify controller parameters.",
            horizontalAlignment=TextAlignment.Left)}),
      experiment(
        StopTime=1320,
        __Dymola_NumberOfIntervals=20000,
        __Dymola_fixedstepsize=0.01,
        __Dymola_Algorithm="Dassl"),preferredView="diagram");
  end C2_8cycles;
  annotation (Icon(graphics={
        Rectangle(
          fillColor={239,46,49},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          radius=25,
          lineColor={127,22,22},
          lineThickness=1),
      Rectangle(
        origin={0,35.149},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}},
          lineColor={255,255,255},
          lineThickness=1),
      Rectangle(
        origin={0,-34.851},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}},
          lineColor={255,255,255},
          lineThickness=1),
      Line(
        origin={-51.25,-2},
        points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}},
          color={255,255,255},
          thickness=1),
      Polygon(
        origin={-40,35},
        pattern=LinePattern.None,
        points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Line(
        origin={51.25,0},
        points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}},
          color={255,255,255},
          thickness=1),
      Polygon(
        origin={40,-35},
        pattern=LinePattern.None,
        points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),preferredView = "info",
    Documentation(info="<html>
<p>This package is configured to simulate the response to an 8-cycle load disturbance and to compare the default PSS control design with the two redesigned controllers presented in [2]. </p>
<ul>
<li>Default/original design: <span style=\"font-family: Courier New;\">Example1.Analysis.RedesignedControllerVerification.C0_8cycles,</span>is configured to simulate the default PSS control design with <img src=\"modelica://Example1/Resources/Images/equations/equation-clBCuWQf.png\" alt=\"k_w = 9.5\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-RmsQjcZ0.png\" alt=\"t_w = 1.41\"/> sec. </li>
<li>Re-design 1: <span style=\"font-family: Courier New;\">Example1.Analysis.RedesignedControllerVerification.C1_8cycles</span>. This design was obtained using <img src=\"modelica://Example1/Resources/Images/equations/equation-6GfUUJy2.png\" alt=\"gamma = 0.025\"/>, resulting in parameters <img src=\"modelica://Example1/Resources/Images/equations/equation-uRaInKme.png\" alt=\"k_w = 22.4455\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-b4mgrEyi.png\" alt=\"t_w = 0.5217\"/> sec.</li>
<li>Re-design 2: <span style=\"font-family: Courier New;\">Example1.Analysis.RedesignedControllerVerification.C2_8cycles</span>. This design was obtained using <img src=\"modelica://Example1/Resources/Images/equations/equation-xYLZp3n1.png\" alt=\"gamma = 0.05\"/>, resulting in parameters <img src=\"modelica://Example1/Resources/Images/equations/equation-Tv6HYrxI.png\" alt=\"k_w = 12.6924\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-QwYVSX78.png\" alt=\"t_w = 0.5602\"/> sec. </li>
</ul>
<p><br>To compare the different control designs the following function is provided: <a href=\"Example1.Analysis.RedesignedControllerVerification.C012_simulate_plot_compare\">C012_simulate_plot_compare</a></p>
<p>Executing this function results in a plot of the terminal voltage and speed similar to that in Fig. 10 of [2], with the main difference being that the random load has been removed to speed up the simulations. Note that the all three cases above are simulated, so if a change is made in one of them, it should be also applied to the others so that running the function gives a plot for useful comparisons.</p>
</html>"));
end RedesignedControllerVerification;
