package rudyhh;
import sys.io.Process;
import sys.net.Socket;
import sys.thread.Thread;
import rudyhh.RequestReader.State;
import sys.io.File;

/**
 * ...
 * @author 
 */
class RequestHandler implements IRequestHandler {

	var _oParentThread :Thread;
	var _oClientSocket :Socket;
	var _sCommand :String;
	
	public function new( sCommand :String ) {
		_oParentThread = Thread.current();
		_oClientSocket = null;
		_sCommand = sCommand;
	}
	
	public function handle( oClientSocket :Socket ) {//TODO : return child thread or something
		_oClientSocket = oClientSocket;
		Thread.create( this.main );
	}
	
	public function main() {
		// write std
		
		
		
		//TODO get uri
		var oReader = new RequestReader( _oClientSocket.input );
		while (oReader.read() != State.HeaderMap ){}
		var oRequest = oReader.createRequest();
		
		// Delegate to program
		var oProcess = new Process( _sCommand, [oRequest.getMethod(), oRequest.getUri(), oRequest.getHttpVersion()]); 
		if( oRequest.getBody() != null )
			oProcess.stdin.write( oRequest.getBody() );
		
		oProcess.exitCode( true );
		var oResponseBody = oProcess.stdout.readAll();
		
		// Write to client
		_oClientSocket.output.writeString( (new ResponseHeader(oResponseBody.length)).toString() );
		_oClientSocket.output.write( oResponseBody );
		_oClientSocket.output.flush();
		
		_oClientSocket.close();
	}
	
}