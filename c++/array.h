#ifndef _ARRAY_H_
#define _ARRAY_H_
#include "point.h"

class Array {
private:
   static Point* array;
   bool* marks;
   int size;

public:
   Array();
   Array(Point* array, int size);
   Array(const Array& instance);
   ~Array();
   Point& operator [](const int index);
   int getSize();
   int getMarked();
   void markAt(int index);
   void markAt(int* array, int size);
};
#endif