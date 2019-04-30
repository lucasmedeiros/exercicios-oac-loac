#include <stdio.h>
#include <stdlib.h>

float letraA() {
    float Y = 0;
    float X = 0.1;

    for(int i = 0; i <= 99; i++) {
        Y += X;
    }
    
    return Y;
}

double letraB() {
    double Y = 0;
    double X = 0.1;
    for(int i = 0; i <= 99; i++) {
        Y += X;
    }
    return Y;
}

int main () {
    // Definir X e Y como variáveis do tipo Float.
    printf("%f\n", letraA());

    // Definir X e Y como variáveis do tipo Double.
    printf("%f\n", letraB());
    
    return 0;
}