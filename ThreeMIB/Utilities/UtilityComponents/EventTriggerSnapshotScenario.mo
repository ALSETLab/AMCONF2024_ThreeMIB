within ThreeMIB.Utilities.UtilityComponents;
model EventTriggerSnapshotScenario
  "Trigger snapshot saving at specific points of the simulation"

  Real x "Copy of the time variable for checking timings for snapshots";

  parameter Real talpha = 0 "start of the scenario";
  parameter Real t2p5 = 150 "Ramping interval (default 2.5 min)";
  parameter Real t5p0 = 300 "Probing interval (default 5.0 min)";

  parameter Real tnin_start = talpha + t2p5;
  parameter Real tnin_duration = t2p5;

  parameter Real tramp1_start=t2p5 annotation (Dialog(group="Default Ramp Values"));
  parameter Real tramp1_duration=tnin_start + tnin_duration annotation (Dialog(group="Default Ramp Values"));

  parameter Real tA_start = tramp1_start + tramp1_duration;
  parameter Real tA_duration = t5p0;

  parameter Real tB_start = tA_start + tA_duration;
  parameter Real tB_duration = t5p0;

  parameter Real tC_start = tB_start + tB_duration;
  parameter Real tC_duration = t5p0;

  parameter Real tramp2_start=tC_start + tC_duration annotation (Dialog(group="Default Ramp Values"));
  parameter Real tramp2_duration=t2p5 annotation (Dialog(group="Default Ramp Values"));

  parameter Real tbeta = tramp2_start + tramp2_duration;

  parameter Real tD_start = tbeta + t2p5;
  parameter Real tD_duration = t5p0;

  parameter Real tE_start = tD_start + tD_duration;
  parameter Real tE_duration = t5p0;

  parameter Real tramp3_start = tE_start + tE_duration  annotation (Dialog(group="Default Ramp Values"));
  parameter Real tramp3_duration = t2p5 annotation (Dialog(group="Default Ramp Values"));

  parameter Real tgamma = tramp3_start + tramp3_duration;

  parameter Real tF_start = tgamma + t2p5;
  parameter Real tF_duration = t5p0;

  parameter Real tG_start = tF_start + tF_duration;
  parameter Real tG_duration = t5p0;

  parameter Real tramp4_start = tG_start + tG_duration annotation (Dialog(group="Default Ramp Values"));
  parameter Real tramp4_duration = t2p5  annotation (Dialog(group="Default Ramp Values"));

  parameter Real tdelta = tramp4_start + tramp4_duration;

  parameter Real tH_start = tdelta + t2p5;
  parameter Real tH_duration = t5p0;

  parameter Real tI_start = tH_start + tH_duration;
  parameter Real tI_duration = t5p0;

equation
  x = time;

    when x >= tA_start then
    Dymola.Simulation.TriggerResultSnapshot();
    elsewhen x >= tB_start then
    Dymola.Simulation.TriggerResultSnapshot();
    elsewhen x >= tC_start then
    Dymola.Simulation.TriggerResultSnapshot();
    elsewhen x >= tD_start then
    Dymola.Simulation.TriggerResultSnapshot();
    elsewhen x >= tF_start then
    Dymola.Simulation.TriggerResultSnapshot();
    elsewhen x >= tG_start then
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
          fillColor={244,125,35},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{-100,160},{100,100}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.CrossDiag,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
           preferredView = "text");
end EventTriggerSnapshotScenario;
