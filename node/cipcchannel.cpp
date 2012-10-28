
#include "cipcchannel.hpp"

namespace San2 { namespace Node {

CIpcChannel::CIpcChannel(CPPL_PIPETYPE handle, unsigned int timRX, unsigned int timTX, CNode &node) :
	San2::Cppl::PipeChannel(handle, timRX, timTX),
	m_node(node)
{
	
}

CIpcChannel::~CIpcChannel()
{
	// empty
}

San2::Cppl::ErrorCode CIpcChannel::receive()
{
	const unsigned int lineSize = 512;
	char line[lineSize];
	
	while (1)
	{
		San2::Cppl::ErrorCode rval = readLine(line, lineSize);
		if (rval != San2::Cppl::ErrorCode::SUCCESS)
		{
			if (rval == San2::Cppl::ErrorCode::PEER_DISCONNECT)
			{
				printf("peer disconnected\n");
				return rval;
			}
			printf("readLine failed errcode: %d\n", errorCodeToInt(rval));
			
			break;
		}
		
		unsigned int lineLen = strlen(line); 
		printf("got line of length: %d\n", lineLen);
		
		line[strlen(line)] = 0x0A;
		lineLen++;
		
		San2::Cppl::ErrorCode sendRval = send(line, lineLen);

		if (sendRval != San2::Cppl::ErrorCode::SUCCESS) // echo
		{
			printf("CServer::receive(): send() error\n");
			return San2::Cppl::ErrorCode::FAILURE;
		}
	}
	
	printf("server exit\n");
	return San2::Cppl::ErrorCode::SUCCESS;
}

}} // ns
