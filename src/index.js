import AWS from 'aws-sdk';
import { promisifyAll } from 'bluebird';
import exec from './exec';

startTimer('init');

const fs = promisifyAll(require('fs'));
const s3 = promisifyAll(new AWS.S3());
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

function noop () {}

// Make sure this declaration is hoisted
var curTimer = null;
function startTimer(label) {
  if (curTimer) console.timeEnd(curTimer);
  if (label) console.time(label);
  curTimer = label;
}

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

async function uploadFile(id, file, mode) {
  try {
    await s3.putObjectAsync({
      Bucket: BUCKET,
      Key: id,
      Body: await fs.readFileAsync(file),
      ContentType: mime[mode],
      StorageClass: 'REDUCED_REDUNDANCY'
    });
    return true;
  } catch (err) {
    return false;
  }
}

async function uploadFiles(id, result) {
  result.files = {
    pdf: await uploadFile(`${id}.pdf`, 'rendered.pdf', 'pdf'),
    midi: await uploadFile(`${id}.midi`, 'rendered.midi', 'midi')
  };

  return result;
}

async function run(event) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  const id = event.id || generateId();

  startTimer('writing input');
  await Promise.all([
    fs.writeFileAsync('input.ly', event.code),
    fs.unlinkAsync('rendered.pdf').catch(noop),
    fs.unlinkAsync('rendered.midi').catch(noop)
  ]);

  startTimer('lilypond');
  let result = await runLilypond();
  result.id = id;

  startTimer('upload');
  result = await uploadFiles(id, result);

  startTimer(null);
  return result;
}

exports.handler = function (event, context, callback) {
  run(event)
  .then(res => callback(null, res))
  .catch(err => {
    console.error('FAILING')
    callback(err)
  });
}
