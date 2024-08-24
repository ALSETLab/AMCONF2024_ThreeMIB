within ThreeMIB.GenerationUnits;
model InfiniteBus "Infinite Bus model"
  extends .OpenIPSL.Interfaces.Generator;
  OpenIPSL.Electrical.Machines.PSSE.GENCLS gENCLS(
    P_0=P_0,
    Q_0=Q_0,
    v_0=v_0,
    angle_0=angle_0,
    M_b=100000000000,
    H=0,
    D=0,
    R_a=0,
    X_d=0.2) annotation (Placement(transformation(extent={{6,-20},{44,20}})));
equation
  connect(gENCLS.p, pwPin) annotation (Line(points={{44,0},{110,0}}, color={0,0,255}));
  annotation (Icon(graphics={Text(
          extent={{-62,38},{70,-38}},
          textColor={28,108,200},
          textString="IB")}));
end InfiniteBus;
