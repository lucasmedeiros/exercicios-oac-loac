#include <stdio.h>
#include <stdlib.h>

float letraA() {
    float y = 0;
    float x = 0.1;

    for(int i = 0; i < 99; i++) {
        y += x;
    }
    
    return y;
}

double letraB() {
    double y = 0;
    double x = 0.1;

    for(int i = 0; i < 99; i++) {
        y += x;
    }

    return y;
}

int main () {
    // Letra A, com valores em Float.
    printf("%f\n", letraA());

    // Letra B, com valores em Double.
    printf("%f\n", letraB());
    
    return 0;
}