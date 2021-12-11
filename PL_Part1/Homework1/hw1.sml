fun is_older(d1 : int*int*int, d2 : int*int*int)=
    if #1 d1 < #1 d2
    then true
    else if #1 d1 > #1 d2 
    then false
    else if #2 d1 < #2 d2
    then true 
    else if #2 d1 > #2 d2
    then false
    else if #3 d1 < #3 d2
    then true
    else false 

fun number_in_month(dates : (int*int*int) list, month:int)=
    if null dates
    then 0
    else if (#2 (hd dates)) = month
    then 1 + number_in_month(tl dates, month)
    else number_in_month(tl dates,month)

fun number_in_months(dates : (int*int*int) list, months:int list)=
    if null months
    then 0
    else 
        let val num = number_in_month(dates , hd months)
        in
            num + number_in_months(dates , tl months)
        end

fun dates_in_month(dates : (int*int*int) list, month : int)=
    if null dates
    then []
    else if (#2 (hd dates)) = month
        then (hd dates)::dates_in_month(tl dates, month)
        else dates_in_month(tl dates, month)

fun dates_in_months(dates : (int*int*int) list, months:int list)=
    if null months
    then []
    else 
        let val res = dates_in_month(dates, (hd months))
        in 
            res @ dates_in_months(dates,(tl months))
            (* @ means list concatenation *)
        end 

fun get_nth(str : string list, index : int )=
    if index = 1
    then hd str
    else get_nth(tl str, index-1)

fun date_to_string(date:(int*int*int))=
    let
        val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
        get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

fun number_before_reaching_sum(sum:int , numbers:int list)=
    if null numbers
    then 0
    else if sum > hd numbers
        then 1 + number_before_reaching_sum(sum-hd numbers, tl numbers)
        else 0

fun what_month(day : int)=
    let val months = [31,28,31,30,31,30,31,31,30,31,30,31]
    in 
        number_before_reaching_sum(day, months)+1
    end

fun month_range(from:int,to:int)=
    if from > to
    then []
    else what_month(from)::month_range(from+1,to)
    
fun oldest(dates : (int*int*int) list)=
    if null dates
    then NONE
    else 
        let
            fun oldest_nonempty(dates : (int*int*int) list)=
                if null(tl dates)
                then hd dates
                else 
                    let val ans = oldest_nonempty(tl dates)
                    in 
                        if is_older(hd dates, ans)
                        then hd dates
                        else ans
                    end
        in
            SOME(oldest_nonempty dates)
        end  
