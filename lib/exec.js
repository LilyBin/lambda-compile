var cp = require('child_process'),
    Promise = require('bluebird')

module.exports = function () {
  var args = [].slice.apply(arguments)
  return new Promise(function (fulfill, reject) {
    args.push(function (err, stdout, stderr) {
      console.log('execution finished')
      console.log('err'   , err)
      console.log('stdout', stdout)
      console.log('stderr', stderr)

      if (err) {
        err.stderr = stderr
        return reject(err)
      }
      fulfill({
        stdout: stdout,
        stderr: stderr
      })
    })
    console.log('executing', argument[0])
    cp.exec.apply(cp, args)
  })
}
