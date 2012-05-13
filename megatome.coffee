$.ajaxSetup({"error": (XMLHttpRequest, textStatus, errorThrown) ->
	alert(textStatus)
	alert(errorThrown)
	alert(XMLHttpRequest.responseText)
	})

tweets = {}

redraw = (id, new_name) ->
	id = document.getElementById("id#{id+1}")
	id.innerHTML = id.innerHTML + "<br>#{new_name}"

update_column = (id, tweet) ->
	text = tweet.text.replace " #sworcery", ""
	if tweets[text]
		tweets[text].push tweet.from_user unless $.inArray tweet.from_user, tweets[text]
		redraw id, tweet.from_user
		console.log(tweets[text])
	else
		document.getElementById("id#{id+1}").innerHTML = tweet.from_user
		document.getElementById("tweet#{id+1}").innerHTML = text
		tweets[text] = [tweet.from_user]

update_columns = (data) ->
	update_column i, tweet for tweet, i in data.results

search = (hashtag, count) ->
	host = "http://search.twitter.com"
	url = "#{host}/search.json?q=%23#{hashtag}&include_entities=false&result_type=recent&rpp=#{count}&callback=?"
	$.getJSON(url, update_columns)

search("sworcery", 8)