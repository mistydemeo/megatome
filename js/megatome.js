// Generated by CoffeeScript 1.3.1
(function() {
  var add_row, latest_id, new_tweet, search, tweets, update, update_columns;

  tweets = {};

  latest_id = "0";

  Array.prototype.includes = function(v) {
    if ($.inArray(v, this) > -1) {
      return true;
    } else {
      return false;
    }
  };

  String.prototype.desworcerize = function() {
    return this.replace(/\ #sworcery$/, "");
  };

  new_tweet = function(tweet) {
    var from, text, tweet_element, tweet_header;
    text = tweet.text.desworcerize();
    if (!tweets[text]) {
      tweets[text] = {};
      tweets[text].users = [tweet.from_user];
      tweets[text].ids = [tweet.id_str];
    } else {
      if (tweets[text].users.includes(tweet.from_user)) {
        tweets[text].users.push(tweet.from_user);
      }
      if (tweets[text].ids.includes(tweet.id_str)) {
        tweets[text].ids.push(tweet.id_str);
      }
    }
    from = tweets[text].users.join(', ');
    tweet_header = "<div class='span2'>" + from + "</div>";
    tweet_element = "<div class='span4'>" + text + "</div>";
    return tweet_header + tweet_element;
  };

  add_row = function(data) {
    var row;
    row = "<div class='row-fluid'>" + (new_tweet(data[0])) + (new_tweet(data[1])) + "</div>";
    return $(row).hide().prependTo('#tweetbox').fadeIn('slow').slideDown();
  };

  update_columns = function(data) {
    var i, index, new_tweets, text, tweet, _i, _j, _ref, _ref1, _results;
    if (data.results.length === 0) {
      return;
    }
    latest_id = data.results[0].id_str;
    new_tweets = [];
    for (i = _i = 0, _ref = data.results.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      tweet = data.results[i];
      text = tweet.text.desworcerize();
      if (!tweets[text] || !tweets[text].ids.includes(tweet.id_str)) {
        new_tweets.push(tweet);
      }
    }
    if (new_tweets.length < 2) {
      return;
    }
    new_tweets = new_tweets.reverse();
    _results = [];
    for (i = _j = 0, _ref1 = Math.floor((new_tweets.length - 1) / 2); 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
      index = i * 2;
      _results.push(add_row(new_tweets.slice(index, (index + 1) + 1 || 9e9)));
    }
    return _results;
  };

  search = function(hashtag, count) {
    var host, url;
    host = "http://search.twitter.com";
    url = "" + host + "/search.json?q=%23" + hashtag + "&include_entities=false&result_type=recent&rpp=" + count + "&since_id=" + latest_id + "&callback=?";
    return $.getJSON(url, update_columns);
  };

  update = function() {
    return search("sworcery", 10);
  };

  update();

  setInterval(update, 60000);

}).call(this);
