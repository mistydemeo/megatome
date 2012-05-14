$.ajaxSetup({"error": (XMLHttpRequest, textStatus, errorThrown) ->
	alert(textStatus)
	alert(errorThrown)
	alert(XMLHttpRequest.responseText)
	})

# To keep track of tweets that have already been displayed
tweets = {}
latest_id = "0"

Array::includes = (v) ->
	if $.inArray(v, this) > -1
		true
	else
		false

String::desworcerize = ->
	this.replace /\ #sworcery$/, ""

new_tweet = (tweet) ->
	text = tweet.text.desworcerize()

	if !tweets[text]
		tweets[text] = {}
		tweets[text].users = [tweet.from_user]
		tweets[text].ids = [tweet.id_str]
	else
		if tweets[text].users.includes tweet.from_user
			tweets[text].users.push tweet.from_user
		if tweets[text].ids.includes tweet.from_user
			tweets[text].ids.push tweet.id_str

	from = tweets[text].users.join(', ')

	tweet_header = "<div class='span2'>#{from}</div>"
	tweet_element = "<div class='span4'>#{text}</div>"

	tweet_header + tweet_element

add_row = (data) ->
	row = "<div class='row-fluid'>#{new_tweet data[0]}#{new_tweet data[1]}</div>"
	$('#tweetbox').prepend row

update_columns = (data) ->
	return if data.results.length == 0
	latest_id = data.results[0].id_str
	new_tweets = []

	for i in [0..data.results.length-1]
		tweet = data.results[i]
		text = tweet.text.desworcerize()
		if !tweets[text] || tweets[text].ids.includes tweet.id_str
			new_tweets.push tweet

	return if new_tweets.length == 0

	for i in [0..Math.floor((new_tweets.length - 1) / 2)]
		index = i*2
		add_row new_tweets[index..index+1]

search = (hashtag, count) ->
	host = "http://search.twitter.com"
	url = "#{host}/search.json?q=%23#{hashtag}&include_entities=false&result_type=recent&rpp=#{count}&since_id=#{latest_id}&callback=?"
	$.getJSON(url, update_columns)

update = ->
	search("sworcery", 8)

update()

setInterval(update, 60000)