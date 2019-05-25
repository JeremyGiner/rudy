package rudyhh;
import haxe.Json;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import haxe.io.Eof;
import haxe.io.Input;
import haxe.io.Error;

/**
 * ...
 * @author 
 */
class RequestReader {

	var _oInput :Input;
	
	var _iState :Int;
	
	var _aSubReader :Array<ReadingPattern>; 
	
	var _oRequestParam :Map<String,Dynamic>;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oInput :Input ) {
		_oInput = oInput;
		_iState = 0;
		_oRequestParam = new Map<String,Dynamic>();
		
		_aSubReader = [
			{ oReader: new ReaderStringSegment(' ', 10), sKey: 'Method', oState: Begin  },
			{ oReader: new ReaderStringSegment(' ', 2083), sKey: 'Uri', oState: Method },
			{ oReader: new ReaderStringSegment("\n", 8000), sKey: 'Version', oState: Uri },
			{ oReader: new ReaderHeaderMap("\n\n", 9000), sKey: 'HeaderMap', oState: HeaderMap },
			{ oReader: new ReaderBody( this ), sKey: 'Body', oState: Body },
		];
	}
	
//_____________________________________________________________________________
//	Accessor

	public function getState() {
		if ( _iState == _aSubReader.length )
			return Done;
		return _aSubReader[_iState].oState;
	}
	
	public function getHeaderMap() :Map<String,String> {
		return _oRequestParam.get('HeaderMap');
	}

//_____________________________________________________________________________
//	Factory

	public function createRequest() {
		// todo 
		return new Request(
			_oRequestParam.get('Method'),
			_oRequestParam.get('Uri'),
			_oRequestParam.get('Version'),
			_oRequestParam.get('HeaderMap'),
			_oRequestParam.get('Body')
		);
	}
	
//_____________________________________________________________________________
//	Process
	
	public function read() :State {
		
		if ( getState() == Done )
			throw 'reading request done, nothing left to read';
		
		var oReadingPattern = _aSubReader[_iState];
		
		var o = null;
		//try {
			
			o = oReadingPattern.oReader.read( _oInput );
		/*} catch ( e :Dynamic ) {
			// Case : not ready to complete reading yet
			if ( e == Error.Blocked ) {
				return getState();
			}
			// Case : too large
			if ( e == ReaderError.TOO_LARGE )
				throw 'request too large while reading ' + getState;
			throw e;
		}*/
		
		_oRequestParam.set( 
			oReadingPattern.sKey, 
			o
		);
		
		_iState++;
			
		return getState();
	}
	

}
enum State {
	Begin;
	Method;
	Uri;
	HttpVersion;
	HeaderMap;
	Body;
	Done;
}
typedef ReadingPattern = {
	var oReader :IReader;
	var sKey :String;
	var oState :State;
}
interface IReader {
	/**
	 * Read until delimiter is found, max length is reach or eof
	 * Delimiter is not part of the result
	 * @param	sDelimiter
	 * @param	iMaxLength
	 * @return string read or null if blocked
	 * @throws Blocked execption 
	 */
	public function read( oInput :Input ) :Dynamic;
}

enum ReaderError {
	TOO_LARGE;
}

class ReaderStringSegment implements IReader {
	
	var _sDelimiter :Null<String>;
	var _iMaxLength :Int;
	var _sBuffer :String;
	
	public function new( sDelimiter :Null<String>, iMaxLength :Int ) {
		_sDelimiter = sDelimiter; 
		_iMaxLength = iMaxLength;
		_sBuffer = '';
	}
	/**
	 * Read until delimiter is found, max length is reach or eof
	 * Delimiter is not part of the result
	 * @param	sDelimiter
	 * @param	iMaxLength
	 * @return string read or null if blocked
	 */
	public function read( oInput :Input ) :Dynamic {
		
		var s = null;
		while ( true  ){
			
			try {
				s = oInput.readString( 1 );
				//trace(s + ':' + StringTools.hex( s.charCodeAt(0)));
			} catch ( e :Eof  ) {
				throw e;
			} 
			
			_sBuffer += s;
			
			var i = _sBuffer.lastIndexOf( _sDelimiter );
			
			if ( i != -1 ) {
				var tmp =  _sBuffer.substring( 0, i );
				_sBuffer = '';
				return tmp.substring( 0, i );
			}
			
			if ( _sBuffer.length + 1 == _iMaxLength )
				throw ReaderError.TOO_LARGE;
		}
		
		
	}
}

class ReaderHeaderMap extends ReaderStringSegment {
	override function read( oInput :Input ) {
		return _readHeaderMap( super.read( oInput ) );
	}
	
	static function _readHeaderMap( s :Null<String> ) :Map<String,String> {
		
		if (s == null)
			return null;
		
		var m = new StringMap<String>();
		var aHeader = s.split("\n");
		for ( s in aHeader ) {
			var a = s.split(': ');
			m.set( a[0], a.length > 1 ? a[1] : null );//TODO: remove case sensitiveness
		}
		return m;
	}
}

class ReaderBody implements IReader {
	
	var _oRequestReader :RequestReader;
	
	public function new( oRequestReader :RequestReader ) {
		_oRequestReader = oRequestReader;
	}
	
	public function read( oInput :Input ) :Dynamic {
		var oHeaderMap = _oRequestReader.getHeaderMap();
		//TODO : handle headermap not read yet exception
		
		var iLength = Std.parseInt( oHeaderMap.get('Content-Length') );//TODO: remove case sensitiveness
		
		// Case : no legnth no body
		if ( iLength == null )
			return null;
		
		var sEncoding = oHeaderMap.get('Content-Encoding'); //TODO: handle encoding
		
		// Get body as string
		var s = oInput.readString( iLength );	// TODO : handle blocking exception
		
		
		
		var sType = oHeaderMap.get('Content-Type');
		
		if ( sType != 'application/json' ) {
			throw 'content type "' + sType+'" not supported';
		}
		
		return Json.parse( s );
		
		// TODO : handle form
		
		/*
		switch( sType ) {
			'text/plain': return s;
			'application/x-www-form-urlencoded' :
		// url decode
		
		// parse data
			
		}
		*/
	}
	
}