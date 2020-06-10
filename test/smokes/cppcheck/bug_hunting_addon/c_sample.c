

double calc(double x0, double x1, double y0, double y1)
{
    double dx, dy, dz;
    double mul1;

    dx = x1 - x0;
    dy = y1 - y0;
    mul1 = dz;

    mul1 = 1 / (dx * dx + dy * dy);

    return mul1;
}
