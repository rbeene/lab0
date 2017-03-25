defmodule CouldDoBetter do
  @moduledoc """
  This module contains a gnarly function. The module that follows
  below it contains some tests.

  The tests pass, but the code in this module needs some TLC.

  Refactor the function to use the match & transform style we've
  discussed. As a target, aim for a new set of functions that are each
  one line long, except where that makes the code worse.

  Remember to leave the original function's API intact.

  We'll discuss a couple of people's solutions at the end.
  """


  @doc """
  The file `file_name` contains a list of words, one per line.
  This function scans it and returns a list of anagrams. where each
  entry in the list is itself a list of words that are anagrams of each
  other. So, given the list

      cat
      dog
      ferret
      act
      reefer
      tac
      god

  The function will return (in no particular order)

    [
      [ "cat", "act", "tac" ],
      [ "dog", "god" ]
    ]
  """

  def find_anagrams_in(file_name) do
    file_name
    |> words
    |> extract_signature_maps
    |> Map.values()
    |> Enum.filter(&has_anagram?/1)
  end

  def extract_signature_maps(words) do
    words
    |> Enum.reduce(%{}, &signature_maps/2)
  end

  def words(file_name) do
    File.read!(file_name)
    |> String.split("\n")
  end

  def has_anagram?(list) when length(list) > 1, do: true

  def has_anagram?(_list), do: false

  def signature_maps(word, sigs) do
    Map.update(sigs, signature(word), [word], fn list -> [ word | list ] end)
  end

  def signature(word), do: String.codepoints(word) |> Enum.sort()

end


#################### don't change below here ####################





ExUnit.start()

defmodule UglyTest do
  use ExUnit.Case

  @anagrams CouldDoBetter.find_anagrams_in("words.8800")

  test "count is correct" do
    assert length(@anagrams) == 355
  end

  test "there are five sets of anagrams with four words in them" do
    quads = Enum.filter(@anagrams, fn l -> length(l) > 3 end)
    assert length(quads) == 5
  end

  test "the longest anagram is conversation/conservation (12 letters)" do
    longest = @anagrams
    |> Enum.map(&String.length(hd(&1)))
    |> Enum.sort_by(&-&1)
    |> hd

    assert longest == 12
  end

end
