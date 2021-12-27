(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2
(* put your solutions for problem 1 here *)

fun all_except_option(str, sl) = 
   case sl of
      [] => NONE
    | x::xs => case same_string(str, x) of  
                  true => SOME(xs)
               |  false => case all_except_option(str, xs) of
                                 NONE => NONE
                              |  SOME y => SOME(x::y)

fun get_substitutions1 (subs, s) =
  case subs of
    [] => []
    | (x :: xs) => case all_except_option(s, x) of 
                     NONE => get_substitutions1(xs, s)
                     | SOME res => res @ get_substitutions1(xs, s) 

fun get_substitutions2(subs, s) = 
   let fun tmp(subs,s,acc) = 
         case subs of
            [] => acc
          | (x::xs) => case all_except_option(s,x) of    
                        NONE => tmp(xs,s,acc)
                      | SOME res => tmp(xs,s,acc @ res)
   in
      tmp(subs,s,[])
   end

type Name = {first:string, middle:string, last:string}
fun similar_names(strls,name) = 
   let fun tmp(strls,acc) = 
      case strls of
      [] => acc
      | (x::xs) => tmp(xs, acc @ [{first=x,middle = (#middle name),last  = (#last name)}])
   in
      tmp(get_substitutions2(strls, (#first name)), [name])
   end

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

fun card_color(suit, _) = 
   case suit of
   Clubs => Black
   | Spades => Black
   | Diamonds => Red
   | Hearts => Red

fun card_value(suit, rank) = 
   case rank of
   Ace => 11
   | King => 10
   | Queen => 10
   | Jack => 10
   | Num x => x

fun remove_card(cs, c, e) =
  case cs of
    [] => raise e
    | x::xs => case c = x of
                 true => xs
                 | false => case remove_card(xs, c, e) of
                              [] => [x]
                              | y::ys => x::y::ys 

fun all_same_color (cs) =
  case cs of
    [] => true
    | a::[] => true
    | a::b::tail => case card_color(a) = card_color(b) of
                    true => all_same_color(b::tail)
                    | false => false

fun sum_cards (cs) =
  let fun aux (cs, acc) =
    case cs of
      [] => acc
      | x::xs => aux(xs, acc + card_value(x))
  in
    aux(cs, 0)
  end

fun score (cs, goal) = 
  let fun pre_score (cs) =
    case (sum_cards(cs), goal) of
      (sum, goal) => case sum > goal of
                       true => (sum - goal) * 3
                       | false => goal - sum
  in
    case all_same_color(cs) of
      true => pre_score(cs) div 2
      | false => pre_score(cs)
  end

fun officiate (cs, ms, goal) =
  let fun process_moves(cs, ms, held) =
      case ms of
        [] => held
        | m::ms_tail => case m of
                          Discard card => process_moves(cs, ms_tail, remove_card(held, card, IllegalMove))
                          | Draw => case cs of
                                      [] => held
                                      | c::_ => case sum_cards(c::held) > goal of
                                                  true => c::held
                                                  | false => process_moves(remove_card(cs, c, IllegalMove), ms_tail, c::held)
                                                       
                                                       
  in
    score(process_moves(cs, ms, []), goal) 
  end

