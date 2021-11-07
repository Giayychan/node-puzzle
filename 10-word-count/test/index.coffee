assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count zero word', (done) ->
      input = ''
      expected = words: 0, lines: 0, characters: 0, bytes: 0
      helper input, expected, done

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, bytes: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 16, bytes: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 13, bytes: 19
    helper input, expected, done

  it 'should ignore unclosed double quote', (done) ->
    input = '"this is one word!'
    expected = words: 4, lines: 1, characters: 13, bytes: 18
    helper input, expected, done

  it 'should ignore unclosed double quote', (done) ->
    input = '"this is one word!" Hello world!'
    expected = words: 3, lines: 1, characters: 23, bytes: 32
    helper input, expected, done

  it 'should ignore unclosed double quote 2', (done) ->
    input = 'this is one word! "Hello world!"'
    expected = words: 5, lines: 1, characters: 23, bytes: 32
    helper input, expected, done

  it 'should count camel cased words as multiple words', (done) ->
    input = 'FunPuzzle'
    expected = words: 2, lines: 1, characters: 9, bytes: 9
    helper input, expected, done

  it 'should count camel cased words as multiple words', (done) ->
    input = 'Fun Puzzle FunPuzzle'
    expected = words: 4, lines: 1, characters: 18, bytes: 20
    helper input, expected, done

  it 'should count a single line', (done) ->
    input = 'one'
    expected = words: 1, lines: 1, characters: 3, bytes: 3
    helper input, expected, done

  it 'should count 2 lines', (done) ->
    input = 'one\ntwo'
    expected = words: 2, lines: 2, characters: 6, bytes: 7
    helper input, expected, done

  it 'should count 3 lines', (done) ->
      input = 'one\ntwo\nthree'
      expected = words: 3, lines: 3, characters: 11, bytes: 13
      helper input, expected, done

  it 'should filter emojis', (done) ->
      input = '💻 💻ab c'
      expected = words: 2, lines: 1, characters: 3, bytes: 13
      helper input, expected, done

  it 'should test fixure 1', (done) ->
      fs.readFile "#{__dirname}/fixtures/1,9,44.txt", 'utf8', (err, fileContents) ->
        if err
          throw err
        input = JSON.parse(JSON.stringify(fileContents))
        expected = words: 9, lines: 1, characters: 35, bytes: 44
        helper input, expected, done

  it 'should test fixure 2', (done) ->
        fs.readFile "#{__dirname}/fixtures/3,7,46.txt", 'utf8', (err, fileContents) ->
          if err
            throw err
          input = JSON.parse(JSON.stringify(fileContents))
          expected = words: 7, lines: 3, characters: 35, bytes: 46
          helper input, expected, done

  it 'should test fixure 3', (done) ->
        fs.readFile "#{__dirname}/fixtures/5,9,40.txt", 'utf8', (err, fileContents) ->
          if err
            throw err
          input = JSON.parse(JSON.stringify(fileContents))
          expected = words: 9, lines: 5, characters: 35, bytes: 40
          helper input, expected, done


