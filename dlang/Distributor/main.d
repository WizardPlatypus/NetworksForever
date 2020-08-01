import std.stdio;
import std.conv : to;
import std.algorithm : reverse;

uint getMinPosition(uint riders, uint targets)
{
   uint p = 0;
   for(uint i = 1; i < riders; ++i)
   {
      p += (targets ^^ (riders - i - 1)) * i;
   }
   return p;
}

uint getMaxPosition(uint riders, uint targets)
{
   uint p = 0;
   for(uint i = 0; i < riders; ++i)
   {
      p += (targets ^^ (riders - i - 1)) * (targets - i - 1);
   }
   return p;
}

/**/
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

uint[] getWays(ref uint position, uint riders, uint targets)
{
   uint[] ways;
   ways.length = riders;
   // write(position, ": ");
   uint p = position++;

   for (uint i = 0; i < riders;)
   {
      ways[i] = p % targets;
      if (exist(ways[0 .. i], ways[i]))
      {
         // uint[] temp = ways[0 .. i + 1].dup;
         // reverse(temp);
         // write(temp, " : incorrect.\n", position, ": ");
         p = position++;
         i = 0;
      }
      else
      {
         p /= targets;
         ++i;
      }
   }
   reverse(ways);
   //write(ways, " : correct.\n");
   return ways;
}

void main()
{
   uint riders, targets;
   readf!" %s %s"(riders, targets);

   immutable(uint) minP = getMinPosition(riders, targets);
   immutable(uint) maxP = getMaxPosition(riders, targets);

   for (uint p = minP; p <= maxP;)
   {
      writeln(getWays(p, riders, targets));
   }
}