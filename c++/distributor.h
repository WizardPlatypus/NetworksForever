#ifndef _DISTRIBUTOR_H_
#define _DISTRIBUTOR_H_
#include <math.h>

class Distributor {
private:
   int cells;
   int targets;
   int position;

   Distributor(int cells, int targets);
   int getMaxPosition();
   int getMinPosition();

public:
   int* getWays();
};

#endif