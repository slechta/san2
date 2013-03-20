
CCC = g++
CCFLAGS = -Wall -I$(CURDIR) -O3 -ggdb -std=c++0x -DUNIX -DLINUX -pthread -I. -DDSRP_DANGEROUS_TESTING
LDFLAGS = -pthread
LIBS = -lpthread
ASM = yasm



OBJS-UTILS = utils/cthread.o \
			 utils/platform/sleep.o \
			 utils/cdatapack.o \
			 utils/config.o \
			 utils/hex.o \
			 utils/address.o \
			 utils/cstringutils.o \
			 utils/platform/sigignore.o

OBJS-CPPL = cppl/helper.o \
            cppl/pipeclient.o \
            cppl/pipeserver.o \
            cppl/pipechannel.o \
            cppl/bufferprocessor.o

OBJS-NETWORK = network/ccapsule.o

OBJS-RPC = rpc/cirpcchannel.o \
		   rpc/crpcexecutor.o \
		   rpc/crpcinvoker.o \
		   rpc/cirpcfunctionin.o \
		   rpc/cirpcfunctionout.o

OBJS-EXAMPLES-UTILS-PRODUCERCONSUMER = examples/utils/producerconsumer/pctest.o

OBJS-EXAMPLES-UTILS-VECTOR = examples/utils/vector/vector.o

OBJS-STREAM = stream/cistreamrw.o \
			  stream/clenvalueseparator.o
			  
OBJS-COMM = comm/cpplstreamrw.o \
			comm/tcpstreamrw.o \
			comm/streamrpcchannel.o
			

OBJS-TCP =  tcp/ctcpchannel.o \
			tcp/ctcpclient.o \
			tcp/tcphelper.o \
			tcp/ctcpserver.o \
			tcp/citcpbuffer.o \
			tcp/csingletcpserver.o
			
OBJS-INTERFACES = interfaces/tcp/ccapsulereceiver.o \
				  interfaces/sendcapsulefuncin.o \
				  interfaces/sendcapsulefuncout.o \
				  interfaces/alivefuncin.o \
				  interfaces/alivefuncout.o \
				  interfaces/tcp/ctcpinterface.o


OBJS-NODE = node/cnode.o node/main.o node/cipcchannel.o node/cnodeapichannel.o

OBJS-EXAMPLES-CPPL-SERVER = examples/cppl/server/server.o \
							examples/cppl/server/cchannel.o
					 
OBJS-EXAMPLES-CPPL-CLIENT = examples/cppl/client/client.o
							
OBJS-EXAMPLES-CPPL-TERMINAL = examples/cppl/terminal/terminal.o \
				examples/cppl/terminal/terminalreceiver.o

OBJS-EXAMPLES-RPC-SERVER = examples/rpc/server/main.o \
						   examples/rpc/server/serverreceiver.o

OBJS-EXAMPLES-RPC-CLIENT = examples/rpc/client/main.o \
						   examples/rpc/client/clientreceiver.o

OBJS-EXAMPLES-RPC-TCPSERVER = examples/rpc/tcpserver/main.o \
						   examples/rpc/tcpserver/serverreceiver.o

OBJS-EXAMPLES-RPC-TCPCLIENT = examples/rpc/tcpclient/main.o \
						   examples/rpc/tcpclient/clientreceiver.o
						   
OBJS-TEST-FUNC = examples/rpc/testfuncin.o  examples/rpc/multiplyin.o \
		 examples/rpc/testfuncout.o examples/rpc/multiplyout.o

# DragonSRP
OBJ-DSRP =  crypto/dsrp/conversionexception.o \
            crypto/dsrp/conversion.o \
            crypto/dsrp/srpclient.o \
            crypto/dsrp/user.o \
            crypto/dsrp/ng.o \
            crypto/dsrp/dsrpexception.o \
            crypto/dsrp/lookupinterface.o \
            crypto/dsrp/hashinterface.o \
            crypto/dsrp/mathinterface.o \
            crypto/dsrp/randominterface.o \
            crypto/dsrp/srpverificator.o \
            crypto/dsrp/srpserver.o \
            crypto/dsrp/usernotfoundexception.o \
            crypto/dsrp/srpclientauthenticator.o \
            crypto/dsrp/memorylookup.o

OBJ-OSSL =  crypto/ossl/osslmd5.o \
            crypto/ossl/osslsha1.o \
            crypto/ossl/osslsha256.o \
            crypto/ossl/osslsha512.o \
            crypto/ossl/osslrandom.o \
            crypto/ossl/osslmathimpl.o \
            crypto/ossl/osslconversion.o

OBJ-AES =   crypto/aes/aeskey.o \
            crypto/aes/aes_modes.o \
            crypto/aes/aestab.o \
	    crypto/aes/aescrypt.o

OBJ-MAC  =  crypto/mac/hmac.o \
            crypto/mac/macexception.o

OBJ-DREL =  crypto/drel/aescounter.o \
            crypto/drel/aesexception.o \
            crypto/drel/simplekeyderivator.o \
            crypto/drel/datagramencryptor.o \
            crypto/drel/datagramdecryptor.o
				

LIBS-OSSL = -lssl -lcrypto

#  ====== end of DragonSRP variables ======

all:: components examples node dragonsrpall


#  ====== begin DragonSRP targets ======
dragonsrpall: dsrp ossl app-dragonsrp-all mac aes drel

#build the object files for dsrp
dsrp: $(OBJ-DSRP)

#to build ossl we first need to have build dsrp
ossl: dsrp $(OBJ-OSSL)

#build mac
mac: dsrp $(OBJ-MAC)

#build drel DRagon Encryption Layer
drel: dsrp ossl aes mac $(OBJ-DREL)

#compile aes object files
aes: $(OBJ-AES)

# APPLICATION SECTION

#build the app
app-dragonsrp-all:  app-srp app-hmac app-drel app-aes

app-srp: app-srp-server-test app-srp-client-test app-srp-create-user app-srp-benchmark app-srp-rfctest app-srp-qtest

app-hmac: mac app-hmac-testvector

app-aes: aes app-aes-rfc3686

app-drel: drel app-drel-cryptotest


app-srp-server-test: dsrp ossl crypto/apps/server_test.o
	$(CCC) crypto/apps/server_test.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/server_test $(LIBS-OSSL)
	
app-srp-client-test: dsrp ossl crypto/apps/client_test.o
	$(CCC) crypto/apps/client_test.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/client_test $(LIBS-OSSL)
	
app-srp-create-user: dsrp ossl crypto/apps/create_user.o
	$(CCC) crypto/apps/create_user.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/create_user $(LIBS-OSSL)
	
app-srp-benchmark: dsrp ossl crypto/apps/benchmark.o
	$(CCC) crypto/apps/benchmark.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/benchmark $(LIBS-OSSL)

app-srp-rfctest: dsrp ossl crypto/apps/rfc_test.o
	$(CCC) crypto/apps/rfc_test.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/rfc_test $(LIBS-OSSL)

app-srp-qtest: dsrp ossl crypto/apps/qtest.o
	$(CCC) crypto/apps/qtest.o $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/qtest $(LIBS-OSSL)
	
app-hmac-testvector: dsrp ossl mac crypto/apps/hmac_md5_testvector.o
	$(CCC) crypto/apps/hmac_md5_testvector.o $(OBJ-DSRP) $(OBJ-MAC) $(OBJ-OSSL) -o crypto/apps/hmac_md5_testvector $(LIBS-OSSL)

app-aes-rfc3686: aes crypto/aes/rfc3686.o
	$(CCC) crypto/aes/rfc3686.o $(OBJ-AES) -o crypto/aes/rfc3686
	
app-drel-cryptotest: drel crypto/apps/cryptotest.o
	$(CCC) crypto/apps/cryptotest.o $(OBJ-AES) $(OBJ-DREL) $(OBJ-MAC) $(OBJ-DSRP) $(OBJ-OSSL) -o crypto/apps/cryptotest $(LIBS-OSSL)

#end DragonSRP targets


components: utils cppl stream network rpc comm tcp interfaces

utils: $(OBJS-UTILS)
cppl: $(OBJS-CPPL)
stream: $(OBJS-STREAM)
network: $(OBJS-NETWORK)
rpc: $(OBJS-RPC)
comm: $(OBJS-COMM)
tcp: $(OBJS-TCP)
interfaces: $(OBJS-INTERFACES)

examples: examples-utils examples-cppl examples-rpc

examples-utils: examples-utils-producerconsumer examples-utils-vector
examples-cppl: examples-cppl-server examples-cppl-client examples-cppl-terminal
examples-rpc: examples-rpc-server examples-rpc-client examples-rpc-tcpserver examples-rpc-tcpclient

examples-utils-producerconsumer: utils $(OBJS-EXAMPLES-UTILS-PRODUCERCONSUMER)
	$(CCC) $(OBJS-EXAMPLES-UTILS-PRODUCERCONSUMER) $(OBJS-UTILS) -o ./pctest $(LIBS) $(LDFLAGS)

examples-cppl-server: utils cppl $(OBJS-EXAMPLES-CPPL-SERVER) 
	$(CCC) $(OBJS-EXAMPLES-CPPL-SERVER) $(OBJS-UTILS) $(OBJS-CPPL) -o ./cppl_server $(LIBS) $(LDFLAGS)
	
examples-cppl-client: utils cppl $(OBJS-EXAMPLES-CPPL-CLIENT) 
	$(CCC) $(OBJS-EXAMPLES-CPPL-CLIENT) $(OBJS-UTILS) $(OBJS-CPPL) -o ./cppl_client $(LIBS) $(LDFLAGS)

examples-cppl-terminal: utils cppl $(OBJS-EXAMPLES-CPPL-TERMINAL) 
	$(CCC) $(OBJS-EXAMPLES-CPPL-TERMINAL) $(OBJS-UTILS) $(OBJS-CPPL) -o ./terminal $(LIBS) $(LDFLAGS)

examples-utils-vector: utils $(OBJS-EXAMPLES-UTILS-VECTOR)
	$(CCC) $(OBJS-EXAMPLES-UTILS-VECTOR) $(OBJS-UTILS) -o ./utils_vector $(LIBS) $(LDFLAGS)

examples-rpc-server: utils cppl stream comm rpc $(OBJS-EXAMPLES-RPC-SERVER) $(OBJS-TEST-FUNC)
	$(CCC) $(OBJS-UTILS) $(OBJS-CPPL) $(OBJS-STREAM) $(OBJS-COMM) $(OBJS-RPC) $(OBJS-EXAMPLES-RPC-SERVER) $(OBJS-TEST-FUNC)  -o ./rpc_server $(LIBS) $(LDFLAGS)
		
examples-rpc-client: utils cppl stream comm rpc $(OBJS-EXAMPLES-RPC-CLIENT) $(OBJS-TEST-FUNC)
	$(CCC) $(OBJS-UTILS) $(OBJS-CPPL) $(OBJS-STREAM) $(OBJS-COMM) $(OBJS-RPC) $(OBJS-EXAMPLES-RPC-CLIENT) $(OBJS-TEST-FUNC)  -o ./rpc_client $(LIBS) $(LDFLAGS)
	
examples-rpc-tcpserver: utils cppl tcp stream comm rpc $(OBJS-EXAMPLES-RPC-TCPSERVER) $(OBJS-TEST-FUNC)
	$(CCC) $(OBJS-UTILS) $(OBJS-CPPL) $(OBJS-TCP) $(OBJS-STREAM) $(OBJS-COMM) $(OBJS-RPC) $(OBJS-EXAMPLES-RPC-TCPSERVER) $(OBJS-TEST-FUNC)  -o ./tcprpc_server $(LIBS) $(LDFLAGS)
		
examples-rpc-tcpclient: utils cppl tcp stream comm rpc $(OBJS-EXAMPLES-RPC-TCPCLIENT) $(OBJS-TEST-FUNC)
	$(CCC) $(OBJS-UTILS) $(OBJS-CPPL)  $(OBJS-TCP) $(OBJS-STREAM) $(OBJS-COMM) $(OBJS-RPC) $(OBJS-EXAMPLES-RPC-TCPCLIENT) $(OBJS-TEST-FUNC)  -o ./tcprpc_client $(LIBS) $(LDFLAGS)
	
node: utils cppl tcp stream comm rpc network interfaces $(OBJS-NODE)
	$(CCC) $(OBJS-UTILS) $(OBJS-CPPL)  $(OBJS-TCP) $(OBJS-STREAM) $(OBJS-COMM) $(OBJS-RPC) $(OBJS-NETWORK) $(OBJS-INTERFACES) $(OBJS-NODE)  -o ./sanode $(LIBS) $(LDFLAGS)


#tells how to make an *.o object file from an *.c file
%.o: %.cpp
	$(CCC) -c $(CCFLAGS) $< -o $@
	
	
clean::
	rm -f *.o
	rm -f sanode
	rm -f rpc/*.o
	rm -f comm/*.o
	rm -f utils/*.o
	rm -f utils/platform/*.o
	rm -f cppl/*.o
	rm -f network/*.o
	rm -f stream/*.o
	rm -f tcp/*.o
	rm -f interafces/*.o
	rm -f interafces/tcp/*.o
	rm -f node/*.o
	rm -f examples/*.o
	rm -f examples/utils/*.o
	rm -f examples/utils/vector/*.o
	rm -f examples/utils/producerconsumer/*.o
	rm -f examples/cppl/*.o
	rm -f examples/rpc/*.o
	rm -f examples/rpc/server/*.o
	rm -f examples/rpc/client/*.o
	rm -f examples/rpc/tcpserver/*.o
	rm -f examples/rpc/tcpclient/*.o
	rm -f cppl_server
	rm -f cppl_client
	rm -f utils_vector
	rm -f producerconsumer
	rm -f term
	rm -f rpc_server
	rm -f rpc_client
	rm -f tcprpc_server
	rm -f tcprpc_client
	rm -f pctest
	rm -f crypto/*.o
	rm -f crypto/dsrp/*.o
	rm -f crypto/ossl/*.o
	rm -f crypto/apps/server_test
	rm -f crypto/apps/client_test
	rm -f crypto/apps/create_user
	rm -f crypto/apps/benchmark
	rm -f crypto/apps/hmac_md5_testvector
	rm -f crypto/apps/*.o
	rm -f crypto/mac/*.o
	rm -f crypto/aes/*.o
	rm -f crypto/aes/rfc3686
	

	
