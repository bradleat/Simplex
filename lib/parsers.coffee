exports.jsepAST = class jsepAST 
  constructor: (AST) ->
    @string = ''
    @toString AST
  toString: (AST) ->
    if AST.type is 'Literal'
      @_foundLiteral AST
    else if AST.type is 'Identifier'
      @_foundIdentifier AST
    else if AST.type is 'Compound'
      @_foundCompound AST
    else if AST.type is 'BinaryExpression'
      @_foundBinaryExpression AST      
    else
      throw new Error "AST type not in ['Compound', 'BinaryExpression', 'Identifier', 'Literal']. Tip: 12x should be written as 12(x)"
  _foundLiteral: (AST) ->
    @string += AST.value
  _foundIdentifier: (AST) ->
    @string += AST.name   
  _foundCompound: (AST) ->
    for expression in AST.body
      @toString expression
  _foundBinaryExpression: (AST) ->
    if AST.operator in ['+', '-']
      @toString AST.left
      @string += " #{AST.operator} "
      @toString AST.right
    else
      throw new Error "Only expressions in ['+', '-'] are supported. Tip: 12*x should be written as 12(x)"


exports.linearMatrix = class window.linearMatrix
  constructor: (linearArr) ->
    ###*
      equations of linearArr should look like:
      {
        expr: STRING
        op: #in ['lte', 'gte', 'e']
        res: STRING or Number
      }
      if the result is a string, op must equal 'e'
      if the result is a number op must equal 'lte' or 'gte'

    *###
    @matrix = []

    for equation, i in linearArr
      @parse equation, i, true


  parse: (equation, i, toMatrix = false) ->
    NumVar = /^(\d+)?([A-z]+)$/
    StrValidate = /^[A-z]+$/
    NumValidate = /^[\d]+$/

    @matrix.push {}
    negative = false
    if equation.op is 'e' and StrValidate.test equation.res
      mode = 'objective'
    else if equation.op in ['lte', 'gte'] and NumValidate.test equation.res
      mode = 'constraint'
    for part in equation.expr.split ' '
      res = NumVar.exec part
      unless res?
        negative = true if part is '-'
        negative = false if part is '+'
      else
        if res[1]? and res[2]? #12x
          res[1] = -res[1] if mode is 'objective'
          @matrix[i][res[2]] = parseFloat res[1]
        else if res[1]? #12
          if mode is 'constraint'
            if negative
              equation.res =+ res[1]
            else
              equation.res =- res[1]
          else if mode is 'objective'
            throw new Error 'objective function not simplified!'
        else if res[2]? #x
          if negative
            @matrix[i][res[2]] = -1
          else
            @matrix[i][res[2]] = 1

            @matrix[i][res[2]] = 1
    if mode is 'constraint'
      if equation.op is 'lte'
        #slack variables is 1
        @matrix[i]["$0#{res[2]}"] = 1
      else if equation.op is 'gte'
        @matrix[i]["$0#{res[2]}"] = -1
        #slack variables is -1
      @matrix[i]['constraint'] = parseInt equation.res
    else if mode is 'objective'
      @matrix[i][equation.res] = 1