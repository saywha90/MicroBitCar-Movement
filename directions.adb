with MicroBit.IOsForTasking;
with MicroBit;
with MicroBit.Console; use MicroBit.Console;
with Ada.Real_Time; use Ada.Real_Time;

package body Directions is
   
   protected body directionobj is
      procedure setDirection(dir: rettning) is
      begin
         dir_value := dir;
      end setDirection;
      
      function getDirection return rettning is
      begin
         return dir_value;
      end getDirection;
   end directionobj;
   
   task body sense is
      Time_Now : Ada.Real_Time.Time;
   begin
      loop
         Time_Now := Ada.Real_Time.Clock;
         
         --line_tracker
         
         if MicroBit.IOsForTasking.set(4) = True then
            directionobj.setDirection(Forward);
         else
            directionobj.setDirection(Left);
         end if;
         delay until Time_Now + Ada.Real_Time.Milliseconds(20);
      end loop;
      
   end sense;
   
   task body act is
      Time_Now : Ada.Real_Time.Time;
      dir : rettning;
      counter : Integer := 0;
      Speed : constant MicroBit.IOsForTasking.Analog_Value := 512; --between 0 and 1023
   begin
      loop
         Time_Now := Ada.Real_Time.Clock;
         
         dir := directionobj.getDirection;
         Put_Line("Direction: " & rettning'Image(dir));
         
         if dir = Forward then
            MicroBit.IOsForTasking.Set_Analog_Period_Us(20000); --50 Hz = 1/50 = 0.02s = 20 ms = 20000us
            
            --LEFT
            --front
            MicroBit.IOsForTasking.Set(6, True); --IN1
            MicroBit.IOsForTasking.Set(7, False); --IN2
            
            --back
            MicroBit.IOsForTasking.Set(2, True); --IN3
            MicroBit.IOsForTasking.Set(3, False); --IN4
            
            --RIGHT
            --front
            MicroBit.IOsForTasking.Set(12, True); --IN1
            MicroBit.IOsForTasking.Set(13, False); --IN2
            
            --back
            MicroBit.IOsForTasking.Set(14, True); --IN3
            MicroBit.IOsForTasking.Set(15, False); --IN4
            
            MicroBit.IOsForTasking.Write(0, Speed); --left speed control ENA ENB
            MicroBit.IOsForTasking.Write(1, Speed); --right speed control ENA ENB
         end if;
         
         if dir = Right then
            -- MicroBit.IOsForTasking.Set_Analog_Period.Us(20000); --50Hz = 1/50 = 0.02s = 20ms = 2000us
            
            --LEFT
            --front
            MicroBit.IOsForTasking.Set(6, True); --IN1
            MicroBit.IOsForTasking.Set(7, False); --IN2
            
            --back
            MicroBit.IOsForTasking.Set(2, False); --IN3
            MicroBit.IOsForTasking.Set(3, True); --IN4
            
            --RIGHT
            --front
            MicroBit.IOsForTasking.Set(12, False); --IN1
            MicroBit.IOsForTasking.Set(13, True); --IN2
            
            --back
            MicroBit.IOsForTasking.Set(14, True); --IN3
            MicroBit.IOsForTasking.Set(15, False); --IN4
            
            MicroBit.IOsForTasking.Write(0, Speed); --left speed control ENA ENB
            MicroBit.IOsForTasking.Write(1, Speed); --right speed control ENA ENB
            
         end if;
         
         if dir = Left then
            counter := counter +1;
            -- MicroBit.IOsForTasking.Set_Analog_Period_Us(20000); -- 60Hz = 1/50 = 0.02 = 20ms = 20000us
            Put_Line("antall: " & Integer'Image(counter));
            if counter >= 50 then
               Put_Line("change dir");
               dir := Right;
               counter := 0;
            end if;
            
            --LEFT
            --front
            MicroBit.IOsForTasking.Set(6, False); --IN1
            MicroBit.IOsFortasking.Set(7, True); --IN2
            
            --back
            MicroBit.IOsFortasking.Set(2, True); --IN3
            MicroBit.IOsFortasking.Set(3, False); --IN4
            
            --RIGHT
            --front
            MicroBit.IOsFortasking.Set(12, True); --IN1
            MicroBit.IOsFortasking.Set(13, False); --IN2
            
            --back
            MicroBit.IOsFortasking.Set(14, False); --IN3
            MicroBit.IOsFortasking.Set(15, True); --IN4
            
            MicroBit.IOsForTasking.Write(0, Speed); --left speed control ENA ENB
            MicroBit.IOsFortasking.Write(1, Speed); --right speed control ENA ENB
            
         end if;
         
         delay until Time_Now + Ada.Real_Time.Milliseconds(20);
      end loop;
   end act;
   end Directions;
