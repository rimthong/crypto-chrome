$ ->
  engine = cryptochrome()
  console.log "Loaded browser page"

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
    cipherText = $('#popup-textarea').val()
    master_password = prompt("Master password to get keys")
    index = parseInt($(this).data('index'))
    engine.list_private_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.decrypt(cipherText, keys[index], prompt("Private key passphrase"), master_password, (err, text) ->
          $('#popup-textarea').val text
        )
    )

  $('#button-sign').click ()->
    plainText = $('#popup-textarea').val()

    master_password = prompt "Master password to get keys"
    index = parseInt($(this).data('index'))
    index = 0
    engine.list_private_keys(master_password, (err, keys) ->
      if err
        alert err
      else
        engine.sign(plainText, keys[index], prompt("Private key passphrase"), master_password, (err, signed_message) ->
          #We send the content-script our signed text
          $('#popup-textarea').val(signed_message)
          chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
            chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: signedText}, (response)->
              if response and response.status is 'ok'
                #Do nothing, injection successful
              else
                #Did not inject, just alter textarea
                $('#popup-textarea').val(signed_message)
                yes
        )
    )

  $('#button-encrypt').click ()->
    plainText = $('#popup-textarea').val()

    master_password = prompt "Master password to get keys"
    cipherText = null
    index = parseInt($(this).data('index'))
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

    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        if response and response.status is 'ok'
          #Do nothing, injection successful
        else
          #Did not inject, just alter textarea
          $('#popup-textarea').val(cipherText)

  $('#button-verify').click ()->
    #TODO sign verif magic here
    signedText = $('#popup-textarea').val()
    verified = true
    if verified
      message =
        """
          <h4 class="success">
            <i class="icon-check-sign"/>
            &nbsp; Signature ok!
          </h4>
        """
    else
      message =
        """
          <h4 class="error">
            <i class="icon-warning-sign"/>
            &nbsp; Bad signature!
          </h4>
        """
    $('#popup-message-box').html message

  populate_keys = (engine) ->
    storage = window.localStorage
    if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
      return alert "You must initiate the storage first by visiting the setting page"

    master_password = prompt "Master password to get keys"
    if not master_password
      master_password = prompt "Master password to retrieve keys"
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
      $("#public").append("<option value='" + i + "'>" + name + "</option>");
      i++
    i = 0
    for key in priv_keys
      name = openpgp_encoding_html_encode(key[0].userIds[0].text)
      $("#private").append("<option value='" + i + "'>" + name + "</option>");
      i++

  populate_keys(engine)
