package ;
import haxe.io.Eof;
import rudyhh.Server;
import sys.io.Process;
import sys.net.Host;
import sys.net.Socket;
import sys.ssl.Certificate;
import sys.ssl.Key;
import sys.ssl.Socket in SocketSSL;
import haxe.io.Error;
import sys.thread.Thread;
import sys.io.File;

/**
 * ...
 * @author 
 */
class Main {

	static public function main() {
		
		/*
		var oCurrent = Thread.current();
		var o = Thread.create(function() {
			trace('hello');
			File.saveContent('toto', 'HELLO');
			oCurrent.sendMessage('DIE');
		});
		var s = Thread.readMessage();
		trace('end :'+s);
		return;
		*/
		
		/*
		var _aSocketDistant = new List<Socket>();
		
		
		var _oSocketMaster =  new SocketSSL();
		_oSocketMaster.setCA(Certificate.loadFile('ssl/homeplanet.pem'));
		_oSocketMaster.setCertificate( 
			Certificate.loadFile('ssl/homeplanet.pem'), 
			Key.loadFile('ssl/homeplanet.key', false, 'homeplanet') 
		);
		_oSocketMaster.setHostname('localhost');
		
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
		//SocketSSL.DEFAULT_CA = Certificate.loadFile('ssl/homeplanet.crs');
		
		var oSocket =  new SocketSSL();
		oSocket.setCA(Certificate.loadFile('ssl/homeplanet.pem'));
		oSocket.setCertificate( 
			Certificate.loadFile('ssl/homeplanet.pem'), 
			Key.loadFile('ssl/homeplanet.key', false, 'homeplanet') 
		);
		oSocket.setHostname('localhost');
		oSocket.verifyCert = false;
		var oServerSSL = new MyServer('localhost', 443, oSocket );
		
		while ( true ){
			oServer.process();
			//oServerSSL.process(); 
		}
	}
	
}

private class MyServer extends Server {
	
	override public function new( 
		sHost :String = 'localhost', 
		iPort :Int = 8000,
		oSocket :Socket = null
	){
		super( sHost, iPort, oSocket );
	}
}