idCheckFlag = new ReactiveVar() #중복체크
userInfoRv = new ReactiveVar()  #유저정보

Router.route 'userDetailWriting'

Router.route 'userDetailEditing',
  path: '/userDetailEditing/:_id'
  template: 'userDetailWriting'

Template.userDetailWriting.onCreated ->
  idCheckFlag.set false
  if Router.current().route.getName() is 'userDetailEditing'
    Meteor.call 'getUserInfoById', Router.current().params._id, (err, rslt) ->
      if err then alert err
      else userInfoRv.set rslt
  else userInfoRv.set [{}]

Template.userDetailWriting.onRendered ->
  if Router.current().route.getName() is 'userDetailEditing'
    Meteor.setTimeout ->
      info = userInfoRv.get()
      $('.radio').removeClass('radio_on')
      $("[value=#{info.profile.사용권한}]").attr("checked",true)
      $("[value=#{info.profile.사용권한}]").parent().addClass("radio_on")
      $("[value=#{info.profile.상태}]").attr("checked",true)
      $("[value=#{info.profile.상태}]").parent().addClass("radio_on")

    ,500

Template.userDetailWriting.helpers
  'userInfo': -> userInfoRv.get()
  isWriting: ->
    unless Router.current().route.getName() is 'userDetailEditing' then true
  readonly: ->
    if Router.current().route.getName() is 'userDetailEditing' then 'readonly'
    else return ''

Template.userDetailWriting.events
  'click [name=btnCancle]': (e, tmpl) ->
    history.back()
  'click [name=btnIdCheck]': (e, tmpl) ->
    e.preventDefault()
    if Router.current().route.getName() is 'userDetailEditing'
      idCheckFlag.set true
      return
    else
      id = $('[name=mgr_id]').val()
      if id.length > 0
        Meteor.call 'idDuplCheck', id, (err, rslt) ->
          if err then alert err; idCheckFlag.set(false); $('[name=mgr_id]').val('');
          else
            alert rslt
            idCheckFlag.set true
      else
        alert '아이디 입력후 중복체크가 가능합니다'
        return
  'click [name=btnSave]': (e, tmpl) ->
    e.preventDefault()
    unless idCheckFlag.get() then alert '아이디 중복체크를 하세요.'; return;

    이름 = $('[name=mgr_nm]').val()
    아이디 = $('[name=mgr_id]').val()
    비밀번호 = $('#tmp_pswd').val()
    이메일 = $('#email1').val()
    휴대폰 = $('#cell_phone3').val()
    사용권한 = $(':radio[name="use_perm"]:checked').val()
    상태 = $(':radio[name="use_yn"]:checked').val()

    obj =
      이름: 이름
      아이디: 아이디
#      비밀번호: 비밀번호
      이메일: 이메일
      휴대폰: 휴대폰
      사용권한: 사용권한
      상태: 상태

    if 이름.length <= 0 then alert '이름을 입력하세요'; $('[name=mgr_nm]').focus(); return;
    if 아이디.length <= 0 then alert '아이디를 입력하세요'; $('[name=mgr_id]').focus(); return;
    if Router.current().route.getName() is 'userDetailWriting'
      if 비밀번호.length <= 0 then alert '비밀번호을 입력하세요'; $('#tmp_pswd').focus(); return;
      _.extend obj,
        비밀번호: 비밀번호


    if Router.current().route.getName() is 'userDetailWriting'
      Meteor.call 'addUser', obj, (err, rslt) ->
        if err then alert err
        else
          alert rslt
          Router.go 'userList'
    else
      Meteor.call 'editUserInfo', obj,Router.current().params._id, (err, rslt) ->
        if err then alert err
        else
          alert '수정되었습니다.'
          Router.go 'userList'
