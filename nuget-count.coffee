
promise = require 'when'
scrape = require 'scrape'
api = 'https://www.nuget.org/profiles/:user'

getUrl = (user = '') ->
	api.replace ':user', user

packages = (user) ->

	deferred = do promise.defer
	page = -1
	total = 0
	requests = 0

	request = ->

		++requests

		url = getUrl user, ++page
		scrape.request url, (err, $) ->
			process err, $

	process = (err, $) ->

		rows = $ '#package .row'
		count = rows.length

		if err or (count is 1 and requests is 1)
			deferred.reject err

		else

			if count > 1

				total += count
				deferred.notify total
				request()

			else

				deferred.resolve total

	# go!
	request()

	# return
	deferred.promise

module.exports = packages