lineStatDatas = new ReactiveVar() #꺽은선 차트 데이터
pieStatDatas = new ReactiveVar()  #용량통계 파이 차트 데이터
agentInfosRv = new ReactiveVar()  #Agent현황 데이터
serviceAccumStatsRv = new ReactiveVar() #서비스별 처리현황 데이터

Template.home.onRendered ->
  @autorun ->
    $('#line_chart_div').highcharts
      colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
      title:
        text: ''
      #      x: -20
      #    subtitle:
      #      text: 'Source: WorldClimate.com'
      #      x: -20
      xAxis:
        title: text: '(시간)'
        categories: lineStatDatas.get()?.categories
      yAxis:
        title: text: '(건)'
        plotLines: [ {
          value: 0
          width: 1
          color: '#808080'
        } ]
      tooltip: valueSuffix: '건'
#      legend:
#        layout: 'vertical'
#        align: 'right'
#        verticalAlign: 'middle'
#        borderWidth: 0
      series: lineStatDatas.get()?.series
      credits:
        enabled: false

  @autorun ->
    # Build the chart
    $('#donut_chart_div').highcharts
      colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
      chart:
        backgroundColor: 'transparent'
#        plotBackgroundColor: "#d2dfe9"
        plotBorderWidth: 0
        borderWidth: 0
        plotShadow: false
        type: 'pie'
#      title: text: 'Browser market shares January, 2015 to May, 2015'
      title: text: null
      tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      plotOptions: pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: false
#        showInLegend: true
      series: [ {
        name: 'Brands'
        colorByPoint: true
        data: do -> if pieStatDatas.get()? then libClient.calForPercent pieStatDatas.get()
      } ]
      credits:
        enabled: false

  ##차트 최초 로드를 위해서 autorun 밑에서 호출함
  todayObj = libClient.getRealtimeDate()
  Meteor.call 'getSimpleRealTimeStats', todayObj.start, (err, rslt) ->
    if err
      alert err
    else
      lineStatDatas.set rslt
  Meteor.call 'getSimmpleCapaStats', (err, rslt) ->
    if err then alert err
    else
      pieStatDatas.set rslt

  ##Agent 현황 정보
  Meteor.call 'getAgentInfos', (err, rslt) ->
    if err then alert err
    else
      agentInfosRv.set rslt

  ##서비스별 처리현황
  Meteor.call 'getAccumStats', (err, rslt) ->
    if err then alert err
    else
      serviceAccumStatsRv.set rslt


Template.home.helpers
  누적요청: ->
    total = 0
    if lineStatDatas.get()?
      lineStatDatas.get().series[0].data.forEach (val) ->
        total += val
    return total
  대기현황: -> jUtils.formatBytes pieStatDatas.get()?[0].y
  처리현황: -> jUtils.formatBytes pieStatDatas.get()?[1].y
  agents: -> agentInfosRv.get()?.data
  agent사용갯수: -> agentInfosRv.get()?.사용
  agent미사용갯수: -> agentInfosRv.get()?.미사용
  isUseAgent: -> if @STATUS then 'on' else ''
  serviceAccumStats: -> serviceAccumStatsRv.get()

Template.home.events
  'click #agent_content > li': (e, tmpl) ->

  'click .tab > ul': (e, tmpl) ->
    if $(e.target).hasClass('ready')
      target = $(e.target).parent()
      $('.tab > ul > li').removeClass 'on'
      target.addClass 'on'
    else
      alert '업데이트 예정입니다.'
      e.preventDefault()
      return false