import consts : ridersNumber, citiesNumber;
import riders : Rider, move, getTargets, areAllVisited;
import moment : Moment, connect, Path;
import matrix : Matrix;
import distributor : Distributor;

Path[] theBests;

void func(Rider[] riders, Moment* then, Matrix matrix, bool[] visits)
in
{
	assert(visits.length == citiesNumber);
}
do
{
	Moment* now = new Moment(riders.getTargets(), riders.move());
	connect(then, now);

	for (uint i = 0; i < ridersNumber; ++i)
		if (riders[i].time == 0)
		{
			matrix.visit((*then).targets[i], (*now).targets[i], i);
			visits[i] == true; // mark visited node
		}
	if (visits.areAllVisited)
		THE_END();
	
	
	auto d = Distributor();
	uint[] freeToGo;
	for (uint i = 0; i < ridersNumber; ++i)
		if (riders[i].time == 0)
		{
			auto targets = matrix.possibleTargets(riders[i].target, i);
			if (targets.length != 0)
			{
				d.add(targets);
				freeToGo ~= i;
			}
		}
	if (freeToGo.length == 0)
		THE_END(); //FIXME
	
	for (uint i = 0; i < d.multiplicity; ++i)
	{
		auto newTargets = d.pop();
		for (uint j = 0; j < freeToGO.length; ++j)
			riders[freeToGo[j]].target = newTargets[j];

		func(riders.dup, now, matrix.dup, visits.dup);
>>>>>>> 4e3462d0075bb5d88c7a14789eaab177fe9e199c
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

