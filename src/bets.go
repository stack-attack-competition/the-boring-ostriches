package ostrich

// Bet
// id: valami
type Bet struct {
	id        string
	isDeleted string
	author    User
	//challenge Challenge
	inFavor bool
	amount  int
	result  int
}
