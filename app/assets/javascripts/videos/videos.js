/*
 *= require videos/mediaelement-and-player
*/ 
window.browser = {
  isiPad: function() {
    return /ipad/i.test(navigator.userAgent.toLowerCase())
  },
  isiPhone: function() {
    return /iphone/i.test(navigator.userAgent.toLowerCase())
  },
  isAndroid: function() {
    return /android/i.test(navigator.userAgent.toLowerCase())
  },
  isiDevice: function() {
    return /ipad|iphone|ipod/i.test(navigator.userAgent.toLowerCase())
  },
  isiPod: function() {
    return /ipod/i.test(navigator.userAgent.toLowerCase())
  },
  detect: function() {
    if(this.isiDevice()) 
      {
        $('video').mediaelementplayer({
          features: ['']
      });
        $('.mejs-wmp .mejs-controls').hide();
        $(".mejs-overlay-button").addClass('add-background');
        $('.mejs-overlay-loading').hide();
      }
    else 
      {
        var player = new MediaElementPlayer('video',{features: ['playpause','progress','current','duration','fullscreen','tracks']});
        $(".mejs-fullscreen-button").click(function(){
          if ($("div.mejs-fullscreen-button").hasClass("mejs-unfullscreen"))
            {
              $("#header").hide();
            }
          else
            {
              $("#header").show();
            }
         });
        $(".mejs-wmp .mejs-controls").addClass("add-mejs-background");
        $('.mejs-overlay-loading').hide();
        } 
    }
}
window.browser.detect();

