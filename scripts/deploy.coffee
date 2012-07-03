# Deploying apps
#
# deploy <app>( from <branch>) - Deploys given branch of the given application.
# build <app>( from <branch>) - Builds given branch of the given application.
module.exports = (robot) ->
  host = 'http://ts.flatsoft.com'
  robot.respond /deploy ([^ ]*)(?: from (.*))?/i, (msg) ->
    options = {}
    options.branch = msg.match[2] if msg.match[2]?
    msg.http("#{host}/deploy/#{msg.match[1]}")
       .query(options)
       .post() (err, res, body) ->
         msg.send body.replace(/(\n|\r)+$/, '')

  robot.respond /build ([^ ]*)(?: from (.*))?/i, (msg) ->
    options = {force: 1}
    options.branch = msg.match[2] if msg.match[2]?
    msg.http("#{host}/build/#{msg.match[1]}")
       .post(qs.stringify options)
