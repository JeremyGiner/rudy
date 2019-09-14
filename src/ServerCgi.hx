package ;
import haxe.io.Eof;
import rudyhh.RequestHandlerCgi;
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
import haxe.Json;
import haxe.io.Path;

/**
 * ...
 * @author 
 */
class ServerCgi {

	static public function main() {
		
		// Get config path
		var sConfigPath = "config.json";
		if ( Sys.args().length == 1 ) {
			sConfigPath = Sys.args()[0];
		}
		
		
		Sys.println( 'Loading config "'+sConfigPath+'"' );
		var oConfig = Json.parse( File.getContent( sConfigPath ) );
		
		var oServer = new Server( oConfig.address, Std.parseInt( oConfig.port ), new RequestHandlerCgi( oConfig.delegate ) );
		//SocketSSL.DEFAULT_CA = Certificate.loadFile('ssl/homeplanet.crs');
		/*
		var oSocket =  new SocketSSL();
		oSocket.setCA(Certificate.loadFile('ssl/homeplanet.pem'));
		oSocket.setCertificate( 
			Certificate.loadFile('ssl/homeplanet.pem'), 
			Key.loadFile('ssl/homeplanet.key', false, 'homeplanet') 
		);
		oSocket.setHostname('localhost');
		oSocket.verifyCert = false;
		var oServerSSL = new MyServer('localhost', 443, oSocket );
		*/
		Sys.println( 'Server running...' );
		while ( true ){
			oServer.process();
			//oServerSSL.process(); 
		}
	}
	
}