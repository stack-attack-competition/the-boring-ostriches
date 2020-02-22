package ostrich

// Bet
// id: valami
type Bet struct {
	Id        string
	IsDeleted bool
	//challenge Challenge
	InFavor bool
	Amount  int
	Result  int
	Author  string
}
