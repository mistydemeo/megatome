$.ajaxSetup({"error": (XMLHttpRequest, textStatus, errorThrown) ->
	alert(textStatus)
	alert(errorThrown)
	alert(XMLHttpRequest.responseText)
	})

tweets = {}

new_tweet = (tweet) ->
	text = tweet.text.replace " #sworcery", ""

	tweet_header = "<div class='span2'>#{tweet.from_user}</div>"
	tweet_element = "<div class='span4'>#{text}</div>"
	tweet_header + tweet_element

add_row = (data) ->
	row = "<div class='row-fluid'>#{new_tweet data[0]}#{new_tweet data[1]}</div>"
	$('#tweetbox').prepend row

update_columns = (data) ->
	for i in [0..data.results.length/2]
		add_row data.results[i..i+1]

search = (hashtag, count) ->
	host = "http://search.twitter.com"
	url = "#{host}/search.json?q=%23#{hashtag}&include_entities=false&result_type=recent&rpp=#{count}&callback=?"
	$.getJSON(url, update_columns)

search("sworcery", 8)