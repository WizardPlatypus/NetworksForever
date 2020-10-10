/*
Problem to solve:
Which strategy 2 riders should follow to visit 4 citites in minimal time?
All of them begin their way from one special city. Let's call it capital

I think, there are two important questions:
1. What's a minimal time.
2. Which way gets minimal time?

Let's at first answer the first question, and then try to make solution a little bit bigger.
*/

/** Number of cities. The capital is counted. */
immutable CITYNUMBER = 5;
/** Distances between cities. */
uint[CITYNUMBER][CITYNUMBER] MATRIX;

/**
Enum represents visit status.
Works CORRECTLY.
*/
enum VISIT_STATUS : bool
{
    VISITED = true,
    UNVISITED = false
}
// VISIT_STATUS test
unittest
{
    import std.stdio : writeln;

    VISIT_STATUS status = VISIT_STATUS.VISITED;
    status = VISIT_STATUS.UNVISITED;
    writeln(status);
}

/**
Randomly sets distances between cities.
Works CORRECTLY.
*/
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
//setMatrix() test
unittest
{
    /** Show Matrix: */
    void showMATRIX()
    {
        import std.stdio : writef;

        for (uint i = 0; i < CITYNUMBER; ++i)
        {
            for (uint j = 0; j < CITYNUMBER; ++j)
            {
                writef("%2s ", MATRIX[i][j]);
            }
            writef("\n");
        }
    }

    setMATRIX();
    showMATRIX();
}

/**
Is all cities visited? It'll return the answer.
Works CORRECTLY.
*/
bool isAllvisited(VISIT_STATUS[] visits)
{
    foreach (visit; visits)
    {
        if (!visit)
            return false;
    }
    return true;
}
// isAllVisited() test
unittest
{
    import std.stdio : writeln;

    VISIT_STATUS[] visits = [
        VISIT_STATUS.VISITED, VISIT_STATUS.VISITED, VISIT_STATUS.VISITED
    ];
    assert(isAllvisited([
                VISIT_STATUS.VISITED, VISIT_STATUS.VISITED, VISIT_STATUS.VISITED
            ]), "Ooops, IT SHOULD WORK!");
    assert(!isAllvisited([
                VISIT_STATUS.VISITED, VISIT_STATUS.VISITED, VISIT_STATUS.UNVISITED
            ]), "Ooops, IT SHOULD WORK!");
    writeln(isAllvisited(visits));
}

/**
Counts how many cities are
*/

/**
Moves the riders due to nearest arrive, and returns time to make it.
Works CORRECTLY.
*/
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

/**/
uint seeOneWay(uint target1, uint time1, uint target2, uint time2, VISIT_STATUS[] visits)
{
    if (isAllvisited(visits))
    {
        return 0;
    }

    immutable uint moveTime = move(time1, time2);
    uint minTime = uint.max;

    if (time1 == 0 && time2 == 0)
    {
        visits[target1] = VISIT_STATUS.VISITED;
        visits[target2] = VISIT_STATUS.UNVISITED;

        for (uint i = 0; i < CITYNUMBER; ++i)
        {
            if (visits[i] == VISIT_STATUS.UNVISITED)
            {
                for (uint j = 0; j < CITYNUMBER; ++j)
                {
                    if (i == j)
                        continue;
                    if (visits[j] == VISIT_STATUS.UNVISITED)
                    {
                        immutable uint tempTime = seeOneWay(i,
                                MATRIX[target1][i], j, MATRIX[target2][j], visits);
                        if (tempTime < minTime)
                            minTime = tempTime;
                    }
                }
            }
        }
    }
    else if (time1 == 0)
    {
        visits[target1] = VISIT_STATUS.VISITED;

        for (uint i = 0; i < CITYNUMBER; ++i)
        {
            if (visits[i] == VISIT_STATUS.UNVISITED)
            {
                immutable uint tempTime = seeOneWay(i, MATRIX[target1][i], target2, time2, visits);
                if (tempTime < minTime)
                    minTime = tempTime;
            }
        }
    }
    else if (time2 == 0)
    {
        visits[target2] = VISIT_STATUS.VISITED;

        for (uint i = 0; i < CITYNUMBER; ++i)
        {
            immutable uint tempTime = seeOneWay(target1, time1, i, MATRIX[target2], visits);
            if (tempTime < minTime)
                minTime = tempTIme;
        }
    }

    return moveTime + minTime;
}

void main()
{
    setMATRIX();
    VISIT_STATUS visits = new VISIT_STATUS[CITYNUMBER];
    visits[0] = VISIT_STATUS.VISITED;
}
