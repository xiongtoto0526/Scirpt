package test
import (
"fmt"
"testing"
	"unicode/utf8"
)

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


func TestArray(t *testing.T) {

   a := []string{"1","2"}
	fmt.Println("old array is:",a)
	changeArrayData(a)
	fmt.Println("new array is:",a)

}

func changeArrayData(param []string)  {
	param[1]="4"
}


func TestEmoj(t *testing.T) {
	aa := FilterEmoji("🐒微转")
	println(aa)
}


// 过滤 emoji 表情
func FilterEmoji(content string) string {
	new_content := ""
	for _, value := range content {
		_, size := utf8.DecodeRuneInString(string(value))
		println(size)
		if size <= 3 {
			new_content += string(value)
		}
	}
	return new_content
}




func main2(){

	b:= new(BDog)
//	b.name=" B wang wang"
	b.Dog.name = "wang wang"
	b.callMyName()
	fmt.Printf(b.name)
}