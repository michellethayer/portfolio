$(document).ready ->
  scrollIt = (top, size)-> 
    $('body').css
      "background-position": ""
      "background-size": ""
    $("body.home").css
      "background-position": "0 #{100 + top/2}px"
      "background-size": "#{100 + size/400}%, #{100 + size/400}%"
  
  top =  $(window).scrollTop()
  size = 100 + (top / 15)   

  scrollIt(top, size)
  
  $("#load").load(->
    scrollIt(top, size)
  )
    
  $(window).scroll ->
    top =  $(window).scrollTop()
    size = 100 + (top / 15)   
    scrollIt(top, size)
    


