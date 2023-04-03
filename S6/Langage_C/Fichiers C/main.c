#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

// Consignes :
//      - Compl�ter les instructions pour r�aliser les fonctions et proc�dures de ce fichier de fa�on � ex�cuter les tests avec succ�s.
// Vous pouvez utiliser les sous-programmes de la biblioth�que string.h pour r�aliser les principales op�rations (copie, recherche, etc.)

struct string {
    char *str; // tableau de caracteres. Doit se terminer par `\0`.
    int N; // nombre de caract�res, `\0` inclus.
};
typedef struct string string;

/**
 * \brief Initialiser � partir d�une cha�ne de caract�res classique (tableau de caract�res termin� par le caract�re nul)
 * \param[out] string_dest string initialis�
 * \param[in] chaine_src chaine conventionnelle
 */
void create(string *string_dest, char *chaine_src){
    string_dest->str = calloc(1+strlen(chaine_src), sizeof(char));
    strcpy(string_dest->str, chaine_src);
    string_dest->N = strlen(chaine_src ) + 1;
}

/**
 * \brief obtenir le nombre de caract�res de la cha�ne
 * \param[in] str chaine
 */
int length(string str){
    return str.N-1;
}

/**
 * \brief ajouter un nouveau caract�re � la fin de la cha�ne. Sa longueur est donc augment�e de 1.
 * \param[inout] chaine_dest
 * \param[in] c caract�res � ajouter en fin de chaine.
*/

void add(string *chaine_dest, char c){
    chaine_dest->str = (char *) realloc(chaine_dest->str, chaine_dest->N+1);
    chaine_dest->str[chaine_dest->N-1] = c;
    chaine_dest->N++;
}

/**
 * \brief supprimer le caract�re � la position i.
 * \param[inout] chaine_dest
 * \param[in] i position du caractere dans la chaine (attention � la precondition).
*/
void delete(string *chaine_dest, int i){
   char * strTemp = calloc(chaine_dest->N, sizeof(char));
   strcpy(strTemp, chaine_dest->str);
   free(chaine_dest->str);
   chaine_dest->str = (char*)malloc((chaine_dest->N-1)*sizeof(char));

   int k = 0;
   int z = 0;

   while (k < chaine_dest->N-1){
        if (k!=i){
            chaine_dest->str[z]=strTemp[k];
            z++;
        }
        k++;
   }
   chaine_dest->N--;
}

/**
 * \brief d�truire, elle ne pourra plus �tre utilis�e (sauf � �tre de nouveau initialis�e)
 * \param[in] chaine_src chaine � d�truire
*/
void destroy(string *chaine){
    free(chaine->str);
    chaine->str = NULL;
}

void test_create(){
    string ch, ch1, ch2;
    create(&ch, "UN");
    assert(ch.N == 3);
    assert(ch.str[0] == 'U');
    create(&ch1, "DEUX");
    assert(ch1.N == 5);
    assert(ch1.str[4] == '\0');
    create(&ch2, "");
    assert(ch2.N == 1);
    assert(ch2.str[0] == '\0');

    destroy(&ch);
    destroy(&ch1);
    destroy(&ch2);
}

void test_length(){
    string ch, ch1;
    create(&ch, "UN");
    assert(strlen("UN")==length(ch));
    create(&ch1, "");
    assert(length(ch1)==strlen(""));
    destroy(&ch);
    destroy(&ch1);
}

void test_add(){
    string ch1;
    create(&ch1, "TROI");
    add(&ch1, 'S');
    assert(length(ch1) == 5);
    assert(ch1.str[4] == 'S');
    add(&ch1, '+');
    assert(length(ch1) == 6);
    assert(ch1.str[5] == '+');
    destroy(&ch1);
}


void test_delete(){
    string ch1;
    create(&ch1, "TROIS");
    delete(&ch1, 0); //ROIS
    assert(length(ch1) == 4);
    assert(ch1.str[0] == 'R');
    delete(&ch1, 2); //ROS
    assert(length(ch1) == 3);
    assert(ch1.str[2] == 'S');
    delete(&ch1, 2); //RO
    assert(length(ch1) == 2);
    assert(ch1.str[1] == 'O');
    delete(&ch1, 0); //O
    delete(&ch1, 0); //_
    assert(length(ch1) == 0);

    destroy(&ch1);
}


void test_destroy(){
    string ch, ch1;
    create(&ch, "UN");
    destroy(&ch);
    assert(ch.str == NULL);

    create(&ch1, "TROI");
    add(&ch1, 'S');
    destroy(&ch1);
    assert(ch1.str == NULL);
}

int main(){

    test_create();
    test_length();
    test_add();
    test_delete();
    test_destroy();

    printf("%s", "\n Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
