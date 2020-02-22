package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	ostrich "return-of-the-boring-ostriches/src"

	"github.com/go-chi/chi"
)

func main() {

	Users := []ostrich.User{
		ostrich.User{
			Id:        "id",
			Email:     "email",
			FirstName: "firstName",
			LastName:  "lastName",
			Picture:   "picture",
			IsDeleted: false},

		ostrich.User{
			Id:        "id1",
			Email:     "email1",
			FirstName: "firstName1",
			LastName:  "lastName2",
			Picture:   "picture3",
			IsDeleted: true},
	}

	TestBet := ostrich.Bet{
		Id:        "id2",
		IsDeleted: false,
		InFavor:   false,
		Amount:    5,
		Result:    2,
		Author:    Users[0].Id,
	}

	Users[0].AddBet(TestBet)

	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	r := chi.NewRouter()
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("{\"CSIP\": true}"))
	})
	r.Get("/users", func(w http.ResponseWriter, r *http.Request) {
		b, err := json.Marshal(Users)

		if err != nil {
			log.Fatal(err)
			w.Write([]byte("{\"err_code\": \"magic_smoke\"} "))
		}

		w.Write(b)
	})
	http.ListenAndServe(":"+port, r)
}
