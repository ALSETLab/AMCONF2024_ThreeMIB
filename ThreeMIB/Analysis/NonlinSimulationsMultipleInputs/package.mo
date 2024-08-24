within ThreeMIB.Analysis;
package NonlinSimulationsMultipleInputs "Example nonlinear time simulations with different input signals"

  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,0},
          radius=25),
        Line(points={{80,0},{60,0}}, color={160,160,164},
          thickness=1),
        Line(
          points={{0,0},{40,0}},
          thickness=1),
        Line(
          points={{0,0},{0,50}},
          thickness=0.5),
        Line(points={{0,80},{0,60}}, color={160,160,164},
          thickness=1),
        Line(points={{37,70},{26,50}}, color={160,160,164},
          thickness=1),
        Line(points={{70,38},{49,26}}, color={160,160,164},
          thickness=1),   Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={255,170,255},
          smooth=Smooth.Bezier,
          origin={-12,17.9},
          rotation=90,
          thickness=1),   Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={162,29,33},
          smooth=Smooth.Bezier,
          origin={-6,-20.1},
          rotation=90,
          thickness=1),   Line(
          points={{80,0.1},{68.7,34.3},{61.5,53.2},{55.1,66.5},{49.4,74.7},{43.8,
              79.2},{38.2,79.9},{32.6,76.7},{26.9,69.8},{21.3,59.5},{14.9,44.2},
              {6.83,21.3},{-10.1,-30.7},{-17.3,-50.1},{-23.7,-64.1},{-29.3,-73},
              {-35,-78.3},{-40.6,-79.9},{-46.2,-77.5},{-51.9,-71.4},{-57.5,-61.8},
              {-63.9,-47.1},{-72,-24.7},{-80,0.1}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          origin={-10,-2.1},
          rotation=90,
          thickness=1)}),preferredView = "info",
    Documentation(info="<html>
<p>This package contains different models that show how to provide inputs signals to drive the non-linear model being simulated.</p>
<p>The main model used for the identification and verification experiments as in Figs. 6 and 10 in [2] is:</p>
<p><span style=\"font-family: Courier New;\">Example1.Analysis.NonlinSimulationsMultipleInputs.A_randomload_and_lowimpactmultisine</span></p>
<p>It is configured to simulate the default PSS control design with <img src=\"modelica://Example1/Resources/Images/equations/equation-clBCuWQf.png\" alt=\"k_w = 9.5\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-RmsQjcZ0.png\" alt=\"t_w = 1.41\"/> sec. To change the control design, click on the &quot;Plant&quot; block and enter a new set of parameters. In [2], the two other PSS designs have parameters:</p>
<ul>
<li>Re-design 1 obtained using <img src=\"modelica://Example1/Resources/Images/equations/equation-6GfUUJy2.png\" alt=\"gamma = 0.025\"/> has parameters <img src=\"modelica://Example1/Resources/Images/equations/equation-uRaInKme.png\" alt=\"k_w = 22.4455\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-b4mgrEyi.png\" alt=\"t_w = 0.5217\"/> sec.</li>
<li>Re-design 2 obtained using <img src=\"modelica://Example1/Resources/Images/equations/equation-xYLZp3n1.png\" alt=\"gamma = 0.05\"/> has parameters <img src=\"modelica://Example1/Resources/Images/equations/equation-Tv6HYrxI.png\" alt=\"k_w = 12.6924\"/> and <img src=\"modelica://Example1/Resources/Images/equations/equation-QwYVSX78.png\" alt=\"t_w = 0.5602\"/> sec.</li>
</ul>
<p>The other models are variants where inputs are set to zero when compared to the case above. They are useful to compare against the above model, for example, the simulation of model &quot;<span style=\"font-family: Courier New;\">B_noise_...</span>&quot; can be compared to the one above to understand the impact of the input signal compared to only the random noise of the loads, etc. See the &quot;Package Contents&quot; below for information on each case.</p>
<p><br>In addition, to perform run any simulation and plot the following function is provided: <a href=\"Example1.Analysis.NonlinSimulationsMultipleInputs.simulate_and_plot\">simulate_and_plot</a></p>
</html>"));
end NonlinSimulationsMultipleInputs;
