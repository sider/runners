class Color
{
    public:
        int r;
        int g;
        int b;
};

double calc(double x0, double x1, double y0, double y1)
{
    double dx, dy, dz;
    double mul1, mul2, mul3;

    dx = x1 - x0;
    dy = y1 - y0;
    mul1 = dz;

    mul1 = 1 / (dx * dx + dy * dy);
    mul2 = 1 / dz;
    mul3 = 1 / mul2;

    return mul1;
}
