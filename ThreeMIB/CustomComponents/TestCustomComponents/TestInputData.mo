within ThreeMIB.CustomComponents.TestCustomComponents;
model TestInputData "Test the InputData block"
  extends Modelica.Icons.Example;
  InputData inputData(nout=1)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Interfaces.RealOutput y1[1]
                     "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(inputData.y, y1)
    annotation (Line(points={{9,0},{110,0}}, color={0,0,127}));
  annotation (experiment(
      StopTime=1320),preferredView="diagram");
end TestInputData;
