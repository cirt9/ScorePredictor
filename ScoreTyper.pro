TEMPLATE = subdirs
CONFIG+=ordered
SUBDIRS = \
    ScoreTyperClient

app.depends = src
tests.depends = src

DISTFILES += \
    defaults.pri
