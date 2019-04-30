#include <stdio.h>
#include <stdlib.h>

signed char letraA() {
    signed char X = 127;
    signed char Y = X + 1;

    return Y;
}

signed char letraB() {
    signed char X = -127;
    signed char Y = X - 2;

    return Y;
}

int main () {
    // Y = X + 1 (para X = 127)
    printf("%d\n", letraA());

    // Y = X - 2 (para X = - 127).
    printf("%d\n", letraB());

    return 0;
}