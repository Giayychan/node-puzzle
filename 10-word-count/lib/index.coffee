through2 = require 'through2'
WordCounter = require './utils'

module.exports = ->
  words = 0
  lines = 0
  bytes = 0
  characters = 0
  tokens = []

  transform = (chunk, encoding, cb) ->
    if !chunk
      return cb()
    bytes = Buffer.byteLength(chunk, encoding)
    lines = chunk.split('\n').filter((line) ->
      line
    ).length
    tokens = WordCounter.pipe(WordCounter.removeLines, WordCounter.removeEmojis, WordCounter.filterNonCharacter, WordCounter.transformDoubleQuote)(chunk)
    words = tokens.length
    characters = tokens.join('').split('').filter(WordCounter.isCharacter).join('').length
    return cb()

  flush = (cb) ->
    this.push {words, lines, bytes, characters}
    this.push null
    return cb()

  return through2.obj transform, flush
