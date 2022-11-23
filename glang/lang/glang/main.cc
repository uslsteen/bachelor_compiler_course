#include "driver/driver.hh"
#include <CLI/CLI.hpp>

int main(int argc, char **argv) {
  std::string path_to_src{}, output_path{};

  // CLI::App cli_app("Glang");

  // cli_app.add_option("-src,--source_code", path_to_src, "Path to source code")
  //     ->required();
// 
  // cli_app.add_option("-o,--output", output_path, "Path to output file")
  //     ->required();
  // //
  // CLI11_PARSE(cli_app, argc, argv);

  path_to_src = std::string{"/home/anton/code/compiler_course/glang/tests/1.gl"}, output_path = {"1.ll"};

  yy::Driver driver{path_to_src, output_path};
  driver.parse();
  driver.dump();

  return 0;
}