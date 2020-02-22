package ostrich

import "encoding/json"

type Challenge struct {
	Id          string `json:"id"`
	IsDeleted   bool   `json:"isDeleted"`
	Author      string `json:"author"`
	Title       string `json:"title"`
	Description string `json:"description"`
	IsActive    bool   `json:"isActive"`
	EndDate     string `json:"endDate"`
	Outcome     bool   `json:"OutCome"`
	ProofUrl    string `json:"proofUrl"`
}

type ChallengeSlice []Challenge

func (challenges *ChallengeSlice) Append(challenge Challenge) {
	*challenges = append(*challenges, challenge)
}

func (challenge Challenge) Serialize() []byte {
	b, err := json.Marshal(challenge)

	if err != nil {
		return []byte{}
	}

	return b
}

func (challenges ChallengeSlice) HasId(uuid string) bool {

	for _, v := range challenges {
		if v.Id == uuid {
			return true
		}
	}

	return false
}
