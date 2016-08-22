servicesRv = new ReactiveVar()
conditionRv = new ReactiveVar() #조회조건
listRv = new ReactiveVar()  #검색결과 데이터
skipRv = new ReactiveVar() #skip No
Router.route 'history'

Template.history.onCreated ->
  skipRv.set 0
  today = libClient.getRealtimeDate()
  conditionRv.set {
    where: {
      REQ_DATE:
        $gte: new Date("#{today.start} 00:00:00")
        $lte: new Date("#{today.end} 00:00:00")
#      SERVICE_ID: 'all' #_id 이므로 서버에서는 SERVICE_ID 로 업데이트해야함
#      STATUS:''  #전체보기는 STATUS를 아예 고려 안함
    }
    options: {
      sort:
        REQ_DATE: 1
      skip: 0
      limit: 10
    }
  }
  Meteor.call 'getServiceLists', (err, rslt) ->
    if err then alert err
    else
      servicesRv.set rslt
  @autorun ->
    cl 'autorun'
    Meteor.call 'getDasHistory', conditionRv.get(), (err, rslt) ->
      if err then alert err
      else
        listRv.set rslt

Template.history.onRendered ->
  todayObj = libClient.getRealtimeDate()
  $('#date01').datepicker({dateFormat: 'yy-mm-dd'})
  $('#date02').datepicker({dateFormat: 'yy-mm-dd'})
  $('#date01').val(todayObj.start)
  $('#date02').val(todayObj.end)
  $('[name=btnSearch]').trigger('click')
Template.history.helpers
  services: -> servicesRv?.get()
  lists: -> if listRv.get()? then listRv.get()
  업로드일시: -> jUtils.getStringYMDHMFromDate(@REQ_DATE)
  소멸시한: -> jUtils.getStringYMDHMFromDate(@DEL_DATE)
  처리일시: -> jUtils.getStringYMDHMFromDate(@processedAt)
  STATUS: ->
    switch @STATUS
      when 'success' then return '성공'
      when 'wait' then return '대기'
      else return '실패'
  현재페이지: ->
    return (skipRv.get()/10) + 1
  게시물번호: (index) ->
    return skipRv.get() + index + 1


Template.history.events
  'change #date01': (e, tmpl) ->
#    cl jUtils.mydiff($('#date01').val(), $('#date02').val(), 'days')
    if jUtils.mydiff($('#date01').val(), $('#date02').val(), 'days') > 90
      alert '3달 이내만 조회가 가능합니다.'
      $('#date01').val(
        jUtils.getStringYMDFromDate(new Date("#{$('#date02').val()}").addDates(-90))
      )
  'change #date02': (e, tmpl) ->
#    cl jUtils.mydiff($('#date01').val(), $('#date02').val(), 'days')
    if jUtils.mydiff($('#date01').val(), $('#date02').val(), 'days') > 90
      alert '3달 이내만 조회가 가능합니다.'
      $('#date02').val(
        jUtils.getStringYMDFromDate(new Date("#{$('#date01').val()}").addDates(90))
      )

  'click .btn_prev': (e, tmpl) ->
    e.preventDefault()
    unless skipRv.get() is 0
      skipRv.set (skipRv.get() - 10)
      condition = conditionRv.get()
      condition.options['skip'] = skipRv.get()
      conditionRv.set condition
    else
      alert '첫페이지입니다.'
      return false
  'click .btn_next': (e, tmpl) ->
    e.preventDefault()
    skipRv.set skipRv.get() + 10
    condition = conditionRv.get()
    condition.options['skip'] =  skipRv.get()
#    cl condition
    conditionRv.set condition


  'click .btn_box > a': (e, tmpl) ->
    e.preventDefault()
    $('.btn_box > .btn_inner').removeClass('on')
    if (target=$(e.target)).hasClass('btn_inner') or (target=$(e.target).parent()).hasClass('btn_inner')
      target.addClass('on')

  'click [name=btnSearch]': (e, tmpl) ->
    e.preventDefault()
    skipRv.set 0
    condition = conditionRv.get()
    SERVICE_ID = $('[name=SERVICE_ID]').val()
    date1 = $('#date01').val()
    date2 = $('#date02').val()
    STATUS = $(':radio[name="SEARCH_PROC_DV"]:checked').val()
    _.extend condition,
      where: {
        REQ_DATE:
          $gte: new Date("#{date1} 00:00:00")
          $lt: new Date("#{date2} 00:00:00").addDates(1)
      }
      options: {
        sort:
          REQ_DATE: 1
        skip: skipRv.get()
        limit: 10
      }

    unless SERVICE_ID is 'all'
      condition.where['SERVICE_ID'] = SERVICE_ID
    else
      if condition.where.SERVICE_ID? then delete condition.where.SERVICE_ID

    unless STATUS is 'all'
      if STATUS is 'fail'
        condition.where['STATUS'] = $nin: ['wait','success']
      else condition.where['STATUS'] = STATUS
    else
      if condition.where.STATUS? then delete condition.where.STATUS

    conditionRv.set condition

#    Meteor.call 'getDasHistory', condition, (err, rslt) ->
#      if err then alert err
#      else
#        listRv.set rslt