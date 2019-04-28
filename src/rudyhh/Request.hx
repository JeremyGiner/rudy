package rudyhh;
import haxe.io.Bytes;

/**
 * ...
 * @author 
 */
class Request {

	var _sMethod :String;
	var _sUri :String;
	var _sHttpVersion :String;
	
	var _mHeader :Map<String,String>;
	
	var _oBody :Bytes;
	
	
	public function new() {
		
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
	
	
	
}