module riders;

private:

import consts;

public:

/** Rider **/
struct Rider
{
public:
	/** Where is rider going to or where is he now **/
	uint halt;
	/** How much time rider need to arrive at halt **/
	uint time;
	
	this(uint halt, uint time)
	in { assert(halt < citiesNumber); }
	do
	{
		this.halt = halt;
		this.time = time;
	}
}

uint move(Rider[ridersNumber] riders)
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

uint[ridersNumber] getHalts(Rider[ridersNumber] riders)
{
	uint[ridersNumber] halts;
	for (uint i = 0; i < ridersNumber; ++i)
		halts[i] = riders[i].halt;
	return halts;
}

bool allDone(bool[citiesNumber] visits)
{
	foreach (visit; visits)
		if (!visit)
			return false;
	return true;
}

unittest 
{
	// allDone : 
	{
		bool[ridersNumber] array;
		array[] = false;
		assert(array.allDone() == false);
		array[$ - 1] = true;
		assert(array.allDone() == false);
		array[] = true;
		assert(array.allDone() == true);
	}

	Rider[ridersNumber] riders;
	for (uint i = 0; i < ridersNumber; ++i)
		riders[i] = Rider(i, 0);
	// getHalts : 
	{
		uint[ridersNumber] result;
		for (uint i = 0; i < ridersNumber; ++i)
			result[i] = i;
		auto answer = riders.getHalts();
		for (uint i = 0; i < ridersNumber; ++i)
			assert(answer[i] == result[i]);
	}
	// move with 0 : 
	{
		auto answer = riders.move();
		assert(answer == 0);
	}
	// move general : 
	{
		for (uint i = 0; i < ridersNumber; ++i)
			riders[i] = Rider(i, i + 1);
		// difference between each rider's time == 1, so
		for (uint i = 0; i < ridersNumber; ++i)
			assert(riders.move() == 1);
	}
}
