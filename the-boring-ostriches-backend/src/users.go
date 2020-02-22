package ostrich

// User 
// id: magic

type User struct {  
    id string
    email  string
	firstName       string
	lastName string
	picture string
	isDeleted bool
	bets []Bet
	//challenges []Challenge
}