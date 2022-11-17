#include <stdio.h>

int numDecodings(char *s)
{
    int res[2] = {1, 0};
    int previous = (*s) - '0';
    if (previous == 0)
    {
        return 0;
    }
    int tmp = 0;
    s++;
    while (*s)
    {
        tmp = res[1];
        if (previous * 10 + (*s) - '0' > 26)
        {
            res[1] = 0;
        }
        else
        {
            res[1] = res[0];
        }
        if (*s - '0')
        {
            res[0] += tmp;
        }
        else
        {
            res[0] = 0;
        }

        previous = *s - '0';
        s++;
    }
    return res[0] + res[1];
}

int main(int argc, char *argv[])
{
    char test0[3] = "12";
    char test1[4] = "226";
    char test2[3] = "06";
    char test3[6] = "11106";

    printf("The result of test0 is %d\n", numDecodings(test0));
    printf("The result of test1 is %d\n", numDecodings(test1));
    printf("The result of test2 is %d\n", numDecodings(test2));
    printf("The result of test3 is %d\n", numDecodings(test3));
    return 0;
}
