int main() {
    for ( i = 0; i < 5; i++ ) {
        printf("Ovo je taman test: %d", i);
    }

    for ( i = 0; i < 123;) {
        return "opa";
    }

    for (; i < 123; i++ ) {
        return "opa";
    }

    for ( i = 0;; i++ ) {
        return "opa";
    }

    for (;;) {
        return "opa";
    }

    for ( i = 0; i < 123; i++ )
        return "opa";

    for ( i = 0; i < 123;)
        return "opa";

    for (; i < 123; i++ )
        return "opa";

    for ( i = 0;; i++ )
        return "opa";

    for (;;) 
        return "opa";

    return 0;
}
