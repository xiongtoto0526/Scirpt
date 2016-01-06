package main

import (
	"gopkg.in/mgo.v2/bson"
	"gopkg.in/mgo.v2"
	"time"
	"fmt"
)

var MONGODB_DATABASE string="127.0.0.1"
var DISTANCE_MULTIPLIER string=""

func main()  {
	//   =======1. get the db session =================================================
	// Create MongoDB connectivity parameters

	dialInfo := &mgo.DialInfo{
		Addrs:    []string{"127.0.0.1"},
		Timeout:  10 * time.Second,
		Database: "tako",
		Username: "tako",
		Password: "tako",
	}



	session1, err := mgo.Dial("127.0.0.1")
	if err != nil {
		panic(err)
	}
	defer session1.Close()

	// Connect to MongoDB and establish a connection
	// Only do this once in your application.
	// There is a lot of overhead with this call.
	session, err := mgo.DialWithInfo(dialInfo)
	if err != nil {
		fmt.Printf("db create ERROR : %s", err)
		return
	}

	// Capture a reference to the collection
	collection := session.DB(MONGODB_DATABASE).C("app")

	//   =========2. define the query condition==============================================

	o1 := bson.M{
		"$project": bson.M{
			"appname": 1,
			"platform": 1,
			"_id": 0,
		},
	}

	o2 := bson.M{
		"$match": bson.M{
			"appid": "123",
		},
	}

	o3 := bson.M{
		"$group": bson.M{
			"_id": "$version",
			"count": bson.M{
				"$sum": 1,
			},
		},
	}

	operations := []bson.M{o1, o2, o3}

	//   =========3. do data analyse ===============================================
	// Prepare the query to run in the MongoDB aggregation pipeline
	pipe := collection.Pipe(operations)

	// Run the queries and capture the results
	results := []bson.M{}
	err1 := pipe.All(&results)

	if err1 != nil {
		fmt.Printf("ERROR : %sn", err)
		return
	}

	// Capture the average wind speed
	appname := results[0]["appname"].(string)
	fmt.Printf("app is : "+appname)

	//   ========================================================
/*

All the query code above is equal to this db shell:
	db.app.aggregate(
	{
	{"$project" : {
	"appname" : 1,
	"platform" : 1,
	"_id" : 0
	}
	},
	{"$match":{
	"appid":"123"}
	},
	{"$group" : {
	"_id" : "$version",
	"count" : {"$sum" : 1}
	}
	}
)
*/

}
