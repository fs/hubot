#module.exports = (robot) ->
#  robot.router.post "/hubot/say", (req, res) ->
#    robot.messageRoom req.body.room, req.body.message
#    res.writeHead 200, {'Content-Type': 'text/plain'}
#    res.end 'Thanks'
