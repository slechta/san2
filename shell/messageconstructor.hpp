
#pragma once

#include <iterator>
#include <string>
#include <stdio.h>

#include "utils/cvector.hpp"

int enc_construct_A_message(const std::string &username, const San2::Utils::bytes &srpA, San2::Utils::bytes &out);
int enc_parse_A_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes &username, San2::Utils::bytes &srpA);
int enc_testA();

int enc_construct_P_message_success(const San2::Utils::bytes& salt, const San2::Utils::bytes& srpB, San2::Utils::bytes &out);
int enc_parse_P_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes &salt, San2::Utils::bytes &srpB, unsigned char& errorCode);
int enc_construct_P_message_fail(San2::Utils::bytes &out, unsigned char errorCode);
int enc_testP();

int enc_construct_B_message(const San2::Utils::bytes& srpM1, San2::Utils::bytes &out);
int enc_parse_B_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes &srpM1);
int enc_testB();

int enc_construct_Q_message_fail(San2::Utils::bytes &out, unsigned char errorCode);
int enc_construct_Q_message_success(const San2::Utils::bytes& srpM2, San2::Utils::bytes &out);
int enc_parse_Q_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes &srpM2, unsigned char &errorCode);
int enc_testQ();

int enc_construct_C_message(const San2::Utils::bytes& request, San2::Utils::bytes &out);
int enc_parse_C_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes &request);
int enc_testC();

int enc_construct_R_message(const San2::Utils::bytes& response, unsigned char errorCode, San2::Utils::bytes &out);
int enc_parse_R_message(const San2::Utils::bytes &messageIn, San2::Utils::bytes& response, unsigned char &errorCode);
int enc_testR();

int enc_construct_D_message(San2::Utils::bytes &out);
int enc_parse_D_message(const San2::Utils::bytes &messageIn);
int enc_testD();
