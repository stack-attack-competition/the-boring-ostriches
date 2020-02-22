package ostrich

import (
	"encoding/json"
)

// User represents user
// Id: magic
type User struct {  
    Id string `json:"id"`
    Email  string `json:"email"`
	FirstName       string `json:"firstName"`
	LastName string `json:"lastName"`
	Picture string `json:"pictureUrl"`
	IsDeleted bool `json:"isDeleted"`
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

type UserSlice []User

func (users *UserSlice) Append (user User) {
	*users = append(*users, user)
}

func (users *UserSlice) EmailExists (email string) bool {
	for _, v := range *users {
		if v.Email == email {
			return true
		}
	}
	return false
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

