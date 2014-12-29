(function ($){
      $('#tiles').imagesLoaded(function() {
        // Prepare layout options.
        var options = {
          align: 'center',
          itemWidth: '27.77%',
          autoResize: true, // This will auto-update the layout when the browser window is resized.
          resizeDelay: 20000,
          container: $('.container'), // Optional, used for some extra CSS styling
          offset: 15, // Optional, the distance between grid items
          outerOffset: 20, // Optional the distance from grid to parent
          flexibleWidth: 180 // Optional, the maximum width of a grid item
        };

        // Get a reference to your grid items.
        var handler = $('#tiles li');

        // Call the layout function.
        handler.wookmark(options);
      });
      $('#tiles a').show();
    })(jQuery);

$(window).scroll(function () {
  page = parseInt($('#tiles').attr('data'));
  if ($(document).height() - $(window).height() == $(window).scrollTop() && $('#tiles li').size() <  parseInt($('#tiles').attr('total'))) {
    $.ajax({
      type: 'GET',
      url: document.location,
      data: {page: page + 1},
      dataType: 'script'
    });
    $(".load").show();
  }
});
