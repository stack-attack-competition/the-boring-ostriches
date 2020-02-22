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
	}

	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}

	r := chi.NewRouter()
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("{\"CSIP\": true}"))
	})
	r.Get("/users", func(w http.ResponseWriter, r *http.Request) {
		b, err := json.Marshal(Users[0])
		if err != nil {
			log.Fatal(err)
			w.Write([]byte("{\"users\": false} "))
		}
		w.Write([]byte(b))
	})
	http.ListenAndServe(":"+port, r)
}
