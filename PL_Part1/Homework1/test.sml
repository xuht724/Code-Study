fun sum_list(x : int list)=
    if null x
    then 0
    else hd x + sum_list(tl x)

fun count_down(x :int) = (* int - >int list *)
    if x=0
    then []
    else x::count_down(x-1)

fun append(x :int list, y : int list) = 
    if null x
    then y
    else hd x :: append(tl x, y)

fun count(from :int, to :int) = 
    if from=to
    then to :: []
    else from :: count(from+1,to)

fun count_from1(to:int)=
    let fun count(from :int)=
        if from = to
        then from::[]
        else from :: count(from+1)
    in 
        count(1)
    end 

val res = count_from1(10)

(* 
val m = [1,2,3,4,5];
val n = [2,5];
val test = 5;
(* val y = sum_list m; *)
val res = append(m,n); *)

