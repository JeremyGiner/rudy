package rudyhh;
import sys.net.Socket;
import sys.thread.Thread;
import rudyhh.RequestReader.State;
import sys.io.File;

/**
 * ...
 * @author 
 */
class RequestHandler {

	var _oParentThread :Thread;
	var _oClientSocket :Socket;
	
	public function new( oClientSocket :Socket ) {
		_oParentThread = Thread.current();
		_oClientSocket = oClientSocket;
		Thread.create( this.main );
	}
	
	public function main() {
		// write std
		
		
		
		//TODO get uri
		var oReader = new RequestReader( _oClientSocket.input );
		while (oReader.read() != State.HeaderMap ){}
		var oRequest = oReader.createRequest();
		
		var s = File.getContent('res/index.html');
		
		_oClientSocket.output.writeString( (new ResponseHeader(s.length)).toString() );
		
		
		//Sys.println( oRequest.getUri() );
		_oClientSocket.output.writeString( s );
		_oClientSocket.output.flush();
		
		Sys.sleep( 2 );
		
		_oClientSocket.close();
	}
	
}