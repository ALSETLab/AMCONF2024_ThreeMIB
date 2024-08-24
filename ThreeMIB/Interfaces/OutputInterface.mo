within ThreeMIB.Interfaces;
partial model OutputInterface
public
  Modelica.Blocks.Interfaces.RealOutput Vt
    annotation (Placement(transformation(extent={{200,-34},{268,34}}),
        iconTransformation(extent={{200,-16},{232,16}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXin annotation (Placement(transformation(extent={{200,
            -116},{270,-46}}),                                                                                       iconTransformation(extent={{200,-96},
            {236,-60}})));
  Modelica.Blocks.Interfaces.RealOutput SCRXout annotation (Placement(transformation(extent={{200,
            -200},{266,-134}}),                                                                                       iconTransformation(extent={{200,
            -172},{238,-134}})));
  Modelica.Blocks.Interfaces.RealOutput
             SPEED "Machine speed deviation from nominal [pu]"
    annotation (Placement(transformation(extent={{200,42},{266,108}}),  iconTransformation(extent={{200,54},
            {234,88}})));
  Modelica.Blocks.Interfaces.RealOutput
             ANGLE "Machine relative rotor angle"
    annotation (Placement(transformation(extent={{200,116},{262,178}}), iconTransformation(extent={{200,128},
            {232,160}})));
  annotation (
    experiment(
      StopTime=10,
      Interval=0.0001,
      Tolerance=1e-06,
      __Dymola_fixedstepsize=0.0001,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This is a partial model for inheritance, outputs need to be coupled with the simulation model at the equation level.</p>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-200,-200},{200,200}})),
               preferredView = "diagram");
end OutputInterface;
