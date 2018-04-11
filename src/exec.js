import { exec } from 'child_process';

/**
 * @return {Promise}
 */
export default function (...args) {
  return new Promise((resolve, reject) => {
    console.log('executing', args[0])
    exec(...args, (error, stdout, stderr) => {
      console.log('execution finished');
      console.log(`error \t${error}`);
      console.log(`stdout\t${stdout}`);
      console.log(`stderr\t${stderr}`);

      if (error) {
        error.stderr = stderr;
        reject(error);
      } else {
        resolve({ stdout, stderr });
      }
    });
  })
}
