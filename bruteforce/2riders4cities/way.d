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

        /** Next point in time: **/
        PointInTime* next;
        /** Previous point in time: **/
        PointInTime* prev;

        /**
        Constructs new point in time using targets of 2 riders.
        **/
        this(uint target1, uint target2, uint time1 = 0, uint time2 = 0,
            PointInTime* next = null, PointInTime* prev = null)
        {
            this.target1 = target1;
            this.target2 = target2;
            this.time1 = time1;
            this.time2 = time2;
            this.next = next;
            this.prev = prev;
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
    PointInTime* bestWay;
    
    /**
    Constructor, which starts searching of best way.
    params: origin — where riders start their movings.
    params: matrix — adjency matrix.
    **/
    this(uint origin, uint[][] matrix)
    {
        this.matrix = matrix;

        bool[cityNumber] visits = false;
        visits[origin] = true;
        
        PointInTime* begin = new PointInTime(origin, origin);

        for (uint i = 0; i < cityNumber; ++i)
        {
            for (uint j = 0; j < cityNumber; ++j)
            {
                if (matrix[i][j] == 0)
                    continue;
                search(i, j, matrix[origin][i], matrix[origin][j],
                    matrix, visits, begin, 0);
            }
        }
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
        it's/their target. Returns that time.
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
    Search for best way.
    **/
    void search(uint target1, uint target2, uint time1, uint time2,
        uint[cityNumber][cityNumber] matrix, bool[cityNumber] visits,
        PointInTime* then, uint globalTime)
    {
        PointInTime* now = new PointInTime(target1, target2, time1,
            time2, null, then);
        then.next = now;
        globalTime += move(time1, time2);

        if (time1 == 0 && time2 == 0)
        // in case both riders have arrived to their targets.
        {
            matrix[then.target1][now.target1] = 0;
            matrix[then.target2][now.target2] = 0;
            visits[now.target1] = true;
            visits[now.target2] = true;

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
                        visits.dup, now, globalTime);
                }
            }
        }
        else
        // in case only one rider arrived to his target. 
        {
            if (time1 == 0)
            {
                matrix[then.target1][now.target1] = 0;
                visits[now.target1] = true;

                for (uint i = 0; i < cityNumber; ++i)
                {
                    if (matrix[now.target1][i] == 0)
                        continue;
                    search(i, target2, matrix[now.target1][i], time2,
                        matrix.dup, visits.dup, now, globalTime);
                }
            }
            else if (time2 == 0)
            {
                matrix[then.target2][now.target2] = 0;
                visits[now.target2] = true;

                for (uint i = 0; i < cityNumber; ++i)
                {
                    if (matrix[now.target2][i] == 0)
                        continue;
                    search(target1, i, time1, matrix[now.target2][i],
                        matrix.dup, visits.dup, now, globalTime);
                }
            }
        }

    }
}