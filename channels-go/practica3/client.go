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
		false,  // auto-ack
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
	// Calculam el nombre de peces que es menjara
	nPeces := rand.Intn(13) + 1;
	log.Printf("Avui menjaré %d peces", nPeces)

	// Menja les peces
	for i := 0; i < nPeces; i++ {
		time.Sleep(time.Duration(rand.Intn(1100)) * time.Millisecond)
		p := <-permis // Espera el permis
		p.Ack(false)
		peces, _:= strconv.Atoi(string(p.Body))
		peces-- // Redueix la quantitat de peces
		s := <-plats // Agafa un sushi
		s.Ack(false)
		log.Printf("Ha agafat un %s", string(s.Body))
		log.Printf("Al plat hi ha %d peces", peces)
		// Si no es la darrera peça que agafa envia un missatge al canal de permisos
			// per fer que la resta seguesqui esperant
		if peces > 0 {
			body := strconv.Itoa(peces)
			err = ch_permis.Publish(
				"",     // exchange
				"permis", // routing key
				false,  // mandatory
				false,  // immediate
				amqp.Publishing{
					ContentType:  "text/plain",
					Body:         []byte(body),
				})
			failOnError(err, "Failed to publish a message")
		} 
	}
	log.Printf("Ja estic ple. Bona nit")
}
