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

  robot.respond /show time logged(?: for (today|yesterday))?$/i, (msg) ->
    user_id = msg.message.user.id
    date_key = msg.match[1] || "today"
    date = dateKeyFor(date_key)

    if log = timeLogForDate(robot, date, user_id)
      msg.send "#{msg.message.user.name}:\n" + ("#{item.time.toFixed(1)} #{item.title}" for item in log).join("\n")
    else
      msg.send "nothing has been logged yet for #{date_key}"

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
  millisecondsPerDay = 24 * 3600 * 1000
  key = parseInt(new Date().getTime() / millisecondsPerDay)
  key -= 1 if date is 'yesterday'
  key
