package test

import (
	"gopkg.in/mgo.v2/bson"
	"gopkg.in/mgo.v2"
	"testing"
	"time"
	"github.com/yaosxi/mgox"
	"encoding/json"
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


var MONGODB_DATABASE string="test"


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



func TestFind(t *testing.T) {
	var users []User
	err := mgox.Dao().Find().Result(&users)
	if handleError(t, err) {
		return
	}
	println(users)
	println(len(users))
}


func TestInsert(t *testing.T) {
	err := mgox.Dao("111111").Insert(
		&User{Name : "xiongtoto123", Age : 2, Sex :1},
	)
	println("success...xht")
	if handleError(t, err) {
		return
	}
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
	db:=session.DB(MONGODB_DATABASE)
	collection := db.C("app")

	println("xht test db name is:"+ db.Name)

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

	operations := []bson.M{ o2, o3}

	//   =========3. do data analyse ===============================================
	// Prepare the query to run in the MongoDB aggregation pipeline
	results := []bson.M{}
	err1 := collection.Pipe(operations).All(&results)

	if len(results)>0 {
		output,_:=json.MarshalIndent(results, "", " ")
		println("result is :"+string(output))
	}

	if err1 != nil {
		println("ERROR : %sn", err)
		return
	}

	println("cmd is ok...")

}
