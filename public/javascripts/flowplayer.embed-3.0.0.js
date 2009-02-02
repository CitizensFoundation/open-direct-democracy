/**
 * flowplayer.embed.js 3.0.0. Flowplayer JavaScript plugin.
 * 
 * This file is part of Flowplayer, http://flowplayer.org
 *
 * Author: Tero Piirainen, <support@flowplayer.org>
 * Copyright (c) 2008 Flowplayer Ltd
 *
 * Dual licensed under MIT and GPL 2+ licenses
 * SEE: http://www.opensource.org/licenses
 * 
 * Version: 3.0.0 - Tue Nov 25 2008 16:29:31 GMT-0000 (GMT+00:00)
 */
(function() {

	// converts paths to absolute URL's as required in external sites 
	function toAbsolute(url, base) {
		
		// http://some.com/path
		if (url.substring(0, 4) == "http") { return url; }
		
		if (base) {			
			return base + (base.substring(base.length -1) != "/" ? "/" : "") + url; 
		}
		
		// /some/path
		base = location.protocol + "//" + location.host;		
		if (url.substring(0, 1) == "/") { return base + url; }
		
		// yet/another/path		
		var path = location.pathname;		
		path = path.substring(0, path.lastIndexOf("/"));
		return base + path + "/" + url;
	}
	
	
	// Flowplayer plugin implementation
	$f.addPlugin("embed", function(options) {
	
		var self = this;
		var conf = self.getConfig(true);

		
		// default configuration
		var opts = {
			width: self.getParent().clientWidth,
			height: self.getParent().clientHeight,
			url: toAbsolute(self.getFlashParams().src), 
			index: -1,
			allowfullscreen: true
		};		 
		
		// override defaults
		$f.extend(opts, options);
		opts.src = opts.url;
		
		// selected clip only
		if (opts.index > -1) {
			conf.playlist = [ conf.playlist[opts.index] ];	
		}
		
		// setup absolute path for each clip
		var index = 0;
		$f.each(conf.playlist, function() {
			conf.playlist[index++].url = toAbsolute(this.url, this.baseUrl);
		});
		
		// not needed for external objects
		delete conf.playerId;		
		delete opts.url;
		delete opts.index;
		
		// construct HTML code for the configuration
		this.getEmbedCode = function(runnable) {			
			
			var html = flashembed.getFullHTML(opts, {config: conf});
			
			if (!runnable)  {
				html = html.replace(/\</g, "&lt;").replace(/\>/g, "&gt;"); 	
			}				
				
			return html;			
		};
		
		return self;
		
	});
	
})();		
