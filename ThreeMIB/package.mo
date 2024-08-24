within ;
package ThreeMIB "This package contains the 3MIB model components and control system design and analysis functions."
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={85,85,255},
          fillPattern=FillPattern.Sphere), Bitmap(extent={{-14,14},{-18,14}}, fileName="")}), uses(
      Modelica(version="4.0.0"),
      OpenIPSL(version="3.1.0-dev"),
      Modelica_LinearSystems2(version="2.4.0"),
      DymolaCommands(version="1.16"),
      DataFiles(version="1.1.0")));
end ThreeMIB;
