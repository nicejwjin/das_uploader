agents = new ReactiveVar()
service = new ReactiveVar()

Router.route 'serviceInfoWriting',
  onRun: ->
    service.set [{}]
    @next()

Router.route 'serviceInfoEditing',
  path: '/serviceInfoEditing/:_id'
  template: 'serviceInfoWriting'

Template.serviceInfoWriting.onCreated ->
  Meteor.call 'getAgentLists', (err, rslt) ->
    if err then alert err
    else
#      cl rslt
      agents.set rslt
  if Router.current().route.getName() is 'serviceInfoEditing'
    Meteor.call 'getServiceInfoById', Router.current().params._id, (err, rslt) ->
      if err then alert err
      else
#        cl rslt
        service.set rslt

Template.serviceInfoWriting.onRendered ->
  if Router.current().route.getName() is 'serviceInfoEditing'
    Meteor.setTimeout ->
      $('.radio').removeClass('radio_on')
      info = service.get()
      $("[value=#{info.파일처리옵션}]").attr("checked",true)
      $("[value=#{info.파일처리옵션}]").parent().addClass("radio_on")
      $("[value=#{info.상태}]").attr("checked",true)
      $("[value=#{info.상태}]").parent().addClass("radio_on")
      $("[value=#{info.DB정보.DBMS종류}]").attr("checked",true)
      $("[value=#{info.DB정보.DBMS종류}]").parent().addClass("radio_on")
      $("[value=#{info.AGENT상태전송주기}]").attr("selected","selected")
      info.AGENT정보.forEach (_id) ->
        $("##{_id}").attr('checked', true)
    ,1000

Template.serviceInfoWriting.helpers
  agents: -> agents?.get()
  소멸정보전송기능: -> if @소멸정보전송기능 then '사용' else '미사용'
  파일삭제기능: -> if @파일삭제기능 then '사용' else '미사용'
  service: -> service.get()

Template.serviceInfoWriting.events
  'click [name=dbTest]': (e, tmpl) ->
    dbObj =
#      DB접속URL: $('[name=DB접속URL]').val()
      DB_IP: $('[name=DB_IP]').val()
      DB_PORT: $('[name=DB_PORT]').val()
      DB_DATABASE: $('[name=DB_DATABASE]').val()
      DBMS종류: $(':radio[name="DBMS종류"]:checked').val()
      DB_ID: $('[name=DB_ID]').val()
      DB_PW: $('[name=DB_PW]').val()
    Meteor.call 'dbConnectionTest', dbObj, (err, rslt) ->
      alert err or rslt

  'click .btn_large_cncl': (e, tmpl) ->
    e.preventDefault()
    Router.go 'serviceInfoFind'
  'click .btn_large_ok': (e, tmpl) ->
    SERVICE_ID = $('[name=SERVICE_ID]').val()
    SERVICE_NAME = $('[name=SERVICE_NAME]').val()
    SERVICE_INFO = $('[name=SERVICE_INFO]').val()
    파일처리옵션 = $(':radio[name="파일처리옵션"]:checked').val()
    백업파일경로 = $('[name=백업파일경로]').val()
    AGENT상태전송주기 = $('[name=AGENT상태전송주기]').val()
    상태 = $(':radio[name="상태"]:checked').val()
    DB이름 = $('[name=DB이름]').val()
#    DB접속URL = $('[name=DB접속URL]').val()
    DB_IP = $('[name=DB_IP]').val()
    DB_PORT = $('[name=DB_PORT]').val()
    DB_DATABASE = $('[name=DB_DATABASE]').val()
    DBMS종류 = $(':radio[name="DBMS종류"]:checked').val()
    DB_ID = $('[name=DB_ID]').val()
    DB_PW = $('[name=DB_PW]').val()
#    AGENT정보 = $(':checkbox[name="AGENT정보"]:checked').attr('id')
    AGENT정보 = []
    $(':checkbox.AGENT정보:checked').each ->
      AGENT정보.push $(@).attr('id')
    #validation
    if SERVICE_NAME.length <= 0 then alert '서비스명을 입력하세요.';$('[name=SERVICE_NAME]').focuID를; return;
    if SERVICE_ID.length <= 0 then alert '서비스ID를 입력하세요.';$('[name=SERVICE_ID]').focus(); return;
    if DB이름.length <= 0 then alert 'DB이름을 입력하세요.';$('[name=DB이름]').focus(); return;
#    if DB접속URL.length <= 0 then alert 'DB접속URL을 입력하세요.';$('[name=DB접속URL]').focus(); return;
    if DB_IP.length <= 0 then alert 'DB_IP을 입력하세요.';$('[name=DB_IP]').focus(); return;
    if DB_PORT.length <= 0 then alert 'DB_PORT을 입력하세요.';$('[name=DB_PORT]').focus(); return;
    if DB_DATABASE.length <= 0 then alert 'DB_DATABASE을 입력하세요.';$('[name=DB_DATABASE]').focus(); return;
    if DB_ID.length <= 0 then alert 'DB_ID을 입력하세요.';$('[name=DB_ID]').focus(); return;
    if DB_PW.length <= 0 then alert 'DB_PW을 입력하세요.';$('[name=DB_PW]').focus(); return;
    if 파일처리옵션 is '백업'
      if 백업파일경로.length <= 0 then alert '백업처리시 경로를 반드시 입력해야합니다.';$('[name=백업파일경로]').focus(); return;
    obj = dataSchema 'Service',
      SERVICE_ID: SERVICE_ID      #기존 서버에 의해 생성되는 유니크한 ID
      SERVICE_NAME: SERVICE_NAME        #관리자가 입력하는 서비스 구분 별칭
      SERVICE_INFO: SERVICE_INFO       #서비스 소개
      파일처리옵션: 파일처리옵션    #삭제/사이즈0/백업
      백업파일경로: 백업파일경로    #파일처리옵션 백업 선택시 경로 e.g. /home/...
#        DMS요청정보전송주기: 0 #Legacy에서 생성하는 소멸정보 파일 생성 주기? 생성시 즉시 생성으로 통일. 10/30/60/360... 분단위
#        소멸정보요청주기: 0   #확인 후 적당히 처리
      AGENT상태전송주기: AGENT상태전송주기   #1/3/5/10/30 분단위
      상태: do ->
              if 상태 is 'true' then return true
              else return false
      DB정보:       #DB정보 자체가 현재 필요 없음. 일단 UI에 맞춰 만듦
        DB이름: DB이름      #DB 이름
#        DB접속URL: DB접속URL   #jdbc:mysql://14.63.225.39:3306/das_demo?characterEncoding=UTF8
        DBMS종류: DBMS종류    #MsSQL/MySQL/Oracle
        DB_IP: DB_IP       #ID
        DB_PORT: DB_PORT       #ID
        DB_DATABASE: DB_DATABASE       #ID
        DB_ID: DB_ID       #ID
        DB_PW: DB_PW       #PW
      AGENT정보: AGENT정보     #등록 갯수만큼 _id만

#    cl obj
    if Router.current().route.getName() is 'serviceInfoWriting'
      Meteor.call 'insertServiceInfo', obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'serviceInfoFind'
    else
      Meteor.call 'updateServiceInfo', Router.current().params._id, obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'serviceInfoFind'
