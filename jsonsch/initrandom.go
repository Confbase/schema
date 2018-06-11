package jsonsch

import (
	"math/rand"
	"time"
)

const randAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()-=_+[]{};':/?,.<>"
const randStrMaxLen = 64

func init() {
	rand.Seed(time.Now().Unix())
}

func randomString() string {
	length := rand.Int() % randStrMaxLen
	randStr := make([]byte, length)
	for i := range randStr {
		randStr[i] = randAlphabet[rand.Intn(len(randAlphabet))]
	}
	return string(randStr)
}
