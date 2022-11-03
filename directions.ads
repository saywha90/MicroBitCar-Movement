package Directions is
   
   task sense with priority => 1; --lavest prioritet
   task act with priority => 2; --høyest prioritet
   
   
   
   protected directionobj is
      procedure setDirection(dir: String);
      function getDirection return String;
   private
      dir_value: String;
      
   end directionobj;
   
   end Directions;
