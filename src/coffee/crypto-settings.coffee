$ ->
  engine = cryptochrome()
  console.log "Loaded settings page"

  read_keys = (master_password) ->
    keys = read_storage master_password
    pub_keys = keys[0]
    priv_keys = keys[1]

    $("#public tbody, #private tbody").empty()
    i = 0
    for key in pub_keys
      name = openpgp_encoding_html_encode(key[0].userIds[0].text)
      $("#public tbody").append("<tr><td>" + i + "</td><td><img src='http://placekitten.com/30/30' /></td><td>" + name + "</td><td><button class='btn btn-danger remove-public-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>")
      i++

    i = 0
    for key in priv_keys
      name = openpgp_encoding_html_encode(key[0].userIds[0].text)
      $("#private tbody").append("<tr><td>" + i + "</td><td><td><img src='http://placekitten.com/30/30' /></td><td>" + name + "</td><td><button class='btn btn-danger remove-private-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>")
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

read_storage = (master_password) ->
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
      pub_keys = JSON.parse(sjcl.decrypt(master_password, storage['crypto-chrome-pub']))
      priv_keys = JSON.parse(sjcl.decrypt(master_password, storage['crypto-chrome-priv']))
    catch e
      alert "Failed to decrypt storage"
      throw e

  return [pub_keys, priv_keys]
