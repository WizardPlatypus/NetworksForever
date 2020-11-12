module algorithm;

private:

import consts : ridersNumber, citiesNumber;
import moment : Moment, connect;
import distributor : Distributor;
import matrix : Matrix;
import riders : Rider, move, getHalts, allDone;

import std.stdio;


public:

/** Starts algorithm **/
void start(uint[][] adjency_matrix, uint origin)
in
{
	assert(origin < citiesNumber);
}
do
{
	Matrix matrix = Matrix(adjency_matrix);
	Rider[] riders;
	riders.length = ridersNumber;
	foreach (ref rider; riders)
	{
		rider.halt = origin;
		rider.time = 0;
	}
	bool[] visits;
	visits.length = citiesNumber;
	visits[] = false;
	visits[origin] = true;

	step(null, matrix, riders, visits);
}

/** New step for riders **/
void step(Moment* then, Matrix matrix, Rider[] riders, bool[] visits)
{
	Moment* now = new Moment(riders.getHalts(), riders.move());
	writeln(riders.getHalts());

	auto d = Distributor();
	Rider*[] free;
	foreach (i, ref rider; riders)
	{
		if (rider.time == 0)
		{
			visits[rider.halt] = true;
			auto possibilities = matrix.possibleTargets(rider.halt, i);
			if (possibilities.length != 0)
			{
				d.add(possibilities);
				free ~= &rider;
			}
		}
	}
	if (visits.allDone)
	{
		destroy(riders);
		destroy(visits);
		destroy(matrix);
		return;
	}
	else if (free.length == 0)
	{
		destroy(matrix);
		destroy(riders);
		destroy(visits);
		return;
	}

	for (uint i = 0; i < d.multiplicity; ++i)
	{
		auto combination = d.pop();
		for (uint j = 0; j < combination.length; ++j)
		{
			free[i].time = matrix.time(free[i].halt, combination[i]);
			free[i].halt = combination[i];
		}
		step(now, matrix.dup, riders.dup, visits.dup);
	}

	destroy(matrix);
	destroy(riders);
	destroy(visits);
	return;
}	
/*
/** Path /
class Path
{
public:
	/** Sequence of cities' indexes from which this path is made of *
	uint[][ridersNumber] halts;
	/** How much time do this path takes to end itself *
	uint time;

	this(uint time)
	{
		time = 0;
	}

	/** Adds a new pair of halts *
	void add(uint[ridersNumber] newHalts)
	{
		for (uint i = 0; i < ridersNumber; ++i)
			this.halts[i] ~= newHalts[i];
		return;
	}

	/** Increases time **
	void increaseTime(uint incTime)
	{
		this.time += incTime;
	}

	/** Converts to string **
	string info()
	{
		string result = "";
		foreach (riderPath; path)
		{
			result ~= riderPath.toString() ~ '\n';
		}
		result ~= '\t' ~ time.toString();
		return result;
	}

	/** GC **
	~this()
	{
		destroy(halts);
	}

	Path dup()
	{

	}
}*/