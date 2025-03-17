#include <stdio.h>

void function_with_callback(const char *key, unsigned long val, void (*callback)(const char *, unsigned long));

void callback(const char *key, unsigned long val)
{
    printf("Call in C: Key=%s, Val=%d\n", key, val);
}

int main()
{
    function_with_callback("123", 456, callback);
}
