within ThreeMIB.Utilities;
package PlotDownsample "Downsample plotting, enable or disable"

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),              Line(
          points={{-76,-58},{-26,28},{32,-40},{70,52}},
          color={0,86,134},
          thickness=0.5,
          smooth=Smooth.Bezier)}),preferredView="info");
end PlotDownsample;
