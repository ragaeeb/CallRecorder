#ifndef CallRecorder_HPP_
#define CallRecorder_HPP_

#include "Persistance.h"

#include <bb/cascades/ArrayDataModel>

namespace bb {
	namespace cascades {
		class Application;
	}
}

namespace callrecorder {

using namespace canadainc;

class CallRecorder : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int numRecordings READ numRecordings NOTIFY recordingCountChanged)

    bb::cascades::ArrayDataModel m_adm;
    Persistance m_persistance;

    CallRecorder(bb::cascades::Application* app);
    QVariantMap getElement(int index) const;

private slots:
	void init();

Q_SIGNALS:
	void recordingCountChanged();
	void initialize();

public:
    static void create(bb::cascades::Application* app);
    virtual ~CallRecorder();

    Q_INVOKABLE void addRecording(QString const& uri, unsigned int duration);
    Q_INVOKABLE bool deleteRecording(int index);
    Q_INVOKABLE void openRecording(int index);
    Q_INVOKABLE bool renameRecording(int index, QString newName);
    Q_INVOKABLE QVariant getDataModel();
    int numRecordings() const;
};

} // callrecorder

#endif /* CallRecorder_HPP_ */
