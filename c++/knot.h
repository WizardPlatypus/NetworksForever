#include "array.h"
#include "distributor.h"
#include "riders.h"

class Knot {
private:
   Array targets;
   Riders riders;
   Distributor commander;
   Knot* relatives[];
   int knotsN;
public:
   Knot(int *values, int size);
   Knot(Riders riders, Array targets);
   ~Knot();
};