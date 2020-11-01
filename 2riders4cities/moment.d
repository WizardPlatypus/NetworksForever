module moment.d;

public:

import consts : ridersNumber;

// Відображає момент зупинки одного або декількох вершників.
struct Moment
{
	public:

	// цілі вершників в цей момент
	uint[ridersNumber] targets;
	// часу вже пройшло
	uint timeLeft;

	// минулий момент
	Moment* prev;
	// можливі наступні моменти
	Moment*[] next;

	// конструктор
	this(uint[] targets, uint timeLeft)
	in
	{
		assert(targets.length = ridersNumber);
	}
	do
	{
		this.targets = targets.dup;
		this.timeLeft = timeLeft;
	}
}

// зв'язує момент-батька та момент-дитину
void connect(Moment* parent, Moment* child)
{
	(*parent).next ~= child;
	(*child).prev = parent;
}

// відображає окремий шлях вершників
struct Path
{
	public:

	uint[][ridersNumber] targets;
	uint time;

	this(Moment* end)
	{
		this.time = (*end).timeLeft;
		do
		{	
			auto moment = *end;
			foreach (i, target; moment.targets)
			{
				this.targets[i] ~= target;
			}
			end = moment.prev;		
		}
		while (end != null);
	}
}
