UI.registerHelper 'incremented', (_index) ->
  return _index + 1

UI.registerHelper 'isAdminUser', ->
  if Meteor.user().profile.사용권한 is '관리자' then true
  else false
