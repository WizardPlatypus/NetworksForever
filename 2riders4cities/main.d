module main;

import consts;
import algorithm;
import std.stdio; 

uint[citiesNumber][citiesNumber] getArray(string source)
{
	File file = File(source);
	uint[citiesNumber][citiesNumber] array;
	for (uint i = 0; i < citiesNumber; ++i)
	{
		for (uint j = 0; j < citiesNumber; ++j)
		{
			file.readf(" %d", array[i][j]);
		}
	}
	return array;
}

void main()
{
	uint[citiesNumber][citiesNumber] array = getArray("input.txt"); // kinda matrix
	uint origin = 0; // where everyone starts
	
	start(array, origin); // start 

	writeln(array);

	writeln("At least that line should work ... ");
	writeln("At least that line should work ... and it works!!! ");

	return;
}

