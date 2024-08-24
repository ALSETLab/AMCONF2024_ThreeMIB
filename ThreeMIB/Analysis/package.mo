within ThreeMIB;
package Analysis "Simulation and linearization models."
  extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>This package includes the main examples for linear analysis and simulation.</p>
<p>It includes three subpackages:</p>
<ul>
<li><span style=\"font-family: Courier New;\">LinearAnalysis</span>: shows how to linearize the model, simulate the obtained linear model and compare it against the nonlinear model&apos;s response.</li>
<li><span style=\"font-family: Courier New;\">NonlinSimulationsMultipleInputs</span>: shows how to introduce different types of input signals and perform simulations using the nonlinear model.</li>
<li><span style=\"font-family: Courier New;\">RedesignedControllerVerification</span>: simulation scenarios without additional input signals that aim to verify the response of the designed controller to a large load disturbance.</li>
</ul>
</html>"),preferredView = "info");
end Analysis;
