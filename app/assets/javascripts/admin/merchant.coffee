Namespace 'com.onetrip.admin.merchant',
  _HoverImage: ()->
    $('#merchant-images-list li.resource').hover(
      ()->
        $(this).find('.action-shade').removeClass('hide')
      ()->
        $(this).find('.action-shade').addClass('hide')
    )
  initImage: ()->
    com.onetrip.admin.merchant._HoverImage()
    com.onetrip.admin.merchant.initOrder()

  _imageSort: (options)->
    $.extend options ||= {},
      axis: 'y'
      placeholder: 'resource-sort-highlight'
    $('#merchant-images-list ul').sortable options

  initOrder: ()->
    # 资源开始排序事件
    $('#merchant-images-list a.start-sort').click ()->
      $('#merchant-images-list .widget-toolbar a').toggle()
      $('#merchant-images-list li.resource').addClass('sort').unbind('mouseenter mouseleave')
      com.onetrip.admin.merchant._imageSort
        disabled: false

    $('#merchant-images-list a.end-sort').click ()->
      $('#merchant-images-list .widget-toolbar a').toggle()
      $('#merchant-images-list li.resource').removeClass('sort')
      com.onetrip.admin.merchant._HoverImage()
      com.onetrip.admin.merchant._imageSort
        disabled: true