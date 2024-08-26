within ThreeMIB.Systems;
model GridIO "3MIB model with input/output interfaces and modifications for simulation and linearization"
  extends Networks.Base(
    Load1(
      P_0=pf.powerflow.loads.PL1,
      Q_0=pf.powerflow.loads.QL1,
      v_0=pf.powerflow.bus.v4,
      angle_0=pf.powerflow.bus.A4,
      d_P=0.0,
      t1=365*24*60*60,
      d_t=Modelica.Constants.small),
    Load2(
      P_0=pf.powerflow.loads.PL2,
      Q_0=pf.powerflow.loads.QL2,
      v_0=pf.powerflow.bus.v5,
      angle_0=pf.powerflow.bus.A5,
      d_P=0.0,
      t1=365*24*60*60,
      d_t=Modelica.Constants.small),
    Load3(
      P_0=pf.powerflow.loads.PL3,
      Q_0=pf.powerflow.loads.QL3,
      v_0=pf.powerflow.bus.v6,
      angle_0=pf.powerflow.bus.A6,
      d_P=0.0,
      t1=365*24*60*60,
      d_t=Modelica.Constants.small),
    infiniteBus(
      P_0=pf.powerflow.machines.PG4,
      Q_0=pf.powerflow.machines.QG4,
      v_0=pf.powerflow.bus.v6,
      angle_0=pf.powerflow.bus.A6,
      displayPF=false),
    line1(t1=365*24*60*60 + 2));
  GenerationUnits.MachineEXPSSIO.Generator1EXPSSIO G1(
    P_0=pf.powerflow.machines.PG1,
    Q_0=pf.powerflow.machines.QG1,
    v_0=pf.powerflow.bus.v1,
    angle_0=pf.powerflow.bus.A1,
    displayPF=false,
    pSSTypeIIExtraLeadLag(Kw=15)) annotation (Placement(transformation(extent={{-134,36},{-118,52}})));
  GenerationUnits.MachineEXPSSIO.Generator2EXPSSIO G2(
    P_0=pf.powerflow.machines.PG2,
    Q_0=pf.powerflow.machines.QG2,
    v_0=pf.powerflow.bus.v2,
    angle_0=pf.powerflow.bus.A2,
    displayPF=false,
    pSSTypeIIExtraLeadLag(Kw=15)) annotation (Placement(transformation(extent={{-134,-8},{-118,8}})));
  GenerationUnits.MachineEXPSSIO.Generator3EXPSSIO G3(
    P_0=pf.powerflow.machines.PG3,
    Q_0=pf.powerflow.machines.QG3,
    v_0=pf.powerflow.bus.v3,
    angle_0=pf.powerflow.bus.A3,
    displayPF=false,
    pSSTypeIIExtraLeadLag(Kw=15)) annotation (Placement(transformation(extent={{-134,-52},{-118,-36}})));

  extends ThreeMIB.Interfaces.OutputInterface;
  PF_Data.Power_Flow pf(redeclare record PowerFlow =
        ThreeMIB.PF_Data.PF_00000)                                                       annotation (Placement(transformation(extent={{52,56},{72,76}})));
  Modelica.Blocks.Interfaces.RealInput uPSS1 annotation (Placement(transformation(extent={{-204,148},{-180,172}}), iconTransformation(extent={{-240,
            218},{-200,258}})));
  Modelica.Blocks.Interfaces.RealInput uPm1 annotation (Placement(transformation(extent={{-204,116},{-180,140}}), iconTransformation(extent={{-240,
            158},{-200,198}})));
  Modelica.Blocks.Interfaces.RealInput uvs1 annotation (Placement(transformation(extent={{-206,84},{-180,110}}), iconTransformation(extent={{-240,98},
            {-200,138}})));
  OpenIPSL.Electrical.Events.PwFault pwFault(
    R=Rfault,
    X=Xfault,
    t1=t1fault,
    t2=t2fault) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={29,-7})));

  parameter Modelica.Units.SI.Time t1=0.5
    "Time of line removal" annotation (Dialog(group="Line Removal Parameters"));
  parameter Modelica.Units.SI.Time t2=0.57
    "Line re-insertion time"
    annotation (Dialog(group="Line Removal Parameters"));
   parameter Integer opening=1
    "Type of opening (1: removes both ends at same time, 2: removes sending end, 3: removes receiving end)"     annotation (Dialog(group="Line Removal Parameters"));
  parameter OpenIPSL.Types.Time t1fault=365*24*60*60
    "Start time of the fault (default to a large value, i.e., no opening applied during intended time of simulation)" annotation (Dialog(group="Fault Parameters"));
  parameter OpenIPSL.Types.Time t2fault=t1fault + 1/60
    "End time of the fault (default to a large value, i.e., no opening applied during intended time of simulation)" annotation (Dialog(group="Fault Parameters"));
parameter OpenIPSL.Types.PerUnit Rfault=Modelica.Constants.eps "Resistance"
    annotation (Dialog(group="Fault Parameters"));
  parameter OpenIPSL.Types.PerUnit Xfault=1e-5 "Reactance"
    annotation (Dialog(group="Fault Parameters"));

  Modelica.Blocks.Interfaces.RealInput uPSS2
    annotation (Placement(transformation(extent={{-204,42},{-180,66}}),
        iconTransformation(extent={{-240,42},{-200,82}})));
  Modelica.Blocks.Interfaces.RealInput uPm2 annotation (Placement(transformation(extent={{-204,8},{-180,32}}), iconTransformation(extent={{-240,
            -20},{-200,20}})));
  Modelica.Blocks.Interfaces.RealInput uvs2 annotation (Placement(transformation(extent={{-206,-28},{-180,-2}}), iconTransformation(extent={{-240,
            -76},{-200,-36}})));
  Modelica.Blocks.Interfaces.RealInput uPSS3
    annotation (Placement(transformation(extent={{-204,-60},{-180,-36}}),
        iconTransformation(extent={{-240,-128},{-200,-88}})));
  Modelica.Blocks.Interfaces.RealInput uPm3 annotation (Placement(transformation(extent={{-204,-90},{-180,-66}}), iconTransformation(extent={{-240,
            -184},{-200,-144}})));
  Modelica.Blocks.Interfaces.RealInput uvs3 annotation (Placement(transformation(extent={{-206,-120},{-180,-94}}), iconTransformation(extent={{-240,
            -240},{-200,-200}})));
  Modelica.Blocks.Interfaces.RealInput uPload1
                                              annotation (Placement(
        transformation(extent={{-206,174},{-180,200}}),
        iconTransformation(extent={{-240,270},{-202,308}})));
  Modelica.Blocks.Interfaces.RealInput uPload2
                                              annotation (Placement(
        transformation(extent={{-206,-152},{-180,-126}}),
        iconTransformation(extent={{-240,-292},{-202,-254}})));
  Modelica.Blocks.Interfaces.RealInput uPload3
                                              annotation (Placement(
        transformation(extent={{-206,-180},{-180,-154}}),
        iconTransformation(extent={{-240,-342},{-202,-304}})));
equation
  SCRXin = G1.feedbackSCRX.y; // SCRXinput, error signal to the SCRX
  SCRXout = G1.sCRX.EFD; // SCRX output, Efd
  Vt = G1.gENSAE.ETERM;
  ANGLE = G1.gENSAE.ANGLE;
  SPEED = G1.gENSAE.SPEED;

  connect(G1.pwPin, B1.p) annotation (Line(points={{-117.2,44},{-106,44}},             color={0,0,255}));
  connect(G2.pwPin, B2.p) annotation (Line(points={{-117.2,0},{-106,0}},             color={0,0,255}));
  connect(G3.pwPin, B3.p) annotation (Line(points={{-117.2,-44},{-106,-44}},             color={0,0,255}));
  connect(uPSS1, G1.uPSS) annotation (Line(points={{-192,160},{-142,160},{-142,48.8},{-135.6,48.8}}, color={0,0,127}));
  connect(uPm1, G1.upm) annotation (Line(points={{-192,128},{-144,128},{-144,39.2},{-135.6,39.2}}, color={0,0,127}));
  connect(pwFault.p, B6.p) annotation (Line(points={{20.8333,-7},{16,-7},{16,
          -44},{30,-44}},                                                                    color={0,0,255}));
  connect(uPm2, G2.upm) annotation (Line(points={{-192,20},{-170,20},{-170,-4.8},{-135.6,-4.8}}, color={0,0,127}));
  connect(uvs2, G2.uVsCRX) annotation (Line(points={{-193,-15},{-126,-15},{-126,-9.6}}, color={0,0,127}));
  connect(uPSS2, G2.uPSS) annotation (Line(points={{-192,54},{-168,54},{-168,4.8},{-135.6,4.8}}, color={0,0,127}));
  connect(uvs1, G1.uVsCRX) annotation (Line(points={{-193,97},{-150,97},{-150,28},{-126,28},{-126,34.4}}, color={0,0,127}));
  connect(uPSS3, G3.uPSS) annotation (Line(points={{-192,-48},{-168,-48},{-168,-39.2},{-135.76,-39.2}}, color={0,0,127}));
  connect(uPm3, G3.upm) annotation (Line(points={{-192,-78},{-160,-78},{-160,-48.8},{-135.6,-48.8}}, color={0,0,127}));
  connect(uvs3, G3.uVsCRX) annotation (Line(points={{-193,-107},{-148,-107},{-148,-62},{-126,-62},{-126,-53.6}}, color={0,0,127}));
  connect(uPload2, Load2.u) annotation (Line(points={{-193,-139},{-74,-139},{-74,-71.7},{-45.67,-71.7}}, color={0,0,127}));
  connect(uPload3, Load3.u) annotation (Line(points={{-193,-167},{32,-167},{32,-71.7},{42.33,-71.7}}, color={0,0,127}));
  connect(uPload1, Load1.u) annotation (Line(points={{-193,187},{-10,187},{-10,44.3},{-1.67,44.3}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-200,-350},{200,350}},
        preserveAspectRatio=false,
        initialScale=0.05),
                   graphics={Rectangle(
          extent={{-200,350},{200,-350}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid), Text(
          extent={{-156,98},{166,-108}},
          textColor={255,255,255},
          textString="GridIO")}),           Diagram(coordinateSystem(extent={{-180,
            -180},{200,200}})));
end GridIO;
