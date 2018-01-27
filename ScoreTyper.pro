TEMPLATE = subdirs
CONFIG+=ordered
SUBDIRS = \
    ScoreTyperClient \
    ScoreTyperServer

app.depends = src
tests.depends = src

DISTFILES += \
    defaults.pri
