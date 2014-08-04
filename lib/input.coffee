{jsepAST} = require './parsers'
{linearMatrix} = require './parsers'
module.exports = class SimplexFormer
  constructor: (@div) ->
    @outputMatrix = null
    @FormContext = 
      objFuncMessage: cjs.constraint false
      newConstraintFuncMessage: cjs.constraint false
      constraint: cjs.array []
      matrix: cjs.array []
      order: cjs.array []
    window.debugContext = @FormContext
    $ () =>
      $("##{@div}").html cjs.createTemplate $('#SimplexForm'), @FormContext
      $("#new-constraint-add").on 'click', () =>
        #add new constraint
        res = @validate @FormContext.newConstraintFunc.get(), 'constraint'
        if res
          @FormContext.constraint.push res
          resObjective = @validate @FormContext.objFunc.get(), 'objective'
          @toMatrix resObjective, @FormContext.constraint.toArray()
      cjs.liven () =>
        #Constraint Function Validation
        @validate @FormContext.newConstraintFunc.get(), 'constraint'
        #Objective Function Validation
        @validate @FormContext.objFunc.get(), 'objective'


  toMatrix: (objective, constraints) ->
    if objective and typeof objective isnt 'string' and constraints.length isnt 0
      #save the objective name i.e Profit
      objectiveName = objective.res
      #get the object version of the matrix (but only for the objective row)
      preForm = new linearMatrix [objective]
      objective = preForm.matrix[0]
      order = []
      #push the objective variables to the row order
      for varName of objective when varName isnt objectiveName
        order.push varName
      #get the object version of the matrix (now for the constraint rows)
      preForm = new linearMatrix constraints
      constraints = preForm.matrix
      #for object version of the row:
      for row in constraints
        #push the remaining found non-slack vars
        for varName of row when varName not in order and varName[0] isnt '$' and varName isnt 'constraint'
          order.push varName
      for row in constraints  
        #push the found slack vars
        for varName of row when varName[0] is '$' and varName not in order
          order.push varName      
      #push objective and constraint rows
      order.push objectiveName
      order.push 'constraint'
      
      #add each row to the matrix (in order)
      #preMatrix = constraints.push objective
      constraints.push objective
      matrix = []
      for row in constraints
        matrixRow = []
        for col in order
          row[col] = 0 unless row[col]?
          matrixRow.push row[col]
        matrix.push matrixRow

      @FormContext.order.setValue order
      @FormContext.matrix.setValue matrix
      @outputMatrix = matrix



  validate: (toValidate, type) ->
    if type is 'constraint'
      set = 'newConstraintFuncMessage'
    else if type is 'objective'
      set = 'objFuncMessage'
    if set?
      #Function Validation
      validateObj = 
        val: toValidate
        e: null
      try
        jsep validateObj.val
      catch e
        validateObj.e = e.dedscription
      finally          
        if validateObj.e?
          @FormContext[set].set validateObj.e 
        else
          try
            parse = new jsepAST jsep validateObj.val
          catch e
            validateObj.e = e.message          
          finally
            if validateObj.e?
              @FormContext[set].set validateObj.e
            else
              if type is 'objective'
                if /^[A-z]+$/.test @FormContext.objVar.get()
                  @FormContext[set].set false
                  return {expr: parse.string, op: "e", res: @FormContext.objVar.get()}
                else
                  @FormContext[set].set 'Objective value must a variable name!'
                  return false

              else if type is 'constraint'
                if /^[\d]+$/.test @FormContext.newConstraintVal.get()
                  @FormContext[set].set false
                  return {expr: parse.string, op: $('#newConstraintOp').children(':selected').first().val(), res: @FormContext.newConstraintVal.get()}
                else
                  @FormContext[set].set 'Constraint value must be a number!'
                  return false
              else
                @FormContext[set].set 'Something went wrong'
                return false
