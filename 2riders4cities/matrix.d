module matrix;

// константи
import consts : citiesNumber, ridersNumber;

// дуга між двома містами
struct Curve
{
	private:

	// час, який необхідно витратити щоб пройти цю дугу
	uint time;
	// массив відвідувань цієї дуги вершниками 
	bool[ridersNumber] checks;

	public:

	// конструктор
	this(uint time)
	{
		this.time = time;
		checks = new bool[ridersNumber]
	}

	// встановлює новий час для подолання цієї дуги
	void setTime(uint time)
	{
		this.time = time;
	}

	// відмічає вершника за індексом id
	void markId(uint id)
	in
	{
		assert(id < ridersNumber);
	}
	do
	{
		this.checks[id] = true;
	}

	// 
	bool check(uint id)
	in
	{
		assert(id < ridersNumber);
	}
	do
	{
		return checks[id];
	}
}

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
				this.matrix[i][j].setTime(matrix[i][j]);
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
		this.matrix[i][j].markId(id);
	}

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

	// повертає копію даного об'єкта
	Matrix dup()
	{
		return Matrix(this.matrix);
	}
}
