servicesRv = new ReactiveVar()  #select용 서비스
listRv = new ReactiveVar()  #누적통계 datas
Router.route 'statCapaView'

Template.statCapaView.onCreated ->
  Meteor.call 'getServiceLists', (err, rslt) ->
    if err then alert err
    else
      servicesRv.set rslt
  Meteor.call 'getCapaStats', (err, rslt) ->
    if err then alert err
    else
      listRv.set rslt

Template.statCapaView.helpers
  services: -> servicesRv.get()
  lists: -> listRv.get()
  upCnt: -> jUtils.formatBytes @upCnt
  delCnt: -> jUtils.formatBytes @delCnt
  waitCnt: -> jUtils.formatBytes @waitCnt

Template.statCapaView.events
  'click #btnExcel': (e, tmpl) ->
    e.preventDefault()
    alert '업데이트 예정입니다.'
    return

  'change [name=SERVICE_ID]': (e, tmpl) ->
#    cl $(e.target).val()
    unless $(e.target).val() is 'all'
      $('#stat_upfile_list > tr').hide()
      $("##{$(e.target).val()}").show()
    else
      $('#stat_upfile_list > tr').show()
