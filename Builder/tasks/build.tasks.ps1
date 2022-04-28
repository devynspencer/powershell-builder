# Synopsis: Execute Build tasks (avoiding setup if possible)
task Build

# Synopsis: Execute build tasks from a new environment
task Rebuild Clean, Register, Reinstall, Package, Build
