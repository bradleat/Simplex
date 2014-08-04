module.exports = class window.SimplexSolver
  constructor: (@matrix, div) ->
    ###*
      matrix is an arr of arr
      arr[0] returns the first row
      arr[0][0] returns the first elem in first row
    *###
    @pivotCol = false
    @pivotRow = false
    @rowCount = @matrix.length
    @colCount = @matrix[0].length
    @indicatorRow = @rowCount - 1
    @finshed = false
    @steps = ['selectPivot', 'selectPivotRow', 'normalizePivotRow', 'reducePivotColum']
    @stepCount = 0
    @start = true
    if div?
      @output = div
      $("##{div}Button").on "click", () => @step()


  print: () ->
    $("##{@output}").append "<pre>"
    for row, i in @matrix
      $("##{@output}").append "
        #{JSON.stringify(@matrix[i])}<br/>"
    $("##{@output}").append "</pre>"
    
    $("##{@output}").append "
      PivotCol: #{@pivotCol}<br />
      PivotRow: #{@pivotRow}<br />
      Finshed: #{@finshed}</p>
    "
    $("##{@output}").append "-----------------"
    unless @finshed
      $("##{@output}").append "
        <p> Step #{@steps[@stepCount]}:\n </p><p>"
    
  selectPivot: () ->
    #select smallest element in the indicator row
    if @start
      @pivotCol = 0
      @start = false
      return
    mostNegative = Infinity
    pivotCol = null
    for elem, i in @matrix[@indicatorRow] when i < @colCount - 2
      if elem < mostNegative
        mostNegative = elem
        pivotCol = i
    #the element should be negative
    if mostNegative < 0
      @pivotCol = pivotCol
      #@selectPivotRow
    else 
      @finshed = true
      console.log @matrix
      $("##{@output}Button").text 'Finshed'
      $("##{@output}Button").off()
      
  selectPivotRow: () ->
    smallest = Infinity
    pivotRow = null
    for row, i in @matrix when i < @rowCount - 1
      if row[@colCount - 1]/row[@pivotCol] > 0
        if row[@colCount - 1]/row[@pivotCol] < smallest
          smallest = row[@colCount - 1]/row[@pivotCol]
          pivotRow = i
    @pivotRow = pivotRow
    if @pivotRow is null
      @finshed = true
    #@normalizePivotRow

  normalizePivotRow: () ->
    receprocal = 1 / @matrix[@pivotRow][@pivotCol]
    for elem, i in @matrix[@pivotRow]
      @matrix[@pivotRow][i] = elem * receprocal
    #@reducePivotColum

  reducePivotColum: () ->
    for row, i in @matrix when i isnt @pivotRow
      multible = @matrix[i][@pivotCol]/@matrix[@pivotRow][@pivotCol]
      for elem, j in @matrix[i]
        @matrix[i][j] = elem - multible*(@matrix[@pivotRow][j])


  step: () ->
    console.log "Doing step #{@steps[@stepCount]}"
    @[@steps[@stepCount]]()
    @stepCount++
    if @stepCount is @steps.length
      @stepCount = 0
    console.log @
    if @output?
      @print()