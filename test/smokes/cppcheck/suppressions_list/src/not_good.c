int a[2];

void foo(int *q)
{
    a[2] = *q + 1;
}

int main() {
    int *b = 0;
    foo(b);
}
