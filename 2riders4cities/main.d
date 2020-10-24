public import std.stdio;
public import citystatus;
public import pointintime;
public import matrix;
import tests;


/** Moves the riders due to nearest arrive, and returns time taken to make it. */
uint move(ref uint time1, ref uint time2)
{
    immutable uint minTime = time1 < time2 ? time1 : time2;
    time1 -= minTime;
    time2 -= minTime;

    return minTime;
}

/** Look at one way: moves riders on moveTime, and if threre are unvisited cities — looks for quickestWay to visit them. */
PointInTime* seeOneWay(uint target1, uint time1, uint target2, uint time2, CityStatus[] visits)
{
    PointInTime* basePoint = new PointInTime(target1, time1, target2, time2);
    (*basePoint).setTIME(move(time1, time2));

    PointInTime* quickestWay = new PointInTime(0, 0, 0, 0);
    (*quickestWay).setTIME(uint.max);

    if (time1 == 0 && time2 == 0)
    {
        visits[target1] = CityStatus.Visited;
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            (*quickestWay).setTIME(0);

        for (uint i = 0; i < matrix.CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                for (uint j = 0; j < matrix.CITYNUMBER; ++j)
                    if (visits[j] == CityStatus.Unvisited)
                    {
                        PointInTime* possibleWay = seeOneWay(i, MATRIX[target1][i],
                            j, MATRIX[target2][j], visits.dup);
                        if ((*possibleWay).getTIME < (*quickestWay).getTIME)
                        {
                            destroy(*quickestWay);
                            quickestWay = possibleWay;

                            // to stop destructor:
                            possibleWay = null;
                        }
                        else
                        {
                            destroy(*possibleWay);
                        }                            
                    }
            }
    }
    else if (time1 == 0)
    {
        visits[target1] = CityStatus.Visited;
        if (isAllvisited(visits))
            (*quickestWay).setTIME(0);

        for (uint i = 0; i < matrix.CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                PointInTime* possibleWay = seeOneWay(i, MATRIX[target1][i],
                    target2, time2, visits.dup);
                if ((*possibleWay).getTIME < (*quickestWay).getTIME)
                {
                    destroy(*quickestWay);
                    quickestWay = possibleWay;

                    // to stop destructor:
                    possibleWay = null;
                }
                else
                {
                    destroy(*possibleWay);
                }
            }
    }
    else if (time2 == 0)
    {
        visits[target2] = CityStatus.Visited;
        if (isAllvisited(visits))
            (*quickestWay).setTIME(0);

        for (uint i = 0; i < matrix.CITYNUMBER; ++i)
            if (visits[i] == CityStatus.Unvisited)
            {
                PointInTime* possibleWay =  seeOneWay(target1, time1, i, MATRIX[target2][i], visits.dup);
                if ((*possibleWay).getTIME < (*quickestWay).getTIME)
                {
                    destroy(*quickestWay);
                    quickestWay = possibleWay;

                    // to stop destructor:
                    possibleWay = null;
                }
                else
                {
                    destroy(*possibleWay);
                }
            }
    }

    (*basePoint).nextPoint = quickestWay;
    (*basePoint).incTIME(quickestWay.getTIME);
    
    // to stop destructor:
    quickestWay = null;

    return basePoint;
}

void main()
{
}
