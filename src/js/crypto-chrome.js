function crypto-chrome() {
  this.openpgp = openpgp.init();

  function encrypt(message, key, callback) {

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

  function add_public_key(master_password, key, callback) {
    var keys = sjcl.decrypt(window.localStorage['crypto-chrome-pub']);
    if(keys) {
      keys.append(key);
      window.localStorage['crypto-chrome-pub'] = sjcl.encrypt(master_password, keys);
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_public_key = add_public_key;

  function list_private_keys(master_password, callback) {
    var keys = sjcl.decrypt(master_password, window.localStorage['crypto-chrome-private']);
    if(keys) {
      return callback(null, keys);
    }
    return callback("Wrong master key");
  };
  this.list_private_keys = list_private_keys;

  function add_private_key(master_password, key, callback) {
    var keys = sjcl.decrypt(window.localStorage['crypto-chrome-private']);
    if(keys) {
      keys.append(key);
      window.localStorage['crypto-chrome-private'] = sjcl.encrypt(master_password, keys);
      return callback();
    }
    return callback("Wrong master key");
  }
  this.add_private_key = add_private_key;


  function find_key_by_email(master_password, callback) {
    this.list_public_keys(master_password, function(err, keys) {
      if(err) {
        return callback(err);
      }

      var keys 

      return callback(null, keys);
};

