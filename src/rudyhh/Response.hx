package rudyhh;

/**
 * HTTP response
 * @author 
 */
class Response {

	var _sVersion :String;
	var _iCode :Int;
	var _sReasonPhrase :String;
	var _mHeader :Map<String,String>;
	
	public function new() {
		
		_sVersion = 'HTTP/1.1';
		_iCode = 200;
		_sReasonPhrase = 'OK';
		_mHeader = [
			'Content-Type' => 'text/html',
		];
	}
	
	
	public function toString() {
		//TODO : print directly into out stream
		return _sVersion + ' ' + _iCode + ' ' + _sReasonPhrase + "\r\n"
			+ _printHeader()
			+ "\r\n"
		;
	}
	
	private function _printHeader() {
		var s = '';
		for ( sKey => sValue in _mHeader ) s += sKey + ': ' + sValue + "\r\n";
		return s;
	}
}