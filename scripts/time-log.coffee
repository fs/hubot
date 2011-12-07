# Log time spent on different tasks
#
# log <hours> on "<task title>" [for today|for yesterday]
# show time logged [for today|for yesterday]
#

module.exports = (robot) ->
  robot.respond /log ([0-9.]+) on "([^"]+)"(?: for (today|yesterday))?$/i, (msg) ->
    user_id = msg.message.user.id
    time = msg.match[1]
    title = msg.match[2]
    date_key = msg.match[3] || "today"
    date = dateKeyFor(date_key)

    addTimeLogForDate(robot, date, user_id, time, title)
    msg.send "ok, logged #{time} on \"#{title}\" for #{date_key}"

  robot.respond /show( all)? time logged(?: for (today|yesterday))?$/i, (msg) ->
    user_id = msg.message.user.id
    date_key = msg.match[2] || "today"
    date = dateKeyFor(date_key)

    logs = usersLoggedForDate(robot, date)

    if msg.match[1]
      if logs
        msg.send "#{formatDateKey(date)}\n---------------------\n\n" + formatLogForUsers(robot, logs)
      else
        msg.send "nothing has been logged yet for #{date_key}"
    else
      if log = timeLogForDate(robot, date, user_id)
        msg.send formatLogForUser(robot, user_id, log)
      else
        msg.send "nothing has been logged yet for #{date_key}"

  robot.respond /show all time logged for all time/i, (msg) ->
    logs = robot.brain.data.time_logs || {}
    result = ""
    
    for date, user_logs of logs
      result += "#{formatDateKey(date)}\n---------------------\n\n"
      result += formatLogForUsers(robot, user_logs)

    msg.send result

addTimeLogForDate = (robot, date, user_id, time, title) ->
  robot.brain.data.time_logs ||= {}
  log = robot.brain.data.time_logs[date] || {}
  user_log = log[user_id] || []
  user_log.push { title: title, time: parseFloat(time) }
  log[user_id] = user_log
  robot.brain.data.time_logs[date] = log

usersLoggedForDate = (robot, date) ->
  logs = robot.brain.data.time_logs || {}
  log = logs[date] || {}

timeLogForDate = (robot, date, user_id) ->
  usersLoggedForDate(robot, date)[user_id]

formatTimeLogEntries = (log) ->
  ("#{item.time.toFixed(1)} #{item.title}" for item in log)

formatLogForUser = (robot, user_id, log) ->
  "#{robot.userForId(user_id).name}:\n" + formatTimeLogEntries(log).join("\n")
  
formatLogForUsers = (robot, logs) ->
  (formatLogForUser(robot, user_id, items) for user_id, items of logs).join("\n\n")

millisecondsPerDay = 24 * 3600 * 1000

dateKeyFor = (date) ->
  key = parseInt(new Date().getTime() / millisecondsPerDay)
  key -= 1 if date is 'yesterday'
  key

formatDateKey = (date) ->
  months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",
            "Oct", "Nov", "Dec"]
  days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

  d = new Date(date * millisecondsPerDay)
  "#{days[d.getDay()]}, #{months[d.getMonth()]} #{d.getDate()}, #{d.getFullYear()}"
