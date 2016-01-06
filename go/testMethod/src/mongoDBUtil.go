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
//		Username: "tako",
//		Password: "tako",
	}

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

	//   =========2. define the query condition===============================================
	Latitude := 27.945886
	Longitude := -82.798676
	MaxDistance := (30.0 / DISTANCE_MULTIPLIER)

	o1 := bson.M{
		"$geoNear": bson.M{
			"near": []float64{Longitude, Latitude},
			"query": bson.M{
				"condition.wind_speed_milehour": bson.M{"$ne": nil},
			},
			"distanceField": "distance",
			"maxDistance": MaxDistance,
			"spherical": true,
			"distanceMultiplier": DISTANCE_MULTIPLIER,
		},
	}

	o2 := bson.M{
		"$project": bson.M{
			"station_id": "$station_id",
			"wind_speed": "$condition.wind_speed_milehour", "_id": 0,
		},
	}

	o3 := bson.M{
		"$group": bson.M{
			"_id": 1,
			"average_wind_speed": bson.M{
				"$avg": "$wind_speed",
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
	avgWindSpeed := results[0]["average_wind_speed"].(float64)

	fmt.Printf("Average Wind Speed : %.2fn", avgWindSpeed)

	//   ========================================================
/*

All the query code above is equal to this db shell:
	db.app.aggregate(
	{"$geoNear": {
	"near": [-82.798676,27.945886],
	"query": {"condition.wind_speed_milehour" : {"$ne" : null}},
	"distanceField": "distance",
	"maxDistance": 0.00756965597428,
	"spherical": true,
	"distanceMultiplier": 3963.192
	}
	},
	{"$project" : {
	"station_id" : "$station_id",
	"wind_speed" : "$condition.wind_speed_milehour",
	"_id" : 0
	}
	},
	{"$group" : {
	"_id" : 1,
	"total_stations" : {"$sum" : 1},
	"average_wind_speed" : {"$avg" : "$wind_speed"}
	}
	}
)
*/

}
