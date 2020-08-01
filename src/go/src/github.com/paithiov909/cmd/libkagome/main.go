package main

//#include <stdlib.h>
import "C"
import (
	"encoding/json"
	"fmt"
	"github.com/ikawaha/kagome/tokenizer"
	"strconv"
	"unsafe"
)

type TokenInfo struct {
	Id      int
	Start   int
	End     int
	Surface string
	Feature []string
}

//export tokenize
func tokenize(text string) *C.char {

	t := tokenizer.New()
	tokens := t.Tokenize(text)

	m := make(map[string]*TokenInfo)

	for i, token := range tokens {
		if token.Class == tokenizer.DUMMY {
			continue
		}
		info := TokenInfo{
			token.ID,
			token.Start,
			token.End,
			token.Surface,
			token.Features(),
		}
		m[strconv.Itoa(i)] = &info
	}

	data, err := json.Marshal(m)

	if err != nil {
		fmt.Println("json.Marshal failed:", err)
		s := C.CString(string("ERROR::json.Marshal failed."))
		defer C.free(unsafe.Pointer(s))
		return s
	} else {
		fmt.Println("DEBUG Go-side:", string(data))
		s := C.CString(string(data))
		defer C.free(unsafe.Pointer(s))
		return s
	}
}

func main() {}
