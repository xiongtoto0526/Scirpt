package test

import (
	"fmt"
	"testing"
	"net/http"
)

var urls = []string{
	"http://pulsoconf.co/",
	"http://golang.org/",
	"http://matt.aimonetti.net/",
}

type HttpResponse struct {
	url      string
	response *http.Response
	err      error
}

func asyncHttpGets(urls []string) <-chan *HttpResponse {
	ch := make(chan *HttpResponse, len(urls)) // buffered
	for _, url := range urls {
		go func(url string) {
			fmt.Printf("Fetching %s \n", url)
			resp, err := http.Get(url)
			resp.Body.Close()
			ch <- &HttpResponse{url, resp, err}
		}(url)
	}
	return ch
}



func TestMe(t *testing.T) {
	results := asyncHttpGets(urls)
	for _ = range urls {
		result := <-results
		fmt.Printf("%s status: %s\n", result.url, result.response.Status)
	}
	print("ok!!!!!!!")
}


