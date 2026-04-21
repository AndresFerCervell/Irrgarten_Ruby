module Irrgarten 
 #Un string antecedido por : significa que es un símbolo. 
  #Esto es, el símbolo :player es único en el programa, no como un string player
  #que ocuparía un lugar nuevo en memoria cada vez que se escribe
  module GameCharacter  
    PLAYER = :player   #Se accede GameCharacter:: PLAYER o 
    MONSTER = :monster #Irrgarten::GameCharacter:: PLAYER si estamos fuera del módulo Irrgarten
  end 
end
