Template.header.events
  'click [name=btn_logout]': (e, tmpl) ->
    e.preventDefault()
    if confirm '로그아웃 하시겠습니까?'
      Meteor.logout (err, rslt) ->
        if err then alert err
        else
          alert '로그아웃 되었습니다.'
          Router.go 'login'

Template.header.helpers
  userName: -> Meteor.user().profile.이름

Template.header.events
  "click [name=runDMS]": (e, tmpl) ->
    e.preventDefault()
    Meteor.call 'runDMS', (err, rslt) ->
      alert err or '실시간 처리 완료'