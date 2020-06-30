class knot
{
private:
   int* values;
   int values_number;
   knot* knots;
   int knots_number;
public:
   knot(int *values, int size){
      this->values = new int[size];
      for(int i = 0; i < size; ++i){
         this->values[i] = values[i];
      }
      knots = nullptr;
   };
   ~knot(){
      delete[] values;
      for(int i = 0; i < knots_number; ++i){
         knots[i].~knot();
      }
      delete[] knots;
   };
};