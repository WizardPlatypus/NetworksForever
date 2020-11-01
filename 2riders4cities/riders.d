module rider.d;

import consts : ridersNumber;

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
uint move(Rider[ridersNumber] riders)
{
	uint minTime = uint.max;
	foreach (rider; riders)
		if (minTime > rider.time)
			minTime = rider.time;
	foreach (ref rider; riders)
		rider.time -= minTime;
	return minTime;
}

// повертає масив цілей вершників.
uint[] getTargets(Rider[ridersNumber] riders)
{
	uint[] targets = new uint[ridersNumber];
	for (uint i = 0; i  < ridersNumber; ++i)
		targets[i] = riders[i].target;
	return targets;
}
