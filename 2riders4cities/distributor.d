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


public:

// класс, що розподіляє елементи массивів на послідовності.
class Distributor
{
	private:

	// контейнери
	CyclicContainer[] containers;

	public:

	// конструктор
	this(uint[][] arrays ...)
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
