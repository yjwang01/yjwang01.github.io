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

