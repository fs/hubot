module.exports = (robot) ->
  robot.router.post "/hubot/say", (req, res) ->
    room = req.body.room
    message = req.body.message
    robot.logger.info "Message '#{message}' received for room #{room}"
    user = robot.userForId 'broadcast'
    user.room = room
    user.type = 'groupchat'
    robot.send user, "#{message}"
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks'