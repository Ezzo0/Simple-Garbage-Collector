# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\CMake\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\CMake\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = E:\Studying\Projects\simple_garbage_collector

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = E:\Studying\Projects\simple_garbage_collector\build

# Include any dependencies generated for this target.
include CMakeFiles/SIMPLEGC.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/SIMPLEGC.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/SIMPLEGC.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/SIMPLEGC.dir/flags.make

CMakeFiles/SIMPLEGC.dir/main.c.obj: CMakeFiles/SIMPLEGC.dir/flags.make
CMakeFiles/SIMPLEGC.dir/main.c.obj: CMakeFiles/SIMPLEGC.dir/includes_C.rsp
CMakeFiles/SIMPLEGC.dir/main.c.obj: E:/Studying/Projects/simple_garbage_collector/main.c
CMakeFiles/SIMPLEGC.dir/main.c.obj: CMakeFiles/SIMPLEGC.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=E:\Studying\Projects\simple_garbage_collector\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/SIMPLEGC.dir/main.c.obj"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/SIMPLEGC.dir/main.c.obj -MF CMakeFiles\SIMPLEGC.dir\main.c.obj.d -o CMakeFiles\SIMPLEGC.dir\main.c.obj -c E:\Studying\Projects\simple_garbage_collector\main.c

CMakeFiles/SIMPLEGC.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/SIMPLEGC.dir/main.c.i"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E E:\Studying\Projects\simple_garbage_collector\main.c > CMakeFiles\SIMPLEGC.dir\main.c.i

CMakeFiles/SIMPLEGC.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/SIMPLEGC.dir/main.c.s"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S E:\Studying\Projects\simple_garbage_collector\main.c -o CMakeFiles\SIMPLEGC.dir\main.c.s

CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj: CMakeFiles/SIMPLEGC.dir/flags.make
CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj: CMakeFiles/SIMPLEGC.dir/includes_C.rsp
CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj: E:/Studying/Projects/simple_garbage_collector/gc/gc.c
CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj: CMakeFiles/SIMPLEGC.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=E:\Studying\Projects\simple_garbage_collector\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj -MF CMakeFiles\SIMPLEGC.dir\gc\gc.c.obj.d -o CMakeFiles\SIMPLEGC.dir\gc\gc.c.obj -c E:\Studying\Projects\simple_garbage_collector\gc\gc.c

CMakeFiles/SIMPLEGC.dir/gc/gc.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/SIMPLEGC.dir/gc/gc.c.i"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E E:\Studying\Projects\simple_garbage_collector\gc\gc.c > CMakeFiles\SIMPLEGC.dir\gc\gc.c.i

CMakeFiles/SIMPLEGC.dir/gc/gc.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/SIMPLEGC.dir/gc/gc.c.s"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S E:\Studying\Projects\simple_garbage_collector\gc\gc.c -o CMakeFiles\SIMPLEGC.dir\gc\gc.c.s

CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj: CMakeFiles/SIMPLEGC.dir/flags.make
CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj: CMakeFiles/SIMPLEGC.dir/includes_C.rsp
CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj: E:/Studying/Projects/simple_garbage_collector/my_malloc/my_malloc.c
CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj: CMakeFiles/SIMPLEGC.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=E:\Studying\Projects\simple_garbage_collector\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj -MF CMakeFiles\SIMPLEGC.dir\my_malloc\my_malloc.c.obj.d -o CMakeFiles\SIMPLEGC.dir\my_malloc\my_malloc.c.obj -c E:\Studying\Projects\simple_garbage_collector\my_malloc\my_malloc.c

CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.i"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E E:\Studying\Projects\simple_garbage_collector\my_malloc\my_malloc.c > CMakeFiles\SIMPLEGC.dir\my_malloc\my_malloc.c.i

CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.s"
	C:\PROGRA~1\CODEBL~1\MinGW\bin\gcc.exe $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S E:\Studying\Projects\simple_garbage_collector\my_malloc\my_malloc.c -o CMakeFiles\SIMPLEGC.dir\my_malloc\my_malloc.c.s

# Object files for target SIMPLEGC
SIMPLEGC_OBJECTS = \
"CMakeFiles/SIMPLEGC.dir/main.c.obj" \
"CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj" \
"CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj"

# External object files for target SIMPLEGC
SIMPLEGC_EXTERNAL_OBJECTS =

SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/main.c.obj
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/gc/gc.c.obj
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/my_malloc/my_malloc.c.obj
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/build.make
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/linkLibs.rsp
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/objects1.rsp
SIMPLEGC.exe: CMakeFiles/SIMPLEGC.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=E:\Studying\Projects\simple_garbage_collector\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking C executable SIMPLEGC.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\SIMPLEGC.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/SIMPLEGC.dir/build: SIMPLEGC.exe
.PHONY : CMakeFiles/SIMPLEGC.dir/build

CMakeFiles/SIMPLEGC.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\SIMPLEGC.dir\cmake_clean.cmake
.PHONY : CMakeFiles/SIMPLEGC.dir/clean

CMakeFiles/SIMPLEGC.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" E:\Studying\Projects\simple_garbage_collector E:\Studying\Projects\simple_garbage_collector E:\Studying\Projects\simple_garbage_collector\build E:\Studying\Projects\simple_garbage_collector\build E:\Studying\Projects\simple_garbage_collector\build\CMakeFiles\SIMPLEGC.dir\DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/SIMPLEGC.dir/depend
