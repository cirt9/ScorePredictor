TEMPLATE = subdirs
CONFIG+=ordered
SUBDIRS = \
    ScorePredictorClient \
    ScorePredictorServer

app.depends = src
tests.depends = src

DISTFILES += \
    defaults.pri
