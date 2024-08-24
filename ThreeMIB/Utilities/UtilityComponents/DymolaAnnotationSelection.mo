within ThreeMIB.Utilities.UtilityComponents;
partial model DymolaAnnotationSelection
  "Add to a model the selections with Dymola-specific annotations"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={0,140,72},
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          lineThickness=1),
        Text(
          lineColor={0,140,72},
          extent={{-98,-50},{102,50}},
          textString="A")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        __Dymola_selections={Selection(name="MySelection", match={MatchVariable(name="plant.Vt", newName="Vt"),MatchVariable(name="plant.Q", newName="Q"),MatchVariable(name="plant.P",newName="P"),MatchVariable(name="plant.w",newName="w"),MatchVariable(name="plant.AVRin",newName="u"),MatchVariable(name="plant.AVRout",newName="AVRout"),MatchVariable(name="timedMultiRamp.y",newName="rampY"),MatchVariable(name="plant.Load9.P",newName="Pload"),MatchVariable(name="r.y",newName="r"),MatchVariable(name="plant.g1.pss.vs",newName="pssy"),MatchVariable(name="ramping.y",newName="rampingy")})},
    Documentation(info="<html>
<p>In this model, the Dymola-specific annotation __Dymola_selections is provided as an example so that the user can configure its own to store the variables preferred.</p>
<p>Expanding the annotations, the following variables can be found:</p>
<p><span style=\"font-family: Courier New;\">__Dymola_selections={<span style=\"color: #ff0000;\">Selection</span>(name=&quot;MySelection&quot;,&nbsp;match={<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.Vt&quot;,&nbsp;newName=&quot;Vt&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.Q&quot;,&nbsp;newName=&quot;Q&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.P&quot;,newName=&quot;P&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.w&quot;,newName=&quot;w&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.AVRin&quot;,newName=&quot;u&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.AVRout&quot;,newName=&quot;AVRout&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;timedMultiRamp.y&quot;,newName=&quot;rampY&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.Load9.P&quot;,newName=&quot;Pload&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;r.y&quot;,newName=&quot;r&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;plant.g1.pss.vs&quot;,newName=&quot;pssy&quot;),<span style=\"font-family: Courier New; color: #ff0000;\">MatchVariable</span>(name=&quot;ramping.y&quot;,newName=&quot;rampingy&quot;)})}</p>
<p>Here several variables from the model used in Example2 are stored.</p>
<p>Usage:</p>
<p>This model can be added to a model containing the model Example2.Base.Systems.sys, which is instantiated as &quot;plant&quot;.</p>
<p>Alternatively the annotation above can be copy/pasted to a model containing Example2.Base.Systems.sys, which should be instantiated as plant.</p>
</html>"));

end DymolaAnnotationSelection;
