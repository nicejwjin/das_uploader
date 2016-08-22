#프로그램 내부에선 jDeifne 을 쓰고, 외부 입력은 export를 쓴다

##both
#@mSettings =
#  isTest: true
#
#if Meteor.isServer
#  _.extend mSettings,
#    serverSEtting: 'serverValue'
#
#
#if Meteor.isClient
#  _.extend mSettings,
#    clientSetting: 'clientValue'