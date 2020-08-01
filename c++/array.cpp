#include "array.h"
#include <list>



Array::Array() {
   array = nullptr;
   marks = nullptr;
   size = 0;
}

Array::Array(Point* array, int size) {
   this->array = new Point[size];
   for(int i = 0; i < size; ++i) {
      this->array[i] = array[i];
   }
   this->marks = new bool[size] {false};
   this->size = size;
}

Array::Array(const Array& instance) {
   this->marks = new bool[size];
   for(int i = 0; i < size; ++i) {
      this->marks[i] = instance.marks[i];
   }
}

Point& Array::operator[](const int index){
   if(marks[index]) {
      if(index >= size)
         throw ("\nindex is out of range: " + size);
      return array[index + 1];
   } else {
      return array[index];
   }
}

int Array::getSize() {
   return size;
}

int Array::getMarked() {
   int count = 0;
   for(int i = 0; i < size; ++i) {
      if(marks[i]) {
         ++count;
      }
   }
   return count;
}

void Array::markAt(int index) {
   this->marks[index] = true;
}

void Array::markAt(int* sorted_array, int size) {
   for(int i = size - 1; i >= 0; --i) {
      this->marks[sorted_array[i]] = false;
   }
}