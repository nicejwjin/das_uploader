userRv = new ReactiveVar()
Router.route 'userDetail',
  path: '/userDetail/:_id'

Template.userDetail.onCreated ->
  Meteor.call 'getUserInfoById', Router.current().params._id, (err, rslt) ->
    if err then alert err
    else
#      cl rslt
      userRv.set rslt

Template.userDetail.helpers
  userInfo: -> userRv?.get()

Template.userDetail.events
  'click [name=btnEdit]': (e, tmpl) ->
    e.preventDefault()
    unless Meteor.user()?.profile.사용권한 is '관리자'
      alert '관리자만 사용가능합니다.'
      return
    else
      Router.go 'userDetailEditing', _id: Router.current().params._id


  'click [name=btnDelete]': (e, tmpl) ->
    e.preventDefault()
    unless Meteor.user().profile.사용권한 is '관리자' then return
    if confirm '삭제하시겠습니까?'
      #관리자 본인 계정 삭제 금지
      if Meteor.userId() is Router.current().params._id then alert '본인계정은 삭제가 불가능합니다. 책임 관리자에게 문의하세요.'; return;

      Meteor.call 'removeUserById', Router.current().params._id, (err, rslt) ->
        if err then alert err
        else
          alert '삭제되었습니다.'
          Router.go 'userList'
