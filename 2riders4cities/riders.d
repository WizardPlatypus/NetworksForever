module rider.d;

import consts : ridersNumber, citiesNumber;

public:

// Вершник.
struct Rider
{
	public:

	// ціль
	uint target;
	// час до цілі
	uint time;
	
	// конструктор
	this(uint target, uint time)
	in
	{
		assert(target < citiesNumber);
	}
	do
	{
		this.target = target;
		this.time = time;
	}
}

// переміщує вершників на максивмально можливий для всих час.
uint move(Rider[] riders)
in
{
	assert(riders.length == ridersNumber);
}
do
{
	uint minTime = uint.max;
	foreach (rider; riders)
		if (minTime > rider.time)
			minTime = rider.time;
	foreach (ref rider; riders)
		rider.time -= minTime;
	return minTime;
}

unittest
{
	Rider[] riders = new Rider[ridersNumber];
	foreach (ref rider; riders)
		rider = Rider(0, 2);
	uint time = riders.move();

	assert(time == 2);
	foreach (rider; riders)
		assert(rider.time == 0);
}

// повертає масив цілей вершників.
uint[] getTargets(Rider[] riders)
in
{
	assert(riders.length == ridersNumber);
}
do
{
	uint[] targets = new uint[ridersNumber];
	for (uint i = 0; i  < ridersNumber; ++i)
		targets[i] = riders[i].target;
	return targets;
}

unittest
{
	Rider[] riders = new Rider[ridersNumber];
	foreach (ref rider; riders)
		rider = Rider(0, 2);
	uint[] targets = riders.getTargets();

	assert(targets[0] == 0);
	assert(targets[1] == 0);
}

bool areAllVisited(bool[] visits)
{
	foreach (visit; visits)
		if (!visit)
			return false;
	return true;
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
