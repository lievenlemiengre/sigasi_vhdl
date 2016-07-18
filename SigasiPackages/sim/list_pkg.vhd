package list_pkg is
  generic(type T);

  constant DEFAULT_SIZE : natural := 10;
  type t_vector is array (natural range <>) of T;
  
  type list is protected
  
    -- to initialize or re-initialize
    procedure initialize(size_hint : natural := DEFAULT_SIZE);
    
    -- call this once you're done using
    procedure deallocate;
    
    procedure add(element : T);
    procedure set(index : natural; element : T);
    
    impure function size return natural;
    impure function get(index : natural) return T;
    
    impure function as_vector return t_vector;
    
  --    procedure grow(size : natural);
  --    function remove(index : natural) return T;
  --    function sub_list(from, to: natural) return T;
  end protected;

end package list_pkg;

package body list_pkg is

  type t_array_ref is access t_vector;

  type list is protected body
    variable arr       : t_array_ref := null;
    variable arr_size  : integer     := -1;
    variable list_size : natural     := 0;
    
    -- private methods
    
    procedure grow(min_capacity : natural) is
      variable new_capacity : integer := arr_size + arr_size * 2;
      variable new_arr : t_array_ref;
      
    begin
      if(new_capacity - min_capacity < 0) then
        new_capacity := min_capacity;
      end if;
      -- create new array
      new_arr := new t_vector(0 to new_capacity-1);
      
      -- copy contents & update state
      new_arr(0 to arr_size-1) := arr.all;
      deallocate(arr);
      arr := new_arr;
      arr_size := new_capacity;
    end;
    
    procedure ensure_capacity(min_capacity : natural) is
    begin
      if(min_capacity - list_size > 0) then
        grow(min_capacity);
      end if;
    end;
    
    procedure validate_index(index : natural) is
    begin
      if (index >= arr_size) then
        report "Out of bounds: index=" & to_string(index) & ", size=" & to_string(arr_size) severity Failure;
      end if;
    end;
    
    -- interface implementation
    
    procedure initialize(size_hint : natural := DEFAULT_SIZE) is
    begin
      if(arr = null) then
        deallocate(arr);
      end if;
      arr := new t_vector(0 to size_hint-1);
      arr_size := size_hint;
    end;
    
    procedure deallocate is
    begin
      deallocate(arr);
    end;
    
    procedure add(element : T) is
    begin
      ensure_capacity(list_size + 1);
      set(list_size, element);
      list_size := list_size + 1;
    end;

    procedure set(index : natural; element : T) is
    begin
      validate_index(index);
      arr(index) := element;
    end;
    
    impure function size return natural is
    begin
      return list_size;
    end;
    
    impure function get(index : natural)
      return T is
    begin
      validate_index(index);
      return arr(index);
    end function get;
    
    -- I think this operation is fast
    -- It should just take a slice
    -- It shouldn't take a copy
    impure function as_vector return t_vector is
    begin
      return arr(0 to list_size-1);
    end;

  end protected body;

end package body list_pkg;
