package rudyhh;
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
		oBody :Bytes = null
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
	
	public function getBody() :Bytes {
		return _oBody;
	}
	
	
	
}