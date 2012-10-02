$(document).ready ->
  
  # ajax #load content    
  $('.header_nav > li > a, .brand').live "click", (e) ->
    e.preventDefault()   
    brand = $('.brand')
    load = $("#load")     
    if $(@).attr('href') is "/" and $('.header_nav > li:eq(0)').hasClass('active')
      return false
    else
      $('.header_nav > li').removeClass "active"
      if $(@).hasClass('brand') 
        $('.header_nav > li:eq(0)').addClass "active"
      else
        $(@).parent().addClass "active"            
      load.fadeOut 200
      $.ajax(@href).done (data) ->
        load.html(data).hide().fadeIn 200

  # testFunction called on /pics
  testFunction = () ->
    alert 'This is a test function!'
  window.testFunction = testFunction

