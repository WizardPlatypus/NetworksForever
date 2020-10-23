module tests;
import main;

public
{
    //seeOneWay() tests:
    unittest
    {
        matrix.MATRIX = [
            [0, 0, 0, 0, 3],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 4],
            [3, 0, 0, 4, 0]
        ];
        CityStatus[] visits = [ CityStatus.Visited, CityStatus.Visited, CityStatus.Visited,
            CityStatus.Visited, CityStatus.Unvisited ];
        PointInTime* time = seeOneWay(4, 3, 4, 4, visits);
        writeln(infoSequence(time));
        writeln();
        assert((*time).getTIME == 3);
    }

    unittest
    {
        matrix.MATRIX = [
            [0, 2, 4, 2, 1],
            [2, 0, 1, 4, 1],
            [4, 1, 0, 3, 1],
            [2, 4, 3, 0, 1],
            [1, 1, 1, 1, 0]
        ];
        CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
            CityStatus.Unvisited, CityStatus.Unvisited ];
        PointInTime* time = seeOneWay(0, 0, 0, 0, visits);
        writeln(infoSequence(time));
        writeln();
        assert((*time).getTIME == 3);
    }
    unittest
    {
        matrix.MATRIX = [
            [0, 2, 5, 5, 1],
            [2, 0, 3, 4, 2],
            [5, 3, 0, 1, 5],
            [5, 4, 1, 0, 4],
            [1, 2, 5, 4, 0]
        ];
        CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
            CityStatus.Unvisited, CityStatus.Unvisited ];
        PointInTime* time = seeOneWay(0, 0, 0, 0, visits);
        writeln(infoSequence(time));
        writeln();
        assert((*time).getTIME == 5);
    }
    unittest
    {
        matrix.MATRIX = [
            [0, 1, 3, 5, 7],
            [1, 0, 1, 3, 5],
            [3, 1, 0, 1, 3],
            [5, 3, 1, 0, 1],
            [7, 5, 3, 1, 0]
        ];
        CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
            CityStatus.Unvisited, CityStatus.Unvisited ];
        PointInTime* time = seeOneWay(0, 0, 0, 0, visits);
        writeln(infoSequence(time));
        writeln();
        assert((*time).getTIME == 4);
    }
    unittest
    {
        matrix.MATRIX = [
            [0, 22, 5, 8, 41],
            [22, 0, 12, 20, 47],
            [5, 12, 0, 18, 23],
            [8, 20, 18, 0, 28],
            [41, 47, 23, 28, 0]
        ];
        CityStatus[] visits = [ CityStatus.Visited, CityStatus.Unvisited, CityStatus.Unvisited,
            CityStatus.Unvisited, CityStatus.Unvisited ];
        PointInTime* time = seeOneWay(0, 0, 0, 0, visits);
        writeln(infoSequence(time));
        writeln();
        assert((*time).getTIME == 10);
    }

    // move() test
    unittest
    {
        uint time1 = 3, time2 = 2;
        immutable uint time = move(time1, time2);
        assert(time == 2, "PROBLEM WITH MINTIME!");
        assert(time1 == 1 && time2 == 0, "PROBLEM WITH SUBTRACTION!");
    }
}
