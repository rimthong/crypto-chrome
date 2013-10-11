$ ->
  engine = cryptochrome()

  $('#button-confirm-verify').click ()->
    $('#modal-verify').modal('hide')

  $('.button-close-verify').click ()->
    $('#modal-verify').modal('hide')

  $('#button-confirm-sign').click ()->
    master_password = $('#input-sign-master-password').val()
    key = $('#select-sign-private-key').val()
    key_password = $('#input-sign-private-password').val()
    $('#modal-sign').modal('hide')
    plainText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.list_private_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.sign(plainText, keys[index], key_password, master_password, (err, signed_message) ->
          #We send the content-script our signed text
          $('#popup-textarea').val(signed_message)
          chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
            chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: signed_message}, (response)->
              if response and response.status is 'ok'
                #Do nothing, injection successful
              else
                #Did not inject, just alter textarea
                $('#popup-textarea').val(signed_message)
                yes
        )
    )

  $('.button-close-sign').click ()->
    $('#modal-sign').modal('hide')

  $('#button-confirm-decrypt').click ()->
    master_password = $('#input-decrypt-master-password').val()
    key = $('#select-decrypt-private-key').val()
    key_password = $('#input-decrypt-private-password').val()
    $('#modal-decrypt').modal('hide')
    cipherText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.list_private_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.decrypt(cipherText, keys[index], key_password, master_password, (err, text) ->
          $('#popup-textarea').val text
        )
    )

  $('.button-close-decrypt').click ()->
    $('#modal-decrypt').modal('hide')

  $('#button-confirm-encrypt').click ()->
    master_password = $('#input-encrypt-master-password').val()
    key = $('#select-encrypt-public-key').val()
    $('#modal-encrypt').modal('hide')
    plainText = $('#popup-textarea').val()
    cipherText = null
    index = parseInt(key)
    engine.list_public_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.encrypt(plainText, keys[index], (err, encrypted_message) ->
          cipherText = encrypted_message
          console.log(cipherText)
          yes
        )
    )

    $('#popup-textarea').val(cipherText)
    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        if response and response.status is 'ok'
          #Do nothing, injection successful
        else
          #Did not inject, just alter textarea
          $('#popup-textarea').val(cipherText)

  $('.button-close-encrypt').click ()->
    $('#modal-encrypt').modal('hide')

  $('#button-confirm-enter-master-password').click ()->
    password = $('#input-entered-master-password').val()
    $('#modal-enter-master-password').modal('hide')
    populate_keys(engine, password)

  $('.button-close-enter-master-password').click ()->
    $('#modal-enter-master-password').modal('hide')

  $('#button-import-textarea').click ()->
    console.log "Clicked text area"
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'retrieve'}, (response)->
        $('#popup-textarea').html response.text

  $('#button-import-message-textarea').click ()->
    console.log "Clicked text area"
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'retrieveLast'}, (response)->
        $('#popup-textarea').html response.text

  $('#button-decrypt').click ()->
    $('#modal-decrypt').modal()

  $('#button-sign').click ()->
    $('#modal-sign').modal()

  $('#button-encrypt').click ()->
    $('#modal-encrypt').modal()

  $('#button-verify').click ()->
    $('#modal-verify').modal()

  populate_keys = (engine, master_password) ->
    if not master_password
      $('#modal-enter-master-password').modal()
    else
      storage = window.localStorage
      if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
        return alert "You must initiate the storage first by visiting the setting page"
      try
        pub_keys = null
        priv_keys = null
        engine.list_public_keys(master_password, (err, keys) ->
          pub_keys = keys
        )
        engine.list_private_keys(master_password, (err, keys) ->
          priv_keys = keys
        )
      catch e
        alert "Failed to decrypt storage"
        throw e

      $("select").empty()
      i = 0
      for key in pub_keys
        name = openpgp_encoding_html_encode(key[0].userIds[0].text)
        $(".select-public-key").append("<option value='" + i + "'>" + name + "</option>");
        i++
      i = 0
      for key in priv_keys
        name = openpgp_encoding_html_encode(key[0].userIds[0].text)
        $(".select-private-key").append("<option value='" + i + "'>" + name + "</option>");
        i++

  populate_keys(engine)
