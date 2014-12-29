dataTable = 
  language:
    'oAria':
      'sSortAscending': ' - 点击升序排列'
      'sSortDescending': ' - 点击降序排列'
    'oPaginate':
      'sNext': '下一页'
      'sFirst': '第一页'
      'sLast': '最后一页'
      'sPrevious': '上一页'
    'sEmptyTable': '没有任何数据'
    'sInfo': '显示 _START_ 到 _END_ 条数据，共有 _TOTAL_ 条数据'
    'sInfoEmpty': '没有任何数据'
    'sInfoFiltered': ' - 从 _MAX_ 条数据过滤'
    'sInfoPostFix': ''
    'sInfoThousands': "'"
    'sLengthMenu': '_MENU_'
    'sLoadingRecords': '请等待，数据加载中...'
    'sProcessing': '数据正在加载中...'
    'sSearch': '搜索'
    'sZeroRecords': '没有匹配结果'
  lengthMenu: [
    [10, 25, 50, 100],
    ['每页10条数据', '每页25条数据', '每页50条数据', '每页100条数据']
  ]

$.extend true, $.fn.dataTable.defaults,
  'sDom': "<'head row-fluid'<'span6 pull-left'l><'span6 pull-right text-right'f>>rt<'foot row-fluid'<'span6'i><'span6 text-right'p>>"
  'sPaginationType': 'bootstrap'
  'oLanguage': dataTable.language
  'bProcessing': true
  'bServerSide': true
  'bAutoWidth': false
  'fnServerData': (sUrl, aoData, fnCallback, oSettings)->
    oSettings.jqXHR = $.ajax
      url: $(oSettings.nTable).data('source')
      data: aoData
      type: 'GET'
      dataType: 'json'
      success: fnCallback
      cache: true
  'fnDrawCallback': (oSetting)->
    $('.dataTables_length select').selectpicker
      style: 'btn-primary'

$.fn.dataTable.defaults.aLengthMenu = dataTable.lengthMenu
  