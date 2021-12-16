#include <stdio.h>

#define SQUARE(x) (x * x)

int main(void) {
	int x = SQUARE(4 + 1);
	printf("number: %d", x);
	return 0;
}