$ ->
  engine = cryptochrome_engine()

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
    masterPassword = $('#input-verify-master-password').val()
    key = $('#select-verify-public-key').val()
    $('#modal-verify').modal('hide')
    signedText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.getPublicKeys masterPassword, (err, keys) ->
      if err
        console.log 'Error getting keys:', err
      else
        engine.verify signedText, keys[index], (err, result) ->
          if result and !err
            badSignatures = (signature for signature in result.signatures when signature.valid is false)

            if badSignatures.length is 0 and result.signatures.length > 0
              $('#verification-success').removeClass('hidden').addClass('show')
              $('#verification-failure').removeClass('show').addClass('hidden')
            else
              $('#verification-failure').removeClass('hidden').addClass('show')
              $('#verification-success').removeClass('show').addClass('hidden')
          else
            console.log 'Error verifying signature:', err
          yes

  sign = ()->
    masterPassword = $('#input-sign-master-password').val()
    key = $('#select-sign-private-key').val()
    keyPassword = $('#input-sign-private-password').val()
    $('#modal-sign').modal('hide')
    plainText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.getPrivateKeys masterPassword, (err, keys) ->
      if err
        console.log 'Error getting keys:', err
      else
        engine.sign plainText, keys[index], keyPassword, (err, signedMessage) ->
          $('#popup-textarea').val(signedMessage)
          #We send the content-script our signed text
          chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
            chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: signed_message}, (response)->

  $('.button-close-sign').click ()->
    $('#modal-sign').modal('hide')

  $('#form-decrypt').submit ()->
    event.preventDefault()
    decrypt()

  $('#button-confirm-decrypt').click ()->
    decrypt()

  decrypt = ()->
    masterPassword = $('#input-decrypt-master-password').val()
    key = $('#select-decrypt-private-key').val()
    keyPassword = $('#input-decrypt-private-password').val()
    $('#modal-decrypt').modal('hide')
    cipherText = $('#popup-textarea').val()
    index = parseInt(key)
    engine.getPrivateKeys masterPassword, (err, keys) ->
      if err
        console.log 'Error getting keys:', err
      else
        engine.decrypt cipherText, keys[index], keyPassword,  (err, text) ->
          $('#popup-textarea').val text

  $('.button-close-decrypt').click ()->
    $('#modal-decrypt').modal('hide')

  $('#button-encrypt-sign').click ()->
    $('#modal-encrypt-sign').modal('show')

  $('#form-encrypt-sign').submit ()->
    event.preventDefault()
    encryptSign()

  $('#button-confirm-encrypt-sign').click ()->
    encryptSign()

  encryptSign = ()->
    masterPassword = $('#input-encrypt-sign-master-password').val()
    privateKey = $('#select-encrypt-sign-private-key').val()
    keyPassword = $('#input-encrypt-sign-private-password').val()
    publicKey = $('#select-encrypt-sign-public-key').val()
    privateKeyIndex = parseInt(privateKey)
    publicKeyIndex = parseInt(publicKey)
    $('#modal-encrypt-sign').modal('hide')
    plaintext = $('#popup-textarea').val()
    engine.getPublicKeys masterPassword, (err1, publicKeys) ->
      engine.getPrivateKeys masterPassword, (err2, privateKeys) ->
        if err1 or err2
          console.log 'Error getting keys:', err1, err2
        else
          engine.signAndEncrypt publicKeys[publicKeyIndex], privateKeys[privateKeyIndex], keyPassword, plaintext, (err, ciphertext)->
            console.log "Sign and encrypt, error is:", err
            $('#popup-textarea').val(ciphertext)
            chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
              chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
                #Either way, we put the encrypted version in text box

  $('.button-close-encrypt-sign').click ()->
    $('#modal-encrypt-sign').modal('hide')

  $('#button-decrypt-verify').click ()->
    $('#modal-decrypt-verify').modal('show')

  $('#form-decrypt-verify').submit ()->
    event.preventDefault()
    decryptVerify()

  $('#button-confirm-decrypt-verify').click ()->
    decryptVerify()

  decryptVerify = ()->
    masterPassword = $('#input-decrypt-verify-master-password').val()
    privateKey = $('#select-decrypt-verify-private-key').val()
    keyPassword = $('#input-decrypt-verify-private-password').val()
    publicKey = $('#select-decrypt-verify-public-key').val()
    privateKeyIndex = parseInt(privateKey)
    publicKeyIndex = parseInt(publicKey)
    $('#modal-decrypt-verify').modal('hide')
    ciphertext = $('#popup-textarea').val()
    engine.getPrivateKeys masterPassword, (err, privateKeys) ->
      engine.getPublicKeys masterPassword, (err, publicKeys) ->
        if err
          console.log 'Error getting keys:', err
        else
          engine.decryptAndVerify privateKeys[privateKeyIndex], publicKeys[publicKeyIndex], keyPassword, ciphertext, (err, result) ->
            $('#popup-textarea').val(result.text)
            if result and !err
              badSignatures = (signature for signature in result.signatures when signature.valid is false)

              if badSignatures.length is 0 and result.signatures.length > 0
                $('#verification-success').removeClass('hidden').addClass('show')
                $('#verification-failure').removeClass('show').addClass('hidden')
              else
                $('#verification-failure').removeClass('hidden').addClass('show')
                $('#verification-success').removeClass('show').addClass('hidden')
            else
              console.log 'Error verifying signature:', err
            yes

  $('.button-close-decrypt-verify').click ()->
    $('#modal-decrypt-verify').modal('hide')

  $('#form-encrypt').submit ()->
    event.preventDefault()
    encrypt()

  $('#button-confirm-encrypt').click ()->
    encrypt()

  encrypt = ()->
    masterPassword = $('#input-encrypt-master-password').val()
    key = $('#select-encrypt-public-key').val()
    $('#modal-encrypt').modal('hide')
    plainText = $('#popup-textarea').val()
    cipherText = null
    index = parseInt(key)
    engine.getPublicKeys masterPassword, (err, keys) ->
      if err
        console.log 'Error getting keys:', err
      else
        engine.encrypt plainText, keys[index], (err, ciphertext) ->
          #We send the content-script our new ciphertext
          $('#popup-textarea').val(ciphertext)
          chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
            chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
              #Either way, we put the encrypted version in text box

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
        $("select").empty()
        engine.getPublicKeys master_password, (err, keys) ->
          pub_keys = keys
          i = 0
          for key in keys
            name = key.keys[0].users[0].userId.userid
            $(".select-public-key").append("<option value='" + i + "'>" + name + "</option>");
            i++

        engine.getPrivateKeys master_password, (err, keys) ->
          priv_keys = keys
          i = 0
          for key in keys
            name = key.keys[0].users[0].userId.userid
            $(".select-private-key").append("<option value='" + i + "'>" + name + "</option>");
            i++
      catch e
        throw e


  populate_keys(engine)
