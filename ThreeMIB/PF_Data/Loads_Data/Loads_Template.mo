within ThreeMIB.PF_Data.Loads_Data;
partial record Loads_Template

parameter OpenIPSL.Types.ActivePower PL1 "Active power consumed by 'load'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QL1 "Reactive power consumed by 'load'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.ActivePower PL2 "Active power consumed by 'load'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QL2 "Reactive power consumed by 'load'" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.ActivePower PL3 "Active power consumed by 'load'" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QL3 "Reactive power consumed by 'load'" annotation(Dialog(enable = false));

end Loads_Template;
