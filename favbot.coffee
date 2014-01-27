twitter = require 'twit'
settings = require './settings.local'

tweeper = new twitter settings.twitter

log = (str) ->
	console.log("[favbot] " + str)

delay = (ms, func) ->
	setTimeout func, ms

favoriteTweet = (tweet) ->
	tweeper.post 'favorites/create', { id: "" + tweet.id_str }, (errors, tweet) ->
		if errors
			log errors
			return
		log 'Tweet by @' + tweet.user.screen_name + ' favorited!'

startTracking = ->
	stream = tweeper.stream 'statuses/filter', { track: settings.keywords.join ', ' }
	stream.on 'tweet', (tweet) ->
		log '  Found a tweet from @' + tweet.user.screen_name + " (id " + tweet.id_str + ", waiting for " + settings.delay + "s)"
		log '  ' + tweet.text
		delay settings.delay * 1000, -> favoriteTweet tweet

startTracking()