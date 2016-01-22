
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
