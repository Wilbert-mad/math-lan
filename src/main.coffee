###
  Math trash compliter lol

  ©2021 Puppet  
###

OPERATOR = 'Operator'
NUMBER = 'Number'
NUMBERS = '0123456789'

###
  ERROR
###

class MathError extends Error
  constructor: (@message) ->
    super()
    
    @name = 'MathError'

###
  TOKENS
###

class Token
  constructor: (@type, @value) ->

  [Symbol.toStringTag]: -> 
    if @value then "#{@name}: #{@value}" else @name

###
  COMPIILER
###

class Lexer
  constructor: (@text) ->
    @position = -1
    @currentChar = null
    @advance()

  advance: () ->
    @position++
    return @currentChar = if @position < @text.length then @text[@position] else null

  makeNum: () ->
    num = ''
    hasdot = false

    while @currentChar isnt null and ([...NUMBERS.slice(''), '.'].includes(@currentChar))
      if @currentChar is '.' and not hasdot
        hasdot = true
        num += @currentChar
      if (@currentChar is '.' and hasdot)
        break
      else
        num += @currentChar
      @advance()

    new Token NUMBER, Number(num)
    

  tokens: () ->
    tokens = []
    error = null
    while @currentChar != null
      if @currentChar is '\t' or @currentChar is ' '
        @advance()
      else if ['+', '-'].includes(@currentChar)
        tokens.push new Token(OPERATOR, @currentChar)
        @advance()
      else if NUMBERS.slice('').includes(@currentChar)
        tokens.push @makeNum()
      else
        current = @currentChar
        error = new MathError('IllegalChar: '+current)
        @advance()
      
    return [tokens, error]


module.exports = { Lexer }