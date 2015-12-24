package test
import "fmt"

// this method will test go extends and overrid ability

type Dog struct {
	name string
}

type BDog struct {
     Dog // 这里必须是struct变量,否则无法实现继承
	name string // 这里不会重写name的属性
}

type  Funny  interface{
	callMyName()
	getName() string
}

func (this *Dog) callMyName(){
	fmt.Printf("my name is %q\n",this.getName())
}

func (this *Dog)  getName() string{
  return this.name
}

func main2(){

	b:= new(BDog)
//	b.name=" B wang wang"
	b.Dog.name = "wang wang"
	b.callMyName()
	fmt.Printf(b.name)
}