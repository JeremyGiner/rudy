package rudyhh;
import haxe.ds.StringMap;

/**
 * TODO use bytes?
 * @author 
 */
class Response {
	var _sVersion :String;
	var _iCode :Int;
	var _sReasonPhrase :String;
	var _sBody :String;
	var _mHeader :StringMap<String>;
	
	public static var CONTENT_LENGTH_KEY = 'Content-Length';
	public static var CONTENT_TYPE_KEY = 'Content-Type';
	public static var E_TAG_KEY = 'ETag';
	public static var CRLF = "\r\n";
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( 
		iCode :Int = 200, 
		sReasonPhrase :String = 'OK',
		sBody = ""
	) {
		_sBody = sBody;
		
		_sVersion = 'HTTP/1.1';
		_iCode = iCode;
		_sReasonPhrase = sReasonPhrase;
		_mHeader = new StringMap();
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function setHeader( sKey :String, sValue :String ) {
		_mHeader.set( sKey, sValue );
	}
	
	public function removeHeader( sKey :String ) {
		_mHeader.remove( sKey );
	}
	
	public function setCacheControl( i :Int ) {
		throw 'TODO';
	}
	
	public function setETag( s :String ) {
		setHeader(E_TAG_KEY,s);
	}
	
	public function setContent( s :String, sType = 'text/html' ) {
		_sBody = s;
		
		if ( _sBody.length == 0 ) {
			removeHeader(CONTENT_LENGTH_KEY);
			removeHeader(CONTENT_TYPE_KEY);
			return;
		}
		
		setHeader(CONTENT_LENGTH_KEY, Std.string(_sBody.length) );
		setHeader(CONTENT_TYPE_KEY,sType);
	}
	
//_____________________________________________________________________________
//	Process
	
	public function toString() {
		return _sVersion + ' ' + _iCode + ' ' + _sReasonPhrase + CRLF
			+ _printHeader()
			+ CRLF
			+ _sBody
		;
	}
//_____________________________________________________________________________
//	Factory
	
	static public function create500( sBody :String = "" ) {
		var o = new Response(500, 'Server internal error');
		o.setContent( sBody );
		return o;
	}
	
	static public function create403() {
		return new Response(403, 'Access denied');
	}
	
	static public function create404( sBody :String = "" ) {
		var o = new Response(404, 'Not found');
		o.setContent( sBody );
		return o;
	}
	
	static public function create304() {
		var o = new Response(304, 'Not modified');
		return o;
	}
	
	
	
//_____________________________________________________________________________
//	Sub-routine
	
	private function _printHeader() {
		var s = '';
		for ( sKey => sValue in _mHeader ) 
			s += sKey + ': ' + sValue + CRLF;
		return s;
	}
}