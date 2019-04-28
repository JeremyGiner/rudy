package rudyhh;
import haxe.io.Error;
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Eof;

/**
 * ...
 * @author 
 */
class Server {

		
	var _bRunning :Bool;
	
	var _sHost :String;
	var _iPort :Int;
	
	var _oSocketMaster :Socket;
	
	var _aSocketDistant :List<Socket>;
	
	var _iConnectionMax = 500;
	
//______________________________________________________________________________
//	Constructor
	
	public function new( 
		sHost :String = 'localhost', 
		iPort :Int = 8000
	){
		//TODO : check host/port
		_sHost = sHost;
		_iPort = iPort;
		_bRunning = false;
		
		_aSocketDistant = new List<Socket>();
		
		
		_bRunning = true;
		
		
		_oSocketMaster = new Socket();
		_oSocketMaster.bind( new Host( _sHost ), _iPort);
		_oSocketMaster.setBlocking( false );
		_oSocketMaster.listen( _iConnectionMax );
	}
//______________________________________________________________________________
//	Event handler

	function _onOpen( oSocket :Socket ) {
		throw 'Abstract method, override it';
	}
	/**
	 * Socket may already be closed
	 * @param	oSocket
	 * @param	sMessage
	 */
	function _onMessage( oSocket :Socket, sMessage :String ) {
		throw 'Abstract method, override it';
	}
	function _onClose( oSocket :Socket ) {
		throw 'Abstract method, override it';
	}
	
//______________________________________________________________________________
//	Accessor

	public function running_check(){ return _bRunning; }
	
	public function process() {
		if ( !_bRunning ) throw('[ERROR] Server : Server not started yet');
		
		// Acknowledge new client (if available)
		_socketAccept_process();
		
		// Process distant socket
		_socketMessage_process();
		
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
		
		oSocketDistant.setBlocking( false );
		
		// Turn the raw distant socket into proper object
		_aSocketDistant.push( oSocketDistant );
		
		// Trigger event
		//trace('[NOTICE] Server : new distant socket (#'+oSocketDistant.resource_get()+').');
		//trace(oSocketDistant);
		_onOpen(oSocketDistant);
	}
	
	/**
	 * Process distant socket
	 */
	function _socketMessage_process() {
		
		
		var aSocketDistantActive = new List<Socket>();
		
		var oSocketDistant :Socket;
		while ( (oSocketDistant = _aSocketDistant.pop()) != null ) {
			
			var sMessage = '';
			
			/*
			var o = oSocketDistant.input.readAll();
			if ( o.length == 0 )
				continue;
			trace( 'message ! ' + o.toHex() );
			continue;z
			*/
			var bIsOpen = true;
			
			try {
				while( true )
					sMessage += oSocketDistant.input.readString(1);
			} 
			catch ( e :Eof ) {
				trace('the end '+sMessage);
				//_mProcess.remove( oSocket ); 
				bIsOpen = false;
			}
			catch ( e :Dynamic ) {
				if ( e != Error.Blocked )
					throw e;
				//todo handle eof
			}
			
			// Keep on processing list
			if( bIsOpen )
				aSocketDistantActive.push( oSocketDistant );
			else 
				_onClose( oSocketDistant );
			
			// Delegate to message handler
			if ( sMessage.length != 0 )
				_onMessage( oSocketDistant, sMessage );
			
		}
		
		_aSocketDistant = aSocketDistantActive; // filter closed socket
	}
	
}