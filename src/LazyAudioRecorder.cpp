#include "LazyAudioRecorder.h"
#include "Logger.h"

#include <bb/multimedia/AudioRecorder>

namespace canadainc {

using namespace bb::multimedia;

LazyAudioRecorder::LazyAudioRecorder(QObject* parent) : QObject(parent), m_recorder(NULL)
{
}


QString LazyAudioRecorder::currentUri() const {
	return m_currentUri;
}


void LazyAudioRecorder::setCurrentUri(QString const& uri)
{
	LOGGER("=================== CURRENT URI" << uri);
	m_currentUri = uri;

	if (m_recorder) {
		if ( !m_currentUri.startsWith("file://") ) {
			LOGGER("=================== DOES NOT ALREADY STArts WITH FILE" << QString("file://%1").arg(uri) );
			m_recorder->setOutputUrl( QString("file://%1").arg(uri) );
		} else {
			LOGGER("=================== ALREADY STArts WITH FILE" << uri );
			m_recorder->setOutputUrl(uri);
		}
	}
}


void LazyAudioRecorder::onMediaStateChanged(bb::multimedia::MediaState::Type mediaState)
{
	Q_UNUSED(mediaState);
	emit recordingStateChanged();
}


bool LazyAudioRecorder::recording() const {
	return m_recorder && m_recorder->mediaState() == MediaState::Started;
}


void LazyAudioRecorder::onError(bb::multimedia::MediaError::Type mediaError, unsigned int position)
{
	Q_UNUSED(mediaError);
	Q_UNUSED(position);
	emit errorDetected();
}


bool LazyAudioRecorder::record()
{
	if (m_recorder == NULL) {
		LOGGER("=========== CREATING FOR FIRST TIME!");
		m_recorder = new AudioRecorder(this);
		connect( m_recorder, SIGNAL( durationChanged(unsigned int) ), this, SIGNAL( durationChanged() ) );
		connect( m_recorder, SIGNAL( error(bb::multimedia::MediaError::Type, unsigned int) ), this, SLOT( onError(bb::multimedia::MediaError::Type, unsigned int) ) );
		connect( m_recorder, SIGNAL( mediaStateChanged(bb::multimedia::MediaState::Type) ), this, SLOT( onMediaStateChanged(bb::multimedia::MediaState::Type) ) );

		setCurrentUri(m_currentUri);
	}

	return m_recorder->record() == MediaError::None;
}


void LazyAudioRecorder::reset()
{
	if (m_recorder != NULL) {
		m_recorder->reset();
	}
}


QVariant LazyAudioRecorder::duration() const {
	return m_recorder ? m_recorder->duration() : 0;
}


LazyAudioRecorder::~LazyAudioRecorder()
{
}

} /* namespace canadainc */
