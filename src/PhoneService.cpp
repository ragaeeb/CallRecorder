#include "precompiled.h"

#include "PhoneService.h"
#include "Logger.h"

namespace canadainc {

using namespace bb::system::phone;

PhoneService::PhoneService(QObject* parent) : QObject(parent), m_service(this)
{
	connect( &m_service, SIGNAL( callUpdated(const bb::system::phone::Call&) ), this, SLOT( callUpdated(const bb::system::phone::Call&) ) );
}

PhoneService::~PhoneService()
{
}


void PhoneService::callUpdated(const bb::system::phone::Call &call)
{
	LOGGER( "Call updated" << call.callId() );

	if ( call.callState() == CallState::Disconnected ) {
		emit connectedStateChanged(false);
	} else if ( call.callState() == CallState::Connected ) {
		emit connectedStateChanged(true);
	}
}


} /* namespace canadainc */
