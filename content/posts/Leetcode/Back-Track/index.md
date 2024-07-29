---
title: "Back Track"
description: Leetcode 回溯相关题目记录
date: 2024-07-15T17:32:01+08:00
slug: 'leetcode-back-track'
tags: ['Leetcode', 'BackTrack']
categories: ['Leetcode']
image: "https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407161228350.png"
math: false
license: false
# hidden: false
comments: true
draft: false
---

## 子集[![](/icons/link.svg)](https://leetcode.cn/problems/subsets/description/?envType=study-plan-v2&envId=top-100-liked)

- 使用递归枚举子集

构造子集相当于原序列中的元素是否被选择加入这个子集，即成为一个深度为n的二叉树，
每一个二叉树的叶子节点就是一个子集。

```cpp
class Solution {
public:
    vector<vector<int>> ans;
    vector<int> temp;

    void backtrack(vector<int>& nums, int cnt)
    {
        if (cnt == nums.size())
        {
            ans.push_back(temp);
            return;
        }
        // 不选择该元素
        backtrack(nums, cnt + 1);
        // 选择该元素
        temp.push_back(nums[cnt]);
        backtrack(nums, cnt + 1);
        temp.pop_back();
    }

    vector<vector<int>> subsets(vector<int>& nums) {
        backtrack(nums, 0);
        return ans;
    }
};
```

> **时间复杂度**：$O(n\times 2^n)$，一共有$2^n$中状态，每个状态需要$O(n)$来构造子集
>
> **空间复杂度**：递归栈空间代价为$O(n)$


---------------------


## 电话号码的字母组合[![](/icons/link.svg)](https://leetcode.cn/problems/letter-combinations-of-a-phone-number/description/?envType=study-plan-v2&envId=top-100-liked)

- 递归回溯

相比于[子集](https://leetcode.cn/problems/subsets/description/?envType=study-plan-v2&envId=top-100-liked)，
本题相当于将二叉树搜索扩展成了`N`叉树搜索，`N`为每一个数字对应的字母个数。

```cpp
class Solution
{
public:
    vector<string> key_map = {
        {},      // 0
        {},      // 1
        {"abc"}, // 2
        {"def"},
        {"ghi"},
        {"jkl"},
        {"mno"},
        {"pqrs"},
        {"tuv"},
        {"wxyz"}};

    vector<string> ans;
    string temp;

    void dfs(string digits, int cnt)
    {
        if (cnt == digits.length())
        {
            ans.push_back(temp);
            return;
        }

        for (int i = 0; i < key_map[digits[cnt] - '0'].size(); i++)
        {
            temp.push_back(key_map[digits[cnt] - '0'][i]); // 添加字符
            dfs(digits, cnt + 1);
            temp.pop_back(); // 回溯
        }
    }

    vector<string> letterCombinations(string digits)
    {
        if (digits.length() == 0)
            return ans;
        dfs(digits, 0);
        return ans;
    }
};
```

> **时间复杂度**：不考虑不同数字对应的字母数，假设都为3，则状态空间为$3^n$，时间复杂度为$O(3^n)$
> 
> **空间复杂度**：递归调用栈$O(n)$

---------

## 括号生成[![](/icons/link.svg)](https://leetcode.cn/problems/generate-parentheses/description/?envType=study-plan-v2&envId=top-100-liked)

最直接的想法是枚举所有具有`2n`长度的括号字符串，即遍历一个深度为`2n`的二叉树，
对每一个二叉树节点检验该括号字符串是否符合要求。

可以对上述方法进行剪枝，即在遍历二叉树的过程中就判断是否符合要求，
若不符合要求即不再遍历该子树。

使用一个变量`check_sum`记录当前字符串的情况，
当字符串添加`(`则将`check_sum++`，当添加`)`则将`check_sum--；
当字符串总数为`2n`，且`check_sum == 0`时，为一个符合要求的括号字符串。

添加`(`时需要左括号数不超过`n`，并且剩余可添加的括号数（全部都是`)`的情况下）可使`check_sum == 0`，即`check_sum <= n && 2 * n - cnt > check_sum`；
添加`)`时需要字符串中有多余的`(`，即`check_sum > 0`

```cpp
class Solution
{
public:
    vector<string> ans;
    string temp;
    void BackTrack(int cnt, int n, int check_sum)
    {
        if (cnt == 2 * n && check_sum == 0)
        {
            ans.push_back(temp);
            return;
        }
        if (check_sum <= n && 2 * n - cnt > check_sum)
        {
            temp.push_back('(');
            BackTrack(cnt + 1, n, check_sum + 1);
            temp.pop_back();
        }
        if (check_sum > 0)
        {
            temp.push_back(')');
            BackTrack(cnt + 1, n, check_sum - 1);
            temp.pop_back();
        }
    }

    vector<string> generateParenthesis(int n)
    {
        BackTrack(0, n, 0);
        return ans;
    }
};
```

> **时间复杂度**：< $O(2^{2n})$，具体多少见[题解方法二](https://leetcode.cn/problems/generate-parentheses/solutions/192912/gua-hao-sheng-cheng-by-leetcode-solution/?envType=study-plan-v2&envId=top-100-liked)
> 
> **空间复杂度**：递归调用栈$O(2n)$
