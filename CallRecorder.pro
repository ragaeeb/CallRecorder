APP_NAME = CallRecorder

INCLUDEPATH += ../../canadainc/src/
CONFIG += qt warn_on cascades10
LIBS += -lbbsystem -lbbmultimedia -lbbcascadespickers

CONFIG(release, debug|release) {
    DESTDIR = o.le-v7
    LIBS += -L../../canadainc/arm/o.le-v7 -lcanadainc -Bdynamic
}

CONFIG(debug, debug|release) {
    DESTDIR = o.le-v7-g
    LIBS += -L../../canadainc/arm/o.le-v7-g -lcanadainc -Bdynamic
}

simulator {
	CONFIG(release, debug|release) {
	    DESTDIR = o
	    LIBS += -Bstatic -L../../canadainc/x86/o-g/ -lcanadainc -Bdynamic     
	}
	CONFIG(debug, debug|release) {
	    DESTDIR = o-g
	    LIBS += -Bstatic -L../../canadainc/x86/o-g/ -lcanadainc -Bdynamic
	}
}

include(config.pri)
