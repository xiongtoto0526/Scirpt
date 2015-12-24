//package main
//
//import (
//	"crypto/cipher"
//	"crypto/des"
//	"errors"
//	"encoding/base64"
//	"bytes"
//	"fmt"
//)
//
//const USER_PWD_KEY = "KEGD^&#O"
//const DES_KEY = "JME*#$KF" // des crypt key lenght must be 8 in xunce system
//
//func PKCS5Padding(ciphertext []byte, blockSize int) []byte {
//	padding := blockSize - len(ciphertext)%blockSize
//	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
//	return append(ciphertext, padtext...)
//}
//
//func PKCS5UnPadding(origData []byte) []byte {
//	length := len(origData)
//	// 去掉最后一个字节 unpadding 次
//	unpadding := int(origData[length-1])
//	return origData[:(length - unpadding)]
//}
//
//
///**
//DES Encrypt: mode: CBC
//	the src is the Plaintext bytes to decode
//	the key length must be 8,
//	and the iv length must equal block size: 8,
//	return Ciphertext bytes
//**/
//func DESEncode(src, key, iv []byte) ([]byte, error) {
//	block, err := des.NewCipher(key)
//	if err != nil {
//		return nil, err
//	}
//	blocklen := block.BlockSize()
//	if blocklen != len(iv) {
//		return nil, errors.New("IV length must equal block size")
//	}
//	src = PKCS5Padding(src, blocklen)
//	cbc := cipher.NewCBCEncrypter(block, iv)
//	dst := make([]byte, len(src))
//	cbc.CryptBlocks(dst, src)
//	return dst, nil
//}
//
///**
//DES Decrypt: mode: CBC
//	the src is the Ciphertext bytes to decode
//	the key length must be 8,
//	and the iv length must equal block size: 8,
//	return Plaintext bytes
//**/
//func DESDecode(src, key, iv []byte) ([]byte, error) {
//	block, err := des.NewCipher(key)
//	if err != nil {
//		return nil, err
//	}
//	blocklen := block.BlockSize()
//	if blocklen != len(iv) {
//		return nil, errors.New("IV length must equal block size")
//	}
//	cbc := cipher.NewCBCDecrypter(block, iv)
//	dst := make([]byte, len(src))
//	cbc.CryptBlocks(dst, src)
//	return PKCS5UnPadding(dst), nil
//}
//
//
//
//
//func dePass() {
//	pass := "123456"
//
//	UESR_PWD_IV := []byte{0x13, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF}
//	encodeByte, _ := DESEncode([]byte(pass), []byte(USER_PWD_KEY), UESR_PWD_IV)
//	fmt.Println("encript pass:" + string(encodeByte))
//	newPass := base64.StdEncoding.EncodeToString(encodeByte)
//	fmt.Println("encode pass:" + newPass)
//
//	inputpass := "v+a10ONe8Yo="
//	encrypt_password_data, _ := base64.StdEncoding.DecodeString(inputpass)
//	password_data, _ := DESDecode(encrypt_password_data, []byte(DES_KEY), UESR_PWD_IV)
//	fmt.Println("decode pass:" + string(password_data))
//
//}
//
//
//func main(){
//
//	fmt.Printf("hello")
//	dePass()
//}
