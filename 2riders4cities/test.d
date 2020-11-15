import consts;
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

	string source = "input.txt";	
	uint[citiesNumber][citiesNumber] array = getArray(source);

	for (uint i = 0; i < citiesNumber; ++i)
		for (uint j = 0; j < citiesNumber; ++j)
			writef(" %s\n", array[i][j]);
}
