function crypto-chrome() {
  this.openpgp = openpgp.init();

  /**
   * @return string Armored string of the message encoded
   */
  function encrypt(message, key, callback) {
    try {
      var encrypted_message = this.openpgp.write_encrypted_message([key], message);
    } catch(e) {
      return callback(e);
    }
    return callback(null, encrypted_message);
  };
  this.encrypt = encrypt;

  function decrypt(message, key, callback) {

  };
  this.decrypt = decrypt;

  function list_public_keys(master_password, callback) {
    var keys = sjcl.decrypt(master_password, window.localStorage['crypto-chrome-pub']);
    if(keys) {
      return callback(null, keys);
    }
    return callback("Wrong master key");
  };
  this.list_public_keys = list_public_keys;

  function add_public_key_from_armored(master_password, armored_key, callback) {
    key = this.openpgp.read_publicKey(armored_key);
    if(!key) {
      return callback("Wrong key format.");
    }

    var keys = sjcl.decrypt(window.localStorage['crypto-chrome-pub']);
    if(keys) {
      keys.append(key);
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, keys);
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_public_key_from_armored = add_public_key_from_armored;

  function list_private_keys(master_password, callback) {
    var keys = sjcl.decrypt(master_password, window.localStorage['crypto-chrome-private']);
    if(keys) {
      return callback(null, keys);
    }
    return callback("Wrong master key");
  };
  this.list_private_keys = list_private_keys;

  function add_private_key_from_armored(master_password, key, callback) {
    key = this.openpgp.read_privateKey(armored_key);
    if(!key) {
      return callback("Wrong key format.");
    }

    var keys = sjcl.decrypt(window.localStorage['crypto-chrome-private']);
    if(keys) {
      keys.append(key);
      window.localStorage['crypto-chrome-private'] = sjcl.encrypt(master_password, keys);
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_private_key_from_armored = add_private_key_from_armored;


  function find_key_by_email(master_password, email, callback) {
    this.list_public_keys(master_password, function(err, keys) {
      if(err) {
        return callback(err);
      }

      var results = []
      for(i in keys) {
        for (for j in keys[i].obj.userIds) {
          if (keys[i].obj.userIds[j].text.toLowerCase().indexOf(email) >= 0)
            results.append(keys[i]);
          }
      }

      return callback(null, results);
};
