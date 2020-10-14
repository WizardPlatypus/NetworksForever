import std.stdio;
import citystatus;


/** Number of cities. The capital is counted. */
immutable uint CITYNUMBER = 5;
/** Distances between cities. */
uint[CITYNUMBER][CITYNUMBER] MATRIX;

/** Randomly sets distances between cities. */
void setMATRIX()
{
    MATRIX = new uint[CITYNUMBER][CITYNUMBER];

    import std.random : uniform;

    for (uint i = 0; i < CITYNUMBER; ++i)
    {
        for (uint j = i; j < CITYNUMBER; ++j)
        {
            if (i == j)
            {
                MATRIX[j][i] = MATRIX[i][j] = 0;
            }
            else
            {
                MATRIX[j][i] = MATRIX[i][j] = uniform(1, 26);
            }
        }
    }
}

/***/
bool isAllvisited(CityStatus[] visits)
{
    foreach (visit; visits)
    {
        if (!visit)
            return false;
    }
    return true;
}

/** Moves the riders due to nearest arrive, and returns time taken to make it. */
uint move(ref uint time1, ref uint time2)
{
    immutable uint minTime = time1 < time2 ? time1 : time2;
    time1 -= minTime;
    time2 -= minTime;

    return minTime;
}
// move() test
unittest
{
    uint time1 = 3, time2 = 2;
    immutable uint time = move(time1, time2);
    assert(time == 2, "PROBLEM WITH MINTIME!");
    assert(time1 == 1 && time2 == 0, "PROBLEM WITH SUBTRACTION!");
}

/** Look at one way: moves riders on moveTime, and if threre are unvisited cities — looks for minTime to visit them. */
uint seeOneWay(uint target1, uint time1, uint target2, uint time2, CityStatus[] visits)
{
    immutable uint moveTime = move(time1, time2);

    uint minTime = uint.max;
    if (time1 == 0 && time2 == 0)
    {
        visits[target1] = CityStatus.Visited;
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            return moveTime;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                for (uint j = 0; j < CITYNUMBER; ++j)
                {
                    if (visits[j] == CityStatus.Unvisited)
                    {
                        immutable uint tempTime = seeOneWay(i,
                                MATRIX[target1][i], j, MATRIX[target2][j], visits.dup);
                        /*writefln("seeOneWay(%s, %s, %s, %s, %s);",
                            i, MATRIX[target1][i], j, MATRIX[target2][j], visits.dup);*/
                        // writefln("%d -> %d : %d", target1, i, MATRIX[target1][i]);
                        // writefln("%d -> %d : %d", target2, j, MATRIX[target2][j]);
                        if (tempTime < minTime)
                            minTime = tempTime;
                    }
                }
            }
    }
    else if (time1 == 0)
    {
        visits[target1] = CityStatus.Visited;
        if (isAllvisited(visits))
            return moveTime;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                immutable uint tempTime = seeOneWay(i, MATRIX[target1][i], target2, time2, visits.dup);
                if (tempTime < minTime)
                    minTime = tempTime;
            }
    }
    else if (time2 == 0)
    {
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            return moveTime;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                immutable uint tempTime = seeOneWay(target1, time1, i, MATRIX[target2][i], visits.dup);
                if (tempTime < minTime)
                    minTime = tempTime;
            }
    }

    return moveTime + minTime;
}

/** seeOneWay() tests: */
unittest
{
    MATRIX = [
        [0, 0, 0, 0, 3],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 4],
        [3, 0, 0, 4, 0]
    ];
    CityStatus[] visits = [ CityStatus.Visited, CityStatus.Visited, CityStatus.Visited,
        CityStatus.Visited, CityStatus.Unvisited ];
    uint time = seeOneWay(4, 3, 4, 4, visits);
    //writeln(time);
    assert(time == 3);
}
unittest
{
    MATRIX = [
        [0, 2, 4, 2, 1],
        [2, 0, 1, 4, 1],
        [4, 1, 0, 3, 1],
        [2, 4, 3, 0, 1],
        [1, 1, 1, 1, 0]
    ];
    CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
        CityStatus.Unvisited, CityStatus.Unvisited ];
    uint time = seeOneWay(0, 0, 0, 0, visits);
    //writeln(time);
    assert(time == 3);
}
unittest
{
    MATRIX = [
        [0, 2, 5, 5, 1],
        [2, 0, 3, 4, 2],
        [5, 3, 0, 1, 5],
        [5, 4, 1, 0, 4],
        [1, 2, 5, 4, 0]
    ];
    CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
        CityStatus.Unvisited, CityStatus.Unvisited ];
    uint time = seeOneWay(0, 0, 0, 0, visits);
    writeln(time);
    assert(time == 5);
}
unittest
{
    MATRIX = [
        [0, 1, 3, 5, 7],
        [1, 0, 1, 3, 5],
        [3, 1, 0, 1, 3],
        [5, 3, 1, 0, 1],
        [7, 5, 3, 1, 0]
    ];
    CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
        CityStatus.Unvisited, CityStatus.Unvisited ];
    uint time = seeOneWay(0, 0, 0, 0, visits);
    writeln(time);
    assert(time == 4);
}

void main()
{
    setMATRIX();
    CityStatus[] visits = new CityStatus[CITYNUMBER];
    visits[0] = CityStatus.Visited;
}
