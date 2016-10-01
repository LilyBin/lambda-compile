import { exec } from 'child_process';

export default function (...args) {
  return new Promise((fulfill, reject) => {
    console.log('executing', args[0])
    exec(...args, (err, stdout, stderr) => {
      console.log('execution finished');
      console.log(`err   \t${err}`);
      console.log(`stdout\t${stdout}`);
      console.log(`stderr\t${stderr}`);

      if (err) {
        err.stderr = stderr;
        return reject(err);
      }

      fulfill({ stdout, stderr });
    });
  })
}
