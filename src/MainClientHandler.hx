package ;
import rudyhh.RequestReader;
import rudyhh.Response;
import sys.io.File;

/**
 * ...
 * @author 
 */
class MainClientHandler {

	static public function main() {
		
		//TODO get uri
		//var oReader = new RequestReader( Sys.stdin() );
		//oReader.read()
		
		
		// write std
		
		Sys.print( new Response() );
		Sys.print( File.getContent('build/res/index.html') );
	}
	
}
