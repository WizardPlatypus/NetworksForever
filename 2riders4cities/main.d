// imports...
import consts : ridersNumber, citiesNumber;
import rider : Rider, move, getTargets;
import moment : Moment, connect, Path;
import matrix : Matrix;
import infgetter : Infgetter;

void func(Rider[] riders, Moment* then)
{
	Moment* now = new Moment(getTargets(riders), move(riders));
	connect(then, now);

	for (uint i = 0; i < ridersNumber; ++i)
		if (riders[i].time == 0)
			matrix.visit((*then).targets[i], (*now).targets[i], i);

	

}
void main()
{
}
