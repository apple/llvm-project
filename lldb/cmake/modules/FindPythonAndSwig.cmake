#.rst:
# FindPythonAndSwig
# -----------
#
# Find the python interpreter and libraries as a whole.

macro(FindPython3)
  # Use PYTHON_HOME as a hint to find Python 3.
  set(Python3_ROOT_DIR "${PYTHON_HOME}")
  find_package(Python3 COMPONENTS Interpreter Development)
  if(Python3_FOUND AND Python3_Interpreter_FOUND)

    # The install name for the Python 3 framework in Xcode is relative to
    # the framework's location and not the dylib itself.
    #
    #   @rpath/Python3.framework/Versions/3.x/Python3
    #
    # This means that we need to compute the path to the Python3.framework
    # and use that as the RPATH instead of the usual dylib's directory.
    #
    # The check below shouldn't match Homebrew's Python framework as it is
    # called Python.framework instead of Python3.framework.
    if (APPLE AND Python3_LIBRARIES MATCHES "Python3.framework")
      string(FIND "${Python3_LIBRARIES}" "Python3.framework" python_framework_pos)
      string(SUBSTRING "${Python3_LIBRARIES}" "0" ${python_framework_pos} Python3_RPATH)
    endif()

    set(PYTHON3_FOUND TRUE)
    mark_as_advanced(
      Python3_LIBRARIES
      Python3_INCLUDE_DIRS
      Python3_EXECUTABLE
      Python3_RPATH
      SWIG_EXECUTABLE)
  endif()
endmacro()

macro(FindPython2)
  # Use PYTHON_HOME as a hint to find Python 2.
  set(Python2_ROOT_DIR "${PYTHON_HOME}")
  find_package(Python2 COMPONENTS Interpreter Development)
  if(Python2_FOUND AND Python2_Interpreter_FOUND)
    set(Python3_LIBRARIES ${Python2_LIBRARIES})
    set(Python3_INCLUDE_DIRS ${Python2_INCLUDE_DIRS})
    set(Python3_EXECUTABLE ${Python2_EXECUTABLE})

    set(PYTHON2_FOUND TRUE)
    mark_as_advanced(
      Python3_LIBRARIES
      Python3_INCLUDE_DIRS
      Python3_EXECUTABLE
      SWIG_EXECUTABLE)
  endif()
endmacro()

if(Python3_LIBRARIES AND Python3_INCLUDE_DIRS AND Python3_EXECUTABLE AND SWIG_EXECUTABLE)
  set(PYTHONANDSWIG_FOUND TRUE)
else()
  find_package(SWIG 2.0)
  if (SWIG_FOUND OR LLDB_USE_STATIC_BINDINGS)
      if (LLDB_USE_STATIC_BINDINGS)
        set(SWIG_EXECUTABLE "/not/found")
      endif()
      FindPython3()
      if (NOT PYTHON3_FOUND AND NOT CMAKE_SYSTEM_NAME STREQUAL Windows)
        FindPython2()
      endif()
  else()
    message(STATUS "SWIG 2 or later is required for Python support in LLDB but could not be found")
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(PythonAndSwig
                                    FOUND_VAR
                                      PYTHONANDSWIG_FOUND
                                    REQUIRED_VARS
                                      Python3_LIBRARIES
                                      Python3_INCLUDE_DIRS
                                      Python3_EXECUTABLE
                                      SWIG_EXECUTABLE)
endif()
