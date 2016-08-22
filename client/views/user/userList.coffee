users = new ReactiveVar()
condition = new ReactiveVar()
Router.route 'userList'

Template.userList.onCreated ->
  condition.set {
    where: {}
    options:
      sort: 'profile.이름': 1
  }
  @autorun ->
    Meteor.call 'getUserLists', condition.get(), (err, rslt) ->
      if err then alert err
      else
        users.set rslt

Template.userList.helpers
  users: -> users?.get()
  등록일: -> jUtils.getStringYMDFromDate(@createdAt)

Template.userList.events
  'click [name=btn_search]': (e, tmpl) ->
    searchWord = $('#mgr_search_txt').val()
    상태 = $(':radio[name="mgr_use_yn"]:checked').val()
    cond = condition.get()
    if searchWord.length > 0
      cond = _.extend cond, {search: searchWord}
    if 상태.length > 0
      cond = _.extend cond, {where: 'profile.상태': 상태}
    else if cond.where['profile.상태']?
      delete cond.where['profile.상태']
    condition.set cond
