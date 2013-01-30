$(document).ready ->

  body = $('body')
  compose = $('img.compose')
  tweet = $('img.tweet')
  reply = $('img.reply')
  landing = $('img.landing')
  load = $("#load")   
  slider = null

  bodyClass = (x) ->  
    body.removeClass()     
    myClass = $(x).attr('href') .replace('/', '')      
    console.log myClass
    if myClass is ""
      body.addClass('home')
    else
      body.addClass(myClass)
  
  # ajax #load content
  $(".nav a, .brand, footer .legal").live "click", (e) ->
    e.preventDefault()
    if $(@).hasClass('login') or $(@).hasClass('contact')
      if $(@).hasClass('contact')
        return false
      else
        window.open('http://pro.localresponse.com')
    else
      $(".nav a").parent().removeClass "active"
      $(@).parent().addClass "active"
      load.empty()
      bodyClass(@)
      $.ajax(@href).done (data) =>                      
        load.html(data).hide().fadeIn 200
        

  slideSwitcher = (elem) ->
    switcher = $("ul.switcher a")    
    indexVar = $(elem).index() 
    slide = 'intent'    
    slide = 'response' if $(elem).parent().hasClass('response') 
    divSelect = ".#{slide} .guide, .#{slide} .screen"
    divInit = ".#{slide} .guide:eq(0), .#{slide} .screen:eq(0)"    
    newDiv = ".#{slide} .guide:eq(#{indexVar}), .#{slide} .screen:eq(#{indexVar})"
    activeList =  $("ul.switcher a.active").index()  
    newSwitch = $("ul.switcher a:eq(#{indexVar})")        
         
    
    $(divSelect).removeClass('selected')
    switcher.removeClass()
    $(elem).addClass('active')
    newSwitch.addClass('active')
    $(newDiv).addClass('selected')
    if indexVar is 0
      $(divInit).addClass('selected')
  
  # switch between iphone screens when clicking circles    
  $("ul.switcher a, .guide").live "click", () ->
    slideSwitcher(@)
    clearInterval(slider)
    setTimeout (->
      clearInterval(slider)      
      slider = setInterval (->
        slideTimer()
      ), 6000          
    ), 10000

  # cycle through slides     
  slideTimer = () ->
    num =  $("ul.switcher a.active").index()       
    num = (num + 1) % 4 
    elem = $("ul.switcher a:eq(#{num})")        
    slideSwitcher(elem)         
  
  slider = setInterval (->
    slideTimer()
  ), 6000    


  # switch between dr and intent retargeting with buttons below iphone
  $(".product_buttons button").live "click", () ->
    switcher = $("ul.switcher li")
    switchLink = $("ul.switcher a")
    products = $('.response, .intent')
    products.hide()
    $('.screen, .guide').removeClass('selected')   
    switcher.removeClass() 
    switchLink.removeClass()
    switchLink.eq(0).addClass('active')
    if $(@).hasClass('response_button') 
      switcher.addClass('response') 
      $('.response').show()
      $('.response .guide:eq(0), .response .screen:eq(0)').addClass('selected')
    else
      switcher.addClass('intent')       
      $('.intent').show()  
      $('.intent .guide:eq(0), .intent .screen:eq(0)').addClass('selected')
          
      
  # cycle through press quotes
  cyclePress = () ->
    activePress = $('ul.press li.active')
    activeIndex = activePress.index()
    newPress = "ul.press li:eq(#{activeIndex + 1})"
    activePress.removeClass('active').fadeOut 500, ()->
      if activeIndex > 3
        $('ul.press li:eq(0)').addClass('active').hide().fadeIn 500
      else
        $(newPress).addClass('active').hide().fadeIn 500
        
  setInterval (->
    cyclePress()
  ), 8000    
      
  # forms 
  # email form
  dom =
    customerName:       $ 'input[name="customerName"]'
    customerEmail:      $ 'input[name="customerEmail"]'
    customerMessage:    $ 'textarea[name="customerMessage"]'    
    mailingButton:      $ '#mailingButton'
    subscriberEmail:    $ 'input[name="subscriberEmail"]'
  
  missingNameText = "Please enter your name"
  missingEmailText = "Please enter a valid email"  
  missingMessageText = "Please enter a message" 
  
  saveToMailingList = ->
    console.log 'Saving to mailing list'
    email = dom.subscriberEmail.val()
    # Validate that we have an email being entered
    if !verifyEmail(email)
      dom.subscriberEmail.val missingEmailText
      dom.subscriberEmail.css('color', '#E25959')
    else if ((email == dom.subscriberEmail.attr("placeholder")) || (email == missingEmailText))
      dom.subscriberEmail.val missingEmailText
      dom.subscriberEmail.css('color', '#E25959')
    else  
      console.log 'Making AJAX call'
      $.ajax
        url: "https://pro.localresponse.com/api/2/landingpage/stayUpdated"
        data: {"email": email}
        type: 'get'
        cache: false
        dataType: 'json'        
      .done ->
        console.log 'email sent'        
        btn = $("#mailingButton")
        btn.html("Thanks!").delay(2000).queue ->
          btn.html("Submit")
      .fail ->
        console.log 'failed'
        $('#mailingButton').html 'Please Try Again'
              
  dom.mailingButton.unbind('click').click (e) =>
    e.preventDefault()
    saveToMailingList()
  
  # get in touch form 
  verifyEmail = (email) ->
    console.log "Email is: #{email}" 
    emailRegEx = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
    if (email.search(emailRegEx) == -1) 
      console.log 'invalid email'
      return false
    else 
      console.log 'valid email'
      return true
    
  $('#infoRequestButton').unbind('click').click (e) ->
    console.log 'Sending email with details'
    customerName = dom.customerName.val()
    customerEmail = dom.customerEmail.val()
    customerMessage = dom.customerMessage.val()

    # Validate that they've put something in all of our required fields
    needsMoreData = false

    if ((customerName == dom.customerName.attr("placeholder")) || (customerName == missingNameText))
      dom.customerName.val missingNameText
      dom.customerName.css('color', '#E25959')
      needsMoreData = true
    if ((customerEmail == dom.customerEmail.attr("placeholder")) || (customerEmail == missingEmailText) || (!verifyEmail(customerEmail)))
      dom.customerEmail.val missingEmailText
      dom.customerEmail.css('color', '#E25959')
      needsMoreData = true      
    if ((customerMessage == dom.customerMessage.attr("placeholder")) || (customerMessage == missingMessageText))
      dom.customerMessage.val missingMessageText
      dom.customerMessage.css('color', '#E25959')
      needsMoreData = true

    if needsMoreData is true
      $('#infoRequestButton').html 'Submit'
    else  
      $('#infoRequestButton').html 'Submitting...'
      console.log 'Calling the api'
      $.ajax
        url: "/api/2/landingpage/getMoreInformation"
        data: {"customerName": customerName, "customerEmail": customerEmail, "customerMessage": customerMessage}
        type: 'get'
        cache: false
        dataType: 'json'
      .done ->
        console.log 'email sent'        
        btn = $("#infoRequestButton")
        btn.html("Thanks!").delay(2000).queue ->
          btn.html("Submit")
      .fail ->
        $('#infoRequestButton').html 'Please Try Again'
