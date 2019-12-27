package rudyhh;
import haxe.ds.StringMap;
import haxe.io.Bytes;

/**
 * ...
 * @author 
 */
class Request {

	var _sMethod :Null<String>;
	var _sUri :Null<String>;
	var _sHttpVersion :Null<String>;
	
	var _mHeader :Map<String,String>;
	
	var _oBody :Dynamic;
	
	public function new(
		sMethod :String = null,
		sUri :String = null,
		sHttpVersion :String = null,
		mHeader :Map<String,String> = null,
		oBody :Dynamic = null
	) {
		_sMethod = sMethod;
		_sUri = sUri;
		_sHttpVersion = sHttpVersion;
		_mHeader = mHeader;
		_oBody = oBody;
	}
	
	public function getMethod() {
		return _sMethod;
	}
	
	public function getUri() {
		return _sUri;
	}
	
	public function getHttpVersion() {
		return _sHttpVersion;
	}
	
	public function getBody() :Dynamic {
		return _oBody;
	}
	
	public function getHeader( sKey :String ) {
		return _mHeader.get( sKey );
	}
	public function getHeaderMap() {
		return _mHeader;
	}
	
	public function getCookie( sKey ) :String {
		var sCookie = _mHeader.get('Cookie');
		
		if ( sCookie == null )
			return null;
		var a = sCookie.split(';');
		var m = new StringMap<String>(); 
		for ( sItem in a ) {
			var a = sItem.split('=');
			if ( a.length != 2 )
				continue;
			m.set( a[0], a[1]);
		}
		// TODO : cache m
		return m.get( sKey );
	}
	
	public function toString() {
		return 
			'Method: ' + _sMethod + "\n"
			+ 'URI: ' + _sUri+ "\n"
			+ 'HTTPVersion: ' + _sHttpVersion + "\n"
		;//TODO : header ans such
			
	}
}