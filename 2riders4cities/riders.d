module riders;

import consts : ridersNumber, citiesNumber;

public:

/** Rider **/
struct Rider
{
public:
	uint halt;
	uint time;
	
	this(uint halt, uint time)
	in
	{
		assert(halt < citiesNumber);
	}
	do
	{
		this.halt = halt;
		this.time = time;
	}
}

uint move(Rider[] riders)
in
{
	assert(riders.length == ridersNumber);
}
do
{
	uint minTime = uint.max;
	foreach (rider; riders)
		if (minTime > rider.time && rider.time != 0)
			minTime = rider.time;
	foreach (ref rider; riders)
		if (rider.time != 0)
			rider.time -= minTime;
	return minTime == uint.max ? 0 : minTime;
}

uint[] getHalts(Rider[] riders)
in
{
	assert(riders.length == ridersNumber);
}
do
{
	uint[] halts = new uint[ridersNumber];
	for (uint i = 0; i  < ridersNumber; ++i)
		halts[i] = riders[i].halt;
	return halts;
}

bool allDone(bool[] visits)
{
	foreach (visit; visits)
		if (!visit)
			return false;
	return true;
}

unittest 
{
	// allDone : PASSED
	{
		bool[] array = [true, true, true, false];
		assert(array.allDone() == false);
		array = [true, true, true, true];
		assert(array.allDone() == true);
	}
	// getHalts : PASSED
	{
		Rider[] riders;
		riders.length = ridersNumber;
		for (uint i = 0; i < ridersNumber; ++i)
			riders[i] = Rider(i, 0);
		uint[] result;
		result.length = ridersNumber;
		for (uint i = 0; i < ridersNumber; ++i)
			result[i] = i;
		uint[] answer = riders.getHalts();
		for (uint i = 0; i < ridersNumber; ++i)
			assert(answer[i] == result[i]);
	}
	// move with 0 : PASSED
	{
		Rider[] riders;
		riders.length = ridersNumber;
		for (uint i = 0; i < ridersNumber; ++i)
			riders[i] = Rider(i, 0);
		auto answer = riders.move();
		assert(answer == 0);
	}
	// move general : PASSED
	{
		Rider[] riders;
		riders.length = ridersNumber;
		for (uint i = 0; i < ridersNumber; ++i)
			riders[i] = Rider(i, i + 1);
		for (uint i = 0; i < ridersNumber; ++i)
			assert(riders.move() == 1);
	}
}