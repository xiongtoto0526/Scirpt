package main
import (
	"bufio"
	"io"
//	"io/ioutil"
	"strconv"
	"time"
	"os"
	"bytes"
	"encoding/base64"
	"fmt"
	"crypto/cipher"
	"crypto/des"
	"errors"
	"strings"
	"crypto/hmac"
	"crypto/sha1"
	"encoding/hex"
)

const HMAC_KEY = "xgsdkNiuxgsdkNiu"
const USER_PWD_KEY = "KEGD^&#O"
const DES_KEY = "JME*#$KF" // des crypt key lenght must be 8 in xunce system
var firstIn bool = true



var help = `
	usage: ./readFile [inputFile] [outputFile]

	for example:
	takoup /root/test/input.csv /root/test/output.sql

	Ouputs:
	00    - success
	01    - miss param
	other - failed

	`


func main() {

	// 参数检查
	if len(os.Args) < 3 {
		fmt.Println("")
		fmt.Println("01:miss param")
		fmt.Println("======help======")
		fmt.Println(help)
		return
	}

	// 读取参数
	inputFile := os.Args[1]
	outputFile := os.Args[2]

	//如果输出文件存在,先删除,再创建.
	if IsFileExist(outputFile) {
		os.Remove(outputFile)
	}
	os.Create(outputFile)


	writeNewLine("#delete from user_tako where userid like 'tako_%';")
	// processLine函数中处理回调
	ReadLine(inputFile, processLine)

	fmt.Print("00:success")
}


// 成功读取一行后的回调函数
func processLine(line []byte) {

	temp := string(line)
	if temp == "" {
		return
	}
	fmt.Println("original line:" + temp)
	filedArray1 := strings.Split(temp, ",")

	// 处理userId
	filedArray1[0] = processUserId(filedArray1[0])//回写
	if filedArray1[0] == "tako__id" {
		// 首行忽略
		return;
	}

	// 处理password
	filedArray1[3] = processPassword(filedArray1[3])//回写

	// 处理createtime
	filedArray1[4] = processCreatetime(filedArray1[4])//回写

	// 输出转换后的行
	newline := generateNewline(filedArray1)

	// 写入文件
	writeNewLine(newline)

}




/*
 process Feild
 */

// 处理密码
func processPassword(password string) string {
	fmt.Println("old password is:" + password)
	UESR_PWD_IV := []byte{0x13, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF}
	if password != "\"\"" {
		encrypt_password_data, _ := base64.StdEncoding.DecodeString(password)
		password_data, _ := DESDecode(encrypt_password_data, []byte(USER_PWD_KEY), UESR_PWD_IV)
		password = string(password_data)
	}

	fmt.Println("decode password is:" + password)
	password = HmacSha1(HMAC_KEY, password)
	fmt.Println("hmacSha1 new password is:" + password)
	return password
}

// 处理createtime
func processCreatetime(createtime string) string {
	fmt.Println("old createtime is:" + createtime)
	i, err := strconv.ParseInt(createtime, 10, 64)
	if err != nil {
		panic(err)
	}
	var s string = time.Unix(i, 0).Format("2006-01-02 15:04:05")
	fmt.Println("new createtime is:" + s)
	return s
}

func processUserId(userId string) string {
	fmt.Println("old userId is:" + userId)
	userId = strings.Replace(userId, "ObjectId(", "", 1)
	userId = "tako_" + strings.Replace(userId, ")", "", 1)
	fmt.Println("new userId is:" + userId)
	return userId
}


/*
  some utils
 */

// 读取行
func ReadLine(filePth string, hookfn func([]byte)) error {
	f, err := os.Open(filePth)
	if err != nil {
		return err
	}
	defer f.Close()
	bfRd := bufio.NewReader(f)
	for {
		line, err := bfRd.ReadBytes('\n')
		hookfn(line) //放在错误处理前面，即使发生错误，也会处理已经读取到的数据。
		if err != nil { //遇到任何错误立即返回，并忽略 EOF 错误信息
			if err == io.EOF {
				return nil
			}
			return err
		}
	}
	return nil
}

// 输出新行
func generateNewline(filedArray1 []string) string {
	var newline string = "INSERT INTO user_tako (userid,username,email,password,createtime,disabled,active,nickname,channel,mobile,realname,gender,image,address)"
	newline += "VALUES ("
	for i := 0; i < len(filedArray1) - 1; i++ {
		if filedArray1[i] == "\"\"" {
			newline += "'',"
		}else if filedArray1[i] == "true" || filedArray1[i] == "false" {
			newline += filedArray1[i] + ","
		}else {
			newline += "'" + filedArray1[i] + "',"
		}
	}
	newline += ")"
	newline = strings.Replace(newline, ",)", ");", 1)
	fmt.Println("newline is:" + newline)
	return newline
}

// 写入文件,append mode
func writeNewLine(newline string) {
	f, err := os.OpenFile(os.Args[2], os.O_APPEND | os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}

	defer f.Close()

	if !firstIn {
		f.WriteString("\n")
	}

	if _, err = f.Write([]byte(newline)); err != nil {
		panic(err)
	}
	firstIn = false
}

// 检查文件存在
func IsFileExist(filename string) (bool) {
	var exist = true;
	if _, err := os.Stat(filename); os.IsNotExist(err) {
		exist = false;
	}
	return exist;
}

// padding
func PKCS5Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext) % blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

// unpadding
func PKCS5UnPadding(origData []byte) []byte {
	length := len(origData)
	// 去掉最后一个字节 unpadding 次
	unpadding := int(origData[length - 1])
	return origData[:(length - unpadding)]
}

// des加密
func DESEncode(src, key, iv []byte) ([]byte, error) {
	block, err := des.NewCipher(key)
	if err != nil {
		return nil, err
	}
	blocklen := block.BlockSize()
	if blocklen != len(iv) {
		return nil, errors.New("IV length must equal block size")
	}
	src = PKCS5Padding(src, blocklen)
	cbc := cipher.NewCBCEncrypter(block, iv)
	dst := make([]byte, len(src))
	cbc.CryptBlocks(dst, src)
	return dst, nil
}

// des解密
func DESDecode(src, key, iv []byte) ([]byte, error) {
	block, err := des.NewCipher(key)
	if err != nil {
		return nil, err
	}
	blocklen := block.BlockSize()
	if blocklen != len(iv) {
		return nil, errors.New("IV length must equal block size")
	}
	cbc := cipher.NewCBCDecrypter(block, iv)
	dst := make([]byte, len(src))
	cbc.CryptBlocks(dst, src)
	return PKCS5UnPadding(dst), nil
}

// HmacSha1
func HmacSha1(inputKey, content string) string {
	key := []byte(inputKey)
	mac := hmac.New(sha1.New, key)
	mac.Write([]byte(content))
	s := hex.EncodeToString(mac.Sum(nil))
	return s
}
