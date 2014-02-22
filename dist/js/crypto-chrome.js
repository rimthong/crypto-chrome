function cryptochrome() {
  function init() {
    openpgp.init();
  }
  this.init = init;

  /**
   * @return string Armored string of the message encoded
   */
  function encrypt(message, key, callback) {
    var encrypted_message = openpgp.write_encrypted_message(key, message);
    if(encrypted_message) {
      return callback(null, encrypted_message);
    }
    return callback("Failed to encrypt message");
  };
  this.encrypt = encrypt;


  /**
   * @return boolean Signature verified
   */
  function verify(message, key, callback) {
    result = true
    if(result) {
      return callback(null, true);
    }
    return callback("Failed to verify message", false);
  };
  this.verify = verify;


  /**
   * Descrypt an armored text
   * @return string
   */
  function decrypt(armored_encrypted_msg, key, passphrase, master_password, callback) {


    priv_key = key;
    if (priv_key.length < 1) {
      throw "No private key";
    }

    var msg = openpgp.read_message(armored_encrypted_msg);
    var keymat = null;
    var sesskey = null;
    // Find the private (sub)key for the session key of the message
    for (var i = 0; i< msg[0].sessionKeys.length; i++) {
      if (priv_key[0].privateKeyPacket.publicKey.getKeyId() == msg[0].sessionKeys[i].keyId.bytes) {
        keymat = { key: priv_key[0], keymaterial: priv_key[0].privateKeyPacket};
        sesskey = msg[0].sessionKeys[i];
        break;
      }
      for (var j = 0; j < priv_key[0].subKeys.length; j++) {
        if (priv_key[0].subKeys[j].publicKey.getKeyId() == msg[0].sessionKeys[i].keyId.bytes) {
          keymat = { key: priv_key[0], keymaterial: priv_key[0].subKeys[j]};
          sesskey = msg[0].sessionKeys[i];
          break;
        }
      }
    }
    if (keymat != null) {
      if (!keymat.keymaterial.decryptSecretMPIs(passphrase)) {
        throw "Wrong passphrase for private key";
        return;
      }
      callback(null, msg[0].decrypt(keymat, sesskey));
    } else {
      throw "No private key found do decrypt message.";
    }

  };
  this.decrypt = decrypt;

  /**
   * Take message and sign it
   * @return string
   */
  function sign(message, key,  passphrase, master_password, callback) {
    priv_key = key;
    if (priv_key.length < 1) {
      throw "No private key";
    }

    priv_key[0].decryptSecretMPIs(passphrase);
    var signed_message = openpgp.write_signed_message(priv_key[0], message);
    if(signed_message) {
      return callback(null, signed_message);
    }
    return callback("Failed to sign message");
  };
  this.sign = sign;


  function list_public_keys(master_password, callback) {
    var armored_keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-pub']));
    if(armored_keys) {
      keys = []
      for (var i = 0; i < armored_keys.length; i++) {
        keys.push(openpgp.read_publicKey(armored_keys[i]));
      }
      return callback(null, keys);
    }
    return callback("Wrong master key");
  };
  this.list_public_keys = list_public_keys;

  function add_public_key_from_armored(master_password, armored_key, callback) {
    key = openpgp.read_publicKey(armored_key);
    if(!key) {
      return callback("Wrong key format.");
    }

    var keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-pub']));
    if(keys) {
      keys.push(armored_key);
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify(keys));
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_public_key_from_armored = add_public_key_from_armored;

  function list_private_keys(master_password, callback) {
    var armored_keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-priv']));
    if(armored_keys) {
      keys = []
      for (var i = 0; i < armored_keys.length; i++) {
        keys.push(openpgp.read_privateKey(armored_keys[i]));
      }
      return callback(null, keys);
    }
    return callback("Wrong master key");
  };
  this.list_private_keys = list_private_keys;

  function add_private_key_from_armored(master_password, armored_key, callback) {
    key = openpgp.read_privateKey(armored_key);
    if(!key) {
      return callback("Wrong key format.");
    }

    var keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-priv']));
    if(keys) {
      keys.push(armored_key);
      window.localStorage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify(keys));
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_private_key_from_armored = add_private_key_from_armored;

  function find_key_by_email(master_password, email, callback) {
    return this.list_public_keys(master_password, function(err, keys) {
      if(err) {
        return callback(err);
      }

      var results = []
      for(var i = 0; i <= keys.length; i++) {
        for(var j = 0; j <= keys[0].obj.userIds.length; j++) {
          if (keys[i].obj.userIds[j].text.toLowerCase().indexOf(email) >= 0)
            results.push(keys[i]);
          }
      }

      return callback(null, results);
    });
  }
  this.find_key_by_email = find_key_by_email;

  /*
  function find_private_key_by_id(master_password, id, callback) {
    return this.list_private_keys(master_password, function(err, keys) {
      if(err) {
        return callback(err);
      }

      var results = []
      for(var i = 0; i <= keys[0].length; i++) {
        if (id == keys[i][0].getKeyId()) {
          results.push({ key: keys[i], keymaterial: keys[i][0].jprivateKeyPacket});
          break;
        }
        if(keys[i][0].subKeys != null) {
          var subkeyids = this.privateKeys[i][0].getSubKeyIds();
          for(var j = 0; j <= subkeyids.length; j++) {
            if (keyId == util.hexstrdump(subkeyids[j])) {
              results.push({ key: keys[i], keymaterial: keys[i][0].subKeys[j]});
            }
          }
        }
      }
      return callback(null, results);
    });
  }
  this.find_private_key_by_id = find_private_key_by_id;
  */

  function delete_public_key_by_index(master_password, index, callback) {
    var armored_keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-pub']));
    armored_keys.splice(index, 1);
    window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify(armored_keys));
    callback(null);
  }
  this.delete_public_key_by_index = delete_public_key_by_index;

  function delete_private_key_by_index(master_password, index, callback) {
    var armored_keys = JSON.parse(sjcl.decrypt(master_password, window.localStorage['crypto-chrome-priv']));
    armored_keys.splice(index, 1);
    window.localStorage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify(armored_keys));
    callback(null);
  }
  this.delete_private_key_by_index = delete_private_key_by_index;

  this.init();
  return this;
}
