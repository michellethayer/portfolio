# inject twitter status updates on about page
# load.on "load", "#team" ,() ->
tweeters = $('body').find('.tweet[data-screenname]')
_.each tweeters, (div) ->
  sn = $(div).attr('data-screenname')
  url = "https://api.twitter.com/1/users/show/#{sn}.json"
  image = $(div).children('img')    
  p = $(div).children('p')
  $.ajax
    url: url
    cache: false
    dataType: 'jsonp'
    success: (result) ->
      text = result.status.text
      img = result.profile_image_url
      p.html "<a href='http://www.twitter.com/#{sn}' target='_blank'>#{text}</a>"
      image.attr("src", "#{img}") 
