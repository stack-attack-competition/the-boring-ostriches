package main

import (
	"os"
	"log"
	"net/http"
	"github.com/go-chi/chi"
)

func main() {

	port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("$PORT must be set")
	}
   

	r := chi.NewRouter()
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte('{"hello": "world"}'))
	})
	http.ListenAndServe(":" + port, r)
}