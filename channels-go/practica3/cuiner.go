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
	
	// Declaram el canal de plats on s'enviaran les peces de sushi
	plats, err := ch_plats.QueueDeclare(
		"plats", // name
		false,    // durable
		false,   // delete when unused
		false,   // exclusive
		false,   // no-wait
		nil,     // arguments
	)
	failOnError(err, "Failed to declare a queue")

	// Declaram el canal de persos que desbloquejaran als consumidors quan 
		//  acabi el cuiner
	permis, err := ch_permis.QueueDeclare(
		"permis", // name
		false,    // durable
		false,   // delete when unused
		false,   // exclusive
		false,   // no-wait
		nil,     // arguments
	)
	failOnError(err, "Failed to declare a queue")

	log.Printf("El cuiner de sushi ja és aquí")

	// Decideix les peces 
	tPeces := 10
	niguiris := rand.Intn(tPeces)
	shashamis := rand.Intn(tPeces - niguiris)
	makis := tPeces - niguiris - shashamis

	// Anuncia les peces 
	log.Printf("El cuiner prepararà un plat amb:")
	log.Printf("%d peces de niguiri de salmó", niguiris)
	log.Printf("%d peces de sashami de tonyina", shashamis)
	log.Printf("%d peces de maki de cranc", makis)

	// Cuina els niguiris i els posa al plat
	for i := 0; i < niguiris; i++ {
		time.Sleep(time.Duration(rand.Intn(300)) * time.Millisecond)
		body := "niguiri de salmó"
		err = ch_plats.Publish(
		"",     // exchange
		plats.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			ContentType:  "text/plain",
			Body:         []byte(body),
		})
	failOnError(err, "Failed to publish a message")
	log.Printf("[x] Posa dins el plat %s", body)
	}

	// Cuina els sashamis i els posa al plat
	for i := 0; i < shashamis; i++ {
		time.Sleep(time.Duration(rand.Intn(300)) * time.Millisecond)
		body := "sashami de tonyina"
		err = ch_plats.Publish(
		"",     // exchange
		plats.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			ContentType:  "text/plain",
			Body:         []byte(body),
		})
	failOnError(err, "Failed to publish a message")
	log.Printf("[x] Posa dins el plat %s", body)
	}
	
	// Cuina els makis i els posa al plat
	for i := 0; i < makis; i++ {
		time.Sleep(time.Duration(rand.Intn(300)) * time.Millisecond)
		body := "maki de cranc"
		err = ch_plats.Publish(
		"",     // exchange
		plats.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			ContentType:  "text/plain",
			Body:         []byte(body),
		})
	failOnError(err, "Failed to publish a message")
	log.Printf("[x] Posa dins el plat %s", body)
	}

	// Allibera als consumidors
	body := strconv.Itoa(tPeces)
	err = ch_plats.Publish(
		"",     // exchange
		permis.Name, // routing key
		false,  // mandatory
		false,  // immediate
		amqp.Publishing{
			ContentType:  "text/plain",
			Body:         []byte(body),
		})
	failOnError(err, "Failed to publish a message")
}















