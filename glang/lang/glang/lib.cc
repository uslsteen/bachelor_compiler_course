#include "lib.hh"

extern "C" {

extern "C" void __glang_print(int num) { std::cout << num << std::endl; }

extern "C" int __glang_read() {
  int num;
  std::cin >> num;
  if (!std::cin) {
    std::cerr << "Error : bad input " << num << std::endl;
    exit(1);
  }
  return num;
}
}