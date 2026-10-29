# ****************************************************************************
#  Project:  LibCMaker
#  Purpose:  A CMake build scripts for build libraries with CMake
#  Author:   NikitaFeodonit, nfeodonit@yandex.com
# ****************************************************************************
#    Copyright (c) 2017-2026 NikitaFeodonit
#
#    This file is part of the LibCMaker project.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License,
#    or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.
# ****************************************************************************


#-----------------------------------------------------------------------
# Library version
#

set(RmlUi_VERSION "6.3" CACHE STRING "RmlUi_VERSION")
set(RmlUi_sha256
  "724fbf2e4b43a39e4f3fc6de67fc6fd30146e271ee821d491c3f31dda8280f9a"
  CACHE STRING "RmlUi_sha256"
)


#-----------------------------------------------------------------------
# RmlUi options
#-----------------------------------------------------------------------

option(RMLUI_COMPILER_OPTIONS "Enable recommended compiler-specific options for the project, such as for supported warning level, standards conformance, and multiprocess builds. Turn off for full control over compiler flags." OFF)


#-----------------------------------------------------------------------
# Unpack, configure and build the required libraries
#-----------------------------------------------------------------------

# Disabling BUILD_TESTING for RmlUi.
if(DEFINED CACHE{BUILD_TESTING})
  set(_STORE_CACHE__BUILD_TESTING ${BUILD_TESTING})
  set(BUILD_TESTING OFF CACHE BOOL "BUILD_TESTING" FORCE)
endif()
if(DEFINED BUILD_TESTING AND NOT DEFINED CACHE{BUILD_TESTING})
  set(_STORE__BUILD_TESTING ${BUILD_TESTING})
  set(BUILD_TESTING OFF)
endif()


find_package(Git 2.17.1 REQUIRED)

set(RmlUi_SRC_NAME "RmlUi-${RmlUi_VERSION}")
set(RmlUi_ARCHIVE_DIR "${CMAKE_CURRENT_LIST_DIR}/source")
set(RmlUi_PATCH_DIR "${RmlUi_ARCHIVE_DIR}/patch/${RmlUi_SRC_NAME}")


include(FetchContent)

FetchContent_Declare(
  RmlUi
  URL "${CMAKE_CURRENT_LIST_DIR}/source/${RmlUi_SRC_NAME}.tar.xz"
  URL_HASH SHA256=${RmlUi_sha256}
  OVERRIDE_FIND_PACKAGE
  PATCH_COMMAND
    ${GIT_EXECUTABLE} apply
      "${RmlUi_PATCH_DIR}/CMake_various_fixes.patch"
)

FetchContent_MakeAvailable(RmlUi)


# Restore BUILD_TESTING.
if(DEFINED _STORE_CACHE__BUILD_TESTING)
  set(BUILD_TESTING ${_STORE_CACHE__BUILD_TESTING} CACHE BOOL "BUILD_TESTING" FORCE)
endif()
if(DEFINED _STORE__BUILD_TESTING)
  set(BUILD_TESTING ${_STORE__BUILD_TESTING})
endif()
