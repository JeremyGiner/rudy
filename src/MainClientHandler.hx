package ;
import rudyhh.RequestReader;
import rudyhh.Response;
import rudyhh.RequestReader.State;
import sys.io.File;

/**
 * ...
 * @author 
 */
class MainClientHandler {

	static public function main() {
		
		// write std
		Sys.print( new Response() );
		
		//TODO get uri
		var oReader = new RequestReader( Sys.stdin() );
		while (oReader.read() != State.HeaderMap ){}
		var oRequest = oReader.createRequest();
		
		
		//Sys.println( oRequest.getUri() );
		Sys.print( File.getContent('build/res/index.html') );
	}
	
}
