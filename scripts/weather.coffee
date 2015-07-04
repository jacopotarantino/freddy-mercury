# Commands:
#   what's the weather - lists the short-term forecast
'use strict'

weather_service_url = 'http://api.wunderground.com/api/f822e8f084978f91/forecast/q/NY/New_York.json'

handle_weather_service_response = (res, forecasts) ->
  res.send '\nThe weather for this week is:'
  forecasts.forEach (day, index, array) ->
    res.send '', day.title, day.fcttext

module.exports = (robot) ->
  robot.hear /what's the weather/i, (res) ->
    robot.http( weather_service_url )
      .get() (err, response, body) ->
        if err
          res.send "\n I'm sorry. I couldn't retrieve the weather. I received the following error:\n"
          res.send err
          return

        unless JSON.parse(body)?.forecast?.txt_forecast?.forecastday?
          res.send '\nThe weather service did not return usable data.'
          return

        forecasts = JSON.parse(body).forecast.txt_forecast.forecastday

        handle_weather_service_response(res, forecasts)

