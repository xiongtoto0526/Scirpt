package test

import (
	"gopkg.in/mgo.v2/bson"
	"gopkg.in/mgo.v2"
	"testing"
	"time"
	"github.com/yaosxi/mgox"
	"encoding/json"
	"github.com/widuu/gojson"
	"fmt"
	"net/http"
	"io/ioutil"
//	"strconv"

	"strings"
	"strconv"
	"os"
	"io"
	"crypto/rand"
)


/*
db测试时,默认会使用本机的test数据库.
 */

func handleError(t *testing.T, err error) bool {
	if err == nil {
		return false
	}
	panic(err)
	t.Fail()
	return true
}


var MONGODB_DATABASE string = "test"


type User struct {
	Id           bson.ObjectId              `json:"id" bson:"_id,omitempty"`
	Name         string                     `json:"name"`
	Age          int                        `json:"age"`
	Sex          int                        `json:"sex"`
	FirstCreator string                     `json:"firstcreator"`
	FirstCreated time.Time                  `json:"firstcreated"`
	LastModifier string                     `json:"lastmodifier"`
	LastModified time.Time                  `json:"lastmodified"`
}

type DayInfoS struct {
	Day   int               `json:"day"`
	Year  int          `json:"year"`
	Month int          `json:"month"`
	Count int         `json:"count"`
}


//"_id": {
//"dayInfo": {
//"day": 26,
//"month": 11,
//"year": 2015
//}

type IPTemp struct {
	Id    bson.ObjectId              `json:"id" bson:"_id,omitempty"`
	Count int `json:"count"`
}


type IPDetail struct {
	Country   string `json:"country"`
	CountryId string `json:"country_id"`
	Area      string `json:"area"`
	AreaId    string `json:"area_id"`
	Region    string `json:"region"`
	RegionId  string `json:"region_id"`
	City      string `json:"city"`
	CityId    string `json:"city_id"`
	County    string `json:"county"`
	CountyId  string `json:"county_id"`
	Isp       string `json:"isp"`
	IspId     string `json:"isp_id"`
	Ip        string `json:"ip"`
}

type IPInfo struct {
	Ip     string `json:"ip"`
	Count  string `json:"count"`
	County string `json:"county"`
	Area   string `json:"area"`
	Region string `json:"region"`
	City   string `json:"city"`
}

var ipMap = make(map[string]interface{})


func TestIpCity(t *testing.T) {

	ip := "113.106.106.98"
	response, _ := http.Get("http://ip.taobao.com/service/getIpInfo.php?ip=" + ip)
	defer response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)
	println(response.Status)
	fmt.Println(string(body))

	s := string(body)
	c1 := gojson.Json(s).Get("data").Get("area")
	ipMap[ip] = c1.Tostring()
	println(ipMap[ip])
	if ipMap[ip] == nil {
		println("errr")
	}

	println(c1.Tostring())
}

func TestUpdate(t *testing.T) {
	db, _ := mgox.GetDatabase()

	o1 := bson.M{
		//		"ip" : "113.106.106.98",
		"_id" : bson.ObjectIdHex("5656b4833e5a2c071d00005b"),
		"client.country":bson.M{"$exists":true},
	}

	o2 := bson.M{"$set":bson.M{
		"client.country": "china111",
		"client.area": "华南1",
		//		"client.region":"广东1",
		"client.city":"珠海",
		"client.hee":"11112",
	}}
	//	o2 := bson.M{"$set":bson.M{"client":bson.M{
	//		"country": "china111",
	//		"area": "华南",
	//		"region":"广东1",
	//		"city":"珠海",
	//		"hee":"1111",
	//	}}}


	results := []bson.M{}

	//	_ = mgox.Dao().Set("downloadlog", o1, o2)

	db.C("downloadlog").UpdateAll(o1, o2);
	db.C("downloadlog").Find(o1).All(&results)

	db.C("app").UpdateAll(bson.M{"appid":"55bb3026e138230ee700000e"}, bson.M{"$set":bson.M{"downloadcount":11, "viewcount":555}})
	//	db.C("").Pipe()


	if len(results) > 0 {
		output, _ := json.MarshalIndent(results, "", " ")
		println("update result is :" + string(output))
	}

	var ips []string
	mgox.New().Find().Distinct("downloadlog", "client.ip", &ips)
	//	db.C("downloadlog").UpdateId(bson.ObjectIdHex("5656b4e13e5a2c071d00005d"),o2)

}


type ChanHe struct {
	Name string                    `json:"name"`
	St   int                        `json:"st"`
	Ed   int                        `json:"ed"`
}


func TestDayDownload(t *testing.T) {

	// 模拟数据
	startDayStr := "2015-11-26"
	endDayStr := "2016-11-27"

	//	//时间段,不转换时区
	startDayStr += " 00:00:00"
	endDayStr += " 00:00:00"
	beginDay, _ := time.Parse("2006-01-02 15:04:05", startDayStr)
	endDay, _ := time.Parse("2006-01-02 15:04:05", endDayStr)
	//


	//	时间段,转换时区
	//	startDay, _ := time.Parse("2006-01-02", startDayStr)
	//	endDay, _ := time.Parse("2006-01-02", en,dDayStr)
	//	diff := int(endDay.Sub(startDay).Hours() / 24)
	//	endDayStr += " 16:59:59"
	//	endDay, _ = time.Parse("2006-01-02 15:04:05", endDayStr)
	//	beginDay := endDay.AddDate(0, 0, -diff)
	//	fmt.Println("diff is:",diff)

	fmt.Println("start day is:", beginDay)
	fmt.Println("end day is:", endDay)

	// 条件
	o1 := bson.M{
		"$match": bson.M{
			"client":bson.M{"$exists":true},
			"firstcreated": bson.M{"$gt": beginDay, "$lt": endDay, },
			//			"client.ip" : "113.106.106.126",
		},
	}

	o2 := bson.M{
		"$group": bson.M{
			"_id": bson.M{"dayInfo":bson.M{
				"month": bson.M{"$month": "$localcreated" },
				"day": bson.M{"$dayOfMonth": "$localcreated" },
				"year": bson.M{"$year": "$localcreated"},
			}},
			"total": bson.M{
				"$sum": 1,
			},
			"date":  bson.M{
				"$first": "$localcreated",
			},
		},
	}


	o3 := bson.M{
		"$project":
		bson.M{
			//			"day":"$_id.dayInfo.day",
			//			"month":"$_id.dayInfo.month",
			//			"year":"$_id.dayInfo.year",
			//			"fullDate":bson.M{"$concat":[]string{
			//				    {"$substr":[]int{"$_id.dayInfo.month", 0, 2}},
			//					"/",
			//				    {"$substr":[]int{"$_id.dayInfo.day", 0, 2}},
			//					{"$substr":[]int{"$_id.dayInfo.year", 0, 4}},
			//			todo: 参考http://stackoverflow.com/questions/26736928/mongodb-group-by-duration-span
			//			}},
			"_id":0,
			"count": "$total",
			"date": bson.M{"$substr":[]interface{}{"$date", 0, 10 } },
		}}

	o4 := bson.M{"$sort" : bson.M{"date" : 1 } }

	//	{ $project: { element_id: '$_id.ord_dt.month', count: '$total' } },

	operations := []bson.M{o1, o2, o3, o4}

	db, err := mgox.GetDatabase()
	defer db.Session.Close()
	if err != nil {
		return;
	}

	results := []bson.M{}
	err = db.C("downloadlog").Pipe(operations).All(&results)
	output, _ := json.MarshalIndent(results, "", " ")
	println("result is :" + string(output))

	var ds []DayInfoS
	err = db.C("downloadlog").Pipe(operations).All(&ds)

	//		println("result is :%d" , ds[1].Day)
	//		println("result is :%d" , ds[1].Month)
	//	    println("result is :%d" , ds[1].Year)
	//		println("result is :%d" , ds[1].Count)
	//	   println(strconv.Itoa(ds[1].Year)+"-"+strconv.Itoa(ds[1].Month)+"-"+strconv.Itoa(ds[1].Day))


	//	output, _ := json.MarshalIndent(results, "", " ")
	//	println("result is :" + string(output))
	//	for i:=0;i<len(results);i++{
	//		output, _ := json.MarshalIndent(results[i], "", " ")
	//		c1 := gojson.Json(string(output)).Get("_id").Get("dayInfo").Get("day")
	//		println(c1)
	//	}

}


type CountInfo struct {
	ViewCount     int          `json:"viewcount"`
	DownloadCount int          `json:"downloadcount"`
}

func TestList(t *testing.T) {
	var ipinfos = [5]string{}
	for i := 0; i < 5; i++ {
		ipinfos[i] = "1"
	}
	println(ipinfos[2])
}

func TestSlice(t *testing.T) {
	a := []int{1, 2, 3, 4}
	//	sa := a[1:3]
	//	fmt.Printf("%p\n", sa) //输出：0xc0840046e0
	s := append(a, 11, 22, 33)
	println("okkk")
	println(a[1])
	fmt.Printf("sdds%p\n", s[6]) //输
}

func TestFindAppInfo(t *testing.T) {

	db, _ := mgox.GetDatabase()

	o1 := bson.M{
		"$match": bson.M{
			"appid":"55bb3026e138230ee700000e",
		},
	}

	o2 := bson.M{
		"$project": bson.M{
			"viewcount": "$viewcount",
			"downloadcount": "$downloadcount",
			"_id":0,
		},
	}

	//	operations := []bson.M{o1}
	operations := []bson.M{o1, o2}

	//   =========3. do data analyse ===============================================
	// Prepare the query to run in the MongoDB aggregation pipeline
	results := []bson.M{}
	db.C("app").Pipe(operations).All(&results)

	var countinfo []CountInfo
	db.C("app").Pipe(operations).All(&countinfo)



	if len(countinfo) > 0 {
		println("len is :%d", len(countinfo))
		println("downloadCount is :%d", countinfo[0].DownloadCount)
		println("viewCount is :%d", countinfo[0].ViewCount)
	}

	if len(results) > 0 {
		output, _ := json.MarshalIndent(results, "", " ")
		println("result is :" + string(output))
	}

}

func TestTimeConvfunc(t *testing.T) {
	//	tm1, err := time.Parse("2015/09/01", "2016/09/01")
	//	tm2, err := time.Parse("2015/09/08", "2015/09/08")

	startDay, err1 := time.Parse("2006-01-02", "2006-01-02")
	endday, err2 := time.Parse("2006-01-02", "2006-01-03")

	if err1 != nil || err2 != nil {
		println("time fomat error!!!")
	}else {
		fmt.Println("fomat ok!!")
	}

	if startDay.Before(endday) {
		println("check ok1")
	}else {
		println("check err1")
	}

}

// testTime

func TestTimezoneInsert(t *testing.T) {
	err := mgox.New("111111").Insert(
		&User{Name : "xiongtoto456", Age : 8, Sex :1, FirstCreated:time.Now()},
	)


	println("success...xht")
	if handleError(t, err) {
		return
	}

	var usr User
	mgox.New().Find(bson.M{"name":"xiongtoto456"}).Result(&usr)

	println(usr.FirstCreated.String())

	//	if len(results) > 0 {
	//		output, _ := json.MarshalIndent(results, "", " ")
	//		println("result is :" + string(output))
	//	}

}

func TestInsert(t *testing.T) {
	err := mgox.New("111").Insert(
		&User{Name : "xiongtoto456", Age : 8, Sex :1},
	)
	println("success...xht")
	if handleError(t, err) {
		return
	}

	results := []bson.M{}
	mgox.New().Find(bson.M{}).Result(&results)

	if len(results) > 0 {
		output, _ := json.MarshalIndent(results, "", " ")
		println("result is :" + string(output))
	}

}


func TestTimezone(t *testing.T) {
	location, _ := time.LoadLocation("America/New_York")
	println(location.String())
	year := 2015
	month := 1
	day := 11
	hour := 13
	minute := 57

	localTime := time.Date(year, time.Month(month), day, hour, minute, 0, 0, location)
	//	utcTime := localTime.UTC()

	fmt.Println("localtime:", localTime)

	//	var t0=time.Now()
	//offset = 秒
	zoneName, offset := localTime.Local().Zone()
	println("zone name is:%s,offset is:%d", zoneName, offset)
	newtime := localTime.Add(time.Duration(offset * 1000000000))
	fmt.Println("newtime:", newtime)

	startDay, _ := time.Parse("2006-01-02", "2015-02-12")
	localTime = time.Date(2015, time.Month(2), 12, 0, 0, 0, 0, time.Local)

	fmt.Println("xht:", startDay.Local())
	fmt.Println("xht1:", localTime)

	t1 := time.Now();
	fmt.Println("diff is:", t1)
	year, month, day = convert2ymd("2015-09-28")
	println("xht2:", year, month, day)
}


func convert2ymd(dateStr string) (year, month, day int) {
	yearStr := strings.Split(dateStr, "-")[0]
	monthStr := strings.Split(dateStr, "-")[1]
	dayStr := strings.Split(dateStr, "-")[2]
	year, _ = strconv.Atoi(yearStr)
	month, _ = strconv.Atoi(monthStr)
	day, _ = strconv.Atoi(dayStr)
	return year, month, day
}


func TestPipe(t *testing.T) {

	dialInfo := &mgo.DialInfo{
		Addrs:    []string{"127.0.0.1"},
		Timeout:  10 * time.Second,
		Database: "tako",
		Username: "tako",
		Password: "tako",
	}


	// Connect to MongoDB and establish a connection
	session, err := mgo.DialWithInfo(dialInfo)
	if err != nil {
		println("db create ERROR : %s", err)
		return
	}

	println("db create success")

	// Capture a reference to the collection
	db := session.DB(MONGODB_DATABASE)
	collection := db.C("app")

	println("xht test db name is:" + db.Name)

	//   =========2. define the query condition==============================================
	//	o1 := bson.M{
	//		"$match": bson.M{
	//		},
	//	}

	o2 := bson.M{
		"$match": bson.M{
			"email": "jouje@163.com",
		},
	}

	o3 := bson.M{
		"$group": bson.M{
			"_id": "$email",
			"count": bson.M{
				"$sum": 1,
			},
		},
	}

	operations := []bson.M{o2, o3}

	//   =========3. do data analyse ===============================================
	// Prepare the query to run in the MongoDB aggregation pipeline
	results := []bson.M{}
	err1 := collection.Pipe(operations).All(&results)

	var ips1 []IPInfo
	collection.Pipe(operations).All(&ips1)
	println(ips1[0].City)

	var ips2 []IPTemp
	collection.Pipe(operations).All(&ips2)
	println("ips2 id :")
	println(ips2[0].Count)



	if len(results) > 0 {
		output, _ := json.MarshalIndent(results, "", " ")
		println("result xht is :" + string(output))
	}

	if err1 != nil {
		println("ERROR : %sn", err)
		return
	}

	println("cmd is ok...")

}


/*
reference:
- https://godoc.org/labix.org/v2/mgo
- https://docs.mongodb.org/manual/tutorial/map-reduce-examples/

1. prepare data in test-db:
db.orders.save({_id: ObjectId("50a8240b927d5d8b5891743c"),cust_id: "abc123",ord_date: new Date("Oct 04, 2012"),status: 'A',price: 25,items: [ { sku: "ss1", qty: 5, price: 2.5 },{ sku: "nnn", qty: 5, price: 2.5 } ]})
db.orders.save({_id: ObjectId("50a8240b927d5d8b5891744c"),cust_id: "abc123",ord_date: new Date("Oct 04, 2012"),status: 'A',price: 21,items: [ { sku: "sss2", qty: 5, price: 2.5 },{ sku: "nnn", qty: 5, price: 2.5 } ]});
db.orders.save({_id: ObjectId("50a8240b927d5d8b5891745c"),cust_id: "abc124",ord_date: new Date("Oct 04, 2012"),status: 'B',price: 29,items: [ { sku: "sss3", qty: 5, price: 2.5 },{ sku: "nnn", qty: 5, price: 2.5 } ]});
db.orders.save({_id: ObjectId("50a8240b927d5d8b5891746c"),cust_id: "abc125",ord_date: new Date("Oct 04, 2012"),status: 'A',price: 11,items: [ { sku: "sss4", qty: 5, price: 2.5 },{ sku: "nnn", qty: 5, price: 2.5 } ]});

2. execute in mongo-shell
var mapFunction1 = function() {
                       emit(this.cust_id, this.price);
                   };
var reduceFunction1 = function(keyCustId, valuesPrices) {
                       return Array.sum(valuesPrices);
                   };

db.orders.mapReduce(
                     mapFunction1,
                     reduceFunction1,
                     { out: "map_reduce_example" }
                   )

3. show the shell result
{
	"result" : "map_reduce_example",
	"timeMillis" : 117,
	"counts" : {
		"input" : 4,
		"emit" : 4,
		"reduce" : 1,
		"output" : 3
	},
	"ok" : 1
}
*/
func TestMapReduce(t *testing.T) {

	println("aa:",1<<5)

	dialInfo := &mgo.DialInfo{
		Addrs:    []string{"127.0.0.1"},
		Timeout:  10 * time.Second,
		Database: "tako",
		Username: "tako",
		Password: "tako",
	}


	// Connect to MongoDB and establish a connection
	session, err := mgo.DialWithInfo(dialInfo)
	if err != nil {
		println("db create ERROR : %s", err)
		return
	}

	println("db create success")

	// Capture a reference to the collection
	db := session.DB(MONGODB_DATABASE)


	job := &mgo.MapReduce{
		Map:      "function() {emit(this.cust_id, this.price);};",
		Reduce:   "function(keyCustId, valuesPrices) {return Array.sum(valuesPrices);};",
	}

	result := []bson.M{}

	_, err1 := db.C("orders").Find(nil).MapReduce(job, &result)
	if err1 != nil {
		return
	}
	if len(result) > 0 {
		output, _ := json.MarshalIndent(result, "", " ")
		println("map reduce result is :" + string(output))
	}

	count := 1000000
	for i := 0; i < count; i++ {
		//Push(randIp(), nil, nil)
		go func() {
			d:=mgox.Connect()
			defer  d.Close()
			mgox.New("111111").Insert(
				&User{Name : "xiongtoto456", Age : 8, Sex :1, FirstCreated:time.Now()},
			)
		}()
	}


}

type Cb1 func(string,string)

func TestGs(t *testing.T) {
	a:= func(p1 string, p2 string) { println("will do cb1"); println("param1 is:"+p1) }
	a(getStr(),"e")


	res, _ := http.Get("http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg")
	file, _ := os.Create("xxx.jpg")
	io.Copy(file, res.Body)
	println("finish...")
//	count := 1000000
//	for i := 0; i < count; i++ {
//		//Push(randIp(), nil, nil)
//		testP();
//	}
}

func getStr()(string)  {
	println("will get string...")
	return "123"
}

func testP()  {
	go func() {
		mgox.New("111111").Insert(
			&User{Name : "xiongtoto456", Age : 8, Sex :1, FirstCreated:time.Now()},
		)
	}()
}


func TestGenDays(t *testing.T) {
	ret:=make(map[string]string)
	begin:=Convert2localDate("2015-03-09");
	end:=Convert2localDate("2015-04-02");
	temp:= begin.AddDate(0,0,1)
	ret[temp.Format("2006-01-02")]=""
	for{
		temp = temp.AddDate(0,0,1)
		ret[temp.Format("2006-01-02")]=""
		if temp.Equal(end) {
			break
		}
	}

	for key,_ :=range ret{
		println("key is:",key)
	}
}


/*
  输入:日期字符格式:"2015-11-22"
  输出:本地时区时间.非utc时间
  */
func Convert2localDate(dateStr string) (time.Time) {
	yearStr := strings.Split(dateStr, "-")[0]
	monthStr := strings.Split(dateStr, "-")[1]
	dayStr := strings.Split(dateStr, "-")[2]
	year, _ := strconv.Atoi(yearStr)
	month, _ := strconv.Atoi(monthStr)
	day, _ := strconv.Atoi(dayStr)
	localdate := time.Date(year, time.Month(month), day, 0, 0, 0, 0, time.Local)
	return localdate
}

func TestMapReduceLocation(t *testing.T) {

	println("aa:",1<<5)

	dialInfo := &mgo.DialInfo{
		Addrs:    []string{"127.0.0.1"},
		Timeout:  10 * time.Second,
		Database: "tako",
		Username: "tako",
		Password: "tako",
	}


	// Connect to MongoDB and establish a connection
	session, err := mgo.DialWithInfo(dialInfo)
	if err != nil {
		println("db create ERROR : %s", err)
		return
	}

	println("db create success")

	// Capture a reference to the collection
	db := session.DB(MONGODB_DATABASE)


	job := &mgo.MapReduce{
		Map:      "function() {emit(this.cust_id, this.price);};",
		Reduce:   "function(keyCustId, valuesPrices) {return Array.sum(valuesPrices);};",
	}

	result := []bson.M{}
	_, err1 := db.C("orders").Find(nil).MapReduce(job, &result)
	if err1 != nil {
		return
	}
	if len(result) > 0 {
		output, _ := json.MarshalIndent(result, "", " ")
		println("map reduce result is :" + string(output))
	}

}



type CallBack func(string)

// 测试重复IP的情况，
// 通过修改数据库中的记录也测试过期的情况,
// 测试执行完请求之后自动切换状态到suspended的情况
func TestResolveRepeatIp(t *testing.T) {
	a := func(ip string) {
//		println("routine is ok:"+ip)
//		 mgox.New("111111").Insert(
//			&User{Name : "xiongtoto456", Age : 8, Sex :1, FirstCreated:time.Now()},
//		)
		println("insert is ok:"+ip)
	}

	for i:=0;i<10000 ;i++  {
		GetClientInfoWithcallback(randIp(), a)
	}
	for{}
}


func GetClientInfoWithcallback(ip string, callback CallBack) {
	go work4GetClientIpInfoWithCallback(ip, callback)
}

func work4GetClientIpInfoWithCallback(ip string, cb CallBack) {
	cb(GetIpInfo(ip))
}

// 生成随机IP用于测试
func randIp() string {
	random := make([]byte, 4)
	for {
		rand.Read(random[:])
		// 判断第一位非0
		if fmt.Sprintf("%x", random[0]) != "0" {
			break
		}
	}

	ip := []string{}
	for _, b := range random {
		segment, _ := strconv.ParseUint(fmt.Sprintf("%x", b), 16, 0)
		ip = append(ip, strconv.Itoa(int(segment)))
	}
	return strings.Join(ip, ".")
}



/*
使用淘宝代理查询ip
*/
func GetIpInfo(ip string) (string) {

	//	println("return 2")
	//	return "2"
	if ip == "127.0.0.1" {
		return "1"
	}
	response, err := http.Get("http://ip.taobao.com/service/getIpInfo.php?ip=" + ip)



	defer response.Body.Close()

	if err != nil || response.StatusCode != http.StatusOK {
		return "2"
	}
//	defer response.Body.Close()

	body, _ := ioutil.ReadAll(response.Body)
	s := string(body)
	gojson.Json(s).Get("data").Get("country").Tostring()// 中国
	gojson.Json(s).Get("data").Get("area").Tostring()// 华南
	gojson.Json(s).Get("data").Get("region").Tostring()// 广东省
	gojson.Json(s).Get("data").Get("city").Tostring()// 广东省

	return "3"
}
