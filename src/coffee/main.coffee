$(document).ready ->

  endpoint = 'http://collectorwp.com/api/v1/'
  
  #1 FORM
  do () ->
    $form = $ 'form'
    $txt = $form.find 'textarea'
    $counter = $form.find 'span.counter'

    $txt.on 'keyup', () ->
      text = do $txt.val
      remaining = 500-text.length
      if remaining < 0
        remaining = 0
        $txt.val text.substring 0, 500
      $counter.html remaining

    $form.submit ->
      name = $ 'input[name="name"]'
      email = $ 'input[name="email"]'
      message = $ 'textarea'

      return do name.focus && false if name.val().length == 0
      return do email.focus && false if email.val().length == 0
      return do message.focus && false if message.val().length == 0

      $form.slideUp 500, () ->
        main = $ '.banner h2'
        sec = $ '.banner p'
        main.text 'Sending...'
        sec.text 'Please wait a second while we deliver your message.'

        $.ajax
          type: 'POST'
          url: endpoint+'sendmessage/'
          data: {
            name: do name.val
            email: do email.val
            company: do $('input[name="company"]').val
            website: do $('input[name="website"]').val
            message: do message.val
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