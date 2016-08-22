###      dasInfo Test Script      ###
#date = new Date()
#date = date.addDates(-100)
#
#for i in [0...10000]
#  rand = Math.random()
#  obj =
#    "AGENT_NAME" : "dasAgent#{do -> if rand < 0.3 then 1 else if rand < 0.5 then 2 else 3}"
#    "AGENT_URL" : "http://localhost:#{do -> if rand < 0.3 then 3000 else if rand < 0.5 then 3100 else 3200}"
#    "SERVICE_ID" : "SVC0000#{do -> if i % 2 is 0 then 2 else 1}"
#    "SERVICE_NAME" : "das서비스#{do -> if i % 2 is 0 then 2 else 1}"
#    "BOARD_ID" : "BRD#{do -> if rand < 0.3 then '00001' else if rand < 0.5 then '00002' else '00003'}"
#    "CUR_IP" : "10.0.0.24"
#    "DEL_FILE_LIST" : [
#      "/data/images/#{i}.jpg"
#      " /data/files/#{i*2}.doc"
#    ]
#    "DEL_DB_URL" : "http://10.0.0.24/delBoard.do?b_id=I38fPie98Kjf"
#    "DEL_DB_QRT" : ""
#    "UP_FSIZE" : (Math.random() * 1000000) + 1
#    "AGENT_URL_FROM_AGENT" : "http://localhost:3000"
#  obj.createdAt = date.addMinutes(Math.round (rand*30)+1)
#  obj.processedAt = date.clone().addDates Math.round (rand*100)+1
#  obj.REQ_DATE = date.clone()
#  obj.DEL_DATE = date.clone().addDates Math.round (rand*100)+1
#  obj.KEEP_PERIOD = Math.round(Math.abs((obj.DEL_DATE.getTime() - obj.REQ_DATE.getTime())/(24*60*60*1000)));
#  obj.STATUS = do ->
#    if rand < 0.1 then 'error test'
#    else if rand > 0.5 then 'wait'
#    else 'success'
#  CollectionDasInfos.insert obj
#
#
