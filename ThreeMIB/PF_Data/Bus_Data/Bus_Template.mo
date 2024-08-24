within ThreeMIB.PF_Data.Bus_Data;
partial record Bus_Template

parameter OpenIPSL.Types.PerUnit v1 "Voltage magnitude at bus 'B01'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A1 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.PerUnit v2 "Voltage magnitude at bus 'B02'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A2 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.PerUnit v3 "Voltage magnitude at bus 'B03'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A3 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.PerUnit v4 "Voltage magnitude at bus 'B04'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A4 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.PerUnit v5 "Voltage magnitude at bus 'B03'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A5 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.PerUnit v6 "Voltage magnitude at bus 'B04'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.Angle A6 "Voltage angle at bus 'B01'" annotation(Dialog(enable = false));

end Bus_Template;
