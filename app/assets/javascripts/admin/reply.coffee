Namespace 'com.onetrip.admin.reply',
  # 初始化新建窗口reply
  initReplyNew: ()->
    com.onetrip.admin.common.initSelectpicker()
    com.onetrip.admin.common.initTooltip()
    com.onetrip.admin.reply.replyCloseNewFrame()
    com.onetrip.admin.reply.replyToggleCategory()
    com.onetrip.admin.reply.initResource()

  initReplyEdit: ()->
    com.onetrip.admin.common.initSelectpicker()
    com.onetrip.admin.reply.replyToggleCategory()
    com.onetrip.admin.reply.initResource()
    com.onetrip.admin.reply.replyResourceList()

  # 关闭添加回复窗口
  replyCloseNewFrame: ()->
    $('#replies-list .widget-main .new.reply-close').click ()->
      $(this).parents('#reply-new').remove()

  # 关闭修改回复窗口
  replyCloseEditFrame: ()->
    $('#replies-list .widget-main .edit.reply-close').click ()->

  # 切换回复的类型选择
  replyToggleCategory: ()->
    $('#replies select[name*="category_cd"]').change ()->
      $(this).parents('form').find('div[id*="category"]').addClass('hide')
      switch $(this).val()
        when '0'
          $(this).parents('form').find('#category-text').removeClass('hide')
        when '1'
          $(this).parents('form').find('#category-resource').removeClass('hide')

  # 资源操作
  initResource: ()->
    # 资源开始排序事件
    $('#reply-resources-list a.start-sort').click ()->
      $('#reply-resources-list .widget-toolbar a').toggle()
      $('#reply-resources-list li.resource').addClass('sort')
      com.onetrip.admin.reply._resourceSort
        disabled: false

    # 资源结束排序事件
    $('#reply-resources-list a.end-sort').click ()->
      $('#reply-resources-list .widget-toolbar a').toggle()
      $('#reply-resources-list li.resource').removeClass('sort')
      com.onetrip.admin.reply._resourceHover()
      com.onetrip.admin.reply._resourceSort
        disabled: true

  # 回复资源列表
  replyResourceList: ()->
    com.onetrip.admin.common.initTooltip()
    com.onetrip.admin.reply._resourceClick()
    com.onetrip.admin.reply._resourceHover()

    # 删除资源事件
    $('#reply-resources-list .action-shade a').click ()->
      $(this).parents('li.resource').remove()

  # 资源点击事件
  _resourceClick: ()->
    $('#reply-resources-list li.resource').click ()->
      $(this).siblings().removeClass('active').end().addClass('active')

  # 资源hover事件
  _resourceHover: ()->
    $('#reply-resources-list li.resource').hover(
      ()->
        $(this).find('.action-shade').removeClass('hide')
      ()->
        $(this).find('.action-shade').addClass('hide')
    )

  # 资源排序事件
  _resourceSort: (options)->
    $.extend options ||= {},
      axis: 'y'
      placeholder: 'resource-sort-highlight'
    $('#reply-resources-list ul').sortable options