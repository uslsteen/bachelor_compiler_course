#include "driver/driver.hh"
#include <CLI/CLI.hpp>

int main(int argc, char **argv) {

  std::string path_to_src{}, output_path{};

#if 0
  CLI::App cli_app("Glang");

  cli_app.add_option("--source_code", path_to_src, "Path to source code")
      ->required();

  cli_app.add_option("--output", output_path, "Path to output file")
      ->required();
  //
  CLI11_PARSE(cli_app, argc, argv);
#endif

#if 1
  path_to_src =
      std::string{"/home/anton/code/compiler_course/glang/tests/if.gl"},
  output_path = {"/home/anton/code/compiler_course/glang/tests/if.ll"};
#endif
  //
  yy::Driver driver{path_to_src, output_path};
  driver.parse();
  driver.dump();

  return 0;
}