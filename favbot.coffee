twitter = require 'twit'
settings = require './settings'

tweeper = new twitter settings.twitter

log = (str) ->
	console.log("[favbot] " + str)

delay = (ms, func) ->
	setTimeout func, ms

favoriteTweet = (tweet) ->
	tweeper.post 'favorites/create', { id: "" + tweet.id }, (errors, tweet) ->
		return if errors
		log 'Tweet by @' + tweet.user.screen_name + ' favorited!'

startTracking = ->
	stream = tweeper.stream 'statuses/filter', { track: settings.keywords.join ', ' }
	stream.on 'tweet', (tweet) ->
		log '  Found a tweet from @' + tweet.user.screen_name + " (waiting for " + settings.delay + "s)"
		log '  ' + tweet.text
		delay settings.delay * 1000, -> favoriteFunc tweet

startTracking()