import AWS from 'aws-sdk';
import Promise, { promisifyAll } from 'bluebird';
import exec from './exec';

console.time('init');

const fs = promisifyAll(require('fs'));

AWS.config.setPromisesDependency(Promise);
const s3 = new AWS.S3();

const BUCKET = 'lilybin-scores';
const LY_DIR = `${process.env.LAMBDA_TASK_ROOT}/ly`;
const mime = {
  pdf: 'application/pdf',
  midi: 'audio/midi',
  png: 'image/png'
};

process.chdir('/tmp');

process.env.PATH += `:${LY_DIR}/usr/bin`;
process.env.LD_LIBRARY_PATH = `${LY_DIR}/usr/lib`;

console.timeEnd('init');

function generateId() {
  return [
    Date.now(),
    ...process.hrtime(),
    Math.random().toString(36).substr(2)
  ].join('-');
}

function runLilypond() {
  return exec(`lilypond --formats=pdf --include="${__dirname}/fonts/font-stylesheets" -o rendered input.ly >&2`);
}

function uploadFile(id, file, mode) {
  return fs.readFileAsync(file).then(body_ => 
    s3.putObject({
      Bucket: BUCKET,
      Key: id,
      Body: body_,
      ContentType: mime[mode],
      StorageClass: 'REDUCED_REDUNDANCY'
    }).promise()
  ).thenReturn(true).catchReturn(false);
}

function uploadFiles(result) {
  return Promise.all([
    uploadFile(`${result.id}.pdf`, 'rendered.pdf', 'pdf'),
    uploadFile(`${result.id}.midi`, 'rendered.midi', 'midi')
  ]).spread((pdf_, midi_) => {
    result.files = {
      pdf: pdf_,
      midi: midi_
    };
    return result;
  });
}

function run(event) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  const id = event.id || generateId();

  console.time('writing input');

  return Promise.all([
    fs.writeFileAsync('input.ly', event.code),
    fs.unlinkAsync('rendered.pdf').catchReturn(null),
    fs.unlinkAsync('rendered.midi').catchReturn(null)
  ]).tap(() => {
    console.timeEnd('writing input');
    console.time('lilypond');
  }).return(
    runLilypond()
  ).then(result => {
    result.id = id;
    return result;
  }).tap(() => {
    console.timeEnd('lilypond');
    console.time('upload');
  }).then(uploadFiles).tap(() => console.timeEnd('upload'));
}

exports.handler = (event, context, callback) => {
  run(event)
  .then(res => callback(null, res))
  .catch(err => {
    console.error('FAILING')
    callback(err)
  });
}
