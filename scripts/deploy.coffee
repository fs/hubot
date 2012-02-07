# Deploying apps
#
# deploy <app> from <branch> - Deploys given branch of the given application.
module.exports = (robot) ->
  robot.respond /deploy (.*) from (.*)/i, (msg) ->
    msg.send "deploying..."
    msg.http("http://services.flatsourcing.com/deploy")
       .query({
          project: msg.match[1]
          branch: msg.match[2]
        })
       .post() (err, res, body) ->
          msg.send err
          msg.send body.replace(/(\n|\r)+$/, '')
