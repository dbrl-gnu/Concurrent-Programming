-- Pau Rosado MUñoz
-- https://youtu.be/I1cjRZ8sKcQ

with Ada.Strings.Unbounded;            use Ada.Strings.Unbounded;

package def_monitor is

   Nre_Taules         : constant := 3; -- Nombre de taules
   Nre_Salons         : constant := 3; -- Nombre de salons
   type Arr_Salons is array (1..Nre_Salons) of Natural; -- Array de l'ocupació dels salons
   type Tipus is (CAP, FUMADORS, NOFUMADORS); -- Tipus dels clients i salons (CAP només serveix per salons)
   type ArrTipus_Salons is array (1..Nre_Salons) of Tipus; -- Array del tipus dels salons

   protected type maitre is

      function gestSalo(Tipus_Client: in Tipus) return Natural;   -- Funció per comprovar si hi ha lloc a un saló
      entry entrarSalo(Tipus)(Nom: in Unbounded_String; Salo: out Natural); -- Entry per controlar l'entrada dels salons
      procedure sortirSalo(Nom: in Unbounded_String; Salo: in Natural);  -- Procediment per sortir del saló
      procedure initMon;   -- Procediment per inicialitzar el monitor

   private

   arrSalons : Arr_Salons; -- Declaració de l'array de l'ocupació dels salons
   arrTipusSalons : ArrTipus_Salons; -- Declaració de l'array del tipus dels salons

   end maitre;

end def_monitor;