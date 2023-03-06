-- Pau Rosado MUñoz
-- https://youtu.be/I1cjRZ8sKcQ


with Ada.Text_IO;                use Ada.Text_IO;
with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;   use Ada.Text_IO.Unbounded_IO;
with Ada.Numerics.Float_Random;  use Ada.Numerics.Float_Random;

with def_monitor;              use def_monitor;

procedure main is

   Nre_Fumadors       : constant := 7; -- Nombre de clients fumadors.
   Nre_NoFumadors     : constant := 7; -- Nombre de clients no fumadors.
   Nre_Clients        : constant := Nre_Fumadors + Nre_NoFumadors; -- Nombre de clients totals
   Fitxer_Noms        : constant String := "noms.txt"; -- Fitxer on es guarda els noms dels clients

   monitor    : maitre; -- Monitor

   Gen : Generator;  -- Generator de la llibreria Ada.Numerics.Float_Random per generar decimals aleatoris entre 0.0 i 1.0
   numRnd : Float; -- Float que gordarà el num random

   task type client is -- Especificacion de la tasca client
      entry Start (Nom_Client : in Unbounded_String; Tipus_Client : in Tipus);
   end client;

   task body client is -- Cos de la tasca client

      Nom         : Unbounded_String; -- Un client té un nom
      TipusClient : Tipus; -- Un client té un tipus

      Salo        : Natural; -- Guarda també el saló on està dinant el client.
      procedure dinar is
      begin
         if(TipusClient = NOFUMADORS) then
            Put_Line("     En " & Nom & " diu: Prendré el menú del dia. Som al saló" & salo'Img);
         else
            Put_Line("En " & Nom & " diu: Prendré el menú del dia. Som al saló" & salo'Img);
         end if;
         numRnd := Random(Gen); -- Generam el nombre aleatori
         delay Duration(numRnd*20.0); -- Simulam que dina
         if(TipusClient = NOFUMADORS) then
            Put_Line("     En " & Nom & " diu: ja he dinat el compte per favor");
         else
            Put_Line("En " & Nom & " diu: ja he dinat el compte per favor");
         end if;
      end dinar;

   begin
      accept Start (Nom_Client : in Unbounded_String; Tipus_Client : in Tipus) do
         Nom := Nom_Client; -- Assignam el nom
         TipusClient := Tipus_Client; -- Assignam el tipus
      end Start;
      numRnd := Random(Gen); -- Generam el nombre aleatori
      delay Duration(numRnd*4.0); -- Per evitar que arribin a la mateixa hora
      if(TipusClient = NOFUMADORS) then
         Put_Line("     BON DIA sóm en " & Nom & " i sóm No fumador");
      else
         Put_Line("BON DIA som en " & Nom & " i sóm fumador");
      end if;
      monitor.entrarSalo(TipusClient)(Nom, Salo); -- El client entra al saló
      dinar; -- El client dina
      monitor.sortirSalo(Nom, Salo); -- El client surt del saló
      if(TipusClient = NOFUMADORS) then
         Put_Line("     En " & Nom & " SE'NVA");
      else
         Put_Line("En " & Nom & " SE'N VA");
      end if;NOFUMADORS
   end client;

   subtype Index_Noms is Positive range Positive'First .. + Nre_Clients;
   type Array_Noms is array (Index_Noms) of Unbounded_String;
   subtype Index_NoFumadors is Positive range Positive'First .. Nre_NoFumadors;
   type Array_NoFumadors is array (Index_NoFumadors) of client;
   subtype Index_Fumadors is Positive range Positive'First .. Nre_Fumadors;
   type Array_Fumadors is array (Index_Fumadors) of client;

   F              : File_Type;
   Noms           : Array_Noms;
   arrNoFumadors  : Array_NoFumadors;
   arrFumadors    : Array_Fumadors;

begin
   Reset(Gen); -- Inicialitzam el generador
   monitor.initMon; -- Inicialitzam el monitor
   Open(F, In_File, Fitxer_Noms); -- Obrim el fitxer de nomscd
   for I in Noms'Range loop -- Els guardam a l'array de noms.
      Noms(I) := To_Unbounded_String(Get_Line(F));
   end loop;
   Close(F); -- Tancam el fitxer de noms 
   for I in arrNoFumadors'Range loop
      arrNoFumadors(I).Start(Noms(I), NOFUMADORS);
   end loop;
   for I in arrFumadors'Range loop
      arrFumadors(I).Start(Noms(I + Nre_NoFumadors), FUMADORS);
   end loop;

end main;
