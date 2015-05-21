console.time('init')

var AWS = require('aws-sdk')
var Promise = require('bluebird')
var exec = require('./lib/exec')
var config = require('./config')
var fs = Promise.promisifyAll(require('fs'))
var s3 = Promise.promisifyAll(new AWS.S3())
const BUCKET = 'lilypad-test'
const LY_DIR = '/tmp/ly'

process.chdir('/tmp')
process.env['PATH'] += ':' + LY_DIR + '/usr/bin'
process.env['LD_LIBRARY_PATH'] = LY_DIR + '/usr/lib'

var mime = {
  'pdf' : 'application/pdf'
, 'midi': 'audio/midi'
, 'png' : 'image/png'
}

var cliOpt = {
  'pdf' : '--formats=pdf'
, 'midi': '--formats=ps'
, 'png' : '--formats=png'
}

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2))
  var mode = event.mode || 'png'
  var cli  = cliOpt[mode]
  cli || (mode = 'png', cli = cliOpt[mode])
  makeTime('init', 'installation')

  return Promise.join(
    exec('sh ' + __dirname + '/install-lilypond.sh ' + config.version)
  , fs.writeFileAsync('input.ly', event.body)
  ).bind({
    key : event.key
  , mode: mode
  , cli : cli
  , result: {}
  }).then(makeTime.bind(null, 'installation', 'lilypond'))
  .then(exec.bind(
    null,
    'lilypond ' + cli + ' -o rendered input.ly'
  ))
  .then(function (res) {
    result = res
  }).then(makeTime.bind(null, 'lilypond', 'upload'))
  .then(function () {
    return uploadCorrectFile(this.key, this.mode, this.result)
  }).then(console.timeEnd.bind(console, 'upload'))
  .then(function () {
    context.succeed(this.result)
  }).catch(context.fail.bind(context))
}

function makeTime (end, begin) {
  console.timeEnd(end)
  console.time(begin)
}

function uploadFile (key, file) {
  return fs.readFileAsync(file)
  .then(function (data) {
    return s3.putObjectAsync({
      Bucket      : BUCKET
    , Key         : key
    , Body        : data
    , ACL         : 'public-read'
    , ContentType : mime[mode]
    , Expiration  : new Date(new Date().valueOf() + 1800000) // 30 minutes
    , StorageClass: 'REDUCED_REDUNDANCY'
    })
  })
}

function uploadCorrectFile (key, mode, res) {
  if (mode === 'pdf')  return uploadFile(key + '.pdf', 'rendered.pdf')

  var midiPromise = uploadFile(key + '.midi', 'rendered.midi')
  var pngPromise = (fs.accessAsync || fs.statAsync)('rendered.png')
  .then(function () {
    res.pages = 1
    return uploadFile(key + '-page1.png', 'rendered.png')
  }, function () {
    return countPages().then(function (pages) {
      res.pages = pages
      var promises = [];

      for (var i = 1; i <= pages; i ++) {
        promises.push(uploadFile(
          key + '-page' + i + '.png', 'rendered-page' + i + '.png'
        ))
      }
      return Promise.all(promises)
    })
  })

  return Promise.join(midiPromise, pngPromise)
}

function countPages () {
  var re = new RegExp('rendered-page.*\.png')
  return fs.readdirAsync('.').then(function (files) {
    return files.filter(re.test.bind(re)).length
  })
}
