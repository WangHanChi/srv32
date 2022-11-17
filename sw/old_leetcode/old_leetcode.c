// DFS
#include <stdio.h>
#include <stdlib.h>

struct TreeNode
{
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

int dfs(struct TreeNode *root, int *level)
{
    if (root == NULL)
    {
        // return if there is no node
        *level = -1;
        return -1;
    }
    if (root->left == NULL && root->right == NULL)
    {
        // this is the bottom
        *level = 0;
        return root->val;
    }
    int al, bl;
    // compare the level, al bl store the level ,a b store the val
    int a = dfs(root->left, &al);
    int b = dfs(root->right, &bl);

    if (al >= bl)
    {
        *level = al + 1;
        return a;
    }
    else
    {
        *level = bl + 1;
        return b;
    }
}

int findBottomLeftValue(struct TreeNode *root)
{
    int level;
    return dfs(root, &level);
}

int main(int argc, char *argv[])
{
    // set TreeNode
    struct TreeNode *test1 = malloc(sizeof(struct TreeNode));
    test1->val = 2;
    test1->left = malloc(sizeof(struct TreeNode));
    test1->left->val = 10;
    test1->left->left = NULL;
    test1->left->right = NULL;
    test1->right = malloc(sizeof(struct TreeNode));
    test1->right->val = 3;
    test1->right->left = NULL;
    test1->right->right = NULL;

    int result1 = findBottomLeftValue((test1));
    printf("The result of test1 is %d\n", result1);
    return 0;
}
