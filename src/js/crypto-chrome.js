var crypto-chrome;

crypto-chrome.prototype.encrypt = function(message, key, callback) {
  return callback(message);
}

crypto-chrome.prototype.decrypt = function(message, key, callback) {
  return callback(message);
}

crypto-chrome.prototype.list_keys = function(callback) {
  list_keys = []
  return callback(list_keys);
}

crypto-chrome.prototype.add_key = function(key, callback) {
  return callback();
}

crypto-chrome.prototype.delete_key = function(key, callback) {
  return callback();
}
