#cytoscape or d3: for graph view of solving the min-flow
#d3 for linear graph view
# tangle of inputs and adjusting inputs
# Convert input into Simplex form

###*

1. Goal: Maximize
2: Objective: 2x + y = P
3: x + y >=2
4: y >= 0
5: x >= 0

----->>
x | y | s1 | s2 | s3 | P | C
1   1   -1    0    0   0   2
1   0    0    -1   0   0   0
0   1    0    0    -1  0   0
-2 -1   0     0    0   1   0


select pivot column x, because -2 is most negative

for each row: divide C by the pivot colums entry for that row

select smallest as the pivot row

divide by receprocal

use this row to make the pivot colums entry 0 for each other row

select another pivot unless no negative indicators (all but P,C)





*###
  

SimplexFormer = require './input'
SimplexSolver = require './solver'

class window.Simplex
	constructor: (div) ->
		input = new SimplexFormer "#{div}Form"
		button = "#{div}Button"
		$("##{button}").text 'Start Solve'
		$("##{button}").click () ->
			if input.outputMatrix?
				$("##{button}").off()
				console.log input.outputMatrix
				console.log div
				solver = new SimplexSolver input.outputMatrix, div
				$("##{button}").text 'Step Simplex'




###*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
To define a simplex matrix is defined
the first n columns of a row are for the variables
the next n colums of a row are for slack variables
the next column is for the P of the objective function
the next column is for the constraint

to make a solver and attach it to a div (with a unique ID!) do as follows:

mySolver = new SimplexSolver(myMatrix, "myDivID");


  
*###







