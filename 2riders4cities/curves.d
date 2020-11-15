module curves;

private:

import consts;

public:

/** Curve between nodes **/
struct Curve
{
public:
    /** Price to go through this curve **/
    uint price;
    /** Visits by riders **/
    bool[ridersNumber] visits;

    this(uint price)
    {
        this.price = price;
    }

    /** Returns copy **/
    Curve dup()
    {
        Curve t = Curve(this.price);
        t.visits = this.visits;
        return t;
    }
}

/** Returns possible targets **/
uint[] possibilities(Curve[citiesNumber][citiesNumber] matrix,
	uint from, uint id)
in
{
	assert(from < citiesNumber);
	assert(id < ridersNumber);
}
do
{
    uint[] halts;
    for (uint i = 0; i < citiesNumber; ++i)
        if (matrix[from][i].visits[id] == false)
            halts ~= i;
    return halts;
}

/** Fills matrix by given array **/
void fill(Curve[citiesNumber][citiesNumber] matrix,
	uint[citiesNumber][citiesNumber] array)
{
    for (uint i = 0; i < citiesNumber; ++i)
        for (uint j = 0; j < citiesNumber; ++j)
            matrix[i][j] = Curve(array[i][j]);
}

