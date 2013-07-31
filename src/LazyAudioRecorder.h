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

	Q_PROPERTY(QString durationHours READ durationHours NOTIFY durationHoursChanged)
	Q_PROPERTY(QString durationMinutes READ durationMinutes NOTIFY durationSecondsChanged)
	Q_PROPERTY(QString durationSeconds READ durationSeconds NOTIFY durationSecondsChanged)
	Q_PROPERTY(bool recording READ recording NOTIFY recordingStateChanged)
	Q_PROPERTY(QString currentUri READ currentUri WRITE setCurrentUri)
	Q_PROPERTY(QVariant duration READ duration FINAL)

	AudioRecorder* m_recorder;
	QString m_hours;
	QString m_mins;
	QString m_secs;
	QString m_currentUri;

private slots:
	void onDurationChanged(unsigned int duration);
	void onError(bb::multimedia::MediaError::Type mediaError, unsigned int position);
	void onMediaStateChanged(bb::multimedia::MediaState::Type mediaState);

Q_SIGNALS:
	void durationHoursChanged();
	void durationMinutesChanged();
	void durationSecondsChanged();
	void recordingStateChanged();
	void errorDetected();

public:
	LazyAudioRecorder(QObject* parent=NULL);
	virtual ~LazyAudioRecorder();

	Q_SLOT bool record();
	Q_SLOT void reset();
	QString durationHours() const;
	QString durationMinutes() const;
	QString durationSeconds() const;
	QString currentUri() const;
	QVariant duration() const;
	void setCurrentUri(QString const& uri);
	bool recording() const;
};

} /* namespace canadainc */
#endif /* LAZYAUDIORECORDER_H_ */
