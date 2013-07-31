#include "precompiled.h"

#include "CallRecorder.hpp"
#include "Logger.h"
#include "IOUtils.h"
#include "PhoneService.h"

namespace callrecorder {

using namespace bb::cascades;
using namespace canadainc;

CallRecorder::CallRecorder(bb::cascades::Application *app) : QObject(app), m_adm(this)
{
	INIT_SETTING("autoRecord", 0);
	INIT_SETTING("hideAgreement", 0);
	INIT_SETTING("autoEnd", 1);
	INIT_SETTING("rejectShort", 10);

	if ( m_persistance.getValueFor("output").isNull() ) {
		m_persistance.saveValueFor( "output", IOUtils::setupOutputDirectory("voice", "call_recorder") );
	}

	qmlRegisterType<bb::cascades::pickers::FilePicker>("CustomComponent", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("CustomComponent", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("CustomComponent", 1, 0, "FilePickerMode", "Can't instantiate");
	qmlRegisterType<PhoneService>("com.canadainc.data", 1, 0, "PhoneService");

	QmlDocument* qmlCover = QmlDocument::create("asset:///Cover.qml").parent(this);
	Control* sceneRoot = qmlCover->createRootObject<Control>();
	SceneCover* cover = SceneCover::create().content(sceneRoot);
	app->setCover(cover);

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("cover", sceneRoot);
    qml->setContextProperty("persist", &m_persistance);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

    if ( m_persistance.getValueFor("hideAgreement").toInt() == 0 )
    {
    	LOGGER("Creating agreement dialog");

        QmlDocument* agreementQML = QmlDocument::create("asset:///Agreement.qml").parent(root);
        agreementQML->setContextProperty("app", this);
        agreementQML->setContextProperty("persist", &m_persistance);

        AbstractDialog* dialog = agreementQML->createRootObject<AbstractDialog>();
        dialog->setParent(root);

        LOGGER("Open agreement dialog");
        dialog->open();
    }
}


void CallRecorder::create(Application* app) {
	new CallRecorder(app);
}


bool CallRecorder::deleteRecording(int index)
{
	QString file = getElement(index).value("uri").toString();
	LOGGER("Delete recording" << file << index);

	QFile f(file);
	bool result = f.remove();

	if (result) {
		m_persistance.showToast( tr("Deleted %1").arg(file) );
		m_adm.removeAt(index);
		emit recordingCountChanged();
	} else {
		m_persistance.showToast( tr("Could not delete %1").arg(file) );
	}

	return result;
}


bool CallRecorder::renameRecording(int index, QString newName)
{
	QVariantMap map = getElement(index);
	QString file = map.value("uri").toString();
	LOGGER(file << newName);

	newName = newName+file.mid( file.lastIndexOf(".") ); // add extension

	LOGGER("Renaming" << file << newName << index);

	QFile f(file);
	QString renamed = file.left( file.lastIndexOf("/")+1 ) + newName;
	bool result = f.rename(renamed);

	if (result) {
		QString title = newName.left( newName.lastIndexOf(".") );

		m_persistance.showToast( tr("Renamed %1 to %2").arg(file).arg(title) );
		map["uri"] = renamed;
		map["title"] = title;
		m_adm.replace(index, map);
	} else {
		m_persistance.showToast( tr("Could not rename %1 to %2").arg(file).arg(newName) );
	}

	return result;
}


void CallRecorder::openRecording(int index)
{
	QVariantMap map = getElement(index);
	QString file = "file://"+map.value("uri").toString();
	LOGGER(file << index);

	bb::system::InvokeManager invokeManager;

	bb::system::InvokeRequest request;
	request.setTarget("sys.mediaplayer.previewer");
	request.setAction("bb.action.OPEN");
	request.setMimeType("audio/m4a");
	request.setUri( QUrl(file) );

	invokeManager.invoke(request);
}


QVariantMap CallRecorder::getElement(int index) const {
	return m_adm.value(index).toMap();
}


void CallRecorder::addRecording(QString const& uri, unsigned int duration)
{
	unsigned int minimumLengthAllowed = m_persistance.getValueFor("rejectShort").toInt() * 1000;
	LOGGER(uri << duration << minimumLengthAllowed);

	if (duration < minimumLengthAllowed) {
		LOGGER("Too short, removing");
		QFile f(uri);
		bool result = f.remove();

		if (result) {
			m_persistance.showToast( tr("Rejected recording!") );
		}

		LOGGER("Removed" << result);
	} else {
		QString title = uri.mid( uri.lastIndexOf("/")+1 );
		title = title.left( title.lastIndexOf(".") );

		LOGGER(title);

		QVariantMap map;
		map["uri"] = uri;
		map["title"] = title;
		map["duration"] = duration;

		m_adm.insert(0, map);

		LOGGER( "Data model now has " << map << m_adm.size() );

		emit recordingCountChanged();
	}
}


QVariant CallRecorder::getDataModel() {
	return QVariant::fromValue(&m_adm);
}


int CallRecorder::numRecordings() const {
	return m_adm.size();
}


CallRecorder::~CallRecorder() {
	m_adm.setParent(NULL);
}

} // callrecorder
