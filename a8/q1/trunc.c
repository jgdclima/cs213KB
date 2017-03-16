#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "list.h"

void returnInt(element_t* dest, element_t arg) {
    element_t a = (element_t) strtol(arg, NULL, 0);
    if (!a) {
        *dest = (element_t) -1;
        return;
    }
    *dest = a;
}

void returnString(element_t* dest, element_t arg1, element_t arg2) {
    if ((intptr_t) arg1 == -1) {
        *dest = arg2;
        return;
    }
    *dest = NULL;
    free(arg2);
}

void getMax (element_t* rv, element_t av, element_t bv) {
    intptr_t* a = av;
    intptr_t b = (intptr_t) bv;
    if (*rv == NULL)
        *rv = malloc (sizeof (intptr_t));
    intptr_t* r = *rv;
    if (*a>b) *r = *a;
    else *r = b;
}

void freeIfNotNumber(element_t e) {
    if (strtol(e, NULL,0)) return;
    free(e);
}

void truncateStrings(element_t* dest, element_t num, element_t string) {
    char* str = (char*) string;
    intptr_t n = (intptr_t) num;
    if (strlen(str) <= n) {
       *dest = string;
        return;
    }
    int i = 0;
    char* j;
    j = malloc(sizeof(char)*n+1);
    while (i < n) {
        j[i] = str[i];
        i++;
    }
    j[i] = 0;
    free(str);
    *dest = (element_t)j;
}

void printNumber(element_t e) {
    intptr_t a = (intptr_t) e;
    printf("%ld\n", a);
}

int isPositive(element_t e) {
    if ((intptr_t)e > 0) return 1;
    else return 0;
}

void printString(element_t e) {
    if (!e) printf("null\n");
    else {
        printf("%s\n", e);
    }
}

int isNotNull(element_t e) {
    if (e) return 1;
    else return 0;
}

int main(int argc, char *argv[]) {
    // Create a list and an array
    struct list* myList = list_create();
    element_t* arr;
    arr = malloc((argc-1)*sizeof(element_t));
    
    // Copy the command line arguments to the array and make a list
    int i;
    // balloon 3 make 2 a 3 seventeen 4
    for (i = 1; i < argc; i++) {
        char * j;
        j = malloc(sizeof(char) * (strlen(argv[i])+1));
        arr[i-1] = (element_t) strcpy(j, argv[i]);
    }
    list_append_array(myList, arr, argc - 1);
    
    // Make number list
    struct list* numberList = list_create();
    list_map1(returnInt, numberList, myList);   // Frees char* and replaces with int
    
    // Make string list
    struct list* stringList = list_create();
    list_map2(returnString, stringList, numberList, myList);
    
    struct list* filteredNumberList = list_create();
    struct list* filteredStringList = list_create();
    
    list_filter(isPositive, filteredNumberList, numberList);
    list_filter(isNotNull, filteredStringList, stringList);
    
    struct list* truncatedStrings = list_create();
    
    list_map2(truncateStrings, truncatedStrings, filteredNumberList, filteredStringList);
    list_foreach(printString, truncatedStrings);
    
    int* sp = malloc (sizeof (int*));
    *sp = 0;
    list_foldl (getMax, (element_t*) &sp, filteredNumberList);
    printf ("%d\n", *sp);
    
    
    free(sp);
    free(arr);
    list_foreach(free, truncatedStrings);
    list_destroy(myList);
    list_destroy(numberList);
    list_destroy(stringList);
    list_destroy(filteredNumberList);
    list_destroy(filteredStringList);
    list_destroy(truncatedStrings);
    
}
