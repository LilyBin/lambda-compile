console.time('init')

var AWS = require('aws-sdk')
var Promise = require('bluebird')
var exec = require('./lib/exec')
var fs = Promise.promisifyAll(require('fs'))
var s3 = Promise.promisifyAll(new AWS.S3())
const BUCKET = 'lilypad-test'
const LY_DIR = '/tmp/ly'

process.chdir('/tmp')
process.env['PATH'] += ':' + LY_DIR + '/bin'

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2))
  var key = event.key
  var result
  makeTime('init', 'installation')

  return Promise.join(
    exec(
      "sh '" + __dirname + "/lilypond-2.18.2-1.linux-64.sh'" +
      " --batch" +
      " --prefix '" + LY_DIR + "'"
    )
  , fs.writeFileAsync('input.ly', event.body)
  ).then(makeTime.bind(null, 'installation', 'lilypond'))
  .then(exec.bind(null, 'lilypond --formats=pdf,png -o rendered input.ly'))
  .then(function (res) {
    result = res
  }).then(makeTime.bind(null, 'lilypond', 'upload'))
  .then(uploadFile.bind(null, key, 'rendered.pdf'))
  .then(console.timeEnd.bind(console, 'upload'))
  .then(function () {
    context.succeed(result)
  }).catch(context.fail.bind(context))
}

function makeTime(end, begin) {
  console.timeEnd(end)
  console.time(begin)
}

function uploadFile(key, file) {
  return fs.readFileAsync(file)
  .then(function (data) {
    s3.putObjectAsync({Bucket: BUCKET, Key: key, Body: data})
  })
}
