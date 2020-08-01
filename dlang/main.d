import std.stdio;

/**Borders, between which the cities could be placed:*/
/**minimal x*/
enum MINX = 0;
/**maximal x*/
enum MAXX = 100;
/**minimal y*/
enum MINY = 0;
/**maximal y*/
enum MAXY = 100;

enum SIZE = 5;

/** Contains coordinates of city*/
struct Point
{
   int x;
   int y;
}
/** Group some fields from which depends behavior of one separete rider*/

struct Rider
{
   /** tar — target — where we are going now */
   Point tar;
   /** last — last visited point*/
   Point last;
   /** prev — previous — where we were */
   Point[] prev;
   /** tToAr — Time To Arrive — time that we need to come to target point*/
   int tToAr; 
}
/**
Calculate distance between two points.
*/
uint distanceFromTo(Point _From, Point _To)
{
   import std.conv : to;
   import std.math : sqrt;
   import std.math : floor;

   return to!uint(sqrt(to!float((_From.x - _To.x) ^^ 2 + (_From.y - _To.y) ^^ 2)));
   // immutable uint a = (from.x - _To.x) ^^ 2;
   // immutable uint b = (from.y - _To.y) ^^ 2;
   // immutable uint sum = a + b;
   // immutable float sq = sqrt(to!float(sum));

   // return to!int(floor(sq));
}

/**  */
uint findMinTimeToArrive(const Rider[] riders)
{
   uint minTime = uint.max;
   for (int i = 0; i < riders.length; ++i)
   {
      if (riders[i].tToAr < minTime)
      {
         minTime = riders[i].tToAr;
      }
   }
   return minTime;
}

/**
Remove element from array.
*/
void remove(Point element, ref Point[] array)
{
   immutable uint index = indexOf(array, element);
   if (index != -1)
   {
      Point[] temp;
      temp.length = array.length - 1;
      for (int i = 0; i < index; ++i)
      {
         temp[i] = array[i];
      }
      for (int i = index + 1; i < array.length; ++i)
      {
         temp[i - 1] = array[i];
      }
      array = temp;
   }
   else if (index == -1)
   {
      stderr.writeln("Problem: point ", element, " does not exist in array: ", array);
   }
}

/**
Moves all riders on minTime, checks, who comes to his target, than deletes visited cities from array
and returns how many riders are free.
*/
uint comeToNearestPoints(ref Rider[] riders, ref Point[] cities, immutable(double) minTime)
{
   uint count = 0;
   for (int i = 0; i < riders.length; ++i)
   {
      riders[i].tToAr -= minTime;
      if (riders[i].tToAr == 0)
      {
         riders[i].prev ~= riders[i].tar;
         riders[i].last = riders[i].tar;
         remove(riders[i].tar, cities);
         count++;
      }
   }
   return count;
}

/**
Returns minimal position that can make k-combination of set n
without any repetitions.
*/
uint getMinPosition(uint riders, uint targets)
{
   uint p = 0;
   for(uint i = 1; i < riders; ++i)
   {
      p += (targets ^^ (riders - i - 1)) * i;
   }
   return p;
}

/**
Returns maximal position that can make k-combination of set n
without any repetitions.
*/
uint getMaxPosition(uint riders, uint targets)
{
   uint p = 0;
   for(uint i = 0; i < riders; ++i)
   {
      p += (targets ^^ (riders - i - 1)) * (targets - i - 1);
   }
   return p;
}

/**
Anwers to one question: does array has in itself sought element?
*/
bool exist(uint[] array, uint element)
{
   for (uint i = 0; i < array.length; ++i)
   {
      if (element == array[i])
      {
         return true;
      }
   }
   return false;
}

/**
Returns index of sought element in array.
*/
uint indexOf(Point[] array, Point element)
{
   for (int i = 0; i < array.length; ++i)
   {
      if(array[i] == element)
      {
         return i;
      }
   }
   return -1;
}

/**
That function looking for next position that have no number repetitions
and returns complete array, which contanes sought combination.
*/
uint[] getWay(ref uint position, uint riders, uint targets)
{
   uint[] way;
   way.length = riders;
   uint p = position++;

   for (uint i = 0; i < riders;)
   {
      way[i] = p % targets;
      if (exist(way[0 .. i], way[i]))
      {
         p = position++;
         i = 0;
      }
      else
      {
         p /= targets;
         ++i;
      }
   }
   import std.algorithm : reverse;
   reverse(way);
   return way;
}

/** 
Returns all posible k-combinations of set n.
There k is ridersN, and n is targetsN.
*/
uint[][] getAllPosibleWaysForFreeRiders(uint ridersN, uint targetsN, ref uint count)
{
   count = 0;
   uint[][] ways = [];
   immutable(uint) minP = getMinPosition(ridersN, targetsN);
   immutable(uint) maxP = getMaxPosition(ridersN, targetsN);

   for (uint p = minP; p <= maxP;)
   {
      //all modifications of p happens in function getWay(...);
      ways ~= getWay(p, ridersN, targetsN);
      ++count;
   }

   return ways;
}

/**Makes an indent*/
void indent(uint level)
{
   for (int i = 0; i < level; ++i)
   {
      for (int j = 0; j < SIZE; ++j)
      {
         write(' ');
      }
   }
}

/**Prints formated information about riders positions*/
void printInfo(uint level, Rider[] riders, uint absTime)
{
   indent(level);
   writef("Absolute Time: %5s\n", absTime);
   for (int i = 0; i < riders.length; ++i)
   {
      indent(level);
      writef("#%2s-%2s,%2s>%2s,%2s:%4s\n", i + 1,
         riders[i].last.x, riders[i].last.y, riders[i].tar.x, riders[i].tar.y, riders[i].tToAr);
   }
}

/**Prints special info when the solution branch ends*/
void printEnd(Rider[] riders, uint level, uint absTime)
{
   indent(level);
   writef("END!!: Absolute Time: %s", absTime);
   foreach (i, rider; riders)
   {
      indent(level);
      writef("#%2s:\n", i);
      foreach (point; rider.prev)
      {
         indent(level);
         writef("[X: %2s; Y: %2s]", point.x, point.y);
      }
   }
}

/**
Recursive solution, functional
*/
void recSolution(Rider[] riders, Point[] cities, uint level, uint absTime)
{
   if (cities.length == 0)
   {
      printEnd(riders, level, absTime);
      return;
   }
   printInfo(level++, riders, absTime);
   immutable double minTime =
      findMinTimeToArrive(riders);
   absTime += minTime;
   immutable uint freeCount = 
      comeToNearestPoints(riders, cities, minTime);
   uint count;
   uint[][] ways =
      getAllPosibleWaysForFreeRiders(freeCount, cities.length, count);

   for (int i = 0; i < count; ++i)
   {
      uint r = 0;
      for (int j = 0; j < riders.length; ++j)
      {
         if (riders[j].tToAr == 0)
         {
            riders[j].tar = cities[ways[i][r++]];
            riders[j].tToAr = distanceFromTo(riders[j].last, riders[j].tar);
         }
      }
      recSolution(riders, cities, level, absTime);
   }
}

void main()
{
   import std.random : uniform;

   uint ridersN, targetsN;
   write("Enter number of riders and cities separeted by space: ");
   readf!" %s %s"(ridersN, targetsN);

   Point[] cities;
   cities.length = targetsN;
   Point capital = Point(uniform(MINX, MAXX), uniform(MINY, MAXY));
   writef("Capital: [X: %2s; Y: %2s]\n", capital.x, capital.y);
   write("Cities' coordinates:\n");
   for (int i = 0; i < targetsN; ++i)
   {
      cities[i] = Point(uniform(MINX, MAXX), uniform(MINY, MAXY));
      writef("\t#%2s: [X: %2s; Y: %2s].\n", i + 1, cities[i].x, cities[i].y);
   }

   Rider[] riders;
   riders.length = ridersN;
   uint count = 0;
   uint[][] ways = getAllPosibleWaysForFreeRiders(ridersN, targetsN, count);
   writeln("different ways: ", count);
   for (int i = 0; i < count; ++i)
   {
      uint r = 0;
      for (int j = 0; j < ridersN; ++j)
      {
         Point target = cities[ways[i][r++]];
         riders[j] = Rider
         (
            target,
            capital,
            [capital],
            distanceFromTo(capital, target)
         );
      }
      recSolution(riders, cities, 0, 0);
   }
}