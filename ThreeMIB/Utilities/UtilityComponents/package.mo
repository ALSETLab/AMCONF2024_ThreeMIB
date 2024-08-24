within ThreeMIB.Utilities;
package UtilityComponents

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
          radius=25.0),
        Polygon(
          points={{-74,16},{-74,-16},{-42,-16},{-26,-48},{-10,-48},{-10,48},{
              -26,48},{-42,16},{-74,16}},
          lineColor={0,86,134},
          fillColor={0,86,134},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{74,16},{74,-16},{42,-16},{26,-48},{10,-48},{10,48},{26,48},{
              42,16},{74,16}},
          lineColor={0,86,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}));
end UtilityComponents;
