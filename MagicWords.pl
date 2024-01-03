/*
 * INF6120
 * A2023
 * TP2
 * First name     : Ali 
 * Last name      : NAYERI POOR
 * Permanent code : NAYA18019909

But du Code :

Ce code résout des énigmes de réécriture de mots à l'aide de règles spécifiées en Prolog.
Il permet de transformer un mot en un autre en appliquant ces règles.

Fonctionnement Global :

Le code définit des règles de réécriture et les regroupe dans un ensemble (rule_set).
Il crée ensuite des casse-tête en utilisant ces règles et des mots de départ.
Des prédicats sont disponibles pour afficher des mots, des règles, des ensembles de règles,
et pour effectuer des réécritures de mots en utilisant les règles.

Prédicats Principaux :

- all_puzzle_solutions :
  Trouve toutes les solutions possibles d'une longueur donnée pour un casse-tête en utilisant
  les règles spécifiées. Utilise la récursivité pour générer les chemins de solution.

- all_magic_words_of_rule_set :
  Identifie les mots magiques, c'est-à-dire ceux ayant des solutions d'une longueur spécifique,
  en utilisant les règles de manière inverse. Les mots magiques sont regroupés dans une liste.

Ces prédicats sont essentiels pour résoudre les énigmes de réécriture de mots.
*/



/******************************************************************************************/
/* Affiche un mot représenté par le terme word(LST) où LST est une liste d'entiers.        */
/* Chaque entier de la liste est affiché sans espaces.                                    */
/* Si la liste est vide, affiche 'ε'.                                                     */
/******************************************************************************************/
print_word(word([])) :- 
    write('ε'), 
    !.
print_word(word(LST)) :- 
    print_word_elements(LST).

print_word_elements([]).
print_word_elements([H|T]) :- 
    write(H), 
    print_word_elements(T).

/******************************************************************************************/
/* Imprime une liste de mots, chacun représenté par le terme word(LST) où LST est une     */
/* liste d'entiers. Chaque mot de la liste est imprimé sur une nouvelle ligne.            */
/******************************************************************************************/
print_word_list([]).
print_word_list([Word|Words]) :-
    print_word(Word),
    (Words \= [] -> nl; true),  
    print_word_list(Words).

/******************************************************************************************/
/* Imprime une règle de réécriture représentée par le terme rule(W1, W2) où W1 et W2      */
/* sont des mots formant les deux parties de la règle.                                    */
/******************************************************************************************/
print_rule(rule(word(W1), word(W2))) :-
    print_word(word(W1)),
    write(' -> '),
    print_word(word(W2)).

/******************************************************************************************/
/* Imprime un ensemble de règles de réécriture représenté par le terme rule_set(LST) où   */
/* LST est une liste de règles. Chaque règle de la liste est imprimée sur une nouvelle    */
/* ligne.                                                                                 */
/******************************************************************************************/

print_rule_set(rule_set([])) :- !.
print_rule_set(rule_set([Rule|Rules])) :-
    print_rule(Rule),
    nl,  
    print_rule_set(rule_set(Rules)).

/******************************************************************************************/
/* Imprime une instance de casse-tête. Un casse-tête est représenté par le terme         */
/* puzzle(RuleSet, Word) où RuleSet est un ensemble de règles de réécriture et Word est   */
/* le mot de départ du casse-tête.                                                        */
/******************************************************************************************/

print_puzzle(puzzle(RuleSet, Word)) :-
    write("Rule Set:\n"),
    print_rule_set(RuleSet),
    write("Word:\n"),
    print_word(Word).


/******************************************************************************************/
/* Imprime un chemin représenté par le terme path(LST) où LST est une liste de mots.      */
/* Chaque mot du chemin est séparé par '=>'.                                              */
/******************************************************************************************/

print_path(path([])).
print_path(path([Word])) :- 
    print_word(Word), 
    !.
print_path(path([Word1, Word2|Rest])) :-
    print_word(Word1),
    write(' => '),
    print_path(path([Word2|Rest])).

/******************************************************************************************/
/* Imprime une liste de chemins, chacun représenté par le terme path(LST) où LST est une  */
/* liste de mots. Chaque chemin de la liste est imprimé sur une nouvelle ligne.           */
/******************************************************************************************/

print_path_list([]).
print_path_list([Path|Paths]) :-
    print_path(Path),
    nl,  
    print_path_list(Paths).

/******************************************************************************************/
/* Concatène deux mots représentés par les termes word(LST1) et word(LST2) pour former    */
/* un nouveau mot représenté par word(LST3).                                              */
/******************************************************************************************/
word_concatenation(word(LST1), word(LST2), word(LST3)) :-
    append(LST1, LST2, LST3).
    
/******************************************************************************************/
/* Ce prédicat établit une relation entre la règle _rule et deux mots _w1 et _w2 lorsque  */
/* _w2 peut être obtenu à partir de _w1 en appliquant _rule sur l'un de ses préfixes.      */
/******************************************************************************************/

rewrite_prefix_by_rule(rule(word(Prefix), word(Substitution)), word(Original), word(Transformed)) :-
    starts_with(Original, Prefix),
    remainder_after_prefix(Original, Prefix, Remainder),
    word_concatenation(word(Substitution), word(Remainder), word(Transformed)).

starts_with([], []).
starts_with([H|T], [H|Prefix]) :-
    starts_with(T, Prefix).

remainder_after_prefix(Whole, Prefix, Remainder) :-
    append(Prefix, Remainder, Whole).

/******************************************************************************************/
/* Ce prédicat établit une relation entre la règle _rule et deux mots, le second étant     */
/* obtenu à partir du premier en appliquant _rule sur l'un de ses facteurs.               */
/******************************************************************************************/
rewrite_factor_by_rule(rule(Factor, Substitution), [], word([])) :- !.

rewrite_factor_by_rule(rule(word(F), Subst), word(W), word(Result)) :-
    split_word_at_factor(word(F), word(W), Prefix, Suffix),
    rewrite_prefix_by_rule(rule(word(F), Subst), Prefix, TransformedPrefix),
    word_concatenation(TransformedPrefix, Suffix, word(Result)).

rewrite_factor_by_rule(rule(F, S), word([Head|Tail]), word(NewWord)) :-
    rewrite_factor_by_rule(rule(F, S), word(Tail), word(TransformedRest)),
    word_concatenation(word([Head]), word(TransformedRest), word(NewWord)).

split_word_at_factor(word(Factor), word(Word), word(Prefix), word(Suffix)) :-
    length(Factor, Length),
    prefix(Word, Prefix, Length),
    length(Prefix, Length),
    suffix(Word, Suffix, Length).

prefix(Word, Prefix, Length) :-
    length(Prefix, Length),
    append(Prefix, _, Word).

suffix(Word, Suffix, Length) :-
    append(_, Suffix, Word),
    length(Prefix, Length),
    append(Prefix, Suffix, Word).

/******************************************************************************************/
/* Ce prédicat met en relation un ensemble de règles de réécriture _rule_set et deux mots */
/* _w1 et _w2. _w2 est obtenu à partir de _w1 en appliquant une règle de _rule_set sur    */
/* l'un de ses facteurs.                                                                  */
/******************************************************************************************/
rewrite(rule_set(ListOfRules), word(Word1), word(Word2)) :-
    member(SelectedRule, ListOfRules),
    rewrite_factor_by_rule(SelectedRule, word(Word1), word(Word2)).

/******************************************************************************************/
/* Relie un ensemble de règles de réécriture, une longueur de chemin, et deux mots.       */
/* Construit un chemin de réécriture de la longueur donnée transformant le premier mot    */
/* en le second en appliquant les règles de l'ensemble spécifié.                           */
/******************************************************************************************/
connecting_path(_, 0, Word, path([Word]), Word).

connecting_path(rule_set(Rules), Length, word(StartWord), path([word(StartWord)|PathTail]), word(EndWord)) :-
    Length > 0,
    NextLength is Length - 1,
    select_a_rule(Rules, word(StartWord), word(IntermediateWord)),
    connecting_path(rule_set(Rules), NextLength, word(IntermediateWord), path(PathTail), word(EndWord)).

select_a_rule(Rules, StartWord, ResultWord) :-
    member(Rule, Rules),
    rewrite_factor_by_rule(Rule, StartWord, ResultWord).

/******************************************************************************************/
/* Met en relation une instance de casse-tête _puzzle, un entier _len et un chemin        */
/* de solution _solution. _solution est un chemin de solution de longueur _len pour       */
/* l'instance de casse-tête _puzzle.                                                      */
/******************************************************************************************/
puzzle_solution(puzzle(rule_set(Rules), word(MagicWord)), Length, path(SolutionPath)) :-
    find_solution_path(rule_set(Rules), Length, word(MagicWord), path(SolutionPath), word([])).

find_solution_path(rule_set(Rules), Length, StartWord, path(SolutionPath), word([])) :-
    connecting_path(rule_set(Rules), Length, StartWord, path(SolutionPath), word([])).

/******************************************************************************************/
/* Associe une instance de puzzle, une longueur spécifique, et une liste de chemins       */
/* de solution. Les solutions de la longueur donnée pour le puzzle sont exactement        */
/* représentées par les chemins de la liste.                                              */
/******************************************************************************************/
all_puzzle_solutions(puzzle(rule_set(Rules), word(MagicWord)), Length, Solutions) :-
    gather_all_solutions(rule_set(Rules), Length, word(MagicWord), Solutions).

gather_all_solutions(rule_set(Rules), Length, StartWord, SortedSolutions) :-
    findall(path(SolutionPath), puzzle_solution(puzzle(rule_set(Rules), StartWord), Length, path(SolutionPath)), SolutionsList),
    sort(SolutionsList, SortedSolutions).

/******************************************************************************************/
/* Relie un ensemble de règles de réécriture, un nombre entier et un mot spécifique,      */
/* où le mot est considéré magique s'il a une solution avec une longueur spécifiée        */
/* utilisant l'ensemble des règles de réécriture.                                         */
/******************************************************************************************/
magic_word_of_rule_set(rule_set(Rules), Length, word(MagicWord)) :-
    reverse_rules(rule_set(Rules), ReversedRuleSet),
    connecting_path(ReversedRuleSet, Length, word([]), _, word(MagicWord)).

reverse_rules(rule_set([]), rule_set([])).
reverse_rules(rule_set([Rule | Rest]), rule_set([ReversedRule | ReversedRest])) :-
    reverse_single_rule(Rule, ReversedRule),
    reverse_rules(rule_set(Rest), rule_set(ReversedRest)).

reverse_single_rule(rule(word(W1), word(W2)), rule(word(W2), word(W1))).

/******************************************************************************************/
/* Associe un ensemble de règles, un entier et une liste de mots magiques, où chaque mot  */
/* de la liste représente une solution possible d'une énigme de longueur spécifiée         */
/* en utilisant l'ensemble de règles donné.                                                */
/******************************************************************************************/
all_magic_words_of_rule_set(rule_set(Rules), Length, MagicWords) :-
    findall(MagicWord, generate_magic_word(rule_set(Rules), Length, MagicWord), List),
    sort(List, MagicWords).

generate_magic_word(rule_set(Rules), Length, word(MagicWord)) :-
    reverse_rules(rule_set(Rules), rule_set(ReversedRules)),
    connecting_path(rule_set(ReversedRules), Length, word([]), _, word(MagicWord)).

reverse_rules(rule_set([]), rule_set([])).
reverse_rules(rule_set([Rule | Rest]), rule_set([ReversedRule | ReversedRest])) :-
    reverse_single_rule(Rule, ReversedRule),
    reverse_rules(rule_set(Rest), rule_set(ReversedRest)).

reverse_single_rule(rule(word(W1), word(W2)), rule(word(W2), word(W1))).