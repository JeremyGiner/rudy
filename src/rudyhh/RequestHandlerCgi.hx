package rudyhh;
import haxe.io.Bytes;
import sys.io.Process;
import sys.net.Socket;
import sys.thread.Thread;
import rudyhh.RequestReader.State;
import sys.io.File;

/**
 * TODO: set env var instead : https://en.wikipedia.org/wiki/Common_Gateway_Interface
 * @author 
 */
class RequestHandlerCgi implements IRequestHandler {

	var _oParentThread :Thread;
	var _sCommand :String;
	
	public function new( sCommand :String ) {
		_oParentThread = Thread.current();
		_sCommand = sCommand;
	}
	
	public function handle( oClientSocket :Socket ) {//TODO : return child thread or something
		//Thread.create( this.main );
		main( oClientSocket );
	}
	
	public function main( oClientSocket :Socket ) {
		// Read request
		var oReader = new RequestReader( oClientSocket.input );
		while (oReader.read() != State.Done ){}
		trace('redaing done');
		var oRequest = oReader.createRequest();

		var bHasBody = (oRequest.getBody() != null);
		
		// Delegate to program
		//TODO : redirect error stream into log file
		var oProcess = new Process( _sCommand, [
			oRequest.getMethod(), 
			oRequest.getUri(), 
			oRequest.getHttpVersion(), 
			(bHasBody ? Std.string(oRequest.getBody().length) : '0' ), 
		]); 
		
		
		
		if ( bHasBody ) // TODO use const
			oProcess.stdin.write( oRequest.getBody() );
		
		// Retrieve response
		var oResponse :Bytes = null;
		
		trace('waiting process');
		do {
			oResponse = oProcess.stdout.readAll();
		} while ( oProcess.exitCode( false ) == null ); // might not be really necessary
		oProcess.close();
		
		
		// Write to client
		if( oResponse.length == 0)
			throw 'TODO: handle error';
		//trace(StringTools.urlEncode(Std.string(oResponse)));
		
		// temporary fix haxe issue
		oResponse = Bytes.ofString( StringTools.replace(oResponse.toString(), "\r\n", "\n") );
		
		trace('done');
		
		//trace( StringTools.urlEncode("HTTP/1.1 404 Not found\r\nContent-Type: text/html\r\nContent-Length: 22\r\n\r\nSysError(Can't read /)"));
		oClientSocket.output.write( oResponse );
		oClientSocket.output.flush();
		
		oClientSocket.close();
	}
	
}