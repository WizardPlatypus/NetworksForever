#include <math.h>
#include <string>
#include "distributor.h"

int Distributor::getMaxPosition() {
   int p = 0;
   for(int i = 1; i <= cells; ++i) {
      p += pow(targets, cells - 1) * (targets - 1);
   }
   return p;
}

int Distributor::getMinPosition() {
   int p = 0;
   for(int i = 1; i < cells; ++i) {
      p += pow(targets, cells - i - 1) * i;
   }
   return p;
}

int* Distributor::getWays() {
   int* ways = new int[cells];
   int tmp = ++position;
   if(position > getMaxPosition()) {
      throw ("Position >= MaxPosition " + position + ' ' + getMaxPosition());
   }
   for(int i = 0; i < cells; ++i) {
      ways[i] = tmp % targets;
      tmp /= targets;
      for(int j = 0; j < i; ++j) {
         if(ways[i] == ways[j]) {
            tmp = ++position;
            i = 0;
            break;
         }
      }
   }
   return ways;
}

Distributor::Distributor(int cells, int targets) {
   this->cells = cells;
   this->targets = targets;
   position = getMinPosition() - 1;
}