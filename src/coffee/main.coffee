String.prototype.capitalize = () ->
  this.charAt(0).toUpperCase() + this.slice(1)

$(document).ready ->

  endpoint = 'http://collectorwp.com/api/v1/'
  
  #1 LINKS
  do () ->
    $('.top-menu a').click (e) ->
      do e.preventDefault

      targetid = $(this).attr('href')
      target = $(targetid).offset()

      $("html,body").animate
        scrollTop: target.top - 30
      , 400, () ->
        do $('input[name="name"]').focus if targetid is '#write'

  #2 FORM
  do () ->
    $form = $ '.hello form'
    $txt = $form.find 'textarea'
    $counter = $form.find 'span.counter'

    $txt.on 'keyup', () ->
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
      return do email.focus && false if email.val().length == 0
      return do message.focus && false if message.val().length == 0

      form.slideUp 500, () ->
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
  do () ->
    $(".person .img").each () ->
      el = $ this

      el.cycle(
        fx: "none"
        speed:    100, 
        timeout:  170 
      ).cycle "pause"

      el.hover () ->
        el.cycle "resume"
      , () ->
        el.cycle "pause"

  #4 CREW FORM
  do () ->

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

      return if recipient not 'nicholas' and recipient not 'michela'

      return do email.focus && false if email.val().length == 0
      return do message.focus && false if message.val().length == 0

      form.slideUp 500, () ->
        main = $ '<p class="response"></p>'
        form.replaceWith main
        main.text 'Please wait a second while we deliver your message to ' + person + '.'

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
