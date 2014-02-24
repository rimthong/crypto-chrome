cryptochrome_engine = ()->

  #OpenGPG functionalities
  @init = ()->
    openpgp.initWorker 'openpgp.worker.js'
  
  @encrypt = (message, key, callback)->
    openpgp.encryptMessage key.keys, message, callback

  @signAndEncrypt = ()->
    #TODO not yet implemented
    openpgp.signAndEncryptMessage publicKeys, privateKey, message, callback
    
  @decrypt = (encrypted, keys, passphrase, callback)->
    privateKey = keys.keys[0]
    message = openpgp.message.readArmored(encrypted)
    keyIds = message.getEncryptionKeyIds()
    privateKey.decryptKeyPacket keyIds, passphrase
    openpgp.decryptMessage privateKey, message, callback

  @decryptAndVerify = ()->
    #TODO not yet implemented
    openpgp.decryptAndVerifyMessage privateKey, publicKeys, message, callback

  @sign = (message, keys, passphrase, callback)->
    key = keys.keys[0]
    key.getSigningKeyPacket().decrypt passphrase
    openpgp.signClearMessage keys.keys, message, callback

  @verify = (text, key)->
    message = openpgp.cleartext.readArmored text
    openpgp.verifyClearSignedMessage [key], message, callback

  @generateKeyPair = ()->
    #TODO not yet used/implemented
    opengpgp.generateKeyPair keyType, numBits, userId, passphrase, callback

  #Internal key management
  
  @getPublicKeys =  (masterPassword, callback) ->
    armoredKeys = JSON.parse sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-pub'])
    if armoredKeys
      keys = []
      keys.push(openpgp.key.readArmored(key)) for key in armoredKeys
      callback null, keys
    else
      callback('Wrong master password.')

  @addPublicKey = (masterPassword, armoredKey, callback) ->
    key = openpgp.key.readArmored armoredKey # we just check the format
    if !key then callback('Wrong key format.')
    armoredKeys = JSON.parse sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-pub'])
    if armoredKeys
      armoredKeys.push armoredKey
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify(keys))
      callback()
    else
      callback('Wrong master password.')

  @getPrivateKeys =  (masterPassword, callback) ->
    armoredKeys = JSON.parse sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-priv'])
    if armoredKeys
      keys = []
      #XXX read_publicKey does not exist anymore, should remove the armoring
      keys.push(openpgp.key.readArmored(key)) for key in armoredKeys
      callback null, keys
    else
      callback 'Wrong master password.'

  @addPrivateKey = (masterPassword, armoredKey, callback) ->
    key = openpgp.key.readArmored armoredKey # we just check the format
    if !key then callback 'Wrong key format.'
    armoredKeys = JSON.parse sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-priv'])
    if armoredKeys
      armoredKeys.push armoredKey
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify(keys))
      callback null
    else
      callback 'Wrong master password.'

  @findPublicKeyByEmail = (masterPassword, email, callback) ->
    @getPublicKeys masterPassword, (err, keys)->
      if err then callback err

      result = []
      for key in keys
        for userId in key.obj.userIds
          if userId.text.toLowerCase().indexOf(email) >= 0
            result.push key
      callback null, result

  @deletePublicKeyByIndex = (masterPassword, index, callback) ->
    armoredKeys = JSON.parse sjcl.decrypt(master_password, window.localStorage['crypto-chrome-pub'])
    armoredKeys.splice index, 1
    window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify(armoredKeys))
    callback null

  @deletePrivateKeyByIndex = (masterPassword, index, callback) ->
    armoredKeys = JSON.parse sjcl.decrypt(master_password, window.localStorage['crypto-chrome-priv'])
    armoredKeys.splice index, 1
    window.localStorage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify(armoredKeys))
    callback null
  @init() 
  @
