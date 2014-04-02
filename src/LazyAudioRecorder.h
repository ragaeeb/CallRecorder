#ifndef LAZYAUDIORECORDER_H_
#define LAZYAUDIORECORDER_H_

#include <QObject>
#include <bb/multimedia/MediaError>
#include <bb/multimedia/MediaState>

namespace bb {
	namespace multimedia {
		class AudioRecorder;
	}
}

namespace canadainc {

using namespace bb::multimedia;

class LazyAudioRecorder : public QObject
{
	Q_OBJECT

	Q_PROPERTY(bool recording READ recording NOTIFY recordingStateChanged)
	Q_PROPERTY(QString currentUri READ currentUri WRITE setCurrentUri)
	Q_PROPERTY(QVariant duration READ duration NOTIFY durationChanged)

	AudioRecorder* m_recorder;
	QString m_currentUri;

private slots:
	void onError(bb::multimedia::MediaError::Type mediaError, unsigned int position);
	void onMediaStateChanged(bb::multimedia::MediaState::Type mediaState);

Q_SIGNALS:
	void recordingStateChanged();
	void errorDetected();
	void durationChanged();

public:
	LazyAudioRecorder(QObject* parent=NULL);
	virtual ~LazyAudioRecorder();

	Q_SLOT bool record();
	Q_SLOT void reset();
	QString currentUri() const;
	QVariant duration() const;
	void setCurrentUri(QString const& uri);
	bool recording() const;
};

} /* namespace canadainc */
#endif /* LAZYAUDIORECORDER_H_ */
