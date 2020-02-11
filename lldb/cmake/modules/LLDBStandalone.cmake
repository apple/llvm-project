option(LLVM_INSTALL_TOOLCHAIN_ONLY "Only include toolchain files in the 'install' target." OFF)

find_package(LLVM REQUIRED CONFIG HINTS ${LLVM_DIR} NO_CMAKE_FIND_ROOT_PATH)
find_package(Clang REQUIRED CONFIG HINTS ${Clang_DIR} ${LLVM_DIR}/../clang NO_CMAKE_FIND_ROOT_PATH)
find_package(Swift REQUIRED CONFIG HINTS "${Swift_DIR}" NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)

# We set LLVM_CMAKE_PATH so that GetSVN.cmake is found correctly when building SVNVersion.inc
set(LLVM_CMAKE_PATH ${LLVM_CMAKE_DIR} CACHE PATH "Path to LLVM CMake modules")

set(LLVM_MAIN_SRC_DIR ${LLVM_BUILD_MAIN_SRC_DIR} CACHE PATH "Path to LLVM source tree")
set(LLVM_MAIN_INCLUDE_DIR ${LLVM_MAIN_INCLUDE_DIR} CACHE PATH "Path to llvm/include")
set(LLVM_BINARY_DIR ${LLVM_BINARY_DIR} CACHE PATH "Path to LLVM build tree")

set(lit_file_name "llvm-lit")
if(CMAKE_HOST_WIN32 AND NOT CYGWIN)
  set(lit_file_name "${lit_file_name}.py")
endif()

function(append_configuration_directories input_dir output_dirs)
  set(dirs_list ${input_dir})
  foreach(config_type ${LLVM_CONFIGURATION_TYPES})
    string(REPLACE ${CMAKE_CFG_INTDIR} ${config_type} dir ${input_dir})
    list(APPEND dirs_list ${dir})
  endforeach()
  set(${output_dirs} ${dirs_list} PARENT_SCOPE)
endfunction()

append_configuration_directories(${LLVM_TOOLS_BINARY_DIR} config_dirs)
find_program(lit_full_path ${lit_file_name} ${config_dirs} NO_DEFAULT_PATH)
set(LLVM_DEFAULT_EXTERNAL_LIT ${lit_full_path} CACHE PATH "Path to llvm-lit")

if(LLVM_TABLEGEN)
  set(LLVM_TABLEGEN_EXE ${LLVM_TABLEGEN})
else()
  if(CMAKE_CROSSCOMPILING)
    set(LLVM_NATIVE_BUILD "${LLVM_BINARY_DIR}/NATIVE")
    if (NOT EXISTS "${LLVM_NATIVE_BUILD}")
      message(FATAL_ERROR
        "Attempting to cross-compile LLDB standalone but no native LLVM build
        found. Please cross-compile LLVM as well.")
    endif()

    if (CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
      set(HOST_EXECUTABLE_SUFFIX ".exe")
    endif()

    if (NOT CMAKE_CONFIGURATION_TYPES)
      set(LLVM_TABLEGEN_EXE
        "${LLVM_NATIVE_BUILD}/bin/llvm-tblgen${HOST_EXECUTABLE_SUFFIX}")
    else()
      # NOTE: LLVM NATIVE build is always built Release, as is specified in
      # CrossCompile.cmake
      set(LLVM_TABLEGEN_EXE
        "${LLVM_NATIVE_BUILD}/Release/bin/llvm-tblgen${HOST_EXECUTABLE_SUFFIX}")
    endif()
  else()
    set(tblgen_file_name "llvm-tblgen${CMAKE_EXECUTABLE_SUFFIX}")
    append_configuration_directories(${LLVM_TOOLS_BINARY_DIR} config_dirs)
    find_program(LLVM_TABLEGEN_EXE ${tblgen_file_name} ${config_dirs} NO_DEFAULT_PATH)
  endif()
endif()

# They are used as destination of target generators.
set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${LLVM_LIBDIR_SUFFIX})
if(WIN32 OR CYGWIN)
  # DLL platform -- put DLLs into bin.
  set(LLVM_SHLIB_OUTPUT_INTDIR ${LLVM_RUNTIME_OUTPUT_INTDIR})
else()
  set(LLVM_SHLIB_OUTPUT_INTDIR ${LLVM_LIBRARY_OUTPUT_INTDIR})
endif()

# We append the directory in which LLVMConfig.cmake lives. We expect LLVM's
# CMake modules to be in that directory as well.
file(TO_CMAKE_PATH ${LLVM_DIR} LLVM_DIR)
list(APPEND CMAKE_MODULE_PATH "${LLVM_DIR}")
list(APPEND CMAKE_MODULE_PATH "${SWIFT_CMAKE_DIR}")
include(AddLLVM)
include(TableGen)
include(HandleLLVMOptions)
include(CheckAtomic)
include(LLVMDistributionSupport)

set(PACKAGE_VERSION "${LLVM_PACKAGE_VERSION}")
set(LLVM_INCLUDE_TESTS ON CACHE INTERNAL "")

option(LLVM_USE_FOLDERS "Enable solution folders in Visual Studio. Disable for Express versions." ON)
if(LLVM_USE_FOLDERS)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()

set_target_properties(clang-tablegen-targets PROPERTIES FOLDER "lldb misc")
set_target_properties(intrinsics_gen PROPERTIES FOLDER "lldb misc")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_directories(
  "${CMAKE_BINARY_DIR}/include"
  "${LLVM_INCLUDE_DIRS}"
  "${CLANG_INCLUDE_DIRS}"
  "${SWIFT_INCLUDE_DIRS}"
  "${SWIFT_MAIN_SRC_DIR}/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/source")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib${LLVM_LIBDIR_SUFFIX})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib${LLVM_LIBDIR_SUFFIX})

set(LLDB_BUILT_STANDALONE 1)
