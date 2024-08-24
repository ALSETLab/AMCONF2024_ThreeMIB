within ThreeMIB.PF_Data;
record Power_Flow
extends Modelica.Icons.Record;

replaceable record PowerFlow = Power_Flow_Template constrainedby Power_Flow_Template
annotation(choicesAllMatching);

PowerFlow powerflow;

end Power_Flow;
