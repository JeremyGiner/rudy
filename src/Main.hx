package ;
import haxe.io.Eof;
import rudyhh.Server;
import sys.io.Process;
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Error;

/**
 * ...
 * @author 
 */
class Main {

	static public function main() {
		
		/*
		var _aSocketDistant = new List<Socket>();
		
		var _oSocketMaster = new Socket();
		_oSocketMaster.bind( new Host( 'localhost' ), 8000);
		_oSocketMaster.setBlocking( false );
		_oSocketMaster.listen( 9999 );
		
		while(true) {
			
			// Accepting socket
			var oSocketDistant = _oSocketMaster.accept();
			if ( oSocketDistant != null ) {
				trace( 'opening : ' + oSocketDistant.peer() );
				oSocketDistant.setBlocking( false );
				_aSocketDistant.add( oSocketDistant );
			}
			
			// Trying to read from each socket 
			for ( oSocketDistant in _aSocketDistant ) {
				try {
					Sys.print( oSocketDistant.input.readString(1) );
				} catch ( e :Dynamic ) {
					if ( e != Error.Blocked )
						throw e;
				}
			}
		
		}
		*/
		var oServer = new MyServer();
		
		while ( oServer.process() ){}
	}
	
}

private class MyServer extends Server {
	
	var _mProcess :Map<Socket,Process>;
	
	override public function new( 
		sHost :String = 'localhost', 
		iPort :Int = 8000
	){
		super( sHost, iPort );
		
		_mProcess = new Map<Socket,Process>();
	}
	
	override function _onOpen( oSocket :Socket ) {
		trace( 'opening : ' + oSocket.peer() );
		//oSocket.write( 'hi' );
		
		_mProcess.set( oSocket, new Process( 'hl build/RudyClientHandler.hl' ) );
	}
	override function _onMessage( oSocket :Socket, sMessage :String ) {
		trace( oSocket.peer() + ' says :' );
		trace( sMessage );
		
		var oProcess = _mProcess.get( oSocket );
		
		// Process already finished
		if ( oProcess.exitCode( false ) != null )
			return;
		
		oProcess.stdin.writeString( sMessage );
	}
	override function _onClose( oSocket :Socket ) {
		if ( !_mProcess.exists( oSocket ) )
			return;
		_mProcess.get( oSocket ).close();
		_mProcess.remove( oSocket );
		trace( 'closing : '+oSocket.peer() );
	}
	
	override function process() {
		
		//Sys.sleep( 1 );
		//var mProcess = new Map<Socket,Process>();
		for ( oSocket => oProcess in _mProcess ) {
			
			// Skip still running process
			if ( oProcess.exitCode(false) == null )
				continue;
		
			var sMessage = '';
			try {
				while ( true ) {
					oSocket.output.writeByte( oProcess.stdout.readByte() );
				}
			} 
			catch ( e :Eof ) {
				trace('ClientHandler end response');
				oSocket.close();
				_onClose( oSocket );
			}
			catch ( e :Dynamic ) {
				
				trace(sMessage);
				
				if ( e != Error.Blocked )
					throw e;
			}
			trace(sMessage);
			
			var sMessage = '';
			try {
				while( true )
					sMessage += oProcess.stderr.readString(1);
			} 
			catch ( e :Eof ) {
				if( sMessage.length != 0 )
					trace('Error : '+sMessage);
				_mProcess.remove( oSocket ); 
			}
			catch ( e :Dynamic ) {
				trace(e);
				if ( e != Error.Blocked )
					throw e;
				
				//todo handle eof
			}
			trace( sMessage );
		}
		return super.process();
	}
}