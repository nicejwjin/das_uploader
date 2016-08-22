@CollectionSettings = new Meteor.Collection 'settings'
@CollectionServices = new Meteor.Collection 'services'
@CollectionAgents = new Meteor.Collection 'agents'
@CollectionDasInfos = new Meteor.Collection 'dasInfos'
#@CollectionDasLogs = new Meteor.Collection 'dasLogs'
@CollectionSizeInfos = new Meteor.Collection 'sizeInfos'
@CollectionError = new Meteor.Collection 'error'      #에러를 무조건 쌓고 향후 분석해야

Meteor.startup ->
  if Meteor.isServer
    CollectionDasInfos._ensureIndex({"REQ_DATE": -1, "SERVICE_ID": 1});
    CollectionDasInfos._ensureIndex({"KEEP_PERIOD": 1});
