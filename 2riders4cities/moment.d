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

    /** Constructor **/
    this(uint[ridersNumber] halts, uint time)
    {
        this.halts = halts.dup;
        this.passed = time;
        this.prev = null;
        this.next = [];
    }

    /** connects child (next) to the parent (this) **/
    void connect(Moment next)
    {
        this.next ~= next;
        if (next !is null)
            next.prev = this;
    }
}

unittest
{
    uint[ridersNumber] halts;
    // Moment : PASSED 
    {
        for (uint i = 0; i < ridersNumber; ++i)
            halts[i] = i;
        Moment now = new Moment(halts, 0);
        assert(now.halts[0] == 0);
        assert(now.halts[1] == 1);
        assert(now.passed == 0);
    }
    // connect general : PASSED
    {
        halts[] = 2;
        Moment now = new Moment(halts, 1);

        halts[] = 1;
        Moment then = new Moment(halts, 8);

        then.connect(now);
        assert(then.next[0] == now);
        assert(now.prev == then);
    }
}
