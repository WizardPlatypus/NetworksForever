void main()
{
    import std.stdio;

    uint[3] ar1;
    uint[3] ar2;
    ar2[0] = 0;
    ar2[1] = 1;
    ar2[2] = 2;
    ar1 = ar2;
    ar2[] = 3;
    writef("%s:%s\n", ar1, ar2);

    write("You should see this message\n");
}



uint[][][] array;

void set(ref uint[][][] array, uint d1, uint d2, uint d3)
{
    array.length = d1;
    for (uint i = 0; i < d1; ++i)
    {
        array[i].length = d2;
        for (uint j = 0; j < d2; ++j)
        {
            array[i][j].length = d3;
        }
    }
}

void print(uint[][][] array)
{
    f; array)
    {
        
    }
}