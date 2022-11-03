with MicroBit.IOsForTasking;
with MicroBit;
with MicroBit.Console; use MicroBit.Console;
with Ada.Real_Time; use Ada.Real_Time;

with Directions;


package body build_program is

   type rettning is (Forward, Right, Left);
   
   task body drive_car is
      current_state : rettning := Forward;
      
      Time_Now : Time;
      Time_done : Time;
      Del_Right : Time_Span := Seconds(1);
      
      
   begin
      loop
         case current_state is
            when Forward =>
               Directions.directionobj.setDirection(Forward);
               if MicroBit.IOsForTasking.Set(4) = False then
                  Time_done := Clock + Del_Right;
                  current_state := Right;
               end if;
            when right =>
               Directions.directionobj.setDirection(Right);
               Time_Now := Clock;
               if (Time_Now > Time_done) then
                  current_state := left;
               end if;
            when left =>
               Directions.directionobj.setDirection(Left);
               if MicroBit.IOsForTasking.set(4) = True then
                  current_state := Forward;
               end if;
         end case;
         delay until Clock + Milliseconds(5);
      end loop;
   end drive_car;
   

end build_program;
