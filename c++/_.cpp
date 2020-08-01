#include <graph.h>

class MemoryTree {
private:
   class Vertex{
   private:
      bool isVisited;
      int x;
      int y;
   public:
      Vertex()
      {
         x = 0;
         y = 0;
      }
      Vertex(int x, int y)
      {
         this->x = x;
         this->y = y;
         this->isVisited = false;
      }
      Vertex(int x, int y, bool b) :Vertex(x, y)
      {
         this->isVisited = b;
      }
      //~Vertex();
   };

   class Knot {
   private:
      int* values;
      int valuesN;
      Knot* relatives;
      int relativesN;
      Vertex* targets;
      int targetsN;

      int getWays()
      {
         int result = 1;
         for(int n = targetsN; n > valuesN; --n)
            result *= n;
         return result;
      }
      void makeWays(int count)
      {
         if(count == getWays())
            return;
         // some code;
      }
   public:
      Knot()
      {
         values = 0;
         valuesN = 0;
         relatives = 0;
         relativesN = 0;
         targets = 0;
         targetsN = 0;
      }
      Knot(int valuesN, Vertex* targets, int targetsN)
      {
         this->values = new int[valuesN] {};
         this->valuesN = valuesN;
         this->relatives = this;
         this->relativesN = 1;
         this->targets = targets;
         this->targetsN = targetsN;
      }
      ~Knot()
      {
         delete[] values;
         delete[] relatives;
         delete[] targets;
      }
      bool notAllVisited()
      {
         return targetsN == 0 ? true : false;
      }
   };
   
   Knot* HEAD;
public:
   MemoryTree();
   ~MemoryTree();
   void selectWays();
   void goWays();
   void drawTree();
   void showStatistics();

};