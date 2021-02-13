defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

    # handles individual list element tagging for tag_tokens
    def tag_it(token) do
        cond do
            token == "+" || token == "-" || token == "*" || token == "/" -> {:op,token} 
            true -> {:num,parse_float(token)}
            end
    end

    # Tag's each element in the list with either :num or :op
    def tag_tokens(list) do
        Enum.map(list,fn token -> tag_it(token) end)
    end

  # compares two string operators {+,-,/,*} and returns whether or not op1 has equal or higher
  # precedence to op2
  def op_compare(op1,op2) do
    op1_val = 0
    op2_val = 0
    case {op1,op2} do
        {op1, op2} when op1 == op2 -> true
        {"*",op2} -> true
        {"/",op2} -> true
        {"+",op2} when op2 == "-" -> true
        {"-",op2} when op2 == "+" -> true
        _ -> false
    end
            
    end

  # updates the given list of operators matching the order-of-operations specs. If any op on the list has equal or higher
  # precedence to op, remove it from the list and append it to the output equation
  def update_op_list(op,list_of_op) do
    appendable_ops = Enum.filter(list_of_op,fn token -> op_compare(elem(token,1),elem(op,1)) end)
    
    #{:cont,op,appendable_ops}
    if appendable_ops == [], do: {:cont,[op|list_of_op]}, else:
    {:cont,appendable_ops,[op |remove_higher_prec(op,list_of_op)]}
    end
            
  def remove_higher_prec(op,list_of_op) do
    Enum.reject(list_of_op,fn token -> op_compare(elem(token,1),elem(op,1)) end)
    end

  # handle's individual list elements for to_postfix. 'token' is the individual element and acc is a helpful accumulator
  def post_helper(token,acc) do
    if elem(token,0) == :op, do: update_op_list(token,acc),
  else: {:cont,[token],acc}
    end

  # Takes in a list of either :num's or :op's and converts it from infix notation to postfix notation
  def to_postfix(list) do
    #ops = Enum.filter(list, fn token -> elem(token,0) == :op end)
    #nums = Enum.filter(list, fn token -> elem(token,0) == :num end)
    #acc = []
    Enum.concat(Enum.chunk_while(list, [],
        fn token, acc-> post_helper(token,acc) end, fn acc -> {:cont,Enum.into(acc,[{}]), []} end))
        
    end 

  # parses the string "op" and the list args and outputs arg[1] op arg[0] (switched to match how they were added to the list)
  def do_math(op,args) do
  opr = elem(op,1)
  arg2 = elem(elem(List.pop_at(args,0),0),1)
  arg1 = elem(elem(List.pop_at(args,1),0),1)
  case opr do
    "+" -> {:num,arg1 + arg2}
    "-" -> {:num,arg1 - arg2}
    "/" -> {:num,arg1 / arg2}
    "*" -> {:num,arg1 * arg2}
  end
  end

  # handles individual list elements given from evaluate's chunk_while function
  def evaluate_helper(token,acc) do
  case token do
    {} -> {:cont, acc}
    {:num,x} -> {:cont, [token | acc]}
    {:op,x} -> {:cont, [do_math(token,elem(Enum.split(acc,2),0)) | elem(Enum.split(acc,2),1)]}
  end
  end

  # evaluates the postfix list given in 'list' as an arith. expression
  def evaluate(list) do
        answer = List.first(Enum.chunk_while(list, [], fn token, acc-> evaluate_helper(token,acc) end, fn acc -> {:cont,elem(List.first(acc),1), []} end))
        case answer do
          _ when trunc(answer) == answer -> trunc(answer)
          _ -> answer
          end
    end

  # Takes in a string expr and returns the numeric value received when parsed as an arith. expression
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/) # split's the string up into a list
    |> tag_tokens # tag's each list element with an atom
    |> to_postfix # re-orders the list to be in postfix notation
    |> evaluate # evaluates the postfix list as an arith. expression


    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
