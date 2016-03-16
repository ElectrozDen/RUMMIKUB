# BARRUCAND Robin && ROQUET Denys

# PROJET OCAML : RUMMIKUB
 
# Partie : Ensemble avec répétitions

## Lien vers le code source : 

https://github.com/ElectrozDen/RUMMIKUB/blob/master/Roquet_Denys_-_Barrucand_Robin/src/partie2.ml

## Definition des types :

```
type 'e melt = 'e * int ;;
type 'e mset = NIL | Cons of 'e melt * 'e mset ;;
```

'e melt est un couple qui désigne un chiffre avec son nombre d'occurences
'e mset est un multi-ensemble de 'e melt (type récursig)

## Constantes pour effectuer des test sur les fonctions :

```
let me = Cons((3,2), Cons((4,1), Cons((6,3) , NIL))) ;;

let me2 = Cons((3,4), NIL) ;;
```

## Fonction isempty:
	
### Profil : 'e mset -> bool

### Sémantique: Vérifie si 'e mset est vide

### Exemples: 
isempty me;; -> false</br>
isempty NIL;; -> true

### Code :
```
let isempty (s:'e mset) : bool =
match s with
|NIL -> true
|_ -> false ;;
```

## Fonction cardinal :

### Profil : 'e mset -> int

### Sémentique : Donne le cardinal de 'e mset

### Exemples:
cardinal me ;; -> 6</br>
cardinal me2;; -> 4

### Code :
```
let rec cardinal (s:'e mset) : int =
match s with
|NIL -> 0
|Cons((b1,b2),b3) -> b2 + cardinal (b3) ;;
```

## Fonction nb_occurences : 

### Profil: 'e -> 'e mset -> int

### Sémentique : Donne le nombre d'occurences de l'élément 'e dans le multi-ensemble 'e mset

### Exemples:
nb_occurences 3 me;; -> 2</br>
nb_occurences 7 me;; -> 7

### Code :
```
let rec nb_occurences (e : 'e) (s : 'e mset) : int =
match s with
|NIL -> 0
|Cons((b1,b2), b3) -> if b1 == e then b2 + nb_occurences e b3
                                 else  nb_occurences e b3 ;;
```

## Fonction member : 

### Profil : 'e -> 'e mset -> bool

### Sémentique : Vérifie si l'élément 'e appartient au multi-ensemble 'e mset

### Exemples : 
member 3 me;; -> true</br>
member 7 me;; -> false</br>

2 façons:

### Code :
```
let rec member (e:'e) (s:'e mset) : bool =
match s with
|NIL -> false 
|Cons((b1,b2),b3) -> if b1== e then true 
  else member e b3 
;;
```

```
let rec member2 (e:'e) (s:'e mset) : bool =
if nb_occurences e s > 0 then true
else false
;;
```

## Fonction subset : 

### Profil : 'e mset -> 'e mset -> bool

### Sémentique : Vérifie si et seulement si le premier multi-ensemble est inclus ou egal dans le deuxieme multi-ensemble

### Exemples : 
subset me me;; -> true;;
subset me me2;; > false;;</br>

### Code :
```
let rec subset (s1 : 'e mset) (s2 : 'e mset) : bool =
match s1 with
|NIL ->true
|Cons((b1,b2), b3) -> if b2 <= nb_occurences b1 s2 then subset b3 s2
                                                   else false

;;
```

## Fonction add : 

### Profil : 'e melt -> 'e mset -> 'e mset

### Sémentique : Ajoute un certain nombre d'occurences d'un élément dans le multi-ensemble

### Exemple : 
add (3,5) me;; ->  Cons ((3, 7), Cons ((4, 1), Cons ((6, 3), NIL)))

### Code :
```
let rec add (e: 'e melt) (s: 'e mset) : 'e mset =
  let (b1,b2)=e in match s with 
    |NIL -> Cons(e, s)
    |Cons((b3,b4),b5) -> if b3==b1 then Cons((b3,b4+b2), b5)
                                   else Cons((b3,b4), add (e) (b5));;
```

## Fonction remove : 

### Profil : 'e melt -> 'e mset -> 'e mset

### Sémentique : Supprime un certain nombre d'occurences d'un élément dans le multi-ensemble

### Exemple :
remove (3,5) me;; ->  Cons ((4, 1), Cons ((6, 3), NIL))

### Code :
```
let rec remove (e : 'e melt) ( s : 'e mset) : 'e mset =
  let (b1,b2) = e in match s with
    |NIL ->Cons(e, s)
    |Cons((b3,b4),b5) -> if b3==b1
                         then if b2 >=b4 then b5
                              else Cons((b3,b4-b2), b5)
                         else Cons((b3,b4), remove (e) (b5))
;; 
```

## Fonction equal : 

### Profil : 'e mset -> 'e mset -> bool

### Sémentique : Vérifie si le premier multi-ensemble est égal au deuxieme multi-ensemble

### Exemples : 
equal me me;; -> true</br>
equal NIL me;; -> false</br>
equal me me2;; -> false

### Code :
```
let equal ( s1 : 'e mset) ( s2 : 'e mset ) : bool = 
	if cardinal s1 == cardinal s2 && subset s1 s2 == true
	then true
	else false
                           
;; 
```

## Fonction sum : 

### Profil : 'e mset -> 'e mset -> 'e mset

### Sémentique : Additionne deux multi-ensemble

### Exemple :
sum me me2;; -> Cons ((3, 6), Cons ((4, 1), Cons ((6, 3), NIL)))

### Code :
```
let rec sum (s1 : 'e mset) (s2 : 'e mset) : 'e mset =
match s1 with
|NIL-> s2
|Cons(b1,b2) -> sum b2 (add b1 s2)
 ;;
```

## Fonction intersection : 

### Profil : 'e mset -> 'e mset -> 'e mset

### Sémentique : Renvoie le multi-ensemble qui est l'intersection des deux multi-ensembles

### Exemple :
intersection me me2;; -> Cons ((3, 2), NIL)

### Code :
```
let rec intersection (s1:'e mset) (s2:'e mset):'e mset=
match s1 with 
|NIL->NIL
|Cons((a,b),s3)->if (member a s2) then (add (a,b) (intersection s3 s2)) else (intersection s3 s2);;
```

## Fonction difference : 

### Profil: 'e mset > 'e mset -> 'e mset 

### Sémentique : Renvoie le multi-ensemble qui est la différence entre les deux multi-ensembles

### Exemple : 
difference me2 me;; -> Cons ((3, 2), Cons ((4, 1), Cons ((6, 3), NIL)))

### Code :
```
let rec difference (s1 :'e mset) (s2 : 'e mset) : 'e mset =
match s1 with 
|NIL -> NIL 
|Cons((a,b),fin) -> if member a s2 then if nb_occurences a s2 == b then difference fin s2
				    				    else Cons((a,(abs(nb_occurences (a) (s2) - b))), difference fin s2)
 				    else Cons((a,b),difference fin s2)
;;
```

## Fonction get : 

### Profil : int -> 'e mset ;;

### Sémentique  : Renvoie le n ieme élément dans le multi-ensemble

### Exemples : 
get 4 me;; -> 6</br>
get 2 me2;; -> 3

### Code :
```
let rec get (n:int) (s:'e mset) : 'e =
match s with
|NIL -> failwith("Vous avez mis un chiffre trop grand")
|Cons((a,b),fin)-> match n with
|1->a
|_->if n>b then (get (n-b) fin) 
else a
;;
```

## Fonction getrandom : 

### Profil : 'e mset -> 'e

### Sémentique : Renvoie un élément au hasard du multi-ensemble

### Exemples :
getrandom me;; -> 3</br>
getrandom me;; -> 6

### Code :
```
let getrandom (s:'e mset):'e=
(get (Random.int ((cardinal s)+1)) s);;
```
