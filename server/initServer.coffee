cl = console.log
fiber = require 'fibers'

#  admin 등 기본 셋팅이 들어가야 한다

Meteor.startup ->
  #  reset 시 테스트 환경을 위한 데이터
#  CollectionServices.update SERVICE_ID: "SVC00001",
#    $set:
#      "용량통계":
#        "업로드용량": 0
#        "처리용량": 0
  unless CollectionServices.findOne()
    agent = dataSchema 'Agent'
    agent.AGENT_NAME = 'dasAgent'
    agent.AGENT_URL = 'http://localhost:3000'
    agent.소멸정보절대경로 = '/Users/jwjin/data'
    agent_id = CollectionAgents.insert agent

    svcInfo = dataSchema 'Service'
    svcInfo.SERVICE_ID = 'SVC00001'
    svcInfo.SERVICE_NAME = 'das서비스1'
    svcInfo.파일처리옵션 = '삭제'
    svcInfo.AGENT정보.push agent_id
    svcInfo.DB정보 = {
      DB이름: 'TestDB'      #DB 이름
      DB접속URL: 'mysql://localhost:3306/test'   #jdbc:mysql://14.63.225.39:3306/das_demo?characterEncoding=UTF8
      DBMS종류: 'MySQL'    #MsSQL/MySQL/Oracle
      DB_ID: 'TestID'       #ID
      DB_PW: 'TestPW'
    }
    CollectionServices.insert svcInfo

    svcInfo = dataSchema 'Service'
    svcInfo.SERVICE_ID = 'SVC00002'
    svcInfo.SERVICE_NAME = 'das서비스2'
    svcInfo.파일처리옵션 = '삭제'
    svcInfo.AGENT정보.push agent_id
    svcInfo.DB정보 = {
      DB이름: 'TestDB'      #DB 이름
      DB접속URL: 'mysql://localhost:3306/test'   #jdbc:mysql://14.63.225.39:3306/das_demo?characterEncoding=UTF8
      DBMS종류: 'MySQL'    #MsSQL/MySQL/Oracle
      DB_ID: 'TestID'       #ID
      DB_PW: 'TestPW'
    }
    CollectionServices.insert svcInfo

#    statTotal = dataSchema '용량통계'
#    statTotal.SERVICE_ID = 'SVC00001'
#    CollectionSizeInfos.insert statTotal


  unless Meteor.users.findOne(username: 'admin')
    cl 'initServer/make admin'
    options = {}
    options.username = 'admin'
    options.password = 'admin123@'
    options.profile = dataSchema 'profile'
    options.profile['사용권한'] = '관리자'
    options.profile['이름'] = '관리자'
    options.profile['상태'] = '사용'
    Accounts.createUser options
