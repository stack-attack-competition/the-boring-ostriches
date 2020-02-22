package ostrich

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
