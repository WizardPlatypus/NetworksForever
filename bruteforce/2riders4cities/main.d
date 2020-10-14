import std.stdio;
import citystatus;
import pointintime;

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
PointInTime seeOneWay(uint target1, uint time1, uint target2, uint time2, CityStatus[] visits)
{
    PointInTime basePoint = PointInTime();
    basePoint.target1 = target1;
    basePoint.target2 = target2;
    basePoint.time1 = time1;
    basePoint.time2 = time2;
    basePoint.visits = visits.dup;

    immutable uint moveTime = move(time1, time2);

    PointInTime quickestWay = PointInTime();
    quickestWay.theTime = uint.max;

    uint minTime = uint.max;
    if (time1 == 0 && time2 == 0)
    {
        visits[target1] = CityStatus.Visited;
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            quickestWay.theTime = 0;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                for (uint j = 0; j < CITYNUMBER; ++j)
                    if (visits[j] == CityStatus.Unvisited)
                    {
                        auto possibleWay = seeOneWay(i,
                                MATRIX[target1][i], j, MATRIX[target2][j], visits.dup);
                        if (possibleWay.theTime < quickestWay.theTime)
                            quickestWay = possibleWay;
                    }
            }
    }
    else if (time1 == 0)
    {
        visits[target1] = CityStatus.Visited;
        if (isAllvisited(visits))
            quickestWay.theTime = 0;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                auto possibleWay = seeOneWay(i, MATRIX[target1][i], target2, time2, visits.dup);
                if (possibleWay.theTime < quickestWay.theTime)
                            quickestWay = possibleWay;
            }
    }
    else if (time2 == 0)
    {
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            quickestWay.theTime = 0;

        for (uint i = 0; i < CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                auto possibleWay =  seeOneWay(target1, time1, i, MATRIX[target2][i], visits.dup);
                if (possibleWay.theTime < quickestWay.theTime)
                            quickestWay = possibleWay;
            }
    }
    basePoint.nextPoint = &quickestWay;
    basePoint.theTime = moveTime + quickestWay.theTime;
    return basePoint;
}

string show(PointInTime point)
{
    import std.string : format;
    string answer = "";
    uint indent = 0;
    do
    {
        for (uint i = 0; i < indent; ++i)
            answer ~= "   ";
        answer ~= format("%d:%d, %d:%d, %s;\n", point.target1, point.time1, point.target2, point.time2, point.visits);
        point = *point.nextPoint;
        ++indent;
    } while (point.nextPoint != null);
    return answer;
}

//seeOneWay() tests:
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
    PointInTime time = seeOneWay(4, 3, 4, 4, visits);
    writeln(*time.nextPoint);
    assert(time.theTime == 3);
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
    PointInTime time = seeOneWay(0, 0, 0, 0, visits);
    writeln(*time.nextPoint);
    assert(time.theTime == 3);
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
    PointInTime time = seeOneWay(0, 0, 0, 0, visits);
    writeln(*time.nextPoint);
    assert(time.theTime == 5);
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
    PointInTime time = seeOneWay(0, 0, 0, 0, visits);
    writeln(*time.nextPoint);
    assert(time.theTime == 4);
}

void main()
{
}
