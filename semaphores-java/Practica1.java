/*
autor: Pau Rosado Muñoz

https://youtu.be/b0ariz7jf9k
*/
package practica1;

import java.util.concurrent.Semaphore;

public class Practica1 {
    static final int NSTUDIANTS = 10; // Nombre d'estudiants
    static final int MAXESTUDIANTS = 4; // Capacitat de la sala 

    static volatile int eSala = 0; // Nombre d'estudiants a la sala

    static Semaphore sala = new Semaphore(1); //  Regula l'accés a la sala
    static Semaphore director = new Semaphore(1); //Regula l'accés del director 
    static Semaphore festa = new Semaphore(1);  // Atura als alumnes mentre el director està desmontant una festa

    static Estat eDirector = Estat.FORA; // Estat del director

    public static void main(String[] args) throws InterruptedException {
        System.out.println("Nombre total d'estudiants: " + NSTUDIANTS);
        System.out.println("Nombre màxim d'estudiants: " + MAXESTUDIANTS);
        Thread d = new Thread(new Director());
        d.start();
        String[] nomEstudiants = {"Bosco", "Pelayo", "Cayetano", "Jacobo", "Tristán", "Beltrán", "Guzmán",
            "Froilán", "Borja", "Sancho", "Rodrigo", "Gonzalo", "JoseMari", "Nicolás", "Leopoldo"};
        Thread[] estudiants = new Thread[NSTUDIANTS];
        for (int i = 0; i < NSTUDIANTS; i++) {
            estudiants[i] = new Thread(new Estudiant(nomEstudiants[i]));
            estudiants[i].start();
        }
        d.join();
        for (int i = 0; i < NSTUDIANTS; i++) {
            estudiants[i].join();
        }
        System.out.println("SIMULACIÓ ACABADA");
    }

    // Possibles estats del director
    enum Estat {
        FORA, ESPERANT, DINS
    }
}