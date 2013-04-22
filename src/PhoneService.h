#ifndef PHONESERVICE_H_
#define PHONESERVICE_H_

#include <bb/system/phone/Phone>

namespace canadainc {

using namespace bb::system::phone;

class PhoneService : public QObject
{
	Q_OBJECT

	Phone m_service;

private slots:
	void callUpdated(const bb::system::phone::Call &call);

signals:
	void connectedStateChanged(bool connected);

public:
	PhoneService(QObject* parent=NULL);
	virtual ~PhoneService();
};

} /* namespace canadainc */
#endif /* PHONESERVICE_H_ */
