#include <stdio.h>



int a[3] = {7,12,14};


int main(int argc, const char * argv[]) {
    return 0;
}

int q2(int arg0, int arg1, int arg2) {
    int val;
    switch(arg0) {
        case 10:
            val = arg1 + arg2;
            break;
        case 12:
            val = arg1 - arg2;
        case 14:
            if (arg2 > arg1) val = 1;
            else val = 0;
            break;
        case 16:
            if (arg2 > arg1) val = 1;
            else val = 0;
            break;
        case 18:
            if (arg1 > arg2) val = 1;
            else val = 0;
            break;
        default:
            val = 0;
            break;
        
    }
    return val;
}
