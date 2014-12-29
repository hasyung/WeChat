Namespace 'com.onetrip.admin.image',
  _HoverImage: ()->
    $('#album-images-list li.resource').hover(
      ()->
        $(this).find('.action-shade').removeClass('hide')
      ()->
        $(this).find('.action-shade').addClass('hide')
    )
  initImage: ()->
    com.onetrip.admin.image._HoverImage()
    com.onetrip.admin.image.initOrder()

  _imageSort: (options)->
    $.extend options ||= {},
      axis: 'y'
      placeholder: 'resource-sort-highlight'
    $('#album-images-list ul').sortable options

  initOrder: ()->
    # 资源开始排序事件
    $('#album-images-list a.start-sort').click ()->
      $('#album-images-list .widget-toolbar a').toggle()
      $('#album-images-list li.resource').addClass('sort').unbind('mouseenter mouseleave')
      com.onetrip.admin.image._imageSort
        disabled: false

    $('#album-images-list a.end-sort').click ()->
      $('#album-images-list .widget-toolbar a').toggle()
      $('#album-images-list li.resource').removeClass('sort')
      com.onetrip.admin.image._HoverImage()
      com.onetrip.admin.image._imageSort
        disabled: true