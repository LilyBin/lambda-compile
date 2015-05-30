console.time('init')

var AWS = require('aws-sdk')
var Promise = require('bluebird')
var exec = require('./lib/exec')
var fs = Promise.promisifyAll(require('fs'))
var s3 = Promise.promisifyAll(new AWS.S3())
const BUCKET = 'lilybin-scores'
const LY_DIR = process.env.LAMBDA_TASK_ROOT + '/ly'

process.chdir('/tmp')
process.env.PATH += ':' + LY_DIR + '/usr/bin'
process.env.LD_LIBRARY_PATH = LY_DIR + '/usr/lib'

var mime = {
  'pdf' : 'application/octet-stream'
, 'midi': 'application/octet-stream'
, 'png' : 'image/png'
}

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2))
  makeTime('init', 'writing input')

  return fs.writeFileAsync('input.ly', event.body).bind({
    key : event.key
  }).then(makeTime.bind(null, 'writing input', 'lilypond'))
  .then(exec.bind(
    null,
    'lilypond --formats=pdf,png -o rendered input.ly'
  ))
  .then(function (res) {
    this.result = res
  }).then(makeTime.bind(null, 'lilypond', 'upload'))
  .then(function () {
    return uploadFiles(this.key, this.result)
  }).then(console.timeEnd.bind(console, 'upload'))
  .then(function () {
    context.succeed(this.result)
  }).catch(context.fail.bind(context))
}

function makeTime (end, begin) {
  console.timeEnd(end)
  console.time(begin)
}

function uploadFile (key, file, mode) {
  return fs.readFileAsync(file)
  .then(function (data) {
    return s3.putObjectAsync({
      Bucket      : BUCKET
    , Key         : key
    , Body        : data
    , ContentType : mime[mode]
    , StorageClass: 'REDUCED_REDUNDANCY'
    })
  }, noop)                              // ignore error
}

function uploadFiles (key, res) {
  var pdfPromise = uploadFile(key + '.pdf', 'rendered.pdf', 'pdf')
  var midiPromise = uploadFile(key + '.midi', 'rendered.midi', 'midi')
  var pngPromise = (fs.accessAsync || fs.statAsync)('rendered.png')
    .then(function () {
      res.pages = 1
      return uploadFile(key + '-page1.png', 'rendered.png', 'png')
    }, function () {
      return countPages().then(function (pages) {
        res.pages = pages
        var promises = [];

        for (var i = 1; i <= pages; i ++) {
          promises.push(uploadFile(
            key + '-page' + i + '.png', 'rendered-page' + i + '.png', 'png'
          ))
        }
        return Promise.all(promises)
      })
    })

  return Promise.join(pdfPromise, midiPromise, pngPromise)
}

function countPages () {
  var re = new RegExp('rendered-page.*\.png')
  return fs.readdirAsync('.').then(function (files) {
    return files.filter(re.test.bind(re)).length
  })
}

function noop () {}
