@jDefine =
  timeFormat: 'YYYY-MM-DD HH:mm:ss'
  timeFormatYMDHM: 'YYYY-MM-DD HH:mm'
  timeFormatMDHM: 'MM-DD HH:mm'
  timeFormatMD: 'MM-DD'
  timeFormatYM: 'YYYY-MM'
  timeFormatYMD: 'YYYY-MM-DD'
  timeFormatYMDdot: 'YYYY.MM.DD'
  timeFormatHMS: 'HH:mm:ss'
  timeFormatH: 'HH'
  timeFormatM: 'mm'
  timeFormatHM: 'HH:mm'

  dayTimeDiv: ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
  dashBoardDayTimeDiv: ['09','10','11','12','13','14','15','16','17','18','19','20']
  periodCateForPie: [
    {
      name:'한달미만',
      period: {
        $gte: 0
        $lt: 31
      }
    }
    {
      name:'6개월미만',
      period: {
        $gte: 31
        $lt: 180
      }
    }
    {
      name:'1년미만',
      period: {
        $gte: 180
        $lt: 365
      }
    }
    {
      name:'1년이상',
      period: {
        $gte: 365
      }
    }
  ]
