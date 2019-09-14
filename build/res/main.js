// Generated by Haxe 4.0.0-rc.3+c6ede59ca
(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var _g = new haxe_ds_StringMap();
	var value = new unveil_Template("Hello ::user.getName::");
	if(__map_reserved["/"] != null) {
		_g.setReserved("/",value);
	} else {
		_g.h["/"] = value;
	}
	new unveil_Unveil(new unveil_RouterDefault(_g));
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		var e1 = ((e) instanceof js__$Boot_HaxeError) ? e.val : e;
		return null;
	}
};
Reflect.isFunction = function(f) {
	if(typeof(f) == "function") {
		return !(f.__name__ || f.__ename__);
	} else {
		return false;
	}
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) {
			this.rh = { };
		}
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) {
			return null;
		} else {
			return this.rh["$" + key];
		}
	}
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g3 = 0;
			var _g11 = o.length;
			while(_g3 < _g11) {
				var i = _g3++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e1 ) {
			var e2 = ((e1) instanceof js__$Boot_HaxeError) ? e1.val : e1;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str1 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str1.length != 2) {
			str1 += ", \n";
		}
		str1 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str1 += "\n" + s + "}";
		return str1;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var unveil_RouterDefault = function(aTemplate) {
	this._aTemplate = aTemplate;
};
unveil_RouterDefault.__name__ = true;
unveil_RouterDefault.prototype = {
	getTemplate: function(oLocation) {
		var _this = this._aTemplate;
		var key = oLocation.pathname;
		if(__map_reserved[key] != null) {
			return _this.getReserved(key);
		} else {
			return _this.h[key];
		}
	}
};
var unveil_Template = function(s) {
	this._oContextHolder = { context : null, global : null};
	var a = s.split("::");
	var _mCache_h = { };
	var _a = [];
	var _g = 0;
	var _g1 = a.length;
	while(_g < _g1) {
		var i = _g++;
		if(i % 2 == 0) {
			_a.push(a[i]);
		} else {
			_a.push(new unveil_VPathAccessorProxy(new unveil_tool_VPathAccessor(a[i]),this._oContextHolder));
		}
	}
};
unveil_Template.__name__ = true;
unveil_Template.prototype = {
	render: function(oContext) {
		this._oContextHolder.context = oContext;
		var oBuffer_b = "";
		var _g = 0;
		var _g1 = this._a;
		while(_g < _g1.length) {
			var o = _g1[_g];
			++_g;
			oBuffer_b += Std.string(o.toString());
		}
		return oBuffer_b;
	}
};
var unveil_Unveil = function(oRouter) {
	this._oRouter = oRouter;
	window.document.addEventListener("click",$bind(this,this.handleClickEvent));
	this.updateView();
};
unveil_Unveil.__name__ = true;
unveil_Unveil.prototype = {
	goto: function(sPath) {
		window.history.pushState({ id : 0},"hellototo",window.location.protocol + "//" + window.location.hostname + sPath);
		this.updateView();
	}
	,updateView: function() {
		var oTemplate = this._oRouter.getTemplate(window.location);
		window.document.body.innerHTML = oTemplate.render(null);
	}
	,handleClickEvent: function(event) {
		var oTarget = event.currentTarget;
		if(oTarget.hasAttribute("href")) {
			event.preventDefault();
			this.goto(oTarget.getAttribute("href"));
		}
	}
};
var unveil_VPathAccessorProxy = function(oAccessor,oContextHolder) {
	this._oAccessor = oAccessor;
	this._oContextHolder = oContextHolder;
};
unveil_VPathAccessorProxy.__name__ = true;
unveil_VPathAccessorProxy.prototype = {
	toString: function() {
		return this._oAccessor.apply(this._oContextHolder);
	}
};
var unveil_tool_VPathAccessor = function(sPath) {
	this._aPath = unveil_tool_VPathAccessor.parsePath(sPath);
};
unveil_tool_VPathAccessor.__name__ = true;
unveil_tool_VPathAccessor.parsePath = function(sPath) {
	var a = sPath.split(".");
	a = a.map(function(s) {
		if(HxOverrides.substr(s,-2,null) == "()") {
			return s.substring(0,s.length - 2);
		}
		return s;
	});
	return a;
};
unveil_tool_VPathAccessor.prototype = {
	apply: function(o) {
		var oRes = o;
		var _g = 0;
		var _g1 = this._aPath;
		while(_g < _g1.length) {
			var sPathPart = _g1[_g];
			++_g;
			oRes = this.getAccess(oRes,sPathPart);
		}
		return oRes;
	}
	,getAccess: function(o,sPathPart) {
		if(o == null) {
			throw new js__$Boot_HaxeError(sPathPart + " parent is null");
		}
		var oRes = Reflect.field(o,sPathPart);
		if(Reflect.isFunction(oRes)) {
			oRes = oRes.apply(o,[]);
		}
		return oRes;
	}
};
var $_;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
if(typeof $global.$haxeUID == "undefined") $global.$haxeUID = 0;
String.__name__ = true;
Array.__name__ = true;
var __map_reserved = {};
Object.defineProperty(js__$Boot_HaxeError.prototype,"message",{ get : function() {
	return String(this.val);
}});
js_Boot.__toStr = ({ }).toString;
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);