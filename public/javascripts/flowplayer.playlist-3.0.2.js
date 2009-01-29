/**
 * flowplayer.playlist.js 3.0.2. Flowplayer JavaScript plugin.
 * 
 * This file is part of Flowplayer, http://flowplayer.org
 *
 * Author: Tero Piirainen, <support@flowplayer.org>
 * Copyright (c) 2008 Flowplayer Ltd
 *
 * Dual licensed under MIT and GPL 2+ licenses
 * SEE: http://www.opensource.org/licenses
 * 
 * Version: 3.0.2 - Wed Jan 21 2009 12:12:37 GMT-0000 (GMT+00:00)
 */
(function($) {
	
	$f.addPlugin("playlist", function(wrap, options) {
	
		// self points to current Player instance
		var self = this;	
		
		var opts = {
			playingClass: 'playing',
			pausedClass: 'paused',
			progressClass:'progress',
			template: '<a href="${url}">${title}</a>',
			loop: false,
			playOnClick: true
		};		
		
		$.extend(opts, options);
		wrap = $(wrap);		
		var manual = self.getPlaylist().length < 2; 
		var els = null;
		

		/* setup playlists with onClick handlers */ 
		
		// template based playlist
		if (!manual) {
			
			var template = wrap.is(":empty") ? opts.template : wrap.html(); 
			wrap.empty(); 
				
			$.each(self.getPlaylist(), function() {
				
				var clip = this;
				
				if (clip.duration === 0) { return false; }
				
				var el = template;	
				
				$.each(clip, function(key, val) {				
					el = el.replace("$\{" +key+ "\}", val).replace("$%7B" +key+ "%7D", val);			
				});				 
				
				el = $(el);	
				
				el.click(function() {				
					return play(el, clip.index);
				});			
				
				wrap.append(el);		
			});
			
			els = wrap.children();		
			
			
		// HTML based playlist
		} else {
			
			els = wrap.children();
			if (els.eq(0).hasClass("__scrollable")) { els = els.children(); }
			
			els.each(function() {
				var el = $(this);
				el.click(function() {
					return play(el, el.attr("href"));
				});
			});						 
					
			// setup player to play first clip
			var clip = self.getClip(0);
			if (!clip.url && opts.playOnClick) {
				clip.update({url: els.eq(0).attr("href")});		
			}   
			
		}
		
		function play(el, clip)  {
		
			if (el.hasClass(opts.playingClass) || el.hasClass(opts.pausedClass)) {
				self.toggle();
				
			} else {
				el.addClass(opts.progressClass);
				self.play(clip); 							
			}			
			
			return false;
		}	
		
		
		function clearCSS() {
			els.removeClass(opts.playingClass);
			els.removeClass(opts.pausedClass);
			els.removeClass(opts.progressClass);			
		}
		
		function getEl(clip) {		
			return (manual) ? els.filter("[href=" + clip.url + "]") : els.eq(clip.index);	
		}
		
		// onBegin
		self.onBegin(function(clip) {
			clearCSS();		
			getEl(clip).addClass(opts.playingClass);
		});	
		
		// onPause	
		self.onPause(function(clip) {
			getEl(clip).removeClass(opts.playingClass).addClass(opts.pausedClass);		
		});	
		
		// onResume
		self.onResume(function(clip) {
			getEl(clip).removeClass(opts.pausedClass).addClass(opts.playingClass);		
		});		
		
		// what happens when clip ends ?
		if (!opts.loop && !manual) {
			
			// stop the playback exept on the last clip, which is stopped by default
			self.onBeforeFinish(function(clip) {
				if (clip.index < els.length -1) {
					return false;
				}
			}); 
		}
		
		// on manual setups perform looping here
		if (manual && opts.loop) {
			self.onBeforeFinish(function(clip) {
				var el = getEl(clip);
				if (el.next().length) {
					el.next().click();	 		
				} else {
					els.eq(0).click();	
				} 
				return false;				
			}); 
		}
		
		// onUnload
		self.onUnload(function() {
			clearCSS();		
		});
		
		
		return self;
		
	});
		
})(jQuery);		
