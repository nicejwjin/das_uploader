@cl = (msg) ->
  console.log msg

@Date.prototype.addSeconds = (s) ->
  @setSeconds @getSeconds() + s
  return @
@Date.prototype.addMinutes = (m) ->
  @setMinutes @getMinutes() + m
  return @
@Date.prototype.addHours = (h) ->
  @setHours @getHours() + h
  return @
@Date.prototype.addDates = (d) ->
  @setDate @getDate() + d
  return @
@Date.prototype.clone = -> return new Date @getTime()

@jUtils =
  formatBytes: (bytes, decimals) ->
#    usage: formatBytes(139328839)
    if(bytes == 0) then return '0 Byte'
    k = 1000
    dm = decimals + 1 || 3
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
    i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]

  mydiff: (date1, date2, interval) ->
    #usage: mydiff('date1', 'date2', 'days')
    second = 1000
    minute = second * 60
    hour = minute * 60
    day = hour * 24
    week = day * 7
    date1 = new Date(date1)
    date2 = new Date(date2)
    timediff = date2 - date1
    if isNaN(timediff)
      return NaN
    switch interval
      when 'years'
        return date2.getFullYear() - date1.getFullYear()
      when 'months'
        return date2.getFullYear() * 12 + date2.getMonth() - (date1.getFullYear() * 12 + date1.getMonth())
      when 'weeks'
        return Math.floor(timediff / week)
      when 'days'
        return Math.floor(timediff / day)
      when 'hours'
        return Math.floor(timediff / hour)
      when 'minutes'
        return Math.floor(timediff / minute)
      when 'seconds'
        return Math.floor(timediff / second)
      else
        return undefined
  getStringYMDFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatYMD)
  getStringMDHMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatMDHM)
  getStringMDFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatMD)
  getStringHMSFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatHMS)
  getStringHFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatH)
  getStringMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatM)
  getStringHMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatHM)
  getStringYMDHMSFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormat)
  getStringYMDHMFromDate: (_date) ->
    return moment(_date).format(jDefine.timeFormatYMDHM)
  getDateFromString: (_date) ->
    return moment(_date, jDefine.timeFormat).toDate()

