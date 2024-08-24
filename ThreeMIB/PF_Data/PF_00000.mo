within ThreeMIB.PF_Data;
record PF_00000
extends Power_Flow_Template;

replaceable record Bus = Bus_Data.PF_Bus_00000 constrainedby Bus_Data.Bus_Template
                                                                "Bus power flow results";
Bus bus;

replaceable record Loads = Loads_Data.PF_Loads_00000 constrainedby Loads_Data.Loads_Template
                                                                      "Loads power flow results";
Loads loads;

replaceable record Machines = Machines_Data.PF_Machines_00000 constrainedby Machines_Data.Machines_Template
                                                                               "Machine power flow results";
Machines machines;

replaceable record Trafos = Trafos_Data.PF_Trafos_00000 constrainedby Trafos_Data.Trafos_Template
                                                                         "Trafos power flow results";
Trafos trafos;

end PF_00000;
