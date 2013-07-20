# -----------------------------------------------------------------------
# APP MAIN JS

$(document).ready ->

  endpoint = 'http://collectorwp.com/api/v1/'

  valid_email = (email) ->
    return String(email).match(/^\s*[\w\-\+_]+(?:\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(?:\.[\w‌​\-\+_]+)*\s*$/)
  
  #1 LINKS
  $ ->
    $('.top-menu a, .mobile-menu a').click (e) ->
      do e.preventDefault

      targetid = $(this).attr('href')
      target = $(targetid).offset()

      $('.mobile-menu').slideUp 500
      $('.mobile-menu-activator').removeClass 'active'

      $("html,body").animate
        scrollTop: target.top - 30
      , 400, () ->
        do $('input[name="name"]').focus if targetid is '#write'

  #2 FORM
  $ ->
    $form = $ '.hello form'
    $txt = $form.find 'textarea'
    $counter = $form.find 'span.counter'

    $txt.on 'keyup', ->
      text = do $txt.val
      remaining = 500 - text.length
      if remaining < 0
        remaining = 0
        $txt.val text.substring 0, 500
      $counter.html remaining

    $form.submit ->
      form = $ this
      name = form.find 'input[name="name"]'
      email = form.find 'input[name="email"]'
      message = form.find 'textarea'

      return do name.focus && false if name.val().length == 0
      return do email.focus && false if email.val().length == 0 || !valid_email(email.val())
      return do message.focus && false if message.val().length < 4

      form.slideUp 500, ->
        main = $ '.hello .banner h2'
        sec = $ '.hello .banner p'
        main.text 'Sending...'
        sec.text 'Please wait a second while we deliver your message.'

        $.ajax
          type: 'POST'
          url: endpoint + 'sendmessage/'
          data: {
            name: do name.val
            email: do email.val
            company: do form.find('input[name="company"]').val
            website: do form.find('input[name="website"]').val
            message: do message.val
            target: 'all'
          }

          success: () ->
            main.text 'Your message has been sent!'
            sec.text 'Thank you very much. We\'ll get back to you as soon as possible.'

          error: (xhr, text_status, error_thrown) ->
            response = $.parseJSON xhr.responseText
            if response
              main.text 'There was an error :('
              sec.text response.description

      false

  #3 PEOPLE (img cycle)
  $ ->
    $(".person").each () ->
      el = $ this
      container = el.find '.img'
      person = el.data 'person'
      for i in [2..13]
        container.append $ "<li><img src='img/crew/#{person}-#{i}.jpg' /></li>"

    $(".person .img").each () ->
      el = $ this

      el.cycle(
        fx: "none"
        speed:    90, 
        timeout:  160 
      ).cycle "pause"

      el.hover () ->
        el.cycle "resume"
      , () ->
        el.cycle "pause"
        el.cycle 0

  #4 CREW FORM
  $ ->

    $('.person .mail').click (e) ->
      do e.preventDefault
      el = $ this
      form = el.closest('.person').find('.contact-form')

      form.toggleClass 'hidden'
      el.toggleClass 'active'

    $form = $ '.person form'

    $form.submit ->
      form = $ this
      recipient = form.data 'recipient'
      person = recipient.capitalize()
      email = form.find 'input[name="email"]'
      message = form.find 'textarea'

      return do email.focus && false if email.val().length == 0 || !valid_email(email.val())
      return do message.focus && false if message.val().length < 4

      form.slideUp 500, () ->
        main = $ '<p class="response"></p>'
        form.replaceWith main
        main.html 'Please wait a second while we deliver your message to ' + person + '.'

        $.ajax
          type: 'POST'
          url: endpoint + 'sendmessage/'
          data: {
            email: do email.val
            message: do message.val
            target: recipient
          }

          success: () ->
            main.text 'Your message has been sent to ' + person + '!'

          error: (xhr, text_status, error_thrown) ->
            response = $.parseJSON xhr.responseText
            if response
              main.text 'There was an error sending your message: ' + response.description

      false


  #5 SCRIPT TO FLIP THE FILES
  $ ->
    tiles = $ '.quotes .flip'
    window.setInterval () ->

      tile = tiles[Math.floor(Math.random() * tiles.length)]
      $(tile).toggleClass 'on'

    , 3000

  #6 VIDEO
  $ ->
    video = document.getElementsByTagName('video')[0];
    videoEnded = (e) ->
      $('.carousel .container').fadeIn 500

    video.addEventListener 'ended', videoEnded, false

  #7 MOBILE MENU
  $ ->
    menu = $ '.mobile-menu'
    $('.mobile-menu-activator').click () ->
      el = $ this
      el.toggleClass 'active'
      menu.slideToggle 500