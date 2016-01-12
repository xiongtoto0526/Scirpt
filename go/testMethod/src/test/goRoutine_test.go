package test
// Simple app that bulk renames files using Go routines and channels.
// Uses a _worker pool_ some goroutines and channels to get the job done.
// To run the scrip:
// go run rename_worker_pool.go -source /var/tmp/data/source/ltesumo/ -target ~/Documents/ReleaseTesting/sfarancoll2/data/ltesumo/ -preface OHDR -sufix iris-lte-sumo
// Please Note: This REMOVES the files in the source dir


import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"time"
)

// Job struct to define all the bits needed
//
type Job struct {
	Jobid       int
	Source      string
	SourceFile  string
	Destination string
	Prefix      string
	Suffix      string
}

// Here's the worker, of which we'll run several
// concurrent instances. These workers will receive
// work on the `jobs` channel and send the corresponding
// results on to the `results` channel.
func worker(id int, jobs <-chan Job, results chan <- int) {
	for j := range jobs {

		x := time.Now().Add(time.Second * time.Duration(j.Jobid))
		myTimeStamp := fmt.Sprintf("%d%02d%02d.%02d%02d%02d",
			x.Year(), x.Month(), x.Day(),
			x.Hour(), x.Minute(), x.Second())
		newFileName := j.Prefix + "." + myTimeStamp + "." + j.Suffix
		fmt.Println("Processing ", j.Source + j.SourceFile, " - New file : ", j.Destination + newFileName)

		// rename the old file with the new name
		// basically a MOVE from one dir to another
		sourceFile := j.Source + j.SourceFile
		targetFile := j.Destination + newFileName

		err := os.Rename(sourceFile, targetFile)
		if err != nil {
			fmt.Println(err)
			return
		}

		results <- j.Jobid
	}
}

func main() {

	// params from the user
	sourceDirPtr := flag.String("source", "/var/foo", "Directory to process.")
	targetDirPtr := flag.String("target", "/var/tmp", "Directory to save to.")
	fnPre := flag.String("preface", "CDR", "Filename prefix to use.")
	fnSfx := flag.String("sufix", "atp", "Filename suffix to use.")

	flag.Parse()

	dirToProcess := *sourceDirPtr
	dirToSave := *targetDirPtr
	filenamePRE := *fnPre
	filenameEND := *fnSfx

	// DO NOT ALLOW the user to have the source and dest dirs the same.
	match, _ := regexp.MatchString(dirToProcess, dirToSave)
	if match {
		fmt.Println("Ah jaysus there's an exception : you have the source and destination dirs the same. Sorry cannot allow that. !!")
		os.Exit(-1)
	}

	// Display the params used
	fmt.Println("Source dir : ", dirToProcess)
	fmt.Println("Dest dir : ", dirToSave)
	fmt.Println("file name Prefix : ", filenamePRE)
	fmt.Println("file name Suffix : ", filenameEND)

	// the files to process are located in the source param passed in by the user
	files, err := ioutil.ReadDir(*sourceDirPtr)
	if err != nil {
		log.Fatal(err)
	}

	// check the number of files we need to process
	numFiles := len(files)

	fmt.Println("Number of files to process : ", numFiles)

	// In order to use our pool of workers we need to send
	// them work and collect their results. We make 2 buffered
	// channels for this. The buffer sizes are set to the number of items to process
	// i.e. the number of files in the source dir.
	jobs := make(chan Job, numFiles)
	results := make(chan int, numFiles)

	// This starts up 3 workers, initially blocked
	// because there are no jobs yet. 3 is just a number, can be higher or lower
	for w := 1; w <= 3; w++ {
		go worker(w, jobs, results)
	}

	// Here we send the `jobs` and then `close` that
	// channel to indicate that's all the work we have.
	// numFiles is the count of files in the source dir
	j := 1
	for _, f := range files {
		fmt.Println("File Name : ", f.Name())
		s := Job{Jobid: j, Source: dirToProcess, SourceFile: f.Name(), Destination: dirToSave, Prefix: filenamePRE, Suffix: filenameEND}
		j = j + 1
		fmt.Println("Job description : ", s)
		jobs <- s
	}
	close(jobs)

	// Finally we collect all the results of the work.
	for a := 1; a <= numFiles; a++ {
		<-results
	}
}
