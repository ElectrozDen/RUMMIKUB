type 'e melt = 'e * int ;;
type 'e mset = NIL | Cons of 'e melt * 'e mset ;;

let me = Cons((3,2), Cons((4,1), Cons((6,3) , NIL))) ;;

let me2 = Cons((3,4), NIL) ;;

let isempty (s:'e mset) : bool =
match s with
|NIL -> true
|_ -> false ;;

let rec cardinal (s:'e mset) : int =
match s with
|NIL -> 0
|Cons((b1,b2),b3) -> b2 + cardinal (b3) ;;


let rec nb_occurences (e : 'e) (s : 'e mset) : int =
match s with
|NIL -> 0
|Cons((b1,b2), b3) -> if b1 == e then b2 + nb_occurences e b3
                                 else  nb_occurences e b3 ;;

let rec member (e:'e) (s:'e mset) : bool =
match s with
|NIL -> false 
|Cons((b1,b2),b3) -> if b1== e then true 
  else member e b3 
;;


let rec subset (s1 : 'e mset) (s2 : 'e mset) : bool =
match s1 with
|NIL ->true
|Cons((b1,b2), b3) -> if b2 <= nb_occurences b1 s2 then subset b3 s2
                                                   else false

;;

let rec add (e: 'e melt) (s: 'e mset) : 'e mset =
  let (b1,b2)=e in match s with 
    |NIL -> Cons(e, s)
    |Cons((b3,b4),b5) -> if b3==b1 then Cons((b3,b4+b2), b5)
                                   else Cons((b3,b4), add (e) (b5));;

let rec remove (e : 'e melt) ( s : 'e mset) : 'e mset =
  let (b1,b2) = e in match s with
    |NIL ->Cons(e, s)
    |Cons((b3,b4),b5) -> if b3==b1
                         then if b2 >=b4 then b5
                              else Cons((b3,b4-b2), b5)
                         else Cons((b3,b4), remove (e) (b5))
;; 

let equal ( s1 : 'e mset) ( s2 : 'e mset ) : bool = 
	if cardinal s1 == cardinal s2 && subset s1 s2 == true
	then true
	else false
                           
;; 

let rec sum (s1 : 'e mset) (s2 : 'e mset) : 'e mset =
match s1 with
|NIL-> s2
|Cons(b1,b2) -> sum b2 (add b1 s2)
 ;;


let rec intersection (s1:'e mset) (s2:'e mset):'e mset=
match s1 with 
|NIL->NIL
|Cons((a,b),s3)->if (member a s2) then (add (a,b) (intersection s3 s2)) else (intersection s3 s2);;



let rec difference (s1 :'e mset) (s2 : 'e mset) : 'e mset =
match s1 with 
|NIL -> NIL 
|Cons((a,b),fin) -> if member a s2 then if nb_occurences a s2 == b then difference fin s2
				    				    else Cons((a,(abs(nb_occurences (a) (s2) - b))), difference fin s2)
 				    else Cons((a,b),difference fin s2)
;;

let rec get (n:int) (s:'e mset) : 'e =
match s with
|NIL -> failwith("Vous avez mis un chiffre trop grand")
|Cons((a,b),fin)-> match n with
|1->a
|_->if n>b then (get (n-b) fin)      
else a
;;		

let getrandom (s:'e mset):'e=
(get (Random.int (cardinal s))+1 s);;
							
