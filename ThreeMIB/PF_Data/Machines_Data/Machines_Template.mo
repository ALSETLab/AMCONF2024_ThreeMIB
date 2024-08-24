within ThreeMIB.PF_Data.Machines_Data;
partial record Machines_Template

parameter OpenIPSL.Types.ActivePower PG1 "generator1_1" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QG1 "generator1_1" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.ActivePower PG2 "generator2_1" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QG2 "generator2_1" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.ActivePower PG3 "generator3_1" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QG3 "generator3_1" annotation(Dialog(enable = false));

parameter OpenIPSL.Types.ActivePower PG4 "generator4_1" annotation(Dialog(enable = false));
parameter OpenIPSL.Types.ReactivePower QG4 "generator4_1" annotation(Dialog(enable = false));

end Machines_Template;
