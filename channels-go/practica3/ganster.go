/*
autor: Pau Rosado Muñoz

https://youtu.be/e76imn_LVJw
*/
package main

import (
	"time"
	"log"
	"math/rand"
	"strconv"

	amqp "github.com/rabbitmq/amqp091-go"
)

func failOnError(err error, msg string) {
	if err != nil {
		log.Panicf("%s: %s", msg, err)
	}
}

func main() {
	// Per no tenir sempre la mateixa simulació
	rand.Seed(time.Now().UnixNano())

	// Obrim les connexions
	conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	// Obrim el canal de plats
	ch_plats, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch_plats.Close()

	// Obrim el canal de permisos
	ch_permis, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch_permis.Close()

	plats, err := ch_plats.Consume(
		"plats", // queue
		"",     // consumer
		true,  // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	permis, err := ch_permis.Consume(
		"permis", // queue
		"",     // consumer
		false,  // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	log.Printf("Bon vespre vinc a sopar de sushi")
	log.Printf("Ho vull tot!")

	// Espera el permis
	p := <-permis 
	p.Ack(false)
	peces, _:= strconv.Atoi(string(p.Body))
	for i := 0; i < peces; i++ {
		s := <-plats // Agafa un sushi
		s.Ack(false) 
	}
	log.Printf("Agafa totes les peces, en total %d", peces)			
	log.Printf("Romp el plat")
	log.Printf("Me'n vaig")
}

