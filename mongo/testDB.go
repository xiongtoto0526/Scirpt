//   =======1. get the db session =================================================
// Create MongoDB connectivity parameters
dialInfo := &amp;mgo.DialInfo{
    Addrs:    []string{DBDB_HOST},
    Timeout:  10 * time.Second,
    Database: MONGODB_DATABASE,
    Username: MONGODB_USERNAME,
    Password: MONGODB_PASSWORD,
}
 
// Connect to MongoDB and establish a connection
// Only do this once in your application.
// There is a lot of overhead with this call.
session, err := mgo.DialWithInfo(dialInfo)
if err != nil {
 
    fmt.Printf("ERROR : %s", err)
    return
}
 
// Capture a reference to the collection
collection := session.DB(MONGODB_DATABASE).C("buoy_stations")

//   =========2. define the query condition===============================================
Latitude := 27.945886
Longitude := -82.798676
MaxDistance := (30.0 / DISTANCE_MULTIPLIER)
 
o1 := bson.M{
    "$geoNear": bson.M{
        "near": []float64{this.Longitude, this.Latitude},
        "query": bson.M{
            "condition.wind_speed_milehour": bson.M{"$ne": nil},
            },  
        "distanceField": "distance",
        "maxDistance": this.MaxDistance,   
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
err := pipe.All(&amp;results)
 
if err != nil {
 
    fmt.Printf("ERROR : %sn", err)
    return
}
 
// Capture the average wind speed
avgWindSpeed := results[0]["average_wind_speed"].(float64)
 
fmt.Printf("Average Wind Speed : %.2fn", avgWindSpeed)

//   ========================================================

cmd = bson.D{
			{"delete", c.Name},
			{"deletes", []interface{}{op}},
			{"writeConcern", writeConcern},
			{"ordered", ordered},
		}


db.runCommand(
   {
      delete: "orders",
      deletes: [ { q: { status: "D" }, limit: 0 } ],
      writeConcern: { w: "majority", wtimeout: 5000 }
   }
)


cmd = bson.D{
	        {"aggregate", c.Name},
	        {"pipeline", []interface{}{op}},
}

db.runCommand( { aggregate: "orders",
                 pipeline: [
                             { $match: { appid: "123" } },
                             { $group: { _id: "$version", count: { $sum: 1 } } }
                           ]
              } )


var result writeCmdResult
	err = c.Database.run(socket, cmd, &result)
	debugf("Write command result: %#v (err=%v)", result, err)


	pipe := collection.Pipe([]bson.M{{"$match": bson.M{"name": "Otavio"}}})
