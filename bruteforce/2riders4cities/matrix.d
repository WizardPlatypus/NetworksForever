module matrix;

public
{
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


    /** Returns string which contains info about MATRIX. */
    string infoMatrix()
    {
        string answer = "";
        for (uint i = 0; i < CITYNUMBER; ++i)
        {
            for (uint j = 0; j < CITYNUMBER; ++j)
            {
                answer ~= MATRIX[i][j];
                if (j != CITYNUMBER - 1)
                    answer ~= " ";
            }
            if (i != CITYNUMBER - 1)
                answer ~= "\n";
        }
        return answer;
    }
}
