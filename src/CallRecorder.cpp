#include "precompiled.h"

#include "CallRecorder.hpp"
#include "Logger.h"
#include "IOUtils.h"
#include "InvocationUtils.h"

namespace callrecorder {

using namespace bb::cascades;
using namespace canadainc;

CallRecorder::CallRecorder(bb::cascades::Application *app) :
        QObject(app), m_adm(this), m_cover("Cover.qml")
{
	qmlRegisterType<PhoneService>("com.canadainc.data", 1, 0, "PhoneService");

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("persist", &m_persistance);
    qml->setContextProperty("formatter", &m_textUtils);
    qml->setContextProperty("recorder", &m_recorder);
    qml->setContextProperty("phone", &m_phone);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

    connect( this, SIGNAL( initialize() ), this, SLOT( init() ), Qt::QueuedConnection ); // async startup
    emit initialize();
}


void CallRecorder::init()
{
    INIT_SETTING("autoRecord", 0);
	INIT_SETTING("autoEnd", 1);
	INIT_SETTING("rejectShort", 10);

    m_cover.setContext("recorder", &m_recorder);

    if ( m_persistance.getValueFor("output").isNull() ) {
        m_persistance.saveValueFor( "output", IOUtils::setupOutputDirectory("voice", "call_recorder") );
    }

	qmlRegisterType<bb::cascades::pickers::FilePicker>("CustomComponent", 1, 0, "FilePicker");
	qmlRegisterUncreatableType<bb::cascades::pickers::FileType>("CustomComponent", 1, 0, "FileType", "Can't instantiate");
	qmlRegisterUncreatableType<bb::cascades::pickers::FilePickerMode>("CustomComponent", 1, 0, "FilePickerMode", "Can't instantiate");

    InvocationUtils::validateSharedFolderAccess( tr("Warning: It seems like the app does not have access to your Shared Folder. This permission is needed for the app to save the recordings to your file system. If you leave this permission off, the app may not work properly.") );
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
		m_persistance.showToast( tr("Deleted %1").arg(file), "", "asset:///images/toast/ic_delete_recording.png" );
		m_adm.removeAt(index);
		emit recordingCountChanged();
	} else {
		m_persistance.showToast( tr("Could not delete %1").arg(file), "", "asset:///images/toast/warning.png" );
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

		m_persistance.showToast( tr("Renamed %1 to %2").arg(file).arg(title), "", "asset:///images/ic_rename.png" );
		map["uri"] = renamed;
		map["title"] = title;
		m_adm.replace(index, map);
	} else {
		m_persistance.showToast( tr("Could not rename %1 to %2").arg(file).arg(newName), "", "asset:///images/toast/warning.png" );
	}

	return result;
}


void CallRecorder::openRecording(int index)
{
	QVariantMap map = getElement(index);
	QString file = map.value("uri").toString();
	LOGGER(file << index);

	InvocationUtils::launchAudio(file);
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
