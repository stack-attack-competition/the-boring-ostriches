package ostrich

import (
	"encoding/json"
)

// User represents user
// Id: magic
type User struct {  
    Id string
    Email  string
	FirstName       string
	LastName string
	Picture string
	IsDeleted bool
	Password string `json:"-"`
	Bets []Bet `json:"-"`
}

func (user User) Serialize() []byte {
	b, err := json.Marshal(user)

	if err != nil {
		return []byte{}
	}

	return b
}

// TODO:
// * [NOT HERE!] handle that one bet should be added to only one user
// * 
func (user *User) AddBet(newBet Bet) {
	user.Bets = append(user.Bets, newBet)
	b, _ := json.Marshal(newBet)
	println(string(b))

	bu, _ := json.Marshal(user)
	println(string(bu))
}