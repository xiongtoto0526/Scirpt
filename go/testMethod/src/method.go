package main
import (
	"fmt"
	"time"
)
func main() {
	ch := make(chan int, 3)
	go func() { time.Sleep(30*time.Second);ch <- 1 ;ch <- 2}()


//	ch <- 3
	println(" before finish ...")
	println("aa:",<-ch)
	println(" finish ...")
//  printParam(ch)
}

func printParam(ch <-chan int)  {
	for v := range ch {
		fmt.Println(v)
		println("new aa:",len(ch))
		if len(ch) <= 0 { // 如果现有数据量为0，跳出循环
			break
		}
	}
}
