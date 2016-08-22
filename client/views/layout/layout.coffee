Template.layout.helpers
  isSubContent: ->
#    console.log 'current routeName : ' + Router.current().route.getName()
    if Router.current().route.getName() in ['login', 'home', undefined] then return false
    else return true