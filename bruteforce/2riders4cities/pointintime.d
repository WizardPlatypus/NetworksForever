module pointintime;

import citystatus;

/** Store moments in life of riders. */
struct PointInTime
{
public:
    /** All time in following moments. */
    uint theTime;
    /** First target. */
    uint target1;
    /** Second target.  */
    uint target2;
    /** First time. */
    uint time1;
    /** Second time. */
    uint time2;
    /** Visit status of cities*/
    CityStatus[] visits;
    /** */
    PointInTime* nextPoint;
}

