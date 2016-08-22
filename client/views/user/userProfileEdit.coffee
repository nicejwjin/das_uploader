Router.route 'userProfileEdit'

Template.userProfileEdit.helpers
  userInfo: -> Meteor.user()

Template.userProfileEdit.events
  'click #btn_cancle': (e, tmpl) ->
    history.back()

  'click #btn_save': (e, tmpl) ->
    cl 비번 = $('#new_pswd').val()
    cl 비번확인 = $('#cnf_pswd').val()
    cl 이메일 = $('#email1').val()
    cl 휴대폰 = $('#cell_phone3').val()

    obj = {}

    if 비번.length > 0
      unless 비번 is 비번확인
        alert '입력 비밀번호가 다릅니다. 다시 입력바랍니다.'
        $('#new_pswd').val('')
        $('#cnf_pswd').val('')
        return

    if 이메일.length > 0 then _.extend obj, 이메일: 이메일
    if 휴대폰.length > 0 then _.extend obj, 휴대폰: 휴대폰

    Meteor.call 'userProfileUpdate', 비번, obj, (err, rslt) ->
      if err then alert err
      else
        alert '저장되었습니다.'
        history.back()