-- Pau Rosado MUñoz
-- https://youtu.be/I1cjRZ8sKcQ

with Ada.Text_IO;                      use Ada.Text_IO;
with Ada.Strings.Unbounded;            use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;    use Ada.Strings.Unbounded.Text_IO;

package body def_monitor is

   protected body maitre is

      procedure initMon is 
      begin
         for I in arrSalons'Range loop 
         arrSalons(I) := Nre_Taules;   -- Iniciam l'array de disponibilitat dels salons amb la disponibilitat màxima.
         arrTipusSalons(I) := CAP; -- Iniciam l'array de tipus dels salons amb salons buits.
         end loop;
         Put_Line("++++++++++ El Maître està preparat");
         Put_Line("++++++++++ Hi ha" & Nre_Salons'Img & " salons amb capacitat de" & Nre_Taules'Img &" comensals cada un");
      end initMon;

      function gestSalo(Tipus_Client: in Tipus) return Natural is 
      begin -- Rep el tipus del client
         for I in arrSalons'Range loop -- Recorrem l'array de salons
            if(arrTipusSalons(I) = CAP OR arrTipusSalons(I) = Tipus_Client) then -- Si el saló esta buit o és del mateix tipus que el client
               if(arrSalons (I) /= 0) then -- Si hi ha lloc per al client
                  return I; -- Retorna el número del saló disponible
               end if;
            end if;
         end loop;
         return 0; -- Retorna 0 perquè no troba lloc per al client
      end gestSalo;

      entry entrarSalo(for Tipus_Client in Tipus)(Nom: in Unbounded_String; Salo: out Natural) when (gestSalo(Tipus_Client) /= 0) is
      begin -- Comprova si hi ha lloc al saló amb la funció gestSalo. Rep el nom del client i el tipus del client, per poder passar-ho com a paràmetre a la funció.
         salo := gestSalo(Tipus_Client);  -- Obtenim el nombre del saló disponible
         if(arrSalons(salo) = Nre_Taules) then -- Si el saló està buit li assignam el tipus del client.
            arrTipusSalons(salo) := Tipus_Client;
         end if;
         arrSalons(salo) := arrSalons(salo) - 1; -- Actualitzam la disponibilitat del saló per indicar que el client ha entrat
         if(Tipus_Client = NOFUMADORS) then
            Put_Line("********** En " & Nom & " té taula al saló de NO fumadors" & salo'Img & ". Disponibilitat:" & arrSalons(salo)'Img);
         else
            Put_Line("---------- En " & Nom & " té taula al saló de fumadors" & salo'Img & ". Disponibilitat:" & arrSalons(salo)'Img);
         end if;
      end;

      procedure sortirSalo(Nom: in Unbounded_String; Salo: in Natural) is
      Tipus_Client : Tipus; -- Declaració del tipus de cliennt
      begin -- Rep el nom del client i el saló on es troba
         Tipus_Client := arrTipusSalons(salo); -- Assignam el tipus del saló al del client
         arrSalons(salo) := arrSalons(salo) + 1;  -- Actualitzam la disponibilitat del saló per indicar que el client ha sortit
         if(arrSalons(salo) = Nre_Taules) then -- Si el saló se queda buit li assignam el tipus BUIT.
            arrTipusSalons(salo) := CAP;
         end if;
         if(Tipus_Client = NOFUMADORS) then
            Put_Line("********** En " & Nom & " allibera una taula del saló " & salo'Img & ". Disponibilitat:" & arrSalons(salo)'Img & " Tipus: " & arrTipusSalons(salo)'Img);
         else
            Put_Line("---------- En " & Nom & " allibera una taula del saló " & salo'Img & ". Disponibilitat:" & arrSalons(salo)'Img & " Tipus: " & arrTipusSalons(salo)'Img);
         end if;
      end sortirSalo;

   end maitre;

end def_monitor;
