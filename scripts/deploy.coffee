# Deploying apps
#
# deploy <app> from <branch> - Deploys given branch of the given application.
module.exports = (robot) ->
  robot.respond /deploy (.*) from (.*)/i, (msg) ->
    app = msg.match[1]
    branch = msg.match[2]
    msg.http("http://integrity.flatsourcing.com/deploy")
      .query({
        project: app,
        branch: branch
      })
      .post() (err, res, body) ->
        msg.send body.replace(/(\n|\r)+$/, '')
