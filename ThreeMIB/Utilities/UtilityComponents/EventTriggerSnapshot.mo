within ThreeMIB.Utilities.UtilityComponents;
model EventTriggerSnapshot
  "Trigger snapshot saving at specific points of the simulation"
  Real x;
equation
  x = time;
  when x >= 1230 then
    Dymola.Simulation.TriggerResultSnapshot();
  elsewhen x>=1245 then
    Dymola.Simulation.TriggerResultSnapshot();
  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Polygon(points={{-54,86},{-54,86}}, lineColor={28,108,200}),
        Polygon(
          points={{-60,80},{60,80},{80,40},{80,-40},{60,-80},{-60,-80},
              {-80,-40},{-80,40},{-60,80}},
          lineColor={28,108,200},
          smooth=Smooth.Bezier,
          fillColor={170,213,255},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-80,40},{80,-20}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.CrossDiag,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
           preferredView = "text");
end EventTriggerSnapshot;
