module main;

import consts : ridersNumber, citiesNumber;
import algorithm : start;

void set(uint[][] matrix)
in
{
	assert(matrix.length == citiesNumber);
	foreach (row; matrix)
		assert(row.length == citiesNumber);
}
do
{
	import std.random : uniform;
	for (uint i = 0; i < citiesNumber; ++i)
		for (uint j = 0; j < citiesNumber; ++j)
			matrix[i][j] = uniform(0, 15);
}

/**
  That's a main function.
  Here we only use our algorithm, which is hidden in module algorithm.d
**/
void main()
{
	import std.stdio;

	uint[][] matrix; // kinda adjency matrix
	matrix.length = citiesNumber;
	for (uint i = 0; i < citiesNumber; ++i)
		matrix[i].length = citiesNumber;
	matrix.set(); // you can set matrix in any way you want

	uint origin = 0; // where everyone begins
	
	start(matrix, origin); // it's the most important : we start the algorithm

	writeln("At least that line should work ... ");
	writeln("At least that line should work ... and it works!!! ");

	return;

}

