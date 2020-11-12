module rider.d;

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
		assert(target < citiesNumber);
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
	return minTime;
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
		targets[i] = riders[i].halt;
	return halts;
}

bool allDone(bool[] visits)
{
	foreach (visit; visits)
		if (!visit)
			return false;
	return true;
}