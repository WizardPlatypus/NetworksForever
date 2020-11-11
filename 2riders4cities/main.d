module main;

import consts : ridersNumber, citiesNumber;
import algorithm;

/**
  That's a main function.
  Here we only use our algorithm, which is hidden in module algorithm.d
**/
void main()
{
	uint[citiesNumber][citiesNumber] matrix; // kinda adjency matrix
	matrix.set(); // you can set matrix in any way you want
	uint origin = 0; // where everyone begins
	algorithm.generatePaths(matrix, origin); // it's the most important : we start the algorithm

	import std.stdio : writeln;
	writeln(algorithm.bestPaths.toString()); // just doing smth with generated paths
}

