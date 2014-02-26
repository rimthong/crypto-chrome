var cryptochrome_engine;

cryptochrome_engine = function() {
  this.init = function() {
    return openpgp.initWorker('openpgp.worker.js');
  };
  this.encrypt = function(message, key, callback) {
    return openpgp.encryptMessage(key.keys, message, callback);
  };
  this.signAndEncrypt = function(publicKeys, privateKey, passphrase, message, callback) {
    privateKey.keys[0].getSigningKeyPacket().decrypt(passphrase);
    return openpgp.signAndEncryptMessage(publicKeys.keys, privateKey.keys[0], message, callback);
  };
  this.decrypt = function(encrypted, keys, passphrase, callback) {
    var keyIds, message, privateKey;
    privateKey = keys.keys[0];
    message = openpgp.message.readArmored(encrypted);
    keyIds = message.getEncryptionKeyIds();
    privateKey.decryptKeyPacket(keyIds, passphrase);
    return openpgp.decryptMessage(privateKey, message, callback);
  };
  this.decryptAndVerify = function(privateKey, publicKeys, passphrase, ciphertext, callback) {
    var keyIds, message;
    message = openpgp.message.readArmored(ciphertext);
    keyIds = message.getEncryptionKeyIds();
    privateKey.keys[0].decryptKeyPacket(keyIds, passphrase);
    return openpgp.decryptAndVerifyMessage(privateKey.keys[0], publicKeys.keys, message, callback);
  };
  this.sign = function(message, keys, passphrase, callback) {
    var key;
    key = keys.keys[0];
    key.getSigningKeyPacket().decrypt(passphrase);
    return openpgp.signClearMessage(keys.keys, message, callback);
  };
  this.verify = function(text, key, callback) {
    var message;
    message = openpgp.cleartext.readArmored(text);
    return openpgp.verifyClearSignedMessage(key.keys, message, callback);
  };
  this.generateKeyPair = function() {
    return opengpgp.generateKeyPair(keyType, numBits, userId, passphrase, callback);
  };
  this.getPublicKeys = function(masterPassword, callback) {
    var armoredKeys, key, keys, _i, _len;
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-pub']));
    if (armoredKeys) {
      keys = [];
      for (_i = 0, _len = armoredKeys.length; _i < _len; _i++) {
        key = armoredKeys[_i];
        keys.push(openpgp.key.readArmored(key));
      }
      return callback(null, keys);
    } else {
      return callback('Wrong master password.');
    }
  };
  this.addPublicKey = function(masterPassword, armoredKey, callback) {
    var armoredKeys, key;
    key = openpgp.key.readArmored(armoredKey);
    if (!key) {
      callback('Wrong key format.');
    }
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-pub']));
    if (armoredKeys) {
      armoredKeys.push(armoredKey);
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(masterPassword, JSON.stringify(armoredKeys));
      return callback();
    } else {
      return callback('Wrong master password.');
    }
  };
  this.getPrivateKeys = function(masterPassword, callback) {
    var armoredKeys, key, keys, _i, _len;
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-priv']));
    if (armoredKeys) {
      keys = [];
      for (_i = 0, _len = armoredKeys.length; _i < _len; _i++) {
        key = armoredKeys[_i];
        keys.push(openpgp.key.readArmored(key));
      }
      return callback(null, keys);
    } else {
      return callback('Wrong master password.');
    }
  };
  this.addPrivateKey = function(masterPassword, armoredKey, callback) {
    var armoredKeys, key;
    key = openpgp.key.readArmored(armoredKey);
    if (!key) {
      callback('Wrong key format.');
    }
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-priv']));
    if (armoredKeys) {
      armoredKeys.push(armoredKey);
      window.localStorage['crypto-chrome-priv'] = sjcl.encrypt(masterPassword, JSON.stringify(armoredKeys));
      return callback(null);
    } else {
      return callback('Wrong master password.');
    }
  };
  this.findPublicKeyByEmail = function(masterPassword, email, callback) {
    return this.getPublicKeys(masterPassword, function(err, keys) {
      var key, result, userId, _i, _j, _len, _len1, _ref;
      if (err) {
        callback(err);
      }
      result = [];
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        _ref = key.obj.userIds;
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          userId = _ref[_j];
          if (userId.text.toLowerCase().indexOf(email) >= 0) {
            result.push(key);
          }
        }
      }
      return callback(null, result);
    });
  };
  this.deletePublicKeyByIndex = function(masterPassword, index, callback) {
    var armoredKeys;
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-pub']));
    armoredKeys.splice(index, 1);
    window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(masterPassword, JSON.stringify(armoredKeys));
    return callback(null);
  };
  this.deletePrivateKeyByIndex = function(masterPassword, index, callback) {
    var armoredKeys;
    armoredKeys = JSON.parse(sjcl.decrypt(masterPassword, window.localStorage['crypto-chrome-priv']));
    armoredKeys.splice(index, 1);
    window.localStorage['crypto-chrome-priv'] = sjcl.encrypt(masterPassword, JSON.stringify(armoredKeys));
    return callback(null);
  };
  this.init();
  return this;
};
