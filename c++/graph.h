class Graph {
private:
   class Vertex{
   private:
      bool isVisited;
      int x;
      int y;
   public:
      Vertex();
      Vertex(int x, int y);
      Vertex(int x, int y, bool b);
      ~Vertex();
   };
   Vertex* cities;
   int numberofcities;
public:
   Graph();
   Graph(int n);
   ~Graph();
   bool notAllVisited();
};