#ifndef CallRecorder_HPP_
#define CallRecorder_HPP_

#include <QSettings>

namespace bb {
	namespace cascades {
		class Application;
	}

	namespace system {
		class SystemToast;
	}
}

namespace callrecorder {

using namespace bb::system;

class CallRecorder : public QObject
{
    Q_OBJECT

    QSettings m_settings;
    SystemToast* m_toast;

    CallRecorder(bb::cascades::Application* app);
    void showToast(const QString& message);

public:
    static void create(bb::cascades::Application* app);
    virtual ~CallRecorder();

    Q_INVOKABLE void saveValueFor(const QString &objectName, const QVariant &inputValue);
    Q_INVOKABLE QVariant getValueFor(const QString &objectName);
    Q_INVOKABLE bool deleteRecording(const QString& file);
    Q_INVOKABLE void openRecording(const QString& file);
    Q_INVOKABLE bool renameRecording(const QString& file, const QString& newName);
};

} // callrecorder

#endif /* CallRecorder_HPP_ */
