Router.route 'login'

Template.login.onRendered ->

Template.login.events
  'click [name=btn_login]': (e, tmpl) ->
    e.preventDefault()
    Meteor.call 'checkLoginPermission', $('#MGR_ID').val(), (err, rslt) ->
      if err then alert err
      else if rslt is 'success'
        Meteor.loginWithPassword $('#MGR_ID').val(), $('#PSWD').val(), (err, rslt) ->
          if err then alert err
          else
            alert '로그인되었습니다.'
            Router.go '/'
      else if rslt is 'denied'
        alert '계정 사용이 중지되었습니다. 관리자에게 문의바랍니다.'
        Router.go 'login'
      else
        alert '로그인 이상. 개발자에게 문의바랍니다.'
        Router.go 'login'

  'keyup #PSWD': (e, tmpl) ->
    if e.which is 13
      $('[name=btn_login]').trigger('click');
