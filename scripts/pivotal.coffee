# Commands:
#   i need stories - lists available stories
#   my stories - lists my work that isn't yet accepted
#   start story - starts story
#   finish story - finishes story
#   deliver story - delivers story
'use strict'

api_token = process.env.HUBOT_PIVOTAL_API_TOKEN
project_id = process.env.HUBOT_PIVOTAL_PROJECT_ID
stories_url = "https://www.pivotaltracker.com/services/v5/projects/#{ project_id }/stories"

module.exports = (robot) ->
  robot.hear /i need stories/i, (responder) ->
    robot.http("#{ stories_url }?filter=current_state%3Aunstarted")
      .header('X-TrackerToken', api_token)
      .header('Content-Type', 'application/json')
      .get() (err, res, stories) ->
        if err
          responder.send err
          return

        stories = JSON.parse stories

        responder.send '\nHere are available stories in Pivotal Tracker:\n'
        stories.forEach (story, index, array) ->
          responder.send "#{ story.id }: #{ story.name }"

  robot.hear /my stories/i, (responder) ->
    robot.http("#{ stories_url }?filter=owner%3A\"Jack%20Tarantino\"")
      .header('X-TrackerToken', api_token)
      .header('Content-Type', 'application/json')
      .get() (err, res, stories) ->
        if err
          responder.send err
          return

        stories = JSON.parse stories || []

        responder.send '\nHere is your current work in Pivotal Tracker:\n'
        stories.forEach (story, index, array) ->
          if story.current_state is 'accepted'
            return
          responder.send "#{ story.id }: #{ story.name }"

  robot.hear /start story (\d+)/i, (responder) ->
    story_number = responder.match[1]
    data = JSON.stringify({ current_state: "started" })

    robot.http("#{ stories_url }/#{ story_number }")
      .header('X-TrackerToken', api_token)
      .header('Content-Type', 'application/json')
      .put(data) (err, res, data) ->
        if err
          responder.send err
        else
          responder.send "\nStarted story ##{ story_number }\n"

  robot.hear /finish story (\d+)/i, (responder) ->
    story_number = responder.match[1]
    data = JSON.stringify({ current_state: "finished" })

    robot.http("#{ stories_url }/#{ story_number }")
      .header('X-TrackerToken', api_token)
      .header('Content-Type', 'application/json')
      .put(data) (err, res, data) ->
        if err
          responder.send err
        else
          responder.send "\nFinished story ##{ story_number }\n"

  robot.hear /deliver story (\d+)/i, (responder) ->
    story_number = responder.match[1]
    data = JSON.stringify({ current_state: "started" })

    robot.http("#{ stories_url }/#{ story_number }")
      .header('X-TrackerToken', api_token)
      .header('Content-Type', 'application/json')
      .put(data) (err, res, data) ->
        if err
          responder.send err
        else
          responder.send "\nDelivered story ##{ story_number }\n"
