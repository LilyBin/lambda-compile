var context = {
  succeed: function (result) {
    console.log('Success!!!')
    console.log(result)
  }
, fail: function (error) {
    console.log('FAIL!!!')
    console.log(error)
  }
, done: function (err, result) {
    console.log('DONE!!!')
    console.log('Error:', err)
    console.log('Result:', result)
  }
}
var event = require('./payload')
var handler = require('./').handler
handler(event, context)
