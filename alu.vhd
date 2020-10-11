library ieee;
use ieee.numeric_bit.all;

entity alu1bit is
    port (
        a, b, less, cin: in bit;
        result, cout, set, overflow: out bit;
        ainvert, binvert: in bit;
        operation: in bit_vector(1 downto 0)
    );
end entity ;

architecture behav of alu1bit is
signal au : bit;
signal bu : bit;
begin
au <= (not(a)) when ainvert = '1' else
    a;
bu <= (not(b)) when binvert = '1' else
    b;
result <= (au and bu) when operation = "00" else
        (au or bu) when operation = "01" else
        (au xor bu xor cin) when operation = "10" else
        (b);
cout <= ((au and bu) or (au and cin) or (cin and bu));
    
set <= (au xor bu xor cin);
overflow <= ((au and bu) or (au and cin) or (cin and bu))xor cin;

end behav;



entity alu is
	generic(
		size : natural := 10
	);
	port (
		A, B 		 : in  bit_vector(size-1 downto 0);
		F  			 : out bit_vector(size-1 downto 0);
		S   		 : in  bit_vector (3 downto 0);
		Z            : out bit;
		Ov           : out bit;
		Co           : out bit
		);
end entity alu;



architecture arch of alu is

	component alu1bit is 
		port (
			a, b, less, cin : in bit;
			result, cout, set, overflow : out bit;
			ainvert, binvert : in bit;
			operation : in bit_vector(1 downto 0)
		);
	end component;

	signal cin, result, cout, set, ovf : bit_vector(size-1 downto 0) := (others => '0');
	signal op : bit_vector(1 downto 0);
    signal zerado : bit_vector(size-1 downto 0) := (others => '0');
    

	
begin

    op <= S(1 downto 0);


    gen : for i in 0 to (size - 1) generate
        G0: if i = 0 generate
            
            alu0 : alu1bit port map (
                a => A(0),
                b => B(0),
                less => B(0),
                cin => S(2),
                result => result(0),
                cout => cout(0),
                set => set(0),
                overflow => ovf(0),
                ainvert => S(3),
                binvert => S(2),
                operation => op
            );
        end generate;

        Gn: if i > 0 generate

            alui : alu1bit port map (
                a => A(i),
                b => B(i),
                less => B(i),
                cin => cout(i-1),
                result => result(i),
                cout => cout(i),
                set => set(i),
                overflow => ovf(i),
                ainvert => S(3),
                binvert => S(2),
                operation => op
            );
        end generate;
    end generate gen;  

     

    Ov <= ovf(size-1);
    F <= (result);
    Co <= cout(size-1);
    Z <= '1' when result = zerado else '0';
    
    

end architecture;
