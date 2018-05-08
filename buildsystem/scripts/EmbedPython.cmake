# Copyright 2017-2017 the openage authors. See copying.md for legal info.

if(NOT forward_variables)
	message(FATAL_ERROR "CMake configuration variables not available. Please include(ForwardVariables.cmake)")
endif()

include("${buildsystem_dir}/modules/DownloadCache.cmake")
set(python_embed_zip "python-${py_version}-embed-win32.zip")
set(python_zip_download_path "${downloads_dir}/${python_embed_zip}")
STRING(REGEX MATCH "[0-9]\\.[0-9]\\.[0-9]" python_download_dir ${py_version})
# TODO: disable downloading for CI builds. <Need CI first>
# FIXME: Tries to download nonexistant https://www.python.org/ftp/python/3.7.0b4/python-3.7.0b4-embed-win32.zip
# Should be .../python/3.7.0/
download_cache(
	"https://www.python.org/ftp/python/${python_download_dir}/${python_embed_zip}"
	"${python_zip_download_path}"
)

execute_process(COMMAND
	"${CMAKE_COMMAND}" -E tar xf "${python_zip_download_path}"
	WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/${py_install_prefix}"
)

execute_process(COMMAND
	"${python}" "${buildsystem_dir}/scripts/copy_modules.py"
	numpy PIL pyreadline readline
	"${CMAKE_INSTALL_PREFIX}/${py_install_prefix}"
)
