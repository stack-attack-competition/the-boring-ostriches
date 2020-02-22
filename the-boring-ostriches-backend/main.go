package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	ostrich "return-of-the-boring-ostriches/src"

	"github.com/go-chi/chi"
	guuid "github.com/google/uuid"
)

// I am using these slices as "backend storage"
// I'm sorry.
var Users ostrich.UserSlice
var Bets ostrich.BetSlice
var Challenges ostrich.ChallengeSlice

// Reads the test data
func importStuff(suffix string) []byte {
	dir, _ := os.Getwd()
	path := path.Join(dir, suffix)
	println(dir, ":::", path)
	jsonFile, _ := os.Open(path)
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)

	return byteValue
}

// I miss C++ templates
func importUsers() {
	byteValue := importStuff("testdata/users.json")

	json.Unmarshal([]byte(byteValue), &Users)

	fmt.Println("Imported", len(Users), "user records")
}

// I miss C++ templates again
func importBets() {
	byteValue := importStuff("testdata/bets.json")

	json.Unmarshal([]byte(byteValue), &Bets)

	fmt.Println("Imported", len(Bets), "bet records")
}

// And again
func importChallenges() {
	byteValue := importStuff("testdata/challenges.json")

	json.Unmarshal([]byte(byteValue), &Challenges)

	fmt.Println("Imported", len(Challenges), "challenge records")
}

func main() {
	importUsers()
	importBets()
	importChallenges()

	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	r := chi.NewRouter()

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("{\"CSIP\": true}"))
	})

	r.Route("/users", func(r chi.Router) {
		r.Get("/", listUsers)
		r.Get("/{uuid}", getUser)
		r.Get("/{uuid}/bets", getUserBets)
		// r.Get("/{uuid}/challenges", getUserChallenges)
		r.Post("/", addUser)
		r.Patch("/{uuid}", changeUser)
		r.Delete("/{uuid}", deleteUser)
	})

	r.Route("/bets", func(r chi.Router) {
		r.Get("/", listBets)
		r.Post("/", addBet)
		r.Get("/{uuid}", getBet)
		r.Patch("/{uuid}", changeBet)
		r.Delete("/{uuid}", deleteBet)
	})

	r.Route("/challenges", func(r chi.Router) {
		r.Get("/", listChallenges)
		r.Post("/", addChallenge)
		r.Get("/{uuid}", getChallenge)
		r.Patch("/{uuid}", changeChallenge)
		r.Delete("/{uuid}", deleteChallenge)
		r.Get("/{uuid}/bets", getChallengeBets)
	})

	r.Route("/auth", func(r chi.Router) {
		r.Post("/login", loginToApi)
		r.Post("/register", addUser)
	})

	http.ListenAndServe(":"+port, r)
}

// This was my first working function
// I miss C++ templates again
func listUsers(w http.ResponseWriter, r *http.Request) {
	showDeleted := r.URL.Query().Get("showDeleted")
	var RetUsers ostrich.UserSlice

	for _, v := range Users {
		v.Password = ""
		if showDeleted == "true" {
			RetUsers.Append(v)
		} else {
			if v.IsDeleted == false {
				RetUsers.Append(v)
			}
		}
	}

	b, err := json.Marshal(RetUsers)

	if err != nil {
		log.Fatal(err)
		http.Error(w, http.StatusText(500), 500)
		return
	}

	w.Write(b)
}

// God, did I tell you about how much I miss...
func listBets(w http.ResponseWriter, r *http.Request) {
	showDeleted := r.URL.Query().Get("showDeleted")
	var RetBets ostrich.BetSlice

	for _, v := range Bets {
		if showDeleted == "true" {
			RetBets.Append(v)
		} else {
			if v.IsDeleted == false {
				RetBets.Append(v)
			}
		}
	}

	b, err := json.Marshal(RetBets)

	if err != nil {
		log.Fatal(err)
		http.Error(w, http.StatusText(500), 500)
		return
	}

	w.Write(b)
}

// ... C++ templates :troll:
func listChallenges(w http.ResponseWriter, r *http.Request) {
	showDeleted := r.URL.Query().Get("showDeleted")
	var RetChallenges ostrich.ChallengeSlice

	for _, v := range Challenges {
		if showDeleted == "true" {
			RetChallenges.Append(v)
		} else {
			if v.IsDeleted == false {
				RetChallenges.Append(v)
			}
		}
	}

	b, err := json.Marshal(RetChallenges)

	if err != nil {
		log.Fatal(err)
		http.Error(w, http.StatusText(500), 500)
		return
	}

	w.Write(b)
}

func getUser(w http.ResponseWriter, r *http.Request) {
	// I loved that I can easily get out the info from URLs
	uuid := chi.URLParam(r, "uuid")
	_, err := guuid.Parse(uuid)
		http.Error(w, http.StatusText(400), 400)
		return
	}

	for _, v := range Users {
		if v.Id == uuid {
			v.Password = "" // if you comment this out, you'll leak sensitive data
			w.Write(v.Serialize())
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func getBet(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	_, err := guuid.Parse(uuid)

	if err != nil {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	for _, v := range Bets {
		if v.Id == uuid {
			w.Write(v.Serialize())
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func getChallenge(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	_, err := guuid.Parse(uuid)

	if err != nil {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	for _, v := range Challenges {
		if v.Id == uuid {
			w.Write(v.Serialize())
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func getUserBets(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	var foundBets ostrich.BetSlice

	for _, v := range Bets {
		if v.Author == uuid {
			foundBets.Append(v)
		}
	}
	if len(foundBets) > 0 {
		b, err := json.Marshal(foundBets)

		if err != nil {
			log.Fatal(err)
			http.Error(w, http.StatusText(500), 500)
			return
		}

		w.Write(b)
	} else {
		http.Error(w, http.StatusText(404), 404)
	}
}

func getChallengeBets(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	foundBets := make(ostrich.BetSlice, 0)

	challengeIdx := -1

	for k, v := range Challenges {
		if v.Id == uuid {
			challengeIdx = k
		}
	}

	if challengeIdx == -1 {
		http.Error(w, http.StatusText(404), 404)
		return
	}

	for _, v := range Bets {
		if v.Challenge == uuid {
			foundBets.Append(v)
		}
	}
	if len(foundBets) > 0 {
		b, err := json.Marshal(foundBets)

		if err != nil {
			log.Fatal(err)
			http.Error(w, http.StatusText(500), 500)
			return
		}

		w.Write(b)
	}
}

func deleteUser(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	for i, v := range Users {
		if v.Id == uuid {
			println("delete id: " + v.Id)
			Users[i].IsDeleted = true
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func deleteBet(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	for i, v := range Bets {
		if v.Id == uuid {
			println("delete bet id: " + v.Id)
			Bets[i].IsDeleted = true
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func deleteChallenge(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")
	for i, v := range Challenges {
		if v.Id == uuid {
			println("delete id: " + v.Id)
			Challenges[i].IsDeleted = true
			return
		}
	}
	http.Error(w, http.StatusText(404), 404)
}

func addUser(w http.ResponseWriter, r *http.Request) {
	var rawUser ostrich.User
	err := json.NewDecoder(r.Body).Decode(&rawUser)

	if err != nil {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	if Users.EmailExists(rawUser.Email) {
		http.Error(w, http.StatusText(409), 409)
		return
	}

	oldCount := len(Users)

	nuuid, _ := guuid.NewUUID()
	fmt.Printf("Adding new user %v\t", nuuid.String())

	rawUser.Id = nuuid.String()
	rawUser.IsDeleted = false
	Users.Append(rawUser)

	fmt.Printf("User count %d -> %d\n", oldCount, len(Users))
}

func addBet(w http.ResponseWriter, r *http.Request) {
	var rawBet ostrich.Bet
	err := json.NewDecoder(r.Body).Decode(&rawBet)

	if err != nil {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	oldCount := len(Bets)

	nuuid, _ := guuid.NewUUID()
	fmt.Printf("Adding new bet %v\t", nuuid.String())

	rawBet.Id = nuuid.String()
	rawBet.IsDeleted = false
	Bets.Append(rawBet)

	fmt.Printf("Bet count %d -> %d\n", oldCount, len(Bets))
}

func addChallenge(w http.ResponseWriter, r *http.Request) {
	var rawChallenge ostrich.Challenge
	err := json.NewDecoder(r.Body).Decode(&rawChallenge)

	if err != nil {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	oldCount := len(Challenges)

	nuuid, _ := guuid.NewUUID()
	fmt.Printf("Adding new challenge %v\t", nuuid.String())

	rawChallenge.Id = nuuid.String()
	rawChallenge.IsDeleted = false
	Challenges.Append(rawChallenge)

	fmt.Printf("Challenges count %d -> %d\n", oldCount, len(Challenges))
}

func changeUser(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")

	var rawUser map[string]interface{}
	json.NewDecoder(r.Body).Decode(&rawUser)

	fmt.Printf("Changing current user %s\n", uuid)

	userIdx := -1

	for k, v := range Users {
		if v.Id == uuid {
			userIdx = k
		}
	}

	if userIdx == -1 {
		http.Error(w, http.StatusText(404), 404)
		return
	}

	for k, v := range rawUser {
		switch k {
		case "email":
			if Users.EmailExists(v.(string)) {
				http.Error(w, http.StatusText(409), 409)
				return
			}
			Users[userIdx].Email = v.(string)
		case "password":
			Users[userIdx].Password = v.(string)
		case "firstName":
			Users[userIdx].FirstName = v.(string)
		case "lastName":
			Users[userIdx].LastName = v.(string)
		case "pictureUrl":
			Users[userIdx].Picture = v.(string)
		default:
			http.Error(w, http.StatusText(400), 400)
		}
	}
}

func changeBet(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")

	var rawBet map[string]interface{}
	json.NewDecoder(r.Body).Decode(&rawBet)

	fmt.Printf("Changing current bet %s\n", uuid)

	betIdx := -1

	for k, v := range Bets {
		if v.Id == uuid {
			betIdx = k
		}
	}

	if betIdx == -1 {
		http.Error(w, http.StatusText(404), 404)
		return
	}

	for k, v := range rawBet {
		switch k {
		case "inFavor":
			Bets[betIdx].InFavor = v.(bool)
		case "amount":
			Bets[betIdx].Amount = int(v.(float64))
		case "result":
			Bets[betIdx].Result = int(v.(float64))
		default:
			http.Error(w, http.StatusText(400), 400)
		}
	}
}

func changeChallenge(w http.ResponseWriter, r *http.Request) {
	uuid := chi.URLParam(r, "uuid")

	var rawChallenge map[string]interface{}
	json.NewDecoder(r.Body).Decode(&rawChallenge)

	fmt.Printf("Changing current challenge %s\n", uuid)

	challengeIdx := -1

	for k, v := range Challenges {
		if v.Id == uuid {
			challengeIdx = k
		}
	}

	if challengeIdx == -1 {
		http.Error(w, http.StatusText(404), 404)
		return
	}

	for k, v := range rawChallenge {
		switch k {
		case "author":
			Challenges[challengeIdx].Author = v.(string)
		case "title":
			Challenges[challengeIdx].Title = v.(string)
		case "description":
			Challenges[challengeIdx].Description = v.(string)
		case "isActive":
			Challenges[challengeIdx].IsActive = v.(bool)
		case "endDate":
			Challenges[challengeIdx].EndDate = v.(string)
		case "OutCome":
			Challenges[challengeIdx].Outcome = v.(bool)
		case "proofUrl":
			Challenges[challengeIdx].ProofUrl = v.(string)
		default:
			http.Error(w, http.StatusText(400), 400)
		}
	}
}

func loginToApi(w http.ResponseWriter, r *http.Request) {
	var rawLogin map[string]interface{}
	json.NewDecoder(r.Body).Decode(&rawLogin)

	user, ok := rawLogin["email"].(string)

	if !ok {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	password, ok := rawLogin["password"].(string)

	if !ok {
		http.Error(w, http.StatusText(400), 400)
		return
	}

	fmt.Printf("Login to API by %s\n", user)

	credentialsOk := false

	for _, v := range Users {
		if v.Email == user && v.Password == password {
			credentialsOk = true
			v.Password = ""
			w.Write(v.Serialize())
			return
		}
	}

	fmt.Println("Credentials match: ", credentialsOk)

	if !credentialsOk {
		http.Error(w, http.StatusText(403), 403)
	}

	// generateToken()
}
