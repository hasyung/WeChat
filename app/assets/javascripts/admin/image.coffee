Namespace 'com.onetrip.admin.image',
  _HoverImage: ()->
    $('#kit-images-list li.resource').hover(
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
    $('#kit-images-list ul').sortable options

  initOrder: ()->
    # 资源开始排序事件
    $('#kit-images-list a.start-sort').click ()->
      $('#kit-images-list .widget-toolbar a').toggle()
      $('#kit-images-list li.resource').addClass('sort').unbind('mouseenter mouseleave')
      com.onetrip.admin.image._imageSort
        disabled: false

    $('#kit-images-list a.end-sort').click ()->
      $('#kit-images-list .widget-toolbar a').toggle()
      $('#kit-images-list li.resource').removeClass('sort')
      com.onetrip.admin.image._HoverImage()
      com.onetrip.admin.image._imageSort
        disabled: true