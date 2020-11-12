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
<<<<<<< HEAD
=======
	Rider[] riders = new Rider[ridersNumber];
	foreach (ref rider; riders)
		rider = Rider(0, 2);
	uint[] targets = riders.getTargets();

	assert(targets[0] == 0);
	assert(targets[1] == 0);
}

bool areAllVisited(bool[] visits)
{
>>>>>>> 4e3462d0075bb5d88c7a14789eaab177fe9e199c
	foreach (visit; visits)
		if (!visit)
			return false;
	return true;
<<<<<<< HEAD
}
=======
}

unittest
{
	bool[] visits = [true, true, true, true];
	assert(visits.areAllVisited == true);
	visits = [false, false, false, false];
	assert(visits.areAllVisited == false);
	visits = [true, false, false, false];
	assert(visits.areAllVisited == false);
}
>>>>>>> 4e3462d0075bb5d88c7a14789eaab177fe9e199c
