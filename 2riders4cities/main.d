// imports...
import consts : ridersNumber, citiesNumber;
import rider : Rider, move, getTargets;
import moment : Moment, connect, Path;
import matrix : Matrix;
import distributor : Distributor;

void func(Rider[] riders, Moment* then, Matrix matrix)
{
	Moment* now = new Moment(getTargets(riders), move(riders));
	connect(then, now);

	for (uint i = 0; i < ridersNumber; ++i)
		if (riders[i].time == 0)
			matrix.visit((*then).targets[i], (*now).targets[i], i);
	
	auto d = Distributor();
	uint[] freeToGo = new uint[];
	for (uint i = 0; i < ridersNumber; ++i)
		if (riders[i].time == 0)
		{
			d.add(matrix.possibleTargets(riders[i].target, i));
			freeToGo ~= i;
		}
	
	for (uint i = 0; i < d.multiplicity; ++i)
	{
		auto newTargets = d.pop();
		for (uint j = 0; j < freeToGO.length; ++j)
			riders[freeToGo[j]].target = newTargets[j];

		func(riders.dup, now, matrix.dup);
	}


}
void main()
{
}
