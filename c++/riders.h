#ifndef _RIDERS_H_
#define _RIDERS_H_
class Riders {
private:
   int* from;
   int* to;
   int* arrive_time;
   int ridersN;

public:
   Riders();
   Riders(const Riders& instance);
   ~Riders();
   int getMinTime(int& number);
   int stepThroughTime(int time);
};
#endif