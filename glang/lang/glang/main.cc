#include "driver/driver.hh"
#include <CLI/CLI.hpp>

int main(int argc, char **argv) {

  std::string path_to_src{}, output_path{};

#if 1
  CLI::App cli_app("Glang");

  cli_app.add_option("--source,-s", path_to_src, "Path to source code")
      ->required();

  cli_app.add_option("--output,-o", output_path, "Path to output file")
      ->required();
  //
  CLI11_PARSE(cli_app, argc, argv);
#endif
//
#if 0
  path_to_src =
      std::string{"/home/anton/code/compiler_course/glang/tests/array.gl"},
  output_path = {"/home/anton/code/compiler_course/glang/tests/array.ll"};
#endif
  //
  yy::Driver driver{path_to_src, output_path};
  driver.parse();
  driver.dump();

  return 0;
}