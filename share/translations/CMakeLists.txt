#  Copyright (C) 2014 Felix Geyer <debfx@fobos.de>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 or (at your option)
#  version 3 of the License.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

file(GLOB TRANSLATION_FILES *.ts)
get_filename_component(TRANSLATION_EN_ABS keepassx_en.ts ABSOLUTE)
list(REMOVE_ITEM TRANSLATION_FILES keepassx_en.ts)
list(REMOVE_ITEM TRANSLATION_FILES ${TRANSLATION_EN_ABS})
message(STATUS ${TRANSLATION_FILES})

qt4_add_translation(QM_FILES ${TRANSLATION_FILES})

if(WITH_EMBED_RESOURCES)
    # Create translations QRC file - translations.qrc
    set(trans_file translations)
    set(trans_infile ${CMAKE_CURRENT_BINARY_DIR}/${trans_file}.qrc)
    set(trans_outfile ${CMAKE_CURRENT_BINARY_DIR}/qrc_${trans_file}.cxx)

    ADD_CUSTOM_COMMAND(
        OUTPUT ${trans_outfile}
        COMMAND ${QT_RCC_EXECUTABLE}
        ARGS ${rcc_options} -name ${trans_file} -o ${trans_outfile} ${trans_infile}
        MAIN_DEPENDENCY ${trans_infile}
        DEPENDS ${QM_FILES}
    )
    file(WRITE ${trans_infile} "<RCC>\n\t<qresource prefix=\"/translations\">")
    foreach(QM_FILE ${QM_FILES})
        get_filename_component(QM_FILE_NAME ${QM_FILE} NAME)
        file(APPEND ${trans_infile} "\n\t\t<file>${QM_FILE_NAME}</file>")
    endforeach()
    file(APPEND ${trans_infile} "\n\t</qresource>\n</RCC>")
    add_custom_target(translations DEPENDS ${trans_outfile})
else()
    add_custom_target(translations DEPENDS ${QM_FILES})
endif(WITH_EMBED_RESOURCES)

install(FILES ${QM_FILES} DESTINATION ${DATA_INSTALL_DIR}/translations)
add_dependencies(${PROGNAME} translations)
