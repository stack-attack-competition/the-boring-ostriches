package ostrich

import "encoding/json"

// Bet
// id: valami
type Bet struct {
	Id        string `json:"id"`
	IsDeleted bool   `json:"isDeleted"`
	Challenge string `json:"challenge"`
	InFavor   bool   `json:"inFavor"`
	Amount    int    `json:"amount"`
	Result    int    `json:"result"`
	Author    string `json:"author"`
}

type BetSlice []Bet

func (bets *BetSlice) Append(bet Bet) {
	*bets = append(*bets, bet)
}

func (bet Bet) Serialize() []byte {
	b, err := json.Marshal(bet)

	if err != nil {
		return []byte{}
	}

	return b
}
