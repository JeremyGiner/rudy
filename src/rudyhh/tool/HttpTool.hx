package rudyhh.tool;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class HttpTool {

	static var _mContentTypeByExt :StringMap<String> = [
'aac' =>'audio/aac', // audio/aac
'abw' =>'application/x-abiword', // application/x-abiword
'arc' =>'application/x-freearc', // application/x-freearc
'avi' =>'video/x-msvideo', // video/x-msvideo
'azw' =>'application/vnd.amazon.ebook', // application/vnd.amazon.ebook
'bin' =>'application/octet-stream', // application/octet-stream
'bmp' =>'image/bmp', // image/bmp
'bz' =>'application/x-bzip', // application/x-bzip
'bz2' =>'application/x-bzip2', // application/x-bzip2
'csh' =>'application/x-csh', // application/x-csh
'css' =>'text/css', // text/css
'csv' =>'text/csv', // text/csv
'doc' =>'application/msword', // application/msword
'docx' =>'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // application/vnd.openxmlformats-officedocument.wordprocessingml.document
'eot' =>'application/vnd.ms-fontobject', // application/vnd.ms-fontobject
'epub' =>'application/epub+zip', // application/epub+zip
'gz' =>'application/gzip', // application/gzip
'gif' =>'image/gif', // image/gif
'htm' =>'text/html', // text/html
'html' =>'text/html', // text/html
'ico' =>'image/vnd.microsoft.icon', // image/vnd.microsoft.icon
'ics' =>'text/calendar', // text/calendar
'jar' =>'application/java-archive', // application/java-archive
'jpeg' =>'image/jpeg', // image/jpeg
'jpg' =>'image/jpeg', // image/jpeg
'js' =>'text/javascript', // text/javascript
'json' =>'application/json', // application/json
'jsonld' =>'application/ld+json', // application/ld+json
'mid' =>'audio/midi audio/x-midi', // audio/midi audio/x-midi
'midi' =>'audio/midi audio/x-midi', // audio/midi audio/x-midi
'mjs' =>'text/javascript', // text/javascript
'mp3' =>'audio/mpeg', // audio/mpeg
'mpeg' =>'video/mpeg', // video/mpeg
'mpkg' =>'application/vnd.apple.installer+xml', // application/vnd.apple.installer+xml
'odp' =>'application/vnd.oasis.opendocument.presentation', // application/vnd.oasis.opendocument.presentation
'ods' =>'application/vnd.oasis.opendocument.spreadsheet', // application/vnd.oasis.opendocument.spreadsheet
'odt' =>'application/vnd.oasis.opendocument.text', // application/vnd.oasis.opendocument.text
'oga' =>'audio/ogg', // audio/ogg
'ogv' =>'video/ogg', // video/ogg
'ogx' =>'application/ogg', // application/ogg
'opus' =>'audio/opus', // audio/opus
'otf' =>'font/otf', // font/otf
'png' =>'image/png', // image/png
'pdf' =>'application/pdf', // application/pdf
'php' =>'application/php', // application/php
'ppt' =>'application/vnd.ms-powerpoint', // application/vnd.ms-powerpoint
'pptx' =>'application/vnd.openxmlformats-officedocument.presentationml.presentation', // application/vnd.openxmlformats-officedocument.presentationml.presentation
'rar' =>'application/x-rar-compressed', // application/x-rar-compressed
'rtf' =>'application/rtf', // application/rtf
'sh' =>'application/x-sh', // application/x-sh
'svg' =>'image/svg+xml', // image/svg+xml
'swf' =>'application/x-shockwave-flash', // application/x-shockwave-flash
'tar' =>'application/x-tar', // application/x-tar
'tif' =>'image/tiff', // image/tiff
'tiff' =>'image/tiff', // image/tiff
'ts' =>'video/mp2t', // video/mp2t
'ttf' =>'font/ttf', // font/ttf
'txt' =>'text/plain', // text/plain
'vsd' =>'application/vnd.visio', // application/vnd.visio
'wav' =>'audio/wav', // audio/wav
'weba' =>'audio/webm', // audio/webm
'webm' =>'video/webm', // video/webm
'webp' =>'image/webp', // image/webp
'woff' =>'font/woff', // font/woff
'woff2' =>'font/woff2', // font/woff2
'xhtml' =>'application/xhtml+xml', // application/xhtml+xml
'xls' =>'application/vnd.ms-excel', // application/vnd.ms-excel
'xlsx' =>'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
'xml' =>'application/xml if not readable from casual users (RFC 3023, section 3)', // application/xml if not readable from casual users (RFC 3023, section 3)
//text/xml if readable from casual users (RFC 3023, section 3)
'xul' =>'application/vnd.mozilla.xul+xml', // application/vnd.mozilla.xul+xml
'zip' =>'application/zip', // application/zip
'3gp' =>'video/3gpp', // video/3gpp
//audio/3gpp if it doesn't contain video
'3g2' =>'video/3gpp2', // video/3gpp2
//audio/3gpp2 if it doesn't contain video
'7z' =>'application/x-7z-compressed', // application/x-7z-compressed
		];
	
	static public function getContentTypeByExt( s :String ) {
		var sContentType = _mContentTypeByExt.get( s );
		if ( sContentType == null )
			return'text/plain';
		return sContentType;
	}
}