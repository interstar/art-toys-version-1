
//Geometry
boolean approx(float a, float b, float marg) {
    return ((a > b-marg) && (a < b+marg));
}

boolean close(float x1, float y1, float x2, float y2, float dist) {
    float xdiff = x1-x2;
    float ydiff = y1-y2;
    return (sqrt(xdiff*xdiff+ydiff*ydiff) <= dist);
}


