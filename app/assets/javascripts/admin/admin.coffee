# = require jquery
# = require jquery-fix
# = require jquery.ui.sortable
# = require jquery_ujs
# = require namespace
# = require bootstrap
# = require ace
# = require messenger
# = require audiojs
# = require i18n
# = require i18n/zh-CN
# = require i18n/en
# = require dataTables
# = require dataTables/configurate
# = require kindeditor
# = require jquery-fileupload
# = require bootstrap-datetimepicker/bootstrap-datetimepicker
# = require jquery.timers
# = require admin/common
# = require admin/datatable
# = require admin/menu
# = require admin/image
# = require admin/merchant
# = require admin/reply

I18n.defaultLocale = 'zh-CN'
I18n.locale = 'zh-CN'

$ ->

  com.onetrip.admin.common.initSelectpicker()
  com.onetrip.admin.common.initDatetimepicker()
  com.onetrip.admin.common.initAceFileInput()
  com.onetrip.admin.common.toggleAccount()
  com.onetrip.admin.common.initAudioJSAll()

  com.onetrip.admin.dataTable.initKitsDataTable()
  com.onetrip.admin.dataTable.initAlbumsDataTable()
  com.onetrip.admin.dataTable.initMembersDataTable()
  com.onetrip.admin.dataTable.initMessagesDataTable()
  com.onetrip.admin.dataTable.initDirectoriesDataTable()
  com.onetrip.admin.dataTable.initAdminUserDataTable()
  com.onetrip.admin.dataTable.initCustomersDataTable()
  com.onetrip.admin.dataTable.initAuditsDataTable()

  com.onetrip.admin.menu.initMenu()

  return
