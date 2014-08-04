// Generated by CoffeeScript 1.7.1
(function() {
  module.exports = window.SimplexSolver = (function() {
    function SimplexSolver(matrix, div) {
      this.matrix = matrix;

      /**
        matrix is an arr of arr
        arr[0] returns the first row
        arr[0][0] returns the first elem in first row
      *
       */
      this.pivotCol = false;
      this.pivotRow = false;
      this.rowCount = this.matrix.length;
      this.colCount = this.matrix[0].length;
      this.indicatorRow = this.rowCount - 1;
      this.finshed = false;
      this.steps = ['selectPivot', 'selectPivotRow', 'normalizePivotRow', 'reducePivotColum'];
      this.stepCount = 0;
      this.start = true;
      if (div != null) {
        this.output = div;
        $("#" + div + "Button").on("click", (function(_this) {
          return function() {
            return _this.step();
          };
        })(this));
      }
    }

    SimplexSolver.prototype.print = function() {
      var i, row, _i, _len, _ref;
      $("#" + this.output).append("<pre>");
      _ref = this.matrix;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        $("#" + this.output).append("" + (JSON.stringify(this.matrix[i])) + "<br/>");
      }
      $("#" + this.output).append("</pre>");
      $("#" + this.output).append("PivotCol: " + this.pivotCol + "<br /> PivotRow: " + this.pivotRow + "<br /> Finshed: " + this.finshed + "</p>");
      $("#" + this.output).append("-----------------");
      if (!this.finshed) {
        return $("#" + this.output).append("<p> Step " + this.steps[this.stepCount] + ":\n </p><p>");
      }
    };

    SimplexSolver.prototype.selectPivot = function() {
      var elem, i, mostNegative, pivotCol, _i, _len, _ref;
      if (this.start) {
        this.pivotCol = 0;
        this.start = false;
        return;
      }
      mostNegative = Infinity;
      pivotCol = null;
      _ref = this.matrix[this.indicatorRow];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        elem = _ref[i];
        if (i < this.colCount - 2) {
          if (elem < mostNegative) {
            mostNegative = elem;
            pivotCol = i;
          }
        }
      }
      if (mostNegative < 0) {
        return this.pivotCol = pivotCol;
      } else {
        this.finshed = true;
        console.log(this.matrix);
        $("#" + this.output + "Button").text('Finshed');
        return $("#" + this.output + "Button").off();
      }
    };

    SimplexSolver.prototype.selectPivotRow = function() {
      var i, pivotRow, row, smallest, _i, _len, _ref;
      smallest = Infinity;
      pivotRow = null;
      _ref = this.matrix;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        if (i < this.rowCount - 1) {
          if (row[this.colCount - 1] / row[this.pivotCol] > 0) {
            if (row[this.colCount - 1] / row[this.pivotCol] < smallest) {
              smallest = row[this.colCount - 1] / row[this.pivotCol];
              pivotRow = i;
            }
          }
        }
      }
      this.pivotRow = pivotRow;
      if (this.pivotRow === null) {
        return this.finshed = true;
      }
    };

    SimplexSolver.prototype.normalizePivotRow = function() {
      var elem, i, receprocal, _i, _len, _ref, _results;
      receprocal = 1 / this.matrix[this.pivotRow][this.pivotCol];
      _ref = this.matrix[this.pivotRow];
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        elem = _ref[i];
        _results.push(this.matrix[this.pivotRow][i] = elem * receprocal);
      }
      return _results;
    };

    SimplexSolver.prototype.reducePivotColum = function() {
      var elem, i, j, multible, row, _i, _len, _ref, _results;
      _ref = this.matrix;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        if (!(i !== this.pivotRow)) {
          continue;
        }
        multible = this.matrix[i][this.pivotCol] / this.matrix[this.pivotRow][this.pivotCol];
        _results.push((function() {
          var _j, _len1, _ref1, _results1;
          _ref1 = this.matrix[i];
          _results1 = [];
          for (j = _j = 0, _len1 = _ref1.length; _j < _len1; j = ++_j) {
            elem = _ref1[j];
            _results1.push(this.matrix[i][j] = elem - multible * this.matrix[this.pivotRow][j]);
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    SimplexSolver.prototype.step = function() {
      console.log("Doing step " + this.steps[this.stepCount]);
      this[this.steps[this.stepCount]]();
      this.stepCount++;
      if (this.stepCount === this.steps.length) {
        this.stepCount = 0;
      }
      console.log(this);
      if (this.output != null) {
        return this.print();
      }
    };

    return SimplexSolver;

  })();

}).call(this);