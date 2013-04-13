
#pragma once

#include "cppl/pipeclient.hpp"
#include "comm/streamrpcchannel.hpp"
#include "rpc/crpcinvoker.hpp"
#include "comm/cpplstreamrw.hpp"
#include "utils/platform/basictypes.hpp"

namespace San2 { namespace Api {
	
	class CNodeConnector : public San2::Cppl::PipeClient
	{
	public:
		CNodeConnector(const char *pipeName, unsigned int timCON, unsigned int timRX, unsigned int timTX, unsigned int timRPC_RX);
		virtual ~CNodeConnector();
		San2::Cppl::ErrorCode receive(); // leave empty?
		
		void cleanup();
		bool connect();
		bool sendCapsule(San2::Utils::bytes &capsuleData);
		bool registerPort(SAN_UINT16 port);
	protected:	
		
	private:
		unsigned int m_timRPC_RX;
	
		// Sender part
		San2::Comm::CpplStreamRW *m_stream;
		San2::Comm::StreamRpcChannel *m_rpcChannel;
		San2::Rpc::CRpcInvoker *m_rpci;
	};
	
	
}} // ns
