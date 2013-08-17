$ ->
  engine = cryptochrome()

  read_keys = (master_password) ->
    keys = read_storage master_password, engine
    pub_keys = keys[0]
    priv_keys = keys[1]

    $("#public tbody, #private tbody").empty()
    if pub_keys.length > 0
      i = 0
      for key in pub_keys
        name = openpgp_encoding_html_encode(key[0].userIds[0].text)
        hash = CryptoJS.MD5(key[0].data)
        $("#public tbody").append("<tr><td>" + i + "</td><td><img src='http://www.gravatar.com/avatar/#{hash}?d=identicon&s=40' /></td><td>" + name + "</td><td><button class='btn btn-danger btn-small remove-public-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>")
        i++

    if priv_keys.klength > 0
      i = 0
      for key in priv_keys
        name = openpgp_encoding_html_encode(key[0].userIds[0].text)
        hash = CryptoJS.MD5(key[0].data)
        $("#private tbody").append("<tr><td>" + i + "</td><td><img src='http://www.gravatar.com/avatar/#{hash}?d=identicon&s=40' /></td><td>" + name + "</td><td><button class='btn btn-danger btn-small remove-private-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>")
        i++

  read_keys()

  $('#add-public-key').click ()->
    key = $('#public-key-to-add').val()
    master_password = prompt "Master password to add private key"
    engine.add_public_key_from_armored master_password, key, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)

    console.log "Adding pubkey #{key}"
    yes

  $('#add-private-key').click ()->
    key = $('#private-key-to-add').val()
    master_password = prompt "Master password to add private key"
    engine.add_private_key_from_armored master_password, key, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)
    console.log "Adding private #{key}"
    yes

  $('#private').on('click', '.remove-private-key', ->
    master_password = prompt "Master password to delete public key"
    engine.delete_private_key_by_index master_password, parseInt($(this).data('index')), (err) ->
      if err
        console.log err
      else
        read_keys(master_password)
    )

  $('#public').on('click', '.remove-public-key', ->
    master_password = prompt "Master password to delete public key"
    engine.delete_public_key_by_index master_password, parseInt($(this).data('index')), (err) ->
      if err
        console.log err
      else
        read_keys(master_password)
    )

read_storage = (master_password, engine) ->
  storage = window.localStorage

  if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
    if not master_password
      master_password = prompt "Master password to initialize the storage"
    if not storage['crypto-chrome-pub']
      storage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify([]))
    if not storage['crypto-chrome-priv']
      storage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify([]))
  else
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

  return [pub_keys, priv_keys]
