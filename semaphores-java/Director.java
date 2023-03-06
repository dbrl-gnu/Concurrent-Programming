/*
autor: Pau Rosado Muñoz

https://youtu.be/b0ariz7jf9k
*/
package practica1;

public class Director implements Runnable {
    static final int nRondes = 3;
    static final String salaBuida= "    El Director veu que no hi ha ningú a la sala d'estudis";

    @Override
    public void run() {
        try {
            for (int i = 1; i <= nRondes; i++) {
                Thread.sleep((long) (Math.random() * 50) + 50); // Per al cas 2, llevar 1 cero
                System.out.println("    El Sr.Director comença la ronda"); // Comença la ronda
                Practica1.sala.acquire(); // Comprova la capacitat
                Practica1.eDirector = Practica1.Estat.ESPERANT;
                if (Practica1.eSala != 0) { // Cas on hi ha estudiants dins la sala
                    if (Practica1.eSala < Practica1.MAXESTUDIANTS) { // Si hi ha un nombre asequible d'alumnes
                        System.out.println("    El Director està esperant per entrar. No molesta als que estudien");    
                    }
                    Practica1.sala.release(); // Esperam per poder entrar
                    Practica1.director.acquire();
                    Practica1.sala.acquire();
                    if (Practica1.eSala != 0) { // Si no s'ha buidat la sala mentre esperava
                        Practica1.eDirector = Practica1.Estat.DINS;
                        System.out.println("    El Director està dins la sala d'estudi: S'HA ACABAT LA FESTA!");
                        Practica1.festa.acquire(); // No entra ningu fins que se buidi
                        Practica1.sala.release(); 
                        Practica1.director.acquire(); // Espera a que surtin tots els estodiants
                        System.out.println(salaBuida);   
                        Practica1.director.release();
                        Practica1.sala.acquire(); 
                        Practica1.festa.release();
                    } else {
                        Practica1.eDirector = Practica1.Estat.DINS;
                        System.out.println(salaBuida);   
                    }
                } else {
                    Practica1.eDirector = Practica1.Estat.DINS;
                    System.out.println(salaBuida);   
                }
                Practica1.eDirector = Practica1.Estat.FORA;
                Practica1.sala.release();
                System.out.println("    El Director acaba la ronda " + i + " de " + nRondes);
                // Thread.sleep((long) (Math.random() * 10000));
            }
        } catch (InterruptedException e) {
            System.out.println("    Director EXEPCIÓ!" + e.getMessage());
        }
    }
}
