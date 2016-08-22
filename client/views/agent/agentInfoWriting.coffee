agent = new ReactiveVar()

Router.route 'agentInfoWriting',
  onRun: ->
    agent.set [{}]
    @next()
Router.route 'agentInfoEditing',
  path: '/agentInfoEditing/:_id'
  template: 'agentInfoWriting'

Template.agentInfoWriting.onCreated ->
  if Router.current().route.getName() is 'agentInfoEditing'
    Meteor.call 'getAgentInfoById', Router.current().params._id, (err, rslt) ->
      if err then alert err
      else
        cl rslt
        agent.set rslt


Template.agentInfoWriting.helpers
  agent: ->
    if agent? then agent.get()
    else []

Template.agentInfoWriting.events
  'click [name=btnSave]': (e, tmpl) ->
    AGENT_NAME = $('[name=AGENT_NAME]').val()
    AGENT_URL = $('[name=AGENT_URL]').val()
    소멸정보절대경로 = $('[name=소멸정보절대경로]').val()
    소멸정보전송기능 = $('[name=소멸정보전송기능]').is(':checked')
    파일삭제기능 = $('[name=파일삭제기능]').is(':checked')

    #validation
    if AGENT_NAME.length <= 0 then alert 'AGENT_NAME 필수입력입니다.'; $('[name=AGENT_NAME]').focus();return;
    if AGENT_URL.length <= 0 then alert 'AGENT_URL 필수입력입니다.'; $('[name=AGENT_URL]').focus();return;
    if 소멸정보전송기능
      if 소멸정보절대경로.length <= 0 then alert '소멸정보전송기능을 사용하려면 절대경로는 필수입력입니다.'; $('[name=소멸정보절대경로]').focus();return;

    obj = dataSchema 'Agent',
      AGENT_NAME: AGENT_NAME
      AGENT_URL: AGENT_URL
      소멸정보절대경로: 소멸정보절대경로
      소멸정보전송기능: 소멸정보전송기능
      파일삭제기능: 파일삭제기능

    cl obj

    if Router.current().route.getName() is 'agentInfoWriting'
      Meteor.call 'insertAgentInfo', obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'agentInfoFind'
    else
      Meteor.call 'updateAgentInfo', Router.current().params._id, obj, (err, rslt) ->
        if err then alert err
        else
          alert '저장되었습니다.'
          Router.go 'agentInfoFind'

