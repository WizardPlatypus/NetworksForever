module way;
/**
This class finds best way to visit all nodes of graph in minimal time.
**/
class Way
{
    /**
    Contains all needed information about special moment in time and
        reference to next moment and prev moments, if they exist.
    **/
    struct PointInTime
    {
        /** First rider's target index: **/
        uint target1;
        /** Second rider's target index: **/
        uint target2;
        /** First rider's time to arrive in target node: **/
        uint time1;
        /** Second rider's time to arrive in target node: **/
        uint time2;
        
        /**
        No need to add globalTime as part of PointInTime structure.
        In the end i will set tail's uint fields to the value of
        globalTime — and compare those fields with fields of bestWays.
        **/

        /** Next point in time: **/
        PointInTime*[] next;
        /** Previous point in time: **/
        PointInTime* prev;

        /**
        Constructs new point in time using targets of 2 riders.
        **/
        this(uint target1, uint target2, uint time1 = 0, uint time2 = 0,
            PointInTime*[] next = null, PointInTime* prev = null)
        {
            this.target1 = target1;
            this.target2 = target2;
            this.time1 = time1;
            this.time2 = time2;
            this.next = next;
            this.prev = prev;
        }
        /**
        Destructor: destroys every child node, and considers that
            parent is safe.
        **/
        ~this()
        {
            for (uint i = 0; i < next.length; ++i)
            {
                destroy(*next);
            }
            next = [];

            if (prev == null)
                return;
            uint index = 0;
            for (; index < (*prev).next; ++index)
                if ((*prev).next[index] == this)
                    break;
            (*prev).next = (*prev).next[0 .. index] ~
                (*prev).next[index + 1 .. $];
        }
    }

    /**
    Number of nodes(cities):
    (Capital city is counted)
    **/
    enum cityNumber = 5;

    /**
    Adjacency matrix.
    Contains information about curves in graph.
    matrix[i][j] — curve which begins in node i and ends in node j.
    matrix[i][j] = {positive number — length of curve; 0 — if curve
        does not exist}.
    **/
    uint[cityNumber][cityNumber] matrix;

    /**
    First node of linked list of points in time, which represents
        best way to visit all nodes in minimal time.
    **/
    PointInTime*[] bestWays;
    
    /**
    Constructor, which starts searching of best way.
    params: origin — where riders start their movings.
    params: matrix — adjency matrix.
    **/
    this(uint origin, uint[][] matrix)
    {
        this.matrix = matrix;
        this.bestWays = [];

        bool[cityNumber] visits = false;
        visits[origin] = true;
        
        PointInTime* now = new PointInTime(origin, origin);

        for (uint i = 0; i < cityNumber; ++i)
        {
            for (uint j = 0; j < cityNumber; ++j)
            {
                if (matrix[i][j] == 0)
                    continue;
                /+ {object}.dup — property to create a copy of an {object} +/
                search(i, j, matrix[origin][i], matrix[origin][j],
                    matrix.dup, visits.dup, now, 0);
            }
        }

        // to do not destroy object on which 'now' has reference.
        now = null;
    }
    /**
    Constructor, which starts searching of best way.
    params: origin — where riders start their movings.
    **/
    this(uint origin)
    {
        this.setMatrix();
        this(origin, this.matrix);
    }

    /**
    Sets adjency matrix.
    **/
    void setMatrix()
    {
        import std.random : uniform;
        for (uint i = 0; i < cityNumber; ++i)
        {
            for (uint j = i; j < cityNumber; ++j)
            {
                if (i == j)
                    matrix[i][j] = 0;
                matrix[i][j] = matrix[j][i] = uniform(1, 11);
            }
        }
    }
    /**
    Moves riders on time, needed to one or both of them to arrive to
        its/their target/s. Returns that time.
    **/
    uint move(ref uint time1, ref uint time2)
    {
        auto minTime = time1 < time2 ? time1 : time2;
        time1 -= minTime;
        time2 -= minTime;
        return minTime;
    }
    /**
    Answers wether all nodes are visited.
    **/
    bool areAllVisited(bool[cityNumber] visits)
    {
        foreach (visit; visits)
            if (!visit)
                return false;
        return true;
    }

    /**
    Looks wether there are ways from specified node.
    **/
    bool weCanGoFurth(const uint from, const uint[cityNumber][cityNumber] matrix)
    {
        uint count = 0;
        for (uint i = 0; i < cityNumber; ++i)
            if (matrix[from][i] != 0)
                ++count;
        if (count == 0)
            return false;
        else
            return true;
    }
    /**
    Search for best way.
    **/
    void search(uint target1, uint target2, uint time1, uint time2,
        uint[cityNumber][cityNumber] matrix, bool[cityNumber] visits,
        PointInTime* then, uint globalTime)
    {
        PointInTime* now = new PointInTime(target1, target2, time1,
            time2, null, then);
        then.next ~= now;
        globalTime += move(time1, time2);

        if (time1 == 0 && time2 == 0)
        // in case both riders have arrived to their targets.
        {
            matrix[then.target1][now.target1] = 0;
            matrix[then.target2][now.target2] = 0;
            visits[now.target1] = true;
            visits[now.target2] = true;

            if (areAllVisited(visits)) // in case when all nodes are visited
            {
                PointInTime* end = new PointInTime(globalTime, globalTime,
                    globalTime, globalTime, null, now);
                (*now).next ~= end;
                if (globalTime < bestWays[0].time1)
                    bestWays = [end];
                else if (globalTime == bestWays[0].time1)
                    bestWays ~= end;
                end = null;

                return;
            }
            // true wether first rider can go anywhere
            immutable bool first = weCanGoFurth(now.target1, matrix);
            // true wether second rider can go anywhere
            immutable bool second = weCanGoFurth(now.target2, matrix);

            if (first && second) //if both can go somewhere
            {
                for (uint i = 0; i < cityNumber; ++i)
                {
                    if (matrix[now.target1][i] == 0)
                        continue;
                    for (uint j = 0; j < cityNumber; ++j)
                    {
                        if (matrix[now.target2][j] == 0)
                            continue;
                        search(i, j, matrix[now.target1][i],
                            matrix[now.target2][j], matrix.dup,
                            visits.dup, *now, globalTime);
                    }
                }
            }
            else if (first) // if only first can go somewhere
            {
                for (uint i = 0; i < cityNumber; ++i)
                {
                    if (matrix[now.target1][i] == 0)
                        continue;
                    search(i, target2, matrix[now.target1][i], time2,
                        matrix.dup, visits.dup);
                }
            }
            else if (second) // if only first can go somewhere
            {
                for (uint i = 0; i < cityNumber; ++i)
                {
                    if (matrix[now.target2][i] == 0)
                        continue;
                    search(target1, i, time1, matrix[target2][i],
                        matrix.dup, visits.dup);
                }
            }
            else // if no one can go anywhere
            {
                destroy(*now);
                return;
            }
        }
        else
        // in case only one rider arrived to his target. 
        {
            if (time1 == 0)
            {
                matrix[then.target1][now.target1] = 0;
                visits[now.target1] = true;

                if (weCanGoFurth(target1, matrix))
                    for (uint i = 0; i < cityNumber; ++i)
                    {
                        if (matrix[now.target1][i] == 0)
                            continue;
                        search(i, target2, matrix[now.target1][i], time2,
                            matrix.dup, visits.dup, *now, globalTime);
                    }
            }
            else if (time2 == 0)
            {
                matrix[then.target2][now.target2] = 0;
                visits[now.target2] = true;

                if (weCanGoFurth(target1, matrix))
                    for (uint i = 0; i < cityNumber; ++i)
                    {
                        if (matrix[now.target2][i] == 0)
                            continue;
                        search(target1, i, time1, matrix[now.target2][i],
                            matrix.dup, visits.dup, *now, globalTime);
                    }
            }
        }

        // to do not destroy objects to which 'then' and 'now' have reference.
        then = null;
        now = null;
    }
}