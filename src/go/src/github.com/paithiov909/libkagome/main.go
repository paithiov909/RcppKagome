package main

//#include <stdlib.h>
import "C"
import (
	"bufio"
	"encoding/json"
	"fmt"
	"github.com/ikawaha/kagome-dict/ipa"
	"github.com/ikawaha/kagome/filter"
	"github.com/ikawaha/kagome/tokenizer"
	"strconv"
	"strings"
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

	t, e := tokenizer.New(ipa.Dict(), tokenizer.OmitBosEos())
	if e != nil {
		panic(e)
	}

	tokens := t.Tokenize(text)

	mp := make(map[string]*TokenInfo)

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
		mp[strconv.Itoa(i)] = &info
	}

	data, err := json.Marshal(mp)

	if err != nil {
		fmt.Println("json.Marshal failed:", err)
		s := C.CString(string("ERROR::json.Marshal failed."))
		return s
	} else {
		s := C.CString(string(data))
		return s
	}
}

//export split
func split(text string) *C.char {

	scanner := bufio.NewScanner(strings.NewReader(text))
	scanner.Split(filter.ScanSentences)

	sl := make([]string, 0)

	for scanner.Scan() {
		sl = append(sl, scanner.Text())
	}

	data, err := json.Marshal(sl)

	if err != nil {
		fmt.Println("json.Marshal failed:", err)
		s := C.CString(string("ERROR::json.Marshal failed."))
		return s
	} else {
		s := C.CString(string(data))
		return s
	}
}

func main() {}
