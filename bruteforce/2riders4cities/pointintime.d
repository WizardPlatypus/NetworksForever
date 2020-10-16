module pointintime;

import citystatus;

public
{
    /** Store moments in life of riders. */
    struct PointInTime
    {
    private:
        /** Time till The End. */
        uint TIME;
    public:
        /** First target. */
        uint target1;
        /** Second target.  */
        uint target2;
        /** First time. */
        uint time1;
        /** Second time. */
        uint time2;
        // /** Visit status of cities*/
        // CityStatus[] visits;
        /** Next point: */
        PointInTime * nextPoint;

        /** Specifies tartet1 and time1, target2 and time2. */
        this(uint tar1, uint tim1, uint tar2, uint tim2)
        {
            target1 = tar1;
            time1 = tim1;
            target2 = tar2;
            time2 = tim2;
        }

        ~this()
        {
            if (nextPoint != null)
                destroy(*nextPoint);
            nextPoint = null;
        }

        /** Shows info about this PointInTime. */
        string toString() const
        {
            import std.format : format;
            return format("%d:%d; %d:%d.", target1, time1, target2, time2);
        }

        /** Sets TIME. */ 
        void setTIME(uint newTime)
        {
            TIME = newTime;
        }

        /** Increments TIME by inc. */
        void incTIME(uint inc)
        {
            TIME += inc;
        }

        /** Gets TIME. */
        uint getTIME()
        {
            return TIME;
        }
    }

    /** Returns info about sequence of points related to given. */
    string infoSequence(PointInTime* point)
    {
        string answer = "";
        while (point != null)
        {
            answer ~= (*point).toString ~ "\n";
            point = (*point).nextPoint;
        }
        return answer;
    }
}