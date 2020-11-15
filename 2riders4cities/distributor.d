module distributor;

private:

struct CyclicContainer
{
private:
	uint[] array;
	uint index;
public:
	this(uint[] array)
	{
		this.array = array.dup;
		this.index = 0;
	}

	@property uint top()
	{
		return array[index];
	}

	bool move()
	{
		++index;
		index %= array.length;
		return index == 0;
	}

	@property uint length()
	{
		return array.length;
	}

	unittest
	{
		uint[] origin = [ 0, 2, 5, 4 ];
		CyclicContainer cc = CyclicContainer(origin);
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
}

public:

struct Distributor
{
private:
	CyclicContainer[] containers;
public:
	void add(uint[][] arrays ...)
	{
		foreach (array; arrays)
			containers ~= CyclicContainer(array);
	}

	uint[] pop()
	{
		uint[] array = new uint[containers.length];

		bool flag = true;
		foreach (i, ref container; containers)
		{
			array[i] = container.top;
			if (flag)
				flag = container.move();
		}
		return array;
	}		

	@property uint multiplicity()
	{
		uint m = 1;
		foreach (container; containers)
			m *= container.length;
		return m;
	}
}	

unittest
{
	auto d = new Distributor();
	d.add([0, 1, 2, 3]);
	d.add([4, 5, 6]);
	d.add([7]);
	d.add([8, 9, 10, 11, 12]);

	assert(d.multiplicity == 60);

	assert(d.pop() == [0, 4, 7, 8]);
	assert(d.pop() == [1, 4, 7, 8]);
	d.pop();
	d.pop();
	assert(d.pop() == [0, 5, 7, 8]);
	assert(d.pop() == [1, 5, 7, 8]);
}

