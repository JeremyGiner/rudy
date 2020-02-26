package rudyhh;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import sweet.ribbon.tool.BytesTool;

/**
 * TODO use bytes?
 * @author 
 */
class Response {
	var _sVersion :String;
	var _iCode :Int;
	var _sReasonPhrase :String;
	var _oBody :Bytes;
	var _mHeader :StringMap<String>;
	
	public static var CONTENT_LENGTH_KEY = 'Content-Length';
	public static var CONTENT_TYPE_KEY = 'Content-Type';
	public static var E_TAG_KEY = 'ETag';
	public static var CRLF = "\r\n";
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( 
		iCode :Int = 200, 
		sReasonPhrase :String = 'OK'
	) {
		_oBody = null;
		
		_sVersion = 'HTTP/1.1';
		_iCode = iCode;
		_sReasonPhrase = sReasonPhrase;
		_mHeader = new StringMap();
	}
	
	static public function createSimple( 
		iCode :Int = 200, 
		sReasonPhrase :String = 'OK',
		sBody :String = null 
	) {
		var o = new Response(iCode, sReasonPhrase );
		if( sBody != null )
			o.setContent( Bytes.ofString(sBody) );
		return o;
	}
	
		
	static public function create500( sBody :String = "" ) {
		return createSimple(500, 'Server internal error',sBody);
	}
	
	static public function create403() {
		return createSimple(403, 'Access denied');
	}
	
	static public function create404( sBody :String = "" ) {
		return createSimple(404, 'Not found',sBody);
	}
	
	static public function create304() {
		return createSimple(304, 'Not modified');
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
	
	// TODO put opitonnal directive into param object 
	public function addCookie( 
		sKey :String, sValue :String, 
		bHttpOnly :Bool, bSecure :Bool = false 
	) {
		setHeader('Set-Cookie', sKey + '=' + sValue+(bHttpOnly?'; HttpOnly':'') );
		//TODO : handle multiple headers set cookie
	}
	
	public function setContent( o :Bytes = null, sType = 'text/html' ) {
		_oBody = o;
		
		if ( _oBody ==null || _oBody.length == 0 ) {
			removeHeader(CONTENT_LENGTH_KEY);
			removeHeader(CONTENT_TYPE_KEY);
			return;
		}
		
		setHeader(CONTENT_LENGTH_KEY, Std.string(_oBody.length) );
		setHeader(CONTENT_TYPE_KEY,sType);
	}
	
//_____________________________________________________________________________
//	Process
	
	public function toString() {
		return _sVersion + ' ' + _iCode + ' ' + _sReasonPhrase + CRLF
			+ _printHeader()
			+ CRLF
			+ (_oBody != null ? _oBody.toString() : '')
		;
	}
	
	public function toBytes() {
		
		var l = new List<Bytes>();
		l.add(Bytes.ofString(_sVersion + ' ' + _iCode + ' ' + _sReasonPhrase + CRLF));
		l.add(Bytes.ofString(_printHeader() + CRLF));
		if( _oBody != null )
			l.add(_oBody);
		
		return BytesTool.joinList( l );
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