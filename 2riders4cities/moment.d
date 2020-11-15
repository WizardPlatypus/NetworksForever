module moment;

import consts : ridersNumber;

public:
/** Moment in time **/
class Moment
{
public:
    /** Riders' halts at this moment **/
    uint[ridersNumber] halts;
    /** How much time has passed from the begining **/
    uint passed;

    /** Previous moment **/
    Moment prev;
    /** Possible next moment **/
    Moment[] next;

    this(uint[ridersNumber] halts, uint time)
    {
        this.halts = halts.dup;
        this.passed = time;
        this.prev = null;
        this.next = [];
    }

    void connect(Moment next)
    {
        this.next ~= next;
        next != null ? next.prev = this;
    }
}

unittest
{
    // Moment : 
    {
        uint[ridersNumber] halts;
        for (uint i = 0; i < ridersNumber; ++i)
            halts[i] = i;
        Moment now = new Moment(halts, 0);
        assert(now.halts[0] == 0);
        assert(now.halts[1] == 1);
        assert(now.time == 0);
    }
    // connect general : 
    {
        uint[ridersNumber] halts;

        halts[] = 2;
        now = new Moment(halts, 1);

        halts[] = 1;
        then = new Moment(halts, 8);

        then.connect(now);
        assert(now.prev == then);
        assert(then.next[0] == now);
    }
}
