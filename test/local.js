'use strict';

const path = require('path');
const version = process.argv[2];

if (process.argv.length < 2) {
  console.error('test/local.js <stable|unstable>');
  process.exit(1);
}

process.env.LAMBDA_TASK_ROOT = path.resolve(__dirname, '..', `deploy-${version}`);

const event = require('./payload.json');
const context = {
  succeed(result) {
    console.log('Success!!!')
    console.log(result)
  },
  fail(error) {
    console.log('FAIL!!!')
    console.log(error)
  },
  done(err, result) {
    console.log('DONE!!!')
    console.log('Error:', err)
    console.log('Result:', result)
  }
};
const callback = context.done;

const handler = require(`../deploy-${version}/`).handler;
handler(event, context, callback);
