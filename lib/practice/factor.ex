defmodule Practice.Factor do

  # takes in an item (ignored, but included for the chunk_while template) and checks if the current y value is a factor
  # of x. Returns a tuple corresponding to the desired return per chunk_while's specs.
  def next_factor(item,acc) do
    x = List.first(acc)
    y = List.last(acc)
    cond do
          rem(x,2)==0 -> {:cont,2,[trunc(x/2),y]}
          rem(x,y)==0 -> {:cont,y,[trunc(x/y),y]}
          true -> {:cont,[x,y+2]}
          end
  end


  # take in an integer (x) and return a list of integers representing x's prime factorization
  def factor(x) do
        list = 1..x # get an enum of length x
        y = 3 # starting point for odd factorization

        # runs a loop over list using [x,y] as accumulators (x stores the current divided num, y stores the curr prime number)
        Enum.chunk_while(list,[x,y],fn n,acc-> next_factor(n,acc) end,fn acc-> {:cont,[]} end)

  end
end
