Namespace 'com.onetrip.admin.menu',
  # 初始化菜单操作（添加和排序）
  initMenu: ()->
    # 菜单开始排序事件
    $('#admin-menus #menu-list a.start-sort').click ()->
      console.log 'start-sort'
      $('#admin-menus #menu-list .widget-toolbar a').toggle()
      $('#admin-menus #menu-list li.menu .menu-inner')
        .toggleClass('sort').unbind('mouseenter mouseleave').unbind('click')
      com.onetrip.admin.menu._clearMenuClick()
      com.onetrip.admin.menu._menuSort
        disabled: false
    
    # 菜单结束排序事件
    $('#admin-menus #menu-list a.end-sort').click ()->
      $('#admin-menus #menu-list .widget-toolbar a').toggle()
      $('#admin-menus #menu-list li.menu .menu-inner').toggleClass('sort')
      com.onetrip.admin.menu._menuClick()
      com.onetrip.admin.menu._menuHover()
      com.onetrip.admin.menu._menuSort
        disabled: true
    
    com.onetrip.admin.menu.menuList()

  # 菜单列表
  menuList: ()->
    com.onetrip.admin.common.initTooltip()
    com.onetrip.admin.menu._menuClick()
    com.onetrip.admin.menu._menuHover()
  
  
  # 初始化资源操作（添加和排序）
  initResource: ()->
    # 资源开始排序事件
    $('#menu-resources-list a.start-sort').click ()->
      $('#menu-resources-list .widget-toolbar a').toggle()
      $('#menu-resources-list li.resource').addClass('sort').unbind('mouseenter mouseleave')
      com.onetrip.admin.menu._resourceSort
        disabled: false
      
    # 资源结束排序事件
    $('#menu-resources-list a.end-sort').click ()->
      $('#menu-resources-list .widget-toolbar a').toggle()
      $('#menu-resources-list li.resource').removeClass('sort')
      com.onetrip.admin.menu._resourceHover()
      com.onetrip.admin.menu._resourceSort
        disabled: true
        
    com.onetrip.admin.menu.menuResourceList()

  # 菜单资源列表
  menuResourceList: ()->
    com.onetrip.admin.common.initTooltip()
    com.onetrip.admin.menu._resourceClick()
    com.onetrip.admin.menu._resourceHover()
    
    # 删除资源事件
    $('#menu-resources-list .action-shade a').click ()->
      $(this).parents('li.resource').remove()

  # 菜单状态选择
  menuToggleCategory: ()->
    $('select[name*="category_cd"]').change ()->
      $.ajax
        url: $(this).data('url')
        data:
          category_id: $(this).val()
        dataType: 'script'
  
  # 菜单的点击事件(私有)
  _menuClick: ()->
    $('#admin-menus #menu-list li.menu .menu-inner').click ()->
      $(this)
        .parents('ul.nav').find('.menu-inner').removeClass('active').end().end()
        .addClass('active')
      $.getScript $(this).data('url')
  
  # 菜单的hover事件(私有)
  _menuHover: ()->
    $('#admin-menus #menu-list li.menu .menu-inner').hover ()->
      $(this).addClass('hover')
    , ()->
      $(this).removeClass('hover')
  
  # 清除菜单的状态(私有)
  _clearMenuClick: ()->
    $('#admin-menus #menu-list li.menu .menu-inner').removeClass('active')
    
  # 菜单排序(私有)
  _menuSort: (options)->
    $.extend options ||= {},
      axis: 'y'
      placeholder: 'menu-sort-highlight'
      update: ->
        $.post $(this).data('url'), $(this).sortable('serialize')
    $('#admin-menus #menu-list ul.nav').sortable options
    
  # 资源点击事件
  _resourceClick: ()->
    $('#menu-resources-list li.resource').click ()->
      $(this).siblings().removeClass('active').end().addClass('active')
      
  # 资源hover事件
  _resourceHover: ()->
    $('#menu-resources-list li.resource').hover(
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
    $('#menu-resources-list ul').sortable options