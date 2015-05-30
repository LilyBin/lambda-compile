var cp = require('child_process'),
    Promise = require('bluebird')

module.exports = function () {
  var args = [].slice.apply(arguments)
  return new Promise(function (fulfill, reject) {
    args.push(function (err, stdout, stderr) {
      console.log('execution finished')
      console.log('err   \t' + err)
      console.log('stdout\t' + stdout)
      console.log('stderr\t' + stderr)

      if (err) {
        err.stderr = stderr
        return reject(err)
      }
      fulfill({
        stdout: stdout,
        stderr: stderr
      })
    })
    console.log('executing', args[0])
    cp.exec.apply(cp, args)
  })
}
