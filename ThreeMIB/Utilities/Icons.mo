within ThreeMIB.Utilities;
package Icons
  extends Modelica.Icons.IconsPackage;

  model PartialModel
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Ellipse(lineColor={170,255,170},
                  extent={{-100,-100},{100,100}})}),
                                Diagram(coordinateSystem(preserveAspectRatio=
              false)));
  end PartialModel;

  model PartialExample
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Ellipse(lineColor={0,140,72},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}), Polygon(
            points={{-60,20},{-20,60},{20,60},{60,20},{60,-20},{20,-60},{-20,
                -60},{-60,-20},{-60,20}},
            lineColor={127,0,0},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            lineThickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=
              false)));
  end PartialExample;

  model FunctionDependentExample
    "f+m = for this model, a function drives the simulation of the model"
    annotation (Icon(coordinateSystem(extent={{-200,-200},{200,200}}),
                     graphics={
          Ellipse(
            lineColor={108,88,49},
            fillColor={213,255,170},
            fillPattern=FillPattern.Solid,
            extent={{-200,-200},{198,200}}),
          Polygon(lineColor={0,0,255},
                  fillColor={105,193,102},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.Solid,
                  points={{30,-40},{228,-140},{30,-242},{30,-40}},
            origin={-140,-110},
            rotation=90),
          Text(
            lineColor={0,140,72},
            extent={{-74,-192},{86,-72}},
            textString="f+m")}), Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"),  preferredView="info");
  end FunctionDependentExample;

  model ModelForLinearizationBis "This model is used for linearization."
    annotation (Icon(graphics={
          Ellipse(
            lineColor={0,140,72},
            fillColor={213,255,170},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}},
            lineThickness=1),
          Text(
            lineColor={0,140,72},
            extent={{-100,-50},{100,50}},
            textString="Lin")}), Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"),  preferredView="info");
  end ModelForLinearizationBis;

  partial model ModelForLinearization
    "nonlin4lin = for this model, you need to provide inputs or use it as is for linearization"
    annotation (Icon(graphics={
          Ellipse(
            lineColor={108,88,49},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}),
          Polygon(lineColor={0,0,255},
                  fillColor={28,108,200},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.Solid,
                  points={{-38,62},{62,2},{-38,-58},{-38,62}}),
          Text(
            lineColor={28,108,200},
            extent={{-100,102},{100,142}},
            textString="%name")}),
                                 Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"));
  end ModelForLinearization;

  partial model ModelForLinearizationLarge
    "nonlin4lin = for this model, you need to provide inputs or use it as is for linearization"
    annotation (Icon(coordinateSystem(extent={{-300,-100},{300,100}}),
                     graphics={
          Rectangle(
            extent={{-300,100},{300,-100}},
            lineColor={135,135,135},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            lineThickness=1),
          Ellipse(
            lineColor={108,88,49},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid,
            extent={{-102,-100},{98,100}}),
          Polygon(lineColor={0,0,255},
                  fillColor={28,108,200},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.Solid,
                  points={{-38,62},{62,2},{-38,-58},{-38,62}}),
          Text(
            lineColor={28,108,200},
            extent={{-100,-138},{100,-18}},
            textString="NL4LIN")}),
                                 Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"));
  end ModelForLinearizationLarge;

  partial package ModelForLinearizationPackage
    "nonlin4lin = for this model, you need to provide inputs or use it as is for linearization"
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Polygon(lineColor={0,0,255},
                  fillColor={28,108,200},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.Solid,
                  points={{-38,62},{62,2},{-38,-58},{-38,62}})}),
                                 Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"));
  end ModelForLinearizationPackage;

  partial package PackageWithSimAndLinModels "Package that contains both simulation and linearization models"
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Polygon(lineColor={175,175,175},
                  fillColor={28,108,200},
                  fillPattern=FillPattern.Solid,
                  points={{-58,40},{0,-2},{-58,-42},{-58,40}},
            lineThickness=1),
          Polygon(lineColor={215,215,215},
                  fillColor={0,140,72},
                  fillPattern=FillPattern.Solid,
                  points={{4,40},{64,-2},{4,-42},{4,40}},
            lineThickness=1)}),  Documentation(info="<html>
<p><b><span style=\"font-size: 24pt;\">f+m Example</span></b></p>
<p>DO NOT try to run this model on it&apos;s own! </p>
<p>Models with this icon will not simulate on their own, instead they work together with a function that populates certain parameters in the model and perform other operations.</p>
<p>See the associated function to run.</p>
</html>"));
  end PackageWithSimAndLinModels;
end Icons;
