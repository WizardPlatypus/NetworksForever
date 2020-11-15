module algorithm;

private:

import consts;
import moment;
import distributor;
import curves;
import riders;

import std.stdio;

/** New step for riders **/
void step(Moment then, Curve[citiesNumber][citiesNumber] matrix,
    Rider[ridersNumber] riders, bool[citiesNumber] visits)
{
    Moment now = new Moment(riders.getHalts(), riders.move());

    auto d = Distributor();
    uint[] free;
    foreach (i, rider; riders)
        if (rider.time == 0)
        {
            visits[rider.halt] = true;
            matrix[then.halts[i]][now.halts[i]].visits[i] = true;
            auto possibilities = matrix.possibilities(rider.halt, i);
            if (possibilities.length != 0)
            {
                d.add(possibilities);
                free ~= i;
            }
        }

    if (visits.allDone())
    {
        return;
    }
    else if (free.length == 0)
    {
        return;
    }

    for (uint i = 0; i < d.multiplicity; ++i)
    {
        auto combination = d.pop();
        for (uint j = 0; j < combination.length; ++j)
        {
            auto id = free[j];
            auto oldHalt = riders[id].halt;
            auto newHalt = combination[j];
            riders[id] = Rider(newHalt, matrix[oldHalt][newHalt].price);
        }
        step(now, matrix, riders, visits);
    }

    return;
}

public:

/** Starts algorithm **/
void start(uint[citiesNumber][citiesNumber] array, uint origin)
in { assert(origin < citiesNumber); }
do
{
    Curve[citiesNumber][citiesNumber] matrix;
    matrix.fill(array);
    
    Rider[ridersNumber] riders;
    foreach (ref rider; riders)
        rider = Rider(origin, 0);

    bool[citiesNumber] visits;
    visits[origin] = true;

    step(null, matrix, riders, visits);
}
