#include "../../TinyEngine.hpp"

int main(int argc, char *args[]) {

  Tiny::init();
  Tiny::loop([&]() {});
  Tiny::quit();

  return 0;
}
