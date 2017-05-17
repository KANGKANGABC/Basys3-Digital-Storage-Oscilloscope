--vga?????èo???ì?????????¤???Hsync,Vsync?????o?ì??±???§????
--?????????00*600*60,??±?0M???????¨|?é?????
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga is
    generic(framlen:integer:=8);--?????????oframlen-1
    port
    (
--        ri,le,k:in std_logic; 
        adderss1:out std_logic_vector(16 downto 0);       
        adderss3:out std_logic_vector(16 downto 0);         
        rgb:in std_logic_vector(2 downto 0);
        rgb1:in std_logic_vector(2 downto 0);        
        clkin,resetin:in std_logic;--??a?¨|?ˉ??????è??????????¤¨¨??°??-?
        hsync,vsync:out std_logic;--vga???ì?????????¤¨¨??°??o
        r,g,b:out std_logic_vector(3 downto 0)--r,g,b¨¨??2???¨¨??°??o
--???§????????-3¨¨??°??-￡¤?????3?????????????????èo???é???
        ------
    );
end vga;

architecture behave of vga is
    constant H_VALID:integer:=1280;--800;--¨¨???????????a?¨|?a?
    constant H_FRONT:integer:=48;--40;--¨¨???????2?
    constant H_SYNC:integer:=112;--128;--¨¨??????-?
    constant H_BACK:integer:=408;--88;--¨¨??????2?
    constant H_PRD:integer:=H_VALID+H_FRONT+H_SYNC+H_BACK;

    constant V_VALID:integer:=1024;--600;--??o?????????a?¨|?a?
    constant V_FRONT:integer:=1;--1;--??o?????2?
    constant V_SYNC:integer:=3;--4;--??o????-?
    constant V_BACK:integer:=42;---23;--??o????2?
    constant V_PRD:integer:=V_FRONT+V_SYNC+V_BACK+V_VALID;

    type h_state is (hs_valid,hs_back,hs_front,hs_sync);
    type v_state is (vs_valid,vs_back,vs_front,vs_sync);

    signal hsync_iner:std_logic;
    signal hs_state:h_state:=hs_back;
    signal vs_state:v_state:=vs_back;

    signal h_cnt_iner:integer range 0 to H_PRD;
    signal v_cnt_iner:integer range 0 to V_PRD;

    signal h_x:integer range 0 to 800:=150;
    signal v_y:integer range 0 to 600:=175;
    signal h_x1:integer range 0 to 800:=320;
    signal v_y1:integer range 0 to 600:=256;     
    signal h_x11:integer range 0 to 800:=320;
    signal v_y11:integer range 0 to 600:=512;       
    signal h_x2:integer range 0 to 800:=400;
    signal v_y2:integer range 0 to 600:=365;
    
    signal h_xw1:integer range 0 to 800:=90;  --wenhao1 
    signal v_yw1:integer range 0 to 600:=310; --wenhao1            
    signal h_xw2:integer range 0 to 800:=240; --wenhao2 
    signal v_yw2:integer range 0 to 600:=310; --wenhao2 
    signal h_xw3:integer range 0 to 800:=300; --wenhao3 
    signal v_yw3:integer range 0 to 600:=310; --wenhao3     
    signal h_xw4:integer range 0 to 800:=270; --wenhao4 
    signal v_yw4:integer range 0 to 600:=170; --wenhao4 
    signal h_xw5:integer range 0 to 800:=75;  --wenhao5 
    signal v_yw5:integer range 0 to 600:=300; --wenhao5 
    signal h_xw6:integer range 0 to 800:=75;  --wenhao6 
    signal v_yw6:integer range 0 to 600:=300; --wenhao6 
    signal h_xw7:integer range 0 to 800:=75;  --wenhao7 
    signal v_yw7:integer range 0 to 600:=300; --wenhao7 
    signal h_xw8:integer range 0 to 800:=75;  --wenhao8 
    signal v_yw8:integer range 0 to 600:=300; --wenhao8 

    signal h_xz1:integer range 0 to 800:=210;  --zhuantou1 
    signal v_yz1:integer range 0 to 600:=310;  --zhuantou1
    signal h_xz2:integer range 0 to 800:=270;  --zhuantou2 
    signal v_yz2:integer range 0 to 600:=310;  --zhuantou2
    signal h_xz3:integer range 0 to 800:=330;  --zhuantou3 
    signal v_yz3:integer range 0 to 600:=310;  --zhuantou3

    signal h_xs1:integer range 0 to 800:=450;  --shuiguan1 
    signal v_ys1:integer range 0 to 600:=380;  --shuiguan1
    signal h_xs2:integer range 0 to 800:=720;  --shuiguan2 
    signal v_ys2:integer range 0 to 600:=345;  --shuiguan2    
    signal adderss:integer range 0 to 131071;
    signal adderss2:integer range 0 to 131071;

    signal buffer1 : integer:= 0;
    signal buffer2 : integer:= 388;

    signal r2:std_logic;
    signal g2:std_logic;
    signal b2:std_logic;
    SIGNAL key_b:std_logic_vector(2 downto 0):="011";
    signal x1:integer range 0 to 800:=318;
    signal y1:integer range 0 to 600:=512;     
    --

begin
--
hsync<=hsync_iner;
--
gen_hsync:   
        process(clkin,resetin)
            variable h_cnt:integer range 0 to H_PRD;
        begin
            if resetin='0' then
                hs_state<=hs_front;--??è??????a?¨¨????-￡¤?????2?
                h_cnt:=0;
                hsync_iner<='1';
            elsif rising_edge(clkin) then
                h_cnt:=h_cnt+1;
                case hs_state is  --
                    when hs_front=>  --?????2?
                        if h_cnt<(H_FRONT) then
                            hs_state<=hs_front;   
                            hsync_iner<='1';
                        else
                            hs_state<=hs_sync;
                            hsync_iner<='0';--?????ì??o?ì??±?¨¨??????-￡¤?????±|ì?1?
                        end if;
                    when hs_sync=>  --¨¨??????-?
                        if h_cnt<(H_FRONT+H_SYNC) then
                            hs_state<=hs_sync;   
                            hsync_iner<='0';
                        else
                            hs_state<=hs_back;
                            hsync_iner<='1';
                        end if;
                    when hs_back=> --????2?
                        if h_cnt<(H_FRONT+H_SYNC+H_BACK) then
                            hs_state<=hs_back;   
                            hsync_iner<='1';
                        else
                            hs_state<=hs_valid;
                            hsync_iner<='1';
                        end if;
                    when hs_valid=>--?????????a?¨|?a??
                        if h_cnt<(H_FRONT+H_SYNC+H_BACK+H_VALID) then
                            hs_state<=hs_valid;   
                            hsync_iner<='1';
                        else
                            hs_state<=hs_front;
                            hsync_iner<='1';
                            h_cnt:=0;--??è????¨¨?????????
                        end if;   
                    when others=>
                        hs_state<=hs_front;
                        h_cnt:=0;
                        hsync_iner<='1';
                end case;
            end if;
        --h_cnt_tst<=h_cnt;
        h_cnt_iner<=h_cnt;
    end process;
----------
gen_vsync:
    process(resetin,hsync_iner)   
    variable v_cnt:integer range 0 to V_PRD;
    begin
        if resetin='0' then
            vs_state<=vs_front;--??è??????a?¨¨????-￡¤?????2?
            v_cnt:=0;
            vsync<='1';
        elsif falling_edge(hsync_iner) then--???§???¨|???2????????-?
            v_cnt:=v_cnt+1;
            case vs_state is  --
                when vs_front=>  --?????2?
                    if v_cnt<(V_FRONT) then
                        vs_state<=vs_front;   
                        vsync<='1';
                    else
                        vs_state<=vs_sync;
                        vsync<='0';--?????ì??o?ì??±???o????-￡¤?????±|ì?1?
                    end if;
                when vs_sync=>  --??o????-?
                    if v_cnt<(V_FRONT+V_SYNC) then
                        vs_state<=vs_sync;   
                        vsync<='0';
                    else
                        vs_state<=vs_back;
                        vsync<='1';
                    end if;
                when vs_back=> --????2?
                    if v_cnt<(V_FRONT+V_SYNC+V_BACK) then
                        vs_state<=vs_back;   
                        vsync<='1';
                    else
                        vs_state<=vs_valid;
                        vsync<='1';
                    end if;
                when vs_valid=>--?????????a?¨|?a??
                    if v_cnt<(V_FRONT+V_SYNC+V_BACK+V_VALID) then
                        vs_state<=vs_valid;   
                        vsync<='1';
                    else
                        vs_state<=vs_front;
                        vsync<='1';
                        v_cnt:=0;--??è????¨¨?????????
                    end if;
                when others=>
                    vs_state<=vs_front;
                    v_cnt:=0;
                    vsync<='1';
            end case;
        end if;
        --v_cnt_tst<=v_cnt;
        v_cnt_iner<=v_cnt;
    end process;
    
    
fuzhi:
            process(clkin)
    begin
            if h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+h_x1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+v_y1 then
               adderss<=(h_cnt_iner-(H_FRONT+H_SYNC+H_BACK+h_x1))+(v_cnt_iner-(V_FRONT+V_SYNC+V_BACK+v_y1))*512;
            else
               adderss<=0;
            end if;
           end process; 
fuzhi1:
                       process(clkin)
               begin
                       if h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+h_x11 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+v_y11 then
                          adderss2<=(h_cnt_iner-(H_FRONT+H_SYNC+H_BACK+h_x11))+(v_cnt_iner-(V_FRONT+V_SYNC+V_BACK+v_y11))*512;
                       else
                          adderss2<=8;
                       end if;
                      end process; 
                      
                      
                      
                            
              
gen_video_data:
    process(v_cnt_iner,h_cnt_iner,h_x,v_y)
    variable v_green:std_logic;
    variable v_blue:std_logic;
    variable v_red:std_logic;
    begin            
                                            
          if key_b="011" then
            if h_cnt_iner<H_FRONT+H_SYNC+H_BACK then--¨¨?¤3¨¨???????2?+????-￡¤+????2????????????????a?¨|?a??800?????|ì?????￥???|ì100
                r<="0000"; g<="0000";b<="0000";



            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+2 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="1111";g<="1111";b<="1111";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+32 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+32+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";         
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+64 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+64+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                               
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+96 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+96+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                               
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+128 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+128+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                               
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+160 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+160+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                               
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+192 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+192+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                               
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+224 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+224+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+256 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+256+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                            
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+288 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+288+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+320 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+320+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+352 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+352+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+384 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+384+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                 
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+416 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+416+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+448 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+448+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+480 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+480+1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="0010";g<="0010";b<="0010";                                         
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1+512 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512+2 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256 then
                             r<="1111";g<="1111";b<="1111";  
                             
                             
                             
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+1 then
                             r<="1111";g<="1111";b<="1111";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+32 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+32+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+64 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+64+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+96 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+96+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+128 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+128+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+160 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+160+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+192 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+192+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+224 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+224+1 then
                             r<="0010";g<="0010";b<="0010";  
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+x1 and h_cnt_iner<H_FRONT+H_SYNC+H_BACK+x1+512 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+y1+256 and v_cnt_iner<V_FRONT+V_SYNC+V_BACK+y1+256+2 then
                             r<="1111";g<="1111";b<="1111";  
                     

                
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+h_x1 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+v_y1 and h_cnt_iner<=H_FRONT+H_SYNC+H_BACK+h_x1+511 and v_cnt_iner<=V_FRONT+V_SYNC+V_BACK+v_y1+255 then
                    r<=rgb(2)&rgb(2)&rgb(2)&rgb(2);g<=rgb(1)&rgb(1)&rgb(1)&rgb(1);b<=rgb(0)&rgb(0)&rgb(0)&rgb(0);    
            elsif h_cnt_iner>=H_FRONT+H_SYNC+H_BACK+h_x11+2 and v_cnt_iner>=V_FRONT+V_SYNC+V_BACK+v_y11 and h_cnt_iner<=H_FRONT+H_SYNC+H_BACK+h_x11+511+2 and v_cnt_iner<=V_FRONT+V_SYNC+V_BACK+v_y11+255 then
                         r<=rgb1(2)&rgb1(2)&rgb1(2)&rgb1(2);g<=rgb1(1)&rgb1(1)&rgb1(1)&rgb1(1);b<=rgb1(0)&rgb1(0)&rgb1(0)&rgb1(0);                                         

                else
                r<="0000"; g<="0000";b<="0000";
                end if;                                                            
            end if;         
adderss1<=CONV_STD_LOGIC_VECTOR(adderss,17);     
adderss3<=CONV_STD_LOGIC_VECTOR(adderss2,17);                  
    end process;
end behave;
