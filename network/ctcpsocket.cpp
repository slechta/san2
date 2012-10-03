#pragma once

#include "sockdefs.h"

#include "nettypedef.hpp"
#include "ctcpsocket.hpp"

San2::Network::CTcpSocket::CTcpSocket(const IPv4Address &toBind) :
	sock(SNET_BADSOCKET)
{
	
}

std::list<San2::Network::IPv4Address> San2::Network::CTcpSocket::getIPv4InterfaceList()
{
    // TODO: Nothing here yet
    std::list<San2::Network::IPv4Address> x;
	return x;
}

/* initialize WSA before use */
SNET_SOCKTYPE get_socket(char *server_ip, char *server_port, struct sockaddr_in *address)
{
    SNET_SOCKTYPE sock;
    struct addrinfo hints, *servinfo, *p;

    memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET; /* force IPv4 */
	hints.ai_socktype = SOCK_DGRAM;
	hints.ai_protocol = IPPROTO_UDP;

	if ((getaddrinfo(server_ip, server_port, &hints, &servinfo)) != 0)
	{
		/* fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv)); */
		perror("getaddrinfo failed");
		return SNET_BADSOCKET;
	}

    for(p = servinfo; p != NULL; p = p->ai_next)
    {
        if ((sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) continue;
        break;
    }

    if (p == NULL)
    {
        perror("socket failed");
        freeaddrinfo(servinfo);
        return SNET_BADSOCKET;
    }

    memcpy(address, p->ai_addr, sizeof(struct sockaddr_in));

    freeaddrinfo(servinfo);
    return sock; /* SUCCESS */
}
