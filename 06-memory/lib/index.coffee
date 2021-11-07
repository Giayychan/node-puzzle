fs = require('fs')
readline = require('readline')
stream = require('stream')

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  readStream = fs.createReadStream(__dirname + '/../data/geo.txt')
  outStream = new stream
  rl = readline.createInterface(readStream, outStream)

  counter = 0
  
  rl.on('line', (chunk) ->
    data = chunk.split('\n')
    if data[0] and data[0].includes(countryCode)
      line = data[0].split('\t')
      if line[3] and line[3] == countryCode
        counter += +line[1] - (+line[0])
    return
  ).on 'close', ->
    cb null, counter
    return
  return