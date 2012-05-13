$.ajaxSetup({"error": (XMLHttpRequest, textStatus, errorThrown) ->
	alert(textStatus)
	alert(errorThrown)
	alert(XMLHttpRequest.responseText)
	})

tweets = {}

new_tweet = (tweet) ->
	text = tweet.text.replace " #sworcery", ""

	if !tweets[text]
		tweets[text] = {}
		tweets[text].users = [tweet.from_user]
		tweets[text].ids = [tweet.id_str]
	else
		if $.inArray(tweet.from_user, tweets[text].users) == -1
			tweets[text].users.push tweet.from_user
		if $.inArray(tweet.from_user, tweets[text].ids) == -1
			tweets[text].ids.push tweet.id_str

	from = tweets[text].users.join(', ')

	tweet_header = "<div class='span2'>#{from}</div>"
	tweet_element = "<div class='span4'>#{text}</div>"

	tweet_header + tweet_element

add_row = (data) ->
	row = "<div class='row-fluid'>#{new_tweet data[0]}#{new_tweet data[1]}</div>"
	$('#tweetbox').prepend row

update_columns = (data) ->
	new_tweets = []

	for i in [0..data.results.length-1]
		tweet = data.results[i]
		text = tweet.text.replace " #sworcery", ""
		if !tweets[text] || $.inArray(tweet.id_str, tweets[text].ids) == -1
			new_tweets.push tweet

	return if new_tweets.length == 0

	for i in [0..Math.floor((new_tweets.length - 1) / 2)]
		add_row new_tweets[i..i+1]

search = (hashtag, count) ->
	host = "http://search.twitter.com"
	url = "#{host}/search.json?q=%23#{hashtag}&include_entities=false&result_type=recent&rpp=#{count}&callback=?"
	$.getJSON(url, update_columns)

update = ->
	search("sworcery", 8)

update()

setInterval(update, 60000)