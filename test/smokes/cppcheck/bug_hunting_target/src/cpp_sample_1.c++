void bar()
{
    double v;

    int ar[] = {1, 3, 5, 7, 9, 0, 11};
    for(int &x : ar) {
        v = 1 / x;
    }
}

double calc(double x0, double x1, double y0, double y1)
{
    double dx, dy, dz;
    double mul1, mul2;

    dx = x1 - x0;
    dy = y1 - y0;
    mul1 = dz;

    mul1 = 1 / (dx * dx + dy * dy);
    mul2 = 1 / dz;

    return mul1;
}
