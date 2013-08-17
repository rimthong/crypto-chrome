$ ->
  console.log "Loaded browser page"

  $('#button-import-textarea').click ()->
    console.log "Clicked text area"
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'retrieve'}, (response)->
        console.log "response is"
        console.log response
        $('#popup-textarea').html response.text

  $('#button-decrypt').click ()->
    #TODO decrypt magic here
    cipherText = $('#popup-textarea').val()
    clearText = "This is clear like woah: #{cipherText}"
    $('#popup-textarea').val clearText

  $('#button-sign').click ()->
    plainText = $('#popup-textarea').val()

    #TODO replace signature strategy here
    cipherText = "====Signed message==== \n #{plainText} \n ==== End message ===="
    $('#popup-textarea').val(cipherText)

    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        console.log "Listener replied with status #{response.status}"

  $('#button-encrypt').click ()->
    plainText = $('#popup-textarea').val()

    #TODO replace encryption strategy here
    cipherText = "shh, this is a secret: #{plainText}"
    $('#popup-textarea').val(cipherText)

    #We send the content-script our new ciphertext
    chrome.tabs.query {active:true, currentWindow:true}, (tabs) ->
      chrome.tabs.sendMessage tabs[0].id, {fonction: 'inject', message: cipherText}, (response)->
        console.log "Listener replied with status #{response.status}"

  $('#button-verify').click ()->
    console.log "Clicked verify"
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

  populate_keys = ->
    storage = window.localStorage
    if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
      return alert "You must initiate the storage first by visiting the setting page"


    master_password = prompt "Master password to get keys"
    try
      pub_keys = JSON.parse(sjcl.decrypt(master_password, storage['crypto-chrome-pub']))
      priv_keys = JSON.parse(sjcl.decrypt(master_password, storage['crypto-chrome-priv']))
    catch e
      alert "Failed to decrypt storage"
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

  populate_keys()
