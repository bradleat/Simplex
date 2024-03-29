// Generated by CoffeeScript 1.7.1
(function() {
  var SimplexFormer, jsepAST, linearMatrix,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  jsepAST = require('./parsers').jsepAST;

  linearMatrix = require('./parsers').linearMatrix;

  module.exports = SimplexFormer = (function() {
    function SimplexFormer(div) {
      this.div = div;
      this.outputMatrix = null;
      this.FormContext = {
        objFuncMessage: cjs.constraint(false),
        newConstraintFuncMessage: cjs.constraint(false),
        constraint: cjs.array([]),
        matrix: cjs.array([]),
        order: cjs.array([])
      };
      window.debugContext = this.FormContext;
      $((function(_this) {
        return function() {
          $("#" + _this.div).html(cjs.createTemplate($('#SimplexForm'), _this.FormContext));
          $("#new-constraint-add").on('click', function() {
            var res, resObjective;
            res = _this.validate(_this.FormContext.newConstraintFunc.get(), 'constraint');
            if (res) {
              _this.FormContext.constraint.push(res);
              resObjective = _this.validate(_this.FormContext.objFunc.get(), 'objective');
              return _this.toMatrix(resObjective, _this.FormContext.constraint.toArray());
            }
          });
          return cjs.liven(function() {
            _this.validate(_this.FormContext.newConstraintFunc.get(), 'constraint');
            return _this.validate(_this.FormContext.objFunc.get(), 'objective');
          });
        };
      })(this));
    }

    SimplexFormer.prototype.toMatrix = function(objective, constraints) {
      var col, matrix, matrixRow, objectiveName, order, preForm, row, varName, _i, _j, _k, _l, _len, _len1, _len2, _len3;
      if (objective && typeof objective !== 'string' && constraints.length !== 0) {
        objectiveName = objective.res;
        preForm = new linearMatrix([objective]);
        objective = preForm.matrix[0];
        order = [];
        for (varName in objective) {
          if (varName !== objectiveName) {
            order.push(varName);
          }
        }
        preForm = new linearMatrix(constraints);
        constraints = preForm.matrix;
        for (_i = 0, _len = constraints.length; _i < _len; _i++) {
          row = constraints[_i];
          for (varName in row) {
            if (__indexOf.call(order, varName) < 0 && varName[0] !== '$' && varName !== 'constraint') {
              order.push(varName);
            }
          }
        }
        for (_j = 0, _len1 = constraints.length; _j < _len1; _j++) {
          row = constraints[_j];
          for (varName in row) {
            if (varName[0] === '$' && __indexOf.call(order, varName) < 0) {
              order.push(varName);
            }
          }
        }
        order.push(objectiveName);
        order.push('constraint');
        constraints.push(objective);
        matrix = [];
        for (_k = 0, _len2 = constraints.length; _k < _len2; _k++) {
          row = constraints[_k];
          matrixRow = [];
          for (_l = 0, _len3 = order.length; _l < _len3; _l++) {
            col = order[_l];
            if (row[col] == null) {
              row[col] = 0;
            }
            matrixRow.push(row[col]);
          }
          matrix.push(matrixRow);
        }
        this.FormContext.order.setValue(order);
        this.FormContext.matrix.setValue(matrix);
        return this.outputMatrix = matrix;
      }
    };

    SimplexFormer.prototype.validate = function(toValidate, type) {
      var e, parse, set, validateObj;
      if (type === 'constraint') {
        set = 'newConstraintFuncMessage';
      } else if (type === 'objective') {
        set = 'objFuncMessage';
      }
      if (set != null) {
        validateObj = {
          val: toValidate,
          e: null
        };
        try {
          return jsep(validateObj.val);
        } catch (_error) {
          e = _error;
          return validateObj.e = e.dedscription;
        } finally {
          if (validateObj.e != null) {
            this.FormContext[set].set(validateObj.e);
          } else {
            try {
              parse = new jsepAST(jsep(validateObj.val));
            } catch (_error) {
              e = _error;
              validateObj.e = e.message;
            } finally {
              if (validateObj.e != null) {
                this.FormContext[set].set(validateObj.e);
              } else {
                if (type === 'objective') {
                  if (/^[A-z]+$/.test(this.FormContext.objVar.get())) {
                    this.FormContext[set].set(false);
                    return {
                      expr: parse.string,
                      op: "e",
                      res: this.FormContext.objVar.get()
                    };
                  } else {
                    this.FormContext[set].set('Objective value must a variable name!');
                    return false;
                  }
                } else if (type === 'constraint') {
                  if (/^[\d]+$/.test(this.FormContext.newConstraintVal.get())) {
                    this.FormContext[set].set(false);
                    return {
                      expr: parse.string,
                      op: $('#newConstraintOp').children(':selected').first().val(),
                      res: this.FormContext.newConstraintVal.get()
                    };
                  } else {
                    this.FormContext[set].set('Constraint value must be a number!');
                    return false;
                  }
                } else {
                  this.FormContext[set].set('Something went wrong');
                  return false;
                }
              }
            }
          }
        }
      }
    };

    return SimplexFormer;

  })();

}).call(this);
