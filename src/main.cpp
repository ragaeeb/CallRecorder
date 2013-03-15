#include <bb/cascades/Application>

#include <bb/cascades/pickers/FilePicker>

#include <bb/multimedia/MediaError>
#include <bb/multimedia/MediaState>

#include "CallRecorder.hpp"
#include "Logger.h"

using namespace bb::cascades;
using namespace bb::multimedia;
using namespace callrecorder;

#ifdef DEBUG
namespace {

void redirectedMessageOutput(QtMsgType type, const char *msg) {
	Q_UNUSED(type);
	fprintf(stderr, "%s\n", msg);
}

}
#endif

Q_DECL_EXPORT int main(int argc, char **argv)
{
#ifdef DEBUG
	qInstallMsgHandler(redirectedMessageOutput);
#endif

	qmlRegisterType<bb::cascades::pickers::FilePicker>("CustomComponent", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("CustomComponent", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("CustomComponent", 1, 0, "FilePickerMode", "Can't instantiate");
	qmlRegisterUncreatableType<bb::multimedia::MediaError>("Multimedia", 1, 0, "MediaError", "Can't instantiate");
	qmlRegisterUncreatableType<bb::multimedia::MediaState>("Multimedia", 1, 0, "MediaState", "Can't instantiate");

    Application app(argc, argv);
    CallRecorder::create(&app);

    return Application::exec();
}
