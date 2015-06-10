# Commands:
#   what's the weather - lists the short-term forecast
'use strict'

module.exports = (robot) ->

  robot.hear /what's the weather/i, (res) ->
    robot.http('http://api.wunderground.com/api/f822e8f084978f91/forecast/q/NY/New_York.json')
      .get() (err, response, body) ->
        if err
          res.send err
          return
        unless JSON.parse(body)?.forecast?.txt_forecast?.forecastday?
          res.send '\nThere was an error retrieving the weather.'
          return
        res.send '\nThe weather for this week is:'
        forecasts = JSON.parse(body).forecast.txt_forecast.forecastday
        forecasts.forEach (day, index, array) ->
          res.send '', day.title, day.fcttext
