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
	Password string `json:"password,omitempty"`
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

func (users UserSlice) HasId (uuid string) bool {

	for _, v := range users {
		if v.Id == uuid {
			return true
		}
	}

	return false
}
 
