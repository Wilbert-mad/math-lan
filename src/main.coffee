###
  Math trash compliter lol

  ©2021 Puppet  
###

OPERATOR = 'Operator'
NUMBER = 'Number'
NUMBERS = '0123456789'
EOF = 'END-OF-FILE'
PLUS = '+'
MINS = '-'

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
  LEXER
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
      else if [PLUS, MINS].includes(@currentChar)
        tokens.push new Token(OPERATOR, @currentChar)
        @advance()
      else if NUMBERS.slice('').includes(@currentChar)
        tokens.push @makeNum()
      else
        current = @currentChar
        error = new MathError('IllegalChar: '+current)
        @advance()
      
    tokens.push new Token(EOF)
    return [tokens, error]


###
  NODES
###

class NumberNode
  constructor: (@token) ->

class BinOpNode
  constructor: (@leftNode, @operatorToken, @rightNode) ->

###
  PARSER RESULT
###

class ParserResult
  constructor: ->
    @error = null
    @node = null

  register: (res) ->
    if res instanceof ParserResult
      @error = res.error if res.error
      return res.node
      
    return res

  success: (node) ->
    @node = node
    return @
  
  failure: (error) ->
    @error = error
    return @

###
  PARSER
###

class Parser
  constructor: (@tokens) ->
    @tokenIndex = -1
    @currentToken = null
    @advance()

  advance: ->
    @tokenIndex++
    if @tokenIndex < @tokens.length
      @currentToken = @tokens[@tokenIndex]
    return @currentToken

  parse: ->
    res = @expression()
    if not res.error and @currentToken.type isnt EOF
      return res.failure(new MathError('Expected "+" or "-"'))
    return res
  
  factor: ->
    res = new ParserResult()
    token = @currentToken

    if token.type is NUMBER
      res.register(@advance())
      return res.success(new NumberNode(token))

    return res.failure(new MathError('Expected number or float'))
  
  expression: ->
    res = new ParserResult()
    _left = res.register(@factor())
    return res if res.error

    left = null
    while [OPERATOR].includes(@currentToken.type)
      opToken = @currentToken
      res.register(@advance())
      right = res.register(@factor())
      return res if res.error
      left = new BinOpNode(_left, opToken, right)
    
    return res.success(left or _left)



module.exports = { Lexer, Parser }