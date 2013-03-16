#include "CallRecorder.hpp"
#include "Logger.h"

#include <bb/system/InvokeManager>
#include <bb/system/SystemToast>

#include <bb/cascades/AbstractDialog>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/Application>
#include <bb/cascades/ArrayDataModel>
#include <bb/cascades/Control>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/SceneCover>

namespace callrecorder {

using namespace bb::cascades;
using namespace bb::system;

CallRecorder::CallRecorder(bb::cascades::Application *app) : QObject(app), m_toast(NULL)
{
	if ( getValueFor("autoRecord").isNull() ) { // first run
		saveValueFor("animations", 1);
		saveValueFor("autoRecord", 0);
		saveValueFor("hideAgreement", 0);

		QString sdDirectory("/accounts/1000/removable/sdcard/voice");

		if ( !QDir(sdDirectory).exists() ) {
			sdDirectory = "/accounts/1000/shared/voice";
		}

		saveValueFor("output", sdDirectory);
	}

	QmlDocument* qmlCover = QmlDocument::create("asset:///Cover.qml").parent(this);
	Control* sceneRoot = qmlCover->createRootObject<Control>();
	SceneCover* cover = SceneCover::create().content(sceneRoot);
	app->setCover(cover);

    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("app", this);
    qml->setContextProperty("cover", sceneRoot);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    app->setScene(root);

    if ( getValueFor("hideAgreement").toInt() == 0 )
    {
    	LOGGER("Creating agreement dialog");

        QmlDocument* agreementQML = QmlDocument::create("asset:///Agreement.qml").parent(root);
        agreementQML->setContextProperty("app", this);

        AbstractDialog* dialog = agreementQML->createRootObject<AbstractDialog>();
        dialog->setParent(root);

        LOGGER("Open agreement dialog");
        dialog->open();
    }
}


void CallRecorder::create(bb::cascades::Application* app) {
	new CallRecorder(app);
}


QVariant CallRecorder::getValueFor(QString const &objectName)
{
    QVariant value( m_settings.value(objectName) );
	LOGGER("getValueFor()" << objectName << value);

    return value;
}


void CallRecorder::saveValueFor(QString const& objectName, QVariant const& inputValue)
{
	LOGGER("saveValueFor()" << objectName << inputValue);
	m_settings.setValue(objectName, inputValue);
}


void CallRecorder::showToast(const QString& message)
{
	if (m_toast == NULL) {
		m_toast = new SystemToast(this);
	}

	m_toast->setBody(message);
	m_toast->show();
}


bool CallRecorder::deleteRecording(const QString& file)
{
	QFile f(file);
	bool result = f.remove();

	if (result) {
		showToast( tr("Deleted %1").arg(file) );
	} else {
		showToast( tr("Could not delete %1").arg(file) );
	}

	return result;
}


bool CallRecorder::renameRecording(const QString& file, const QString& newName)
{
	QFile f(file);
	bool result = f.rename(newName);

	if (result) {
		showToast( tr("Renamed %1 to %2").arg(file).arg(newName) );
	} else {
		showToast( tr("Could not rename %1 to %2").arg(file).arg(newName) );
	}

	return result;
}


void CallRecorder::openRecording(const QString& file)
{
	InvokeManager invokeManager;

	InvokeRequest request;
	request.setTarget("sys.mediaplayer.previewer");
	request.setAction("bb.action.OPEN");
	request.setMimeType("audio/m4a");
	request.setUri( QUrl(file) );

	invokeManager.invoke(request);
}


CallRecorder::~CallRecorder()
{
}

} // callrecorder
