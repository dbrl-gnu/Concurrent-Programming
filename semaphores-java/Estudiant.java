/*
autor: Pau Rosado Muñoz

https://youtu.be/b0ariz7jf9k
*/
package practica1;

public class Estudiant implements Runnable{
    private String nom;

    public Estudiant (String nom) {
        this.nom = nom;
    }

    @Override 
    public void run() {
        try {
            Thread.sleep((long) (Math.random() * 100) + 100);
            Practica1.festa.acquire(); // Si el director es dedins buidant la festa esperam
            Practica1.festa.release();
            Practica1.sala.acquire(); // Entra a la sala
            if (Practica1.eSala == 0) { 
                Practica1.director.acquire();
            }
            Practica1.eSala++;
            System.out.println(nom + " entra a la sala d'estudi, nombre estudiants: " + Practica1.eSala);
            if (Practica1.eSala >= Practica1.MAXESTUDIANTS) { // Si hi ha festa
                System.out.println(nom + ": FESTA!!!!!");
                    if (Practica1.eDirector.equals(Practica1.Estat.ESPERANT)) { // Si el director estava esperant 
                        System.out.println(nom + ": ALERTA que vé el director!!!!!!!!!");
                        Practica1.director.release(); // Deixam que el director pugui entrar
                    }
            }  else {
                System.out.println(nom + " estudia");
            }
            Practica1.sala.release();
            Thread.sleep((long) (Math.random() * 100) + 400); // El estodiant estudia
            Practica1.sala.acquire(); // Surt de la sala
            Practica1.eSala--;
            System.out.println(nom + " surt de la sala d'estudi, nombre estudiants: " + Practica1.eSala);
            if (Practica1.eSala == 0) { // Si es el darrer
                if (Practica1.eDirector.equals(Practica1.Estat.ESPERANT)) { // Si el director esta esperant dafora
                    System.out.println(nom + ": ADEU Senyor Director, pot entrar si vol, no hi ha ningú");
                } else if (Practica1.eDirector.equals(Practica1.Estat.DINS)) { // Si el director esta dins la sala
                    System.out.println(nom + ": ADÉU Senyor Director es queda sol");
                }
                Practica1.director.release();
            }
            Practica1.sala.release();
        } catch (InterruptedException e) {
            System.out.println(this.nom + " EXEPCIÓ!" + e.getMessage());
        }
    }
}
