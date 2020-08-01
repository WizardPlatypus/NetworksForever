import std.stdio;



void main()
{
   import std.format : format;
   immutable(string) outPut = format("#%2s-%2s,%2s>%2s,%2s:%4s", 0, 0, 0, 0, 0 ,0);
   immutable(uint) size = outPut.length;
   writeln(size, ':', outPut);
}