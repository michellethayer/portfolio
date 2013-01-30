// taken respectfully from http://joshnh.com/ 
$(document).ready(function() {

	// Smooth same page scrolling

	function filterPath(string) {
	  return string
	    .replace(/^\//,'')
	    .replace(/(index|default).[a-zA-Z]{3,4}$/,'')
	    .replace(/\/$/,'');
	  }
	  var locationPath = filterPath(location.pathname);
	  var scrollElem = scrollableElement('html', 'body');

	  $('a[href*=#]').each(function() {
	    var thisPath = filterPath(this.pathname) || locationPath;
	    if (  locationPath == thisPath
	    && (location.hostname == this.hostname || !this.hostname)
	    && this.hash.replace(/#/,'') ) {
	      var $target = $(this.hash), target = this.hash;
	      if (target) {
	        var targetOffset = $target.offset().top-72;
	        $(this).click(function(event) {
	          event.preventDefault();
	          $(scrollElem).animate({scrollTop: targetOffset}, 400, function() {
	            location.hash = target;
	            window.scrollBy(0, -72)
	          });
	        });
	      }
	    }
	  });

	  // use the first element that is "scrollable"
	  function scrollableElement(els) {
	    for (var i = 0, argLength = arguments.length; i <argLength; i++) {
	      var el = arguments[i],
	          $scrollElement = $(el);
	      if ($scrollElement.scrollTop()> 0) {
	        return el;
	      } else {
	        $scrollElement.scrollTop(1);
	        var isScrollable = $scrollElement.scrollTop()> 0;
	        $scrollElement.scrollTop(0);
	        if (isScrollable) {
	          return el;
	        }
	      }
	    }
	    return [];
	  }

	  // Fade in scroll to top link

	  /* set variables locally for increased performance */
		var scroll_timer;
		var displayed = false;
		var $message = $('#backToTop');
		var $window = $(window);
		var top = 0;//$(document.body).children(0).position().top;

		/* react to scroll event on window */
		$window.scroll(function () {
			window.clearTimeout(scroll_timer);
			scroll_timer = window.setTimeout(function () { // use a timer for performance
				if($window.scrollTop() <= top) // hide if at the top of the page
				{
					displayed = false;
					$message.fadeOut(250);
				}
				else if(displayed == false) // show if scrolling down
				{
					displayed = true;
					$message.stop(true, true).fadeIn(250).click(function () { 
					  $message.fadeOut(250); 
					});
				}
			}, 100);
		});

}); /* end of as page load scripts */