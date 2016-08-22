services = new ReactiveVar()

Router.route 'serviceInfoFind'

Template.serviceInfoFind.onCreated ->
  Meteor.call 'getServiceLists', (err, rslt) ->
    if err then alert err
    else
#      cl rslt
      services.set rslt

Template.serviceInfoFind.helpers
  services: -> services?.get()
  AGENTS_count: -> @AGENT정보.length