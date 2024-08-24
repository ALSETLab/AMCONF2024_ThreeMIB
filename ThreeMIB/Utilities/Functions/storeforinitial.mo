within ThreeMIB.Utilities.Functions;
function storeforinitial
  extends Modelica.Icons.Function;
  input String dsName="dsin.txt" "file name to assign to dsName in exportInitial";
  input String scriptName="scriptInitial.mo" "script name to assgine to scriptName in exportInitial";
algorithm
    Modelica.Utilities.Streams.print("Saving file for initialization at given snapshot.");
    DymolaCommands.SimulatorAPI.exportInitial(dsName,scriptName);
  annotation (Documentation(info="<html>
<p><span style=\"font-family: Segoe UI;\">This function will store the initialization data for a given snapshot as a .most script.</span></p>
<p><span style=\"font-family: Segoe UI;\">The user should enter the name of the text file that will include the initialization data, and of a .mos script that will be used to re-use the intialization data.</span></p>
<p><span style=\"font-family: Segoe UI;\">This is a Dymola specific function that uses the following function from the DymolaCommands library:</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #ff0000;\">&nbsp;&nbsp;DymolaCommands.SimulatorAPI.exportInitial</span>(dsName,scriptName);</p>
<p><br><i>Usage:</i></p>
<p>The user can run the model up to any point in time and execute this function to store the snapshot.</p>
</html>"));
end storeforinitial;
