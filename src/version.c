/* version.c */
/* Autogenerated by Makefile - DO NOT EDIT */

const char *version_string = "1.14";
const char *compilation_string = "gcc -DHAVE_CONFIG_H -DSYSTEM_WGETRC=\"/usr/local/etc/wgetrc\" -DLOCALEDIR=\"/usr/local/share/locale\" -I. -I../lib -I../lib -O2 -Wall";
const char *link_string = "gcc -O2 -Wall -lssl -lcrypto -lz -ldl -lz -lz -lidn -luuid -lpcre -lrt ftp-opie.o openssl.o http-ntlm.o ../lib/libgnu.a";
