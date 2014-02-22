$ ->
  engine = cryptochrome()

  $('#button-confirm-verify').click ()->
    verify()

  $('.button-close-verify').click ()->
    $('#modal-verify').modal('hide')

  $('#form-sign').submit ()->
    event.preventDefault()
    sign()

  $('#button-confirm-sign').click ()->
    sign()

  verify = ()->
    master_password = $('#input-verify-master-password').val()
    key = $('#select-verify-public-key').val()
    $('#modal-verify').modal('hide')
    signedText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.list_public_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.verify(signedText, keys[index], (err, result) ->
          if result and !err
            $('#verification-success').removeClass('hidden').addClass('show')
            $('#verification-failure').removeClass('show').addClass('hidden')
          else
            $('#verification-failure').removeClass('hidden').addClass('show')
            $('#verification-success').removeClass('show').addClass('hidden')
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

  sign = ()->
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
              unless response and response.status is 'ok'
                #Did not inject, just alter textarea
                $('#popup-textarea').val(signed_message)
                yes
        )
    )

  $('.button-close-sign').click ()->
    $('#modal-sign').modal('hide')

  $('#form-decrypt').submit ()->
    event.preventDefault()
    decrypt()

  $('#button-confirm-decrypt').click ()->
    decrypt()

  decrypt = ()->
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

  $('#form-encrypt').submit ()->
    event.preventDefault()
    encrypt()

  $('#button-confirm-encrypt').click ()->
    encrypt()

  encrypt = ()->
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

  $('#form-enter-master-password').submit ()->
    event.preventDefault()
    enterMasterPassword()

  $('#button-confirm-enter-master-password').click ()->
    enterMasterPassword()

  enterMasterPassword = ()->
    password = $('#input-entered-master-password').val()
    $('#modal-enter-master-password').modal('hide')
    populate_keys(engine, password)

  $('.button-close-enter-master-password').click ()->
    $('#modal-enter-master-password').modal('hide')

  $('#button-import-textarea').click ()->
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'retrieve'}, (response)->
        $('#popup-textarea').html response.text

  $('#button-import-message-textarea').click ()->
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
