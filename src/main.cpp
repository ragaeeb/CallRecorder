#include "precompiled.h"

#include "CallRecorder.hpp"
#include "Logger.h"

using namespace bb::cascades;
using namespace callrecorder;

Q_DECL_EXPORT int main(int argc, char **argv)
{
#if !defined(QT_NO_DEBUG)
    registerLogging();
#endif

    Application app(argc, argv);
    CallRecorder::create(&app);

    return Application::exec();
}
