import consts : ridersNumber, citiesNumber;
import algorithm;

// sets matrix TODO
void set(uint[citiesNumber][citiesNumber] matrix)
{
	for (uint i = 0; i < citiesNumber; ++i)
	{
		for (uint j = 0; j < citiesNumber; ++j)
		{
			matrix[i][j] = 0;
		}
	}
	return;
}

/**
  That's a main function.
  Here we only use our algorithm, which is hidden in module algorithm.d
**/
void main()
{
	import std.stdio;
	uint[citiesNumber][citiesNumber] matrix; // kinda adjency matrix

	matrix.set(); // you can set matrix in any way you want
	uint origin = 0; // where everyone begins
	algorithm.start(matrix, origin); // it's the most important : we start the algorithm

	writeln("At least that line should work ... ");
	writeln("At least that line should work ... and it works!!! ");

	return;

}

