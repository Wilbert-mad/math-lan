###
  Math trash compliter lol

  ©2021 Puppet  
###

{ Lexer, Parser } = require './main'
ToComplileStrings = ['3 - 1', '2'];

for str in ToComplileStrings
  tokenResults = new Lexer(str).tokens()
  parser = new Parser(tokenResults[0]) 
  console.log tokenResults[0], tokenResults[1]
  continue if tokenResults[1]
  parsment = parser.parse()
  console.log parsment.error if parsment.error
  console.log parsment.node
