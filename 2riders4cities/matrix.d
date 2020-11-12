module matrix;

private:

import consts : citiesNumber, ridersNumber;

struct Curve
{
private:
	bool[ridersNumber] checks;

public:
	uint time;

	this(uint time)
	{
		this.time = time;
		checks = new bool[ridersNumber];
		checks[] = false;
	}

	void mark(uint id)
	in
	{
		assert(id < ridersNumber);
	}
	do
	{
		this.checks[id] = true;
	}

	bool check(uint id)
	in
	{
		assert(id < ridersNumber);
	}
	do
	{
		return checks[id];
	}

	unittest
	{
		Curve c = Curve(3);
		assert(c.time == 3);
		for (uint i = 0; i < ridersNumber; ++i)
			assert(c.check(i) == false);
		c.mark(0);
		assert(c.check(0) == true);
	}
	
}

public:

struct Matrix
{
private:
	Curve[][] matrix;

	this(Curve[][] matrix)
	in
	{
		assert(matrix.length == citiesNumber);
		foreach (row; matrix)
			assert(row.length == citiesNumber);
	}
	do
	{
		this.matrix = matrix.dup;
	}

	bool check(uint from, uint to, uint id)
	in
	{
		assert(from < citiesNumber);
		assert(to < citiesNumber);
		assert(id < ridersNumber);
	}
	do
	{
		return matrix[from][to].check(id);
	}

public:
	this(uint[][] matrix)
	{
		this.matrix.length = citiesNumber;
		for (uint i = 0; i < citiesNumber; ++i)
		{
			this.matrix[i].length = citiesNumber;
			for (uint j = 0; j < citiesNumber; ++j)
				this.matrix[i][j] = Curve(matrix[i][j]);
		}
	}

	void visit(uint i, uint j, uint id)
	in
	{
		assert(i < citiesNumber);
		assert(j < citiesNumber);
		assert(id < ridersNumber);
	}
	do
	{
		this.matrix[i][j].mark(id);
	}

	unittest
	{
		auto m = Matrix([
			[ 1, 1, 1, 1, 1],
			[ 1, 1, 1, 1, 1],
			[ 1, 1, 1, 1, 1],
			[ 1, 1, 1, 1, 1],
			[ 1, 1, 1, 1, 1]
		]);
		uint i = 0;
		uint j = 0;
		uint id = 0;
		m.visit(i, j, id);
		assert(m.check(i, j, id));
	}

	uint[] possibleTargets(uint from, uint id)
	in
	{
		assert(from < citiesNumber);
		assert(id < ridersNumber);
	}
	do
	{
		uint[] targets;
		for (uint i = 0; i < ridersNumber; ++i)
			if (!matrix[from][i].check(id))
				targets ~= i;
		return targets;		
	}

	unittest
	{
		auto m = Matrix([
			[ 0, 1, 1, 1, 1],
			[ 1, 0, 1, 1, 1],
			[ 1, 1, 0, 1, 1],
			[ 1, 1, 1, 0, 1],
			[ 1, 1, 1, 1, 0]
		]);
		uint origin = 0;
		import std.stdio :writeln;
		writeln(m.possibleTargets(origin, 0));
		assert(m.possibleTargets(origin, 0) == [0, 1, 2, 3, 4]);
		m.visit(0, 0, 0);
		writeln(m.possibleTargets(origin, 0));
		assert(m.possibleTargets(origin, 0) == [1, 2, 3, 4]);
	}

	uint time(uint from, uint to)
	in
	{
		assert(from < citiesNumber);
		assert(to < citiesNumber);
	}
	do
	{
		return matrix[from][to].time;
	}

	Matrix dup()
	{
		return Matrix(this.matrix);
	}
}
