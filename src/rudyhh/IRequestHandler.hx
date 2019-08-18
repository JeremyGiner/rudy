package rudyhh;
import sys.net.Socket;

/**
 * @author 
 */
interface IRequestHandler {
	public function handle( oClientSocket :Socket ) :Void;//TODO : return child thread or something
}