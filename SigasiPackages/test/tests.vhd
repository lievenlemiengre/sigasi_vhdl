library sigasi_sim;

entity tests is
end entity tests;

architecture t of tests is
  package integer_list_pkg is new sigasi_sim.list_pkg
    generic map(T => integer);
    
  alias integer_list is integer_list_pkg.list;
begin

  test : process is
    variable v : integer_list;
  begin
    v.add(0);
    v.add(1);
    v.add(2);
    v.add(3);
    v.add(4);
    v.add(5);
    v.add(6);
    v.add(7);
    v.add(8);
    v.add(9);
    v.add(10);
    report "SUCCESS!!" severity note;
    wait;
  end process;
  

end architecture t;
