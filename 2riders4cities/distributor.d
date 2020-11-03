module distributor;

private:

// Циклічний контейнер.
struct CyclicContainer
{
	private:
	// масив значень, які необхідно передати.
	uint[] array;
	// індекс поточного елементу. 
	uint index;

	public:
	// конструктор.
	this(uint[] array)
	{
		this.array = array.dup;
		this.index = 0;
	}

	// повертає поточний елемент масиву. 
	@property uint top()
	{
		return array[index];
	}

	// переходить до наступного елементу та повертає true, якщо повернувся
	// до першого елементу.
	bool move()
	{
		++index;
		index %= array.length;
		return index == 0;
	}

	// довжина массиву.
	@property uint length()
	{
		return array.length;
	}
}

unittest
{
	uint[] origin = [0, 2, 3, 1];
	auto cc = CyclicContainer(origin);
	for (uint i = 0; i < origin.length; ++i)
	{
		assert(origin[i] == cc.top);
		cc.move();
	}
	// це повинно працювати багато разів.
	for (uint i = 0; i < origin.length; ++i)
	{
		assert(origin[i] == cc.top);
		cc.move();
	}
	for (uint i = 0; i < origin.length; ++i)
	{
		assert(origin[i] == cc.top);
		cc.move();
	}
}

public:

// класс, що розподіляє елементи массивів на послідовності.
class Distributor
{
	private:

	// контейнери
	CyclicContainer[] containers;

	public:

	// конструктор
	this()
	{
		containers = [];
	}

	// додає массив до розподілювача 
	void add(uint[] array)
	{
		containers = [];
		foreach (array; arrays)
			containers ~= CyclicContainer(array);
	}

	// повертає поточну послідовність та переходить до наступної
	uint[] pop()
	{
		uint[] array = new uint[containers.length];

		bool flag = true;
		foreach (i, container; containers)
		{
			array[i] = container.top;
			if (flag)
				flag = container.move();
		}
		return array;
	}		

	// кількість послідовностей, які можливо згенерувати.
	@property uint multiplicity()
	{
		uint m = 1;
		foreach (container; containers)
			m *= container.length;
		retrun m;
	}
}	

unittest
{
	auto d = Distributor();
	d.add([0, 2, 4, 3]);
	d.add([1, 7, 2, 6]);
	d.add([2, 4]);
	d.add([0]);

	assert(d.multiplicity == 32);

	assert(d.pop() == [0, 1, 2, 0]);
	assert(d.pop() == [2, 1, 2, 0]);
	assert(d.pop() == [4, 1, 2, 0]);
	assert(d.pop() == [3, 1, 2, 0]);
	assert(d.pop() == [0, 7, 2, 0]);
	assert(d.pop() == [2, 7, 2, 0]);
}

