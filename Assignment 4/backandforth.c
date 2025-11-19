#include <stdio.h>
#include <string.h>
#include <stdlib.h>


// ---- Assembly functions ----
extern int addstr(char *a, char *b);
extern int is_palindromeASM(char *s);
extern int factstr(char *s);
extern void palindrome_check();


// ---- C functions called by assembly ----
int fact(int n) {
   if (n < 0) return 0;
   if (n == 0) return 1;


   int result = 1;
   for (int i = n; i > 1; i--) {
       result *= i;
   }
   return result;
}


int is_palindromeC(char *s) {
   int len = strlen(s);
   int left = 0;
   int right = len - 1;


   while (left < right) {
       if (s[left] != s[right])
           return 0;
       left++;
       right--;
   }


   return 1;
}




int main() {
   int choice;
   char str1[256], str2[256];


   while (1) {
       printf("\nMENU:\n");
       printf("1) Add two strings as integers\n");
       printf("2) Test palindrome (C -> ASM)\n");
       printf("3) Factorial (string -> ASM -> C fact())\n");
       printf("4) Palindrome check (ASM does I/O and calls C)\n");
       printf("5) Quit\n");
       printf("Enter choice: ");
       scanf("%d", &choice);


       // Clear leftover newline
       getchar();


       // Exit
       if (choice == 5) {
           break;
       }


       // Option 1
       // adding 2 ints
       if (choice == 1) {
           printf("Enter first integer as string: ");
           scanf("%255s", str1);


           printf("Enter second integer as string: ");
           scanf("%255s", str2);


           int result = addstr(str1, str2);
           printf("Result: %d\n", result);
       }


       // Option 2
       // checking for palindrome using bytes
       else if (choice == 2) {
           printf("Enter a string: ");
           scanf("%255s", str1);


           int r = is_palindromeASM(str1);
           if (r)
               printf("Palindrome (ASM)\n");
           else
               printf("NOT palindrome (ASM)\n");
       }


       // Option 3
       // factorial
       else if (choice == 3) {
           printf("Enter an integer as string: ");
           scanf("%255s", str1);


           int result = factstr(str1);
           printf("Factorial: %d\n", result);
       }


       // Option 4
       // palindrome check
       else if (choice == 4) {
           palindrome_check();
       }


       else {
           printf("Invalid choice. Try again.\n");
       }
   }


   return 0;
}