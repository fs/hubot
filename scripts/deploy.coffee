# Deploying apps
#
# deploy <app>( from <branch>) - Deploys given branch of the given application.
module.exports = (robot) ->
  robot.respond /deploy (.*)(?: from (.*))?/i, (msg) ->
    params = {project: msg.match[1]}
    params['branch'] = msg.match[2] if msg.match.length > 2
    msg.http("http://integrity.flatsourcing.com/deploy")
       .query(params)
       .post() (err, res, body) ->
          msg.send body.replace(/(\n|\r)+$/, '')
