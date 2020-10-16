module citystatus;

public
{
    /** Enum represents visit status. */
    enum CityStatus : bool
    {
        Unvisited = false,
        Visited = true
    }

    /** Are all visited ? */
    bool isAllvisited(CityStatus[] visits)
    {
        foreach (visit; visits)
        {
            if (!visit)
                return false;
        }
        return true;
    }
}
