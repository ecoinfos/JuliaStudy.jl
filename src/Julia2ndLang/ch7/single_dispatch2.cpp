// This code is modified version of single_dispatch.cpp
// with class methods.
// https://www.youtube.com/watch?v=kc9HwsxE1OY
// To compile: clang++ single_dispatch2.cpp -o pets2

#include <iostream>
#include <string>
using namespace std;

class Pet {
public:
  string name;
  virtual string meets(Pet &b) { return "FALLBACK"; };

  virtual void encounter(Pet &b) {
    cout << name << " meets " << b.name << " and " << meets(b) << endl;
  };
};

class Cat;

class Dog : public Pet {
public:
  // string meets(Pet &b) override { return b.meets(*this); };

  string meets(Dog &b) { return "sniffs"; };
  string meets(Cat &b) { return "chases"; };

  // void encounter(Pet &b) {
  //   cout << "Dog: " << name << " meets " << b.name << " and " << meets(b)
  //        << endl;
  // };
};

class Cat : public Pet {
public:
  // string meets(Pet &b) override { return b.meets(*this); };
  string meets(Dog &b) { return "hisses"; };
  string meets(Cat &b) { return "slinks"; };

  // void encounter(Pet &b) {
  //   cout << "Cat: " << name << " meets " << b.name << " and " << meets(b)
  //        << endl;
  // };
};

int main() {
  Dog fido;
  fido.name = "Fido";
  Dog rex;
  rex.name = "Rex";
  Cat whiskers;
  whiskers.name = "Whiskers";
  Cat spots;
  spots.name = "Spots";

  fido.encounter(rex);
  fido.encounter(whiskers);
  whiskers.encounter(rex);
  whiskers.encounter(spots);
  return 0;
};
