package list_pkg is
  generic(type T);

  type list is protected
    procedure add(element : T);
    procedure set(index : natural; element : T);
    impure function size return natural;
--    procedure grow(size : natural);
--    function get(index : natural) return T;
--    function remove(index : natural) return T;
--    function sub_list(from, to: natural) return T;
  end protected;

end package list_pkg;

package body list_pkg is
  
  constant DEFAULT_SIZE : natural := 10;
  
  type t_array is array(natural range <>) of T;
  type t_array_ref is access t_array;

  type list is protected body
    variable arr : t_array_ref := new t_array(0 to DEFAULT_SIZE-1);
    variable arr_size : natural := DEFAULT_SIZE;
    variable list_size : natural := 0;
    
    impure function size return natural is
    begin
      return list_size;
    end;
    
    procedure add(element : T) is
    begin
      set(list_size, element);
      list_size := list_size+1;
    end;
    
    procedure set(index: natural; element : T) is
    begin
      if(index >= arr_size) then
        report "Out of bounds: index=" & to_string(index) & ", size=" & to_string(arr_size) severity Failure;
      end if;
      arr(index) := element;
    end;
    
--    procedure set(index : natural; element : T);
--    function get(index : natural) return T;
--    function remove(index : natural) return T;
    
  end protected body;

end package body list_pkg;
