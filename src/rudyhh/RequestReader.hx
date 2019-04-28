package rudyhh;
import haxe.io.Input;
import haxe.io.Error;

/**
 * ...
 * @author 
 */
class RequestReader {

	var _sBuffer :String;
	var _oInput :Input;
	
	public function new( oInput :Input ) {
		_oInput = oInput;
	}
	
	public function read() {
		
	}
	
	public function _readUntil( sDelimiter :String, iMaxLength :Int ) {
		
			var s = null;
			while ( true  ){
				
				try {
					s = _oInput.readString( 1 );
				} catch ( e :Dynamic ) {
					if ( e == Error.Blocked ) {
						return null;
					}
					throw e;
				}
				
				_sBuffer += s;
				
				var i = _sBuffer.lastIndexOf( sDelimiter );
				
				if ( i != -1 )
					return _sBuffer.substring( 0, i );
				
				if ( _sBuffer.length + 1 == iMaxLength )
					return null;
			}
		
		
	}
}