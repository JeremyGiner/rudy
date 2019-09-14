package handler_demo;
import rudyhh.RequestReader;
import rudyhh.Response;
import sys.io.Process;
import sys.io.File;
import haxe.io.Bytes;

/**
 * ...
 * @author 
 */
class HandlerDemo {

	static public function main() :Void {
		if(Sys.args().length != 4)
			throw 'invallid argument count :'+Sys.args().length;
		// Read Request from sys
		var sMethod = Sys.args()[0];
		var sUri = Sys.args()[1];	//removing leading slash
		var sHttpVersion = Sys.args()[2];
		var iContentLength = Std.parseInt(Sys.args()[3]);
		
		if( iContentLength > 0 )
			var oRequestBody = Sys.stdin().readString(iContentLength);
		
		if ( sUri.length > 2 )
			sUri = sUri.substring(1);
		if (sUri == '/' )
			sUri = '/index.html';
		
		// Get file from URI
		var oResponse :Response = null;
		try {
			oResponse = Response.create( 
				File.getContent( 'res'+sUri ), 
				getContentTypeFromUri( sUri ) 
			);
		} catch ( e :Dynamic ) {
			oResponse = Response.create404(e);
		}
		
		// Send Response
		Sys.stdout().writeString( oResponse.toString() );
	}
	
	static public function getContentTypeFromUri( sUri :String ) {
		
		switch( sUri.substr( -3) ) {
			case '.js': return 'application/javascript';
			//TODO: image, video, etc
		}
		return 'text/html';
	}
	
}