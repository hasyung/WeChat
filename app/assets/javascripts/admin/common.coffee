Namespace 'com.onetrip.admin.common',

  # 初始化Bootstrap Select插件
  initSelectpicker: ()->
    $('select').selectpicker
      style: 'btn-primary'

  # 初始化时间控件
  initDatetimepicker: ()->
    $('.datetimepicker')
    .datetimepicker
      format: 'yyyy-mm-dd'
      autoclose: true
      minView: 'month'
    $('.datetimepickerEnd').datetimepicker 'setStartDate', $('.datetimepickerStart').val()
    $('.datetimepickerStart').datetimepicker 'setEndDate', $('.datetimepickerEnd').val()
    $('.datetimepickerStart').on 'change', ()->
      $('.datetimepickerEnd').datetimepicker 'setStartDate', $('.datetimepickerStart').val()
    $('.datetimepickerEnd').on 'change', ()->
      $('.datetimepickerStart').datetimepicker 'setEndDate', $('.datetimepickerEnd').val()

  # 初始化Ace的上传插件
  initAceFileInput: ()->
    $('input[type="file"]').ace_file_input
      icon_remove: ''

  # 初始化Bootstrap Tooltip插件
  initTooltip: ()->
    $('a[data-toggle="tooltip"]').tooltip
      placement: 'bottom'

  # 动画关闭Flash的Alert
  hideFlashAlert: ()->
    $('#flash-alert').oneTime '3s', ()->
      $(this).fadeOut(300)

  # 帐号选择
  toggleAccount: ()->
    $('#select-accounts select').change ()->
      $(this).parents('form').submit()

  # 为一个Audio初始化AUdioJS
  initAudioJSBy: (audio)->
    window.audiojs.events.ready ()->
      window.audiojs.create audio,
        preload: false

  # 初始化所有的AudioJS
  initAudioJSAll: ()->
    window.audiojs.events.ready ()->
      audiojs.createAll()


  initFileUpload: ()->
    fileUploadErrors = {
      maxFileSize: '上传文件过大'
      minFileSize: '上过文件太小'
      acceptFileTypes: '上传文件类型错误'
      maxNumberOfFiles: '已超过最大上传文件数量'
      uploadedBytes: '上传文件过大'
      emptyResult: '上传空的文件'
    };

    $('#fileupload').fileupload
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
      finished: (e, data)->
        $.ajax
          url: $('#fileupload').attr('action')
          data:
            type: 'list'
          dataType: 'script'

  # 初始化资源模态框
  initResourcesModal: ()->
    com.onetrip.admin.dataTable.initResourcesDataTable()
    $('#modal .modal-footer button#submit').click ()->
      rows = $('#resource-datatables tr.row-selected')
      if rows.size() is 0
        alert I18n.t('errors.messages.resources.empty_select')
        return false
      else
        resource_ids = []
        $.each rows, ()->
          resource_ids.push $(this).attr('id')
        $.ajax
          url: $(this).data('url')
          data:
            resource_ids: resource_ids
          type: 'POST'
          dataType: 'script'

