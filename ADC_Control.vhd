library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity ADC_Control is
	port
	(
		RESET    : in std_logic;
		CLK_IN   : in std_logic;
		ADC_DATA : in std_logic_vector(7 downto 0);
		
		CLK_ADC  : out std_logic;
		DATA_OUT : out std_logic_vector(7 downto 0);
		ADDRESS  : out std_logic_vector(9 downto 0) := "0000000000";
		INT1 : out std_logic := '0';
		
	    Num_Max : out std_logic_vector(7 downto 0);
	    Num_Min : out std_logic_vector(7 downto 0);
	    Num_Mean : out std_logic_vector(7 downto 0);
	    
		
		X_IN : in std_logic_vector(7 downto 0);
		Y_IN : in std_logic_vector(7 downto 0);	
		TRIGGER : in std_logic;
		CLK_RAM : out std_logic := '0';
		RAM_EN : out std_logic := '1';
		FREQUENCY : in std_logic_vector(31 downto 0)
	);
end entity;


architecture beh of ADC_Control is
	signal TriggerFlag : boolean := false;
	signal WaitFlag : boolean := false;
begin
	CLK_ADC <= CLK_IN;
	process(CLK_IN, ADC_DATA, RESET, X_IN, Y_IN, TriggerFlag, TRIGGER, FREQUENCY)
		variable addr : std_logic_vector(9 downto 0) := "0000000000";
		variable freq_value :std_logic_vector(31 downto 0);
		variable x_in_0 :std_logic_vector(7 downto 0);
		variable y_in_0 :std_logic_vector(7 downto 0);
		type StateType is (S00, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);
		variable state : StateType := S00;
		variable cnt : integer range 0 to 500 := 0;
		variable Num_Max_1 : std_logic_vector(7 downto 0) := "00000000";
		variable Num_Min_1 : std_logic_vector(7 downto 0) := "00000000";
		variable Num_Mean_1 : std_logic_vector(7 downto 0) := "00000000";
	begin
		if RESET = '0' then
			addr := "0000000000";
			Num_Max_1 := "00000000";
			Num_Min_1 := "00000000";
			
			state := S00;
			INT1 <= '0';
		elsif falling_edge(CLK_IN) then
			case state is
				when S00 =>
					WaitFlag <= true;	
					cnt := cnt + 1;	
					if (TriggerFlag = true) or (cnt = 500) then
						WaitFlag <= false;
						cnt := 0;
						state := S0;
					end if;
				when S0 =>
					if addr > "0111110010" then -- 1000
					    state := S2;
					    addr := addr + '1';
					    DATA_OUT <= ADC_DATA;
					    freq_value := FREQUENCY;
					    
					    if ADC_DATA > Num_Max_1 then 
					       Num_Max_1 := ADC_DATA;
					    else
				        end if;
					    if ADC_DATA < Num_Min_1 then 
                           Num_Min_1 := ADC_DATA;
                        else
                        end if;				        
				   					    
					else
						ADDRESS <= addr;	
						CLK_RAM <= '0';
						state := S1;
						DATA_OUT <= ADC_DATA;
						
					    if ADC_DATA > Num_Max_1 then 
                           Num_Max_1 := ADC_DATA;
                        else
                          
                        end if;
                        if ADC_DATA < Num_Min_1 then 
                           Num_Min_1 := ADC_DATA;
                        else
                        
                        end if;    						
						
						
					end if;
				when S1 =>		
				    addr := addr + '1';		
					CLK_RAM <= '1';
					state := S0;
					--ADC_ST <= '0';
				when S2 =>
				    Num_Max <= Num_Max_1;
				    Num_Min <= Num_Min_1;
				    Num_Mean_1 := Num_Max_1 + Num_Min_1;
				    Num_Mean_1 := '0' & Num_Mean_1(6 downto 0);
				    
				    CLK_RAM <= '0';
				    ADDRESS <= addr;
				    DATA_OUT <= freq_value(31 downto 24);
				    state := S3;
				when S3 =>
				    Num_Mean <= Num_Mean_1;
				    
					CLK_RAM <= '1';
					addr := addr + '1';	
					state := S4;
				when S4 =>
                    CLK_RAM <= '0';
                    ADDRESS <= addr;
                    DATA_OUT <= freq_value(23 downto 16);
                    state := S5;
                when S5 =>
                    CLK_RAM <= '1';
                    addr := addr + '1';    
                    state := S6;
				when S6 =>
                    CLK_RAM <= '0';
                    ADDRESS <= addr;
                    DATA_OUT <= freq_value(15 downto 8);
                    state := S7;
                when S7 =>
                    CLK_RAM <= '1';
                    addr := addr + '1';    
                    state := S8;
                when S8 =>
                    CLK_RAM <= '0';
                    ADDRESS <= addr;
                    DATA_OUT <= freq_value(7 downto 0);
                    state := S9;
                when S9 =>
                    freq_value := "00000000000000000000000000000000";
                    CLK_RAM <= '1';
                    addr := addr + '1';    
                    state := S10;
                    x_in_0 := X_IN;	
                    y_in_0 := Y_IN;			    
				when S10 =>
                    CLK_RAM <= '0';
                    ADDRESS <= addr;
                    DATA_OUT <= x_in_0;
                    state := S11;
                when S11 =>
                    CLK_RAM <= '1';
                    addr := addr + '1';    
                    state := S12;
                when S12 =>
                    CLK_RAM <= '0';
                    ADDRESS <= addr;
                    DATA_OUT <= y_in_0;
                    state := S13;
                when S13 =>
                    CLK_RAM <= '1';   
                    state := S14;
                    addr := "0000000000";
                    INT1 <= '1';				    
                
				when others =>
					INT1 <= '1';
			end case;
		end if;
	end process;
	
	process(TRIGGER)
	begin
		if falling_edge(TRIGGER) then
			if WaitFlag = true then
				TriggerFlag <= true;
			else
				TriggerFlag <= false;
			end if;
		end if;
	end process;
end architecture;
