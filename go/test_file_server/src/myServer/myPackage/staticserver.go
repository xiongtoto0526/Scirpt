package main

import (
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"time"
	"github.com/kimiazhu/log4go"
)



var mux map[string]func(http.ResponseWriter, *http.Request)

type Myhandler struct{}
type home struct {
	Title string
}

const (
	Template_Dir = "./view/"
	Upload_Dir   = "./upload/"
)

func main() {
	
	// log4go.Info(fmt.Sprintf("User [uid=%s] have no permission to this app [xgAppId=%s]", "userid", "xgAppId"))
	log4go.Info("begin start...")

	server := http.Server{
		Addr:        ":9090",
		Handler:     &Myhandler{},
		ReadTimeout: 10 * time.Second,
	}
	mux = make(map[string]func(http.ResponseWriter, *http.Request))
	mux["/"] = index
	mux["/upload"] = upload
	// mux["/file"] = StaticServer
	mux["/JSPatch"] = StaticServer
	server.ListenAndServe()
	log4go.Info("start successful...")
}

func (*Myhandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if h, ok := mux[r.URL.String()]; ok {
		h(w, r)
		return
	}
	if ok, _ := regexp.MatchString("/css/", r.URL.String()); ok {
		http.StripPrefix("/css/", http.FileServer(http.Dir("./css/"))).ServeHTTP(w, r)
	} else {
		http.StripPrefix("/", http.FileServer(http.Dir("./upload/"))).ServeHTTP(w, r)
	}

}

func upload(w http.ResponseWriter, r *http.Request) {
	log4go.Info("begin upload...")
	if r.Method == "GET" {
		t, _ := template.ParseFiles(Template_Dir + "file.html")
		t.Execute(w, "上传文件")
	} else {
		r.ParseMultipartForm(32 << 20)
		file, handler, err := r.FormFile("uploadfile")
		if err != nil {
			fmt.Println(w, "%v", "上传错误")
			return
		}
		fileext := filepath.Ext(handler.Filename)
		if check(fileext) == false {
			fmt.Fprintf(w, "%v", "不允许的上传类型")
			return
		}
		filename := strconv.FormatInt(time.Now().Unix(), 10) + fileext
		f, _ := os.OpenFile(Upload_Dir+filename, os.O_CREATE|os.O_WRONLY, 0660)
		_, err = io.Copy(f, file)
		if err != nil {
			fmt.Fprintf(w, "%v", "上传失败")
			return
		}
		filedir, _ := filepath.Abs(Upload_Dir + filename)
		fmt.Fprintf(w, "%v", filename+"上传完成,服务器地址:"+filedir)
	}
	log4go.Info("upload successful...")
}

func index(w http.ResponseWriter, r *http.Request) {
	log4go.Info("begin index...")

	title := home{Title: "首页"}
	t, _ := template.ParseFiles(Template_Dir + "index.html")
	t.Execute(w, title)
	log4go.Info("index successful...")

}

func StaticServer(w http.ResponseWriter, r *http.Request) {
	log4go.Info("begin StaticServer...")

	http.StripPrefix("/JSPatch", http.FileServer(http.Dir("./upload/"))).ServeHTTP(w, r)
	log4go.Info("StaticServer successful...")
}

func check(name string) bool {
	log4go.Info("begin check, note : js,png,exe file is not valid !!!")
	ext := []string{".exe", ".js", ".png"}

	for _, v := range ext {
		if v == name {
			return false
		}
	}
	return true
}

func init() {
	 log4go.LoadConfiguration("conf/log4go.xml")
}

