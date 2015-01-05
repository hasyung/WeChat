Namespace 'com.onetrip.admin.dataTable',
  # 初始化音频的DataTable

  # 初始化视频的DataTable
  initKitsDataTable: ()->
    $('#kits-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'title' }
        { mData: 'price' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
        null
      ]
    .fnSetFilteringDelay()


  # 初始化文章的DataTable

  # 初始化帐号的DataTable
  initAccountsDataTable: ()->
    $('#accounts-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'name' }
        { mData: 'alias' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
      ]
    .fnSetFilteringDelay()

  # 初始化目录的DataTable
  initDirectoriesDataTable: ()->
    $('#directories-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'title' }
        { mData: 'price' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
        null
      ]
    .fnSetFilteringDelay()

  # 初始化消息的DataTable
  initMessagesDataTable: ()->
    $('#messages-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'member.open_id' }
        { mData: 'body' }
        { mData: 'category_cd', sClass: 'msg-type' }
        { mData: 'created_at', sClass: 'date' }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
        null
      ]
    .fnSetFilteringDelay()

  # 初始化回复的DataTable
  initRepliesDataTable: ()->
    $('#replies-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'number' }
        { mData: 'msg_type' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
        null
      ]
    .fnSetFilteringDelay()

  # 初始化资源的DataTable
  initResourcesDataTable: ()->
    $('#resource-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'title' }
        { mData: 'type', sClass: 'text-center' }
        { mData: 'created_at', sClass: 'date' }
      ]
      fnRowCallback: (nRow, aData, iDisplayIndex)->
        $(nRow).click ()->
          $(this).toggleClass('row-selected')
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
      ]
    .fnSetFilteringDelay()

  # 初始化图集的DataTable
  initAlbumsDataTable: ()->
    $('#albums-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'title' }
        { mData: 'realname_at', sClass: 'date' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
        null
      ]
    .fnSetFilteringDelay()


  # 初始化会员的DataTable
  initMembersDataTable: ()->
    $('#members-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'open_id', sClass: 'date' }
        { mData: 'nickname', sClass: 'date' }
        { mData: 'city', sClass: 'date' }
        { mData: 'sex_cd', sClass: 'date' }
        { mData: 'subscribe', sClass: 'date' }
        { mData: 'action_cd', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
      ]
    .fnSetFilteringDelay()


  # 初始化图片的DataTable
  initImagesDataTable: ()->
    $('#images-list-datatables').dataTable
      aoColumns: [
        { mData: 'title' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
    .fnSetFilteringDelay()

  # 初始化用户的DataTable
  initAdminUserDataTable: ()->
    $('#admin-user-datatables').dataTable
      bSortCellsTop: true
      aoColumns: [
        { mData: 'email' }
        { mData: 'realname' }
        { mData: 'sign_in_count', sClass: 'number' }
        { mData: 'current_sign_in_at', sClass: 'date' }
        { mData: 'current_sign_in_ip', sClass: 'ip' }
        { mData: 'last_sign_in_at', sClass: 'date' }
        { mData: 'last_sign_in_ip', sClass: 'ip' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        { type: 'text', bRegex: true, bSmart: true, iFilterLength: 1 }
        null
        null
      ]
    .fnSetFilteringDelay()


  # 初始化日志的DataTable
  initAuditsDataTable: ()->
    $('#audits-datatables').dataTable
      bSortCellsTop: true
      bFilter: false
      aoColumns: [
        { mData: 'user_id', sClass: 'date' }
        { mData: 'auditable_type', sClass: 'date' }
        { mData: 'auditable_id', sClass: 'num' }
        { mData: 'action', sClass: 'date' }
        { mData: 'version', sClass: 'num' }
        { mData: 'created_at', sClass: 'date' }
        { mData: 'actions.html', sClass: 'actions', bSortable: false }
      ]
      fnCreatedRow: (nRow, aData, iDataIndex)->
        # 处理操作按钮
        $(nRow).find('a[data-toggle="tooltip"]').tooltip
          placement: 'bottom'
    .columnFilter
      sPlaceHolder: 'head:after'
      aoColumns: [
        null
        null
        null
        null
        null
        null
        null
      ]
    .fnSetFilteringDelay()