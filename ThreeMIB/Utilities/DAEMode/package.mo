within ThreeMIB.Utilities;
package DAEMode "Enable or disable DAE Mode"

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
          radius=25.0),                   Text(
          extent={{-66,50},{62,-40}},
          textColor={28,108,200},
          textString="DAE
Mode")}),preferredView="info");
end DAEMode;
