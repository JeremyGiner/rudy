package;
import sys.io.Process;

/**
 * ...
 * @author 
 */
class Test {

	static public function main() {
		// Delegate to program
		var oProcess = new Process( "test_out.bat", []); 
		var s = oProcess.stdout.readAll();
		trace( StringTools.urlEncode(s.toHex()) );
		trace( StringTools.urlEncode(s.toString()) );
		trace( oProcess.exitCode( false ) );
	}
	
}