# Log time spent on different tasks
#
# log <hours> on "<task title>" [for today|for yesterday|for last Mon/Tue/Wed/Thu/Fri]
# remove logged <hours> on "<task title>" [for today|for yesterday|for last Mon/Tue/Wed/Thu/Fri]
# show time logged [for yesterday|for today|for last sprint]
#

module.exports = (robot) ->
  robot.respond /log ([0-9.]+) on "([^"]+)"$/i, (msg) ->
    user_id = msg.message.user.id
    time = msg.match[1]
    title = msg.match[2]
    date = dateKeyFor(null)

    addTimeLogForDate(robot, date, user_id, time, title)
    msg.send "ok, logged #{time} on \"#{title}\""

  robot.respond /show time logged$/i, (msg) ->
    user_id = msg.message.user.id
    date = dateKeyFor(null)

    if log = timeLogForDate(robot, date, user_id)
      msg.send "#{msg.message.user.name}:\n" + ("#{item.time.toFixed(1)} #{item.title}" for item in log).join("\n")
    else
      msg.send "nothing has been logged yet"

addTimeLogForDate = (robot, date, user_id, time, title) ->
  robot.brain.data.time_logs ||= {}
  log = robot.brain.data.time_logs[date] || {}
  user_log = log[user_id] || []
  user_log.push { title: title, time: parseFloat(time) }
  log[user_id] = user_log
  robot.brain.data.time_logs[date] = log

timeLogForDate = (robot, date, user_id) ->
  logs = robot.brain.data.time_logs || {}
  log = logs[date] || {}
  log[user_id]

dateKeyFor = (date) ->
  parseInt(new Date().getTime() / 1000 / 3600 / 24)
