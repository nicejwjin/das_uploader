agents = new ReactiveVar()

Router.route 'agentInfoFind'

Template.agentInfoFind.onCreated ->
  Meteor.call 'getAgentLists', (err, rslt) ->
    if err then alert err
    else
      agents.set rslt

Template.agentInfoFind.helpers
  agents: -> agents?.get()
  소멸정보전송기능: -> if @소멸정보전송기능 then '사용' else '미사용'
  파일삭제기능: -> if @파일삭제기능 then '사용' else '미사용'
#  incremented: (index) -> return index + 1

Template.agentInfoFind.events
  'click [name=btnAgentDel]': (e, tmpl) ->
    e.preventDefault()
    unless Meteor.user()?.profile.사용권한 is '관리자'
      alert '관리자만 사용가능합니다.'
      return
    agent_id = $(e.target).attr('id')
    if confirm '해당 Agent를 삭제하시겠습니까? 삭제후에는 복구가 불가능합니다.'
      Meteor.call 'removeAgent', agent_id, (err, rslt) ->
        if err then alert err
        else
          alert '삭제되었습니다.'
          Meteor.call 'getAgentLists', (err, rslt) ->
            if err then alert err
            else
              agents.set rslt


