---
title: "Binary Tree"
description: Leetcode关于二叉树相关题目记录
date: 2024-07-14T12:15:35+08:00
slug: 'leetcode_binary_tree'
tags: ['Leetcode', 'Binary Tree']
categories: ['Leetcode']
image: https://assets.leetcode.com/uploads/2021/03/14/invert1-tree.jpg
math: false
license: false
# hidden: false
comments: true
draft: false
---

## 将有序数组转换为平衡二叉搜索树[![Link](/icons/link.svg)](https://leetcode.cn/problems/convert-sorted-array-to-binary-search-tree/description/?envType=study-plan-v2&envId=top-100-liked)

- **二叉搜索树**：左子树的值都比头节点小，右子树的值都比头节点大
- **平衡**：所有节点的左右子树的深度相差不超过1

有序数组已按照升序排列，易得二叉树的头节点为数组的中间值，
而数据的左侧为左子树的集合，右侧成为右子树；
左右子树又转化为新的二叉搜索树的子问题，
因而易想到采用分治、递归的方式实现。
每一个节点的顺序即为二分搜索遍历结果，而二分搜索也保证了每一步的左右子树的深度相差不会超过1

```cpp
class Solution {
public:
    TreeNode *binary_search(vector<int> &nums, int l, int r)
    {
        if (l > r) return nullptr;
        else
        {
            int mid = (l + r) / 2;
            TreeNode *left = binary_search(nums, l, mid - 1);
            TreeNode *right = binary_search(nums, mid + 1, r);
            TreeNode *head = new TreeNode(nums[mid], left, right);

            return head;
        }
    }

    TreeNode *sortedArrayToBST(vector<int> &nums)
    {
        return binary_search(nums, 0, nums.size() - 1);
    }
};
```

## 验证二叉搜索树 [![Link](/icons/link.svg)](https://leetcode.cn/problems/validate-binary-search-tree/description/?envType=study-plan-v2&envId=top-100-liked)

根据二叉搜索树的性质，可采用中序遍历二叉树的方式，每一次遍历得到的值比上一次大，
即可判定该二叉树为一个二叉搜索树。

```cpp
class Solution {
public:
    long long val = (long long)INT_MIN - 1;
    bool isValidBST(TreeNode* root) {
        bool flag = true;
        if (root == nullptr)
        {
            return true;
        }
        /******** 中序遍历 ******/
        if (root->left != nullptr)
        {
            flag = flag && isValidBST(root->left);
        }

        if (root->val > val)
        {
            val = root->val;
        }
        else
        {
            return false;
        }

        if (root->right != nullptr)
        {
            flag = flag && isValidBST(root->right);
        }
        /***********************/
        return flag;
    }
};
```
- 节点的取值可能等于`INT_MIN`，因此需要将`val`定义为`long long`，并取值为`INT_MIN -1`
- Leetcode中不同的测试用例将共享静态变量，
因此如果上述代码中将`long long val`定义为`static`变量，则会出错


----


## 二叉搜索树中第K小的元素[![](/icons/link.svg)](https://leetcode.cn/problems/kth-smallest-element-in-a-bst/description/?envType=study-plan-v2&envId=top-100-liked)

- 中序遍历

根据二叉搜索树的性质，中序遍历的结果将会是一个有=由小到大的排列。
当采用递归法进行中序遍历时，可通过返回值的特性进行剪枝，不至于遍历整颗树。

```cpp
class Solution
{
public:
    int cnt = 0;
    int dfs(TreeNode *head, int k)
    {
        if (head->left != nullptr)
        {
            int temp = dfs(head->left, k);
            if (temp != -1) return temp;
        }

        cnt++;
        if (cnt == k) return head->val;   // val >= 0

        if (head->right != nullptr)
        {
            int temp = dfs(head->right, k);
            if (temp != -1) return temp;
        }

        return -1;
    }

    int kthSmallest(TreeNode *root, int k)
    {
        return dfs(root, k);
    }
};
```

> **时间复杂度**：$O(H+k)$，需要$O(H)$到达叶子节点，再需要$O(k)$搜索第k个节点
>
> **空间复杂度**：$O(H)$，递归栈空间为树的高度

- 在题解中采用了迭代法的方式来模拟递归调用的过程，可参考学习，更适合递归中途需要返回的方式

```cpp
class Solution {
public:
    int kthSmallest(TreeNode* root, int k) {
        stack<TreeNode *> stack;
        while (root != nullptr || stack.size() > 0) {
            while (root != nullptr) {
                stack.push(root);
                root = root->left;
            }
            root = stack.top();
            stack.pop();
            --k;
            if (k == 0) {
                break;
            }
            root = root->right;
        }
        return root->val;
    }
};
```

------ 

## 二叉树展开为链表[![Link](/icons/link.svg)](https://leetcode.cn/problems/flatten-binary-tree-to-linked-list/description/?envType=study-plan-v2&envId=top-100-liked)

对于本题，最直接的想法就是通过前序遍历的方式转换为链表。
但是在遍历的过程中将节点展开成链表会破坏二叉树的结构。

使用递归的方式，问题可分解为展开左子树，展开右子树，
将展开后的右子树连接到展开的左子树后面。

在展开左子树的时候，记录每次展开后该链表的最后一个非空节点`temp`，
再将右子树的节点连接到`temp`。

```cpp
class Solution {
public:
    // 返回值为链表的末尾非空节点
    TreeNode* PreOrder(TreeNode* head)
    {
        TreeNode *r = head->right;
        TreeNode *l = head->left;
        TreeNode *temp = head;  // 指向最后一个非空节点
        temp->left = nullptr;

        if (l != nullptr)
        {
            temp->right = l;
            temp = PreOrder(l);
        }
        if (r != nullptr)
        {
            temp->right = r;
            temp = PreOrder(r);
        }
        return temp;
    }

    void flatten(TreeNode* root) {
        if (root == nullptr)     return;
        PreOrder(root);
    }
};
```

## 二叉树中的最大路径和[![Link](/icons/link.svg)](https://leetcode.cn/problems/binary-tree-maximum-path-sum/description/?envType=study-plan-v2&envId=top-100-liked)

本题中，对于一个头节点`head`，其相关路径有如下几种：

1. `head`
2. `head` + 左子树最大值路径
3. `head` + 右子树最大值路径
4. `head` + 左子树最大值路径 + 右子树最大值路径

其中左右子树最大值路径都应当是单链的。

显然，将问题分解为求解左右子树最大值，
然后计算上述4种情况的最大值，即可得到通过`head`路径的最大值，
返回以`head`作为子树时的最大值，即上述前3种情况的最大值。

```cpp
class Solution {
public:
    int max_sum;
    int dfs_sum(TreeNode *head)
    {
        // 当节点为空时，返回0，不影响其他节点的求和
        if (head == nullptr)    return 0;

        int l = dfs_sum(head->left);
        int r = dfs_sum(head->right);

        // head作为最顶端节点的所有路径最大和
        // 左子树+head，右子树+head，左子树+右子树+head，head
        max_sum = max({max_sum, l + head->val, 
            r + head->val, head->val, l + r + head->val});
        
        // head作为顶端节点的的单侧最大路径和
        return max({l, r, 0}) + head->val; 
    }

    int maxPathSum(TreeNode* root) {
        max_sum = root->val;
        dfs_sum(root);
        return max_sum;
    }
};
```
