package rudyhh;
import haxe.io.Error;
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Eof;
import sys.thread.Thread;

/**
 * ...
 * @author 
 */
class Server {

		
	var _bRunning :Bool;
	
	var _sHost :String;
	var _iPort :Int;
	
	var _oSocketMaster :Socket;
	
	var _iConnectionMax = 500;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( 
		sHost :String = 'localhost', 
		iPort :Int = 8000,
		oSocket :Socket = null
	){
		//TODO : check host/port
		_sHost = sHost;
		_iPort = iPort;
		_bRunning = false;
		
		
		_bRunning = true;
		
		
		_oSocketMaster = oSocket == null ? new Socket() : oSocket;
		_oSocketMaster.bind( new Host( _sHost ), _iPort);
		_oSocketMaster.setBlocking( false );
		_oSocketMaster.listen( _iConnectionMax );
	}
	
//______________________________________________________________________________
//	Accessor

	public function running_check(){ return _bRunning; }
	
	public function process() {
		if ( !_bRunning ) throw('[ERROR] Server : Server not started yet');
		
		// Acknowledge new client (if available)
		_socketAccept_process();
		
		return true;
	}
//______________________________________________________________________________
//	Sub-routine

	/**
	 * Acknowledge new client (if available)
	 */
	function _socketAccept_process() {
		
		// Get new raw distant socket from master
		//trace('accepting socket');
		var oSocketDistant = _oSocketMaster.accept();
		
		// Case : no new socket available
		if ( oSocketDistant == null )
			return;
		
		new RequestHandler( oSocketDistant );
	}
	
}