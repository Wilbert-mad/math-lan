###
  Math trash compliter lol

  ©2021 Puppet  
###

{Lexer} = require './main'
ToComplileStrings = ['3 - 1'];

tokenResults = new Lexer(ToComplileStrings[0]).tokens()
console.log tokenResults[0], tokenResults[1]
