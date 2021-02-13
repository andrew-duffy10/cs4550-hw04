defmodule Practice.Palindrome do

  #takes in a string (word) and returns Yes or No depending on if the word is a palindrome
  def palindrome(word) do
    reverse_word = String.reverse(word)
    case word do
      _ when word == reverse_word -> "Yes"
      _ -> "No"
    end

  end
end
