
# - Try to find the Gcrypt library
# Once run this will define
#
#  GCRYPT_FOUND - set if the system has the gcrypt library
#  GCRYPT_CFLAGS - the required gcrypt compilation flags
#  GCRYPT_LIBRARIES - the linker libraries needed to use the gcrypt library
#
# Copyright (c) 2006 Brad Hards <bradh@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# libgcrypt is moving to pkg-config, but earlier version don't have it

#search in typical paths for libgcrypt-config
FIND_PROGRAM(GCRYPTCONFIG_EXECUTABLE NAMES libgcrypt-config)

#reset variables
set(GCRYPT_LIBRARIES)
set(GCRYPT_CFLAGS)

# if libgcrypt-config has been found
IF(GCRYPTCONFIG_EXECUTABLE)

  # workaround for MinGW/MSYS
  # CMake can't starts shell scripts on windows so it need to use sh.exe
  EXECUTE_PROCESS(COMMAND sh ${GCRYPTCONFIG_EXECUTABLE} --libs RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE GCRYPT_LIBRARIES OUTPUT_STRIP_TRAILING_WHITESPACE)
  EXECUTE_PROCESS(COMMAND sh ${GCRYPTCONFIG_EXECUTABLE} --cflags RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE GCRYPT_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
  EXECUTE_PROCESS(COMMAND sh ${GCRYPTCONFIG_EXECUTABLE} --version RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE GCRYPT_VERSION_STRING)

  IF(NOT GCRYPT_CFLAGS AND NOT _return_VALUE)
    SET(GCRYPT_CFLAGS " ")
  ENDIF(NOT GCRYPT_CFLAGS AND NOT _return_VALUE)

  IF(GCRYPT_LIBRARIES AND GCRYPT_CFLAGS)
    SET(GCRYPT_FOUND TRUE)
  ENDIF(GCRYPT_LIBRARIES AND GCRYPT_CFLAGS)

ENDIF(GCRYPTCONFIG_EXECUTABLE)

if (GCRYPT_FOUND)
   if (NOT LibGcrypt_FIND_QUIETLY)
      message(STATUS "Found libgcrypt: ${GCRYPT_LIBRARIES}")
   endif (NOT LibGcrypt_FIND_QUIETLY)
else (GCRYPT_FOUND)
   if (LibGcrypt_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find libgcrypt libraries")
   endif (LibGcrypt_FIND_REQUIRED)
endif (GCRYPT_FOUND)

MARK_AS_ADVANCED(GCRYPT_CFLAGS GCRYPT_LIBRARIES GCRYPT_VERSION_STRING)
