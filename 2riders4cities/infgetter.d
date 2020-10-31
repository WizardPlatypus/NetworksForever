module infgetter;

public:
struct Infgetter
{
	private:
	// масив значень, які необхідно передати.
	uint[] array;
	// значення, яке повертається, коли масив пустий.
	uint bung;

	// відповідає, чи пустий масив.
	bool empty()
	{
		return array.length == 0;
	}

	public:
	// конструктор.
	this(uint[] array, uint bung)
	{
		this.array = array.dup;
		this.bung = bung;
	}

	// повертає елемент массиву, або bung, якщо масив пустий.
	uint pop()
	{
		if (this.empty)
			return bung;
		else
		{
			auto value = array[0];
			array = array[1 .. $];
			return value;
		}
	}
}

private:
unittest
{
	auto g = Infgetter([0, 2, 4, 6, 8], 3);
	assert(g.pop == 0);
	assert(g.pop == 2);
	assert(g.pop == 4);
	assert(g.pop == 6);
	assert(g.pop == 8);
	assert(g.pop == 3);
}

void main()
{}

