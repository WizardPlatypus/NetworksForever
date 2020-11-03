module matrix;

private:

// константи
import consts : citiesNumber, ridersNumber;

// дуга між двома містами
struct Curve
{
	private:

	// массив відвідувань цієї дуги вершниками 
	bool[ridersNumber] checks;

	public:

	// час, який необхідно витратити щоб пройти цю дугу
	uint time;

	// конструктор
	this(uint time)
	{
		this.time = time;
		checks = new bool[ridersNumber];
		checks[] = false;
	}

	// відмічає вершника за індексом id
	void mark(uint id)
	in
	{
		assert(id < ridersNumber);
	}
	do
	{
		this.checks[id] = true;
	}

	// повертає стан вершника за id 
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

// Матриця відстаней
struct Matrix
{
	private:

	// Матриця дуг
	// matrix[i][j] - дуга з міста i в місто j
	Curve[citiesNumber][citiesNumber] matrix;

	// конструктор за іншою матрицею дуг
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

	public:

	// конструктор за матрицею відстаней
	this(uint[][] matrix)
	in
	{
		assert(matrix.length == citiesNumber)
		
		for (uint i = 0; i < matrix.length; ++i)
			assert(matrix[i].length == citiesNumber);
	}
	do
	{
		this.matrix = new Curve[citiesNumber][citiesNumber];
		for (uint i = 0; i < citiesNumber; ++i)
			for (uint j = 0; j < citiesNumber; ++j)
				this.matrix[i][j] = Curve(matrix[i][j]);
	}

	// відмітити дугу з i в j як пройдену вершником з індексом id
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
		assert(m[i][j].check(id));

	// можливі цілі для руху з вершини from для вершника id
	uint[] possibleTargets(uint from, uint id)
	in
	{
		assert(from < citiesNumber);
		assert(id < ridersNumber);
	}
	do
	{
		uint[] targets = new uint[];
		for (uint i = 0; i < ridersNumber; ++i)
			if (!matrix[from][i].check(id))
				targets ~= i;
		return targets;		
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
		uint from = 0;
	}

	// повертає копію даного об'єкта
	Matrix dup()
	{
		return Matrix(this.matrix);
	}
}
