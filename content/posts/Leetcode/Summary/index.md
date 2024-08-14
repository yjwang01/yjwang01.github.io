---
title: "Leetcode 做题方法汇总"
description: 
date: 2024-08-14T09:21:03+08:00
slug: 'leetcode-summary'
tags: ['Leetcode','Leetcode Summary']
categories: ['Leetcode']
# image: 'image path'
math: false
license: false
# hidden: false
comments: true
draft: false
---

## 双指针法

### [移除元素](https://leetcode.cn/problems/remove-element/description/)

To be added.

### [有序数组的平方](https://leetcode.cn/problems/squares-of-a-sorted-array/description/)

由于是一个有序数组，则同为正数的和同为负数的nums的平方并不需要进行排列；需要考虑的是如何将两者合并起来，则类似与两个数组进行比较合并成一个数组，使用两个指针指向两个数组的一端，再进行比较合并。

在合并的过程中，需要考虑两个数组的单调性是相同的，
对于需要比较平方值的正负数数组来说，负数从小到大，正数从大到小遍历，
两者的平方的单调性相同。

因此将两个指针分别设置在nums的首尾，根据平方值大小进行比较合并。

当然，平方值的大小就对应于绝对值的大小，可使用绝对值比较来降低乘法的计算量；也可以通过正负数相加与 0 比较来判断平方值的大小。

```cpp
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n);
        int left = 0, right = n - 1;
        while (left <= right)
        {
            // 一个为负数，一个为正数，通过相加判断绝对值大小
            // 如果都为正数，则必定right的平方值更大
            // 如果都为负数，则必定left的平方值更大
            if (nums[left] + nums[right] < 0)
            {
                ans[--n] = nums[left] * nums[left];
                left++;
            }
            else
            {
                ans[--n] = nums[right] * nums[right];
                right--;
            }
        }
        return ans;
    }
```

> 时间复杂度：$O(n)$
>
> 空间复杂度：$O(1)$，返回数组不算

## 滑动窗口

滑动串口算是双指针法的一种吧，但是双指针的移动更像一种窗口移动的感觉。

### [长度最小的子数组](https://leetcode.cn/problems/minimum-size-subarray-sum/description/)

因为全部都是正数，
所以窗口扩大肯定会使得求和结果变大，
窗口缩小使得求和结果减小。

<font color='red'>**如果nums中的数不再是正数，该如何解决？**</font>

```cpp
    int minSubArrayLen(int target, vector<int> &nums)
    {
        int l = -1, r = 0; // 左开右闭
        int sum = 0, min_len = INT_MAX;
        while (r < nums.size())
        {
            sum += nums[r];
            while(sum >= target)
            {
                min_len = min(min_len, r - l);
                l++; // 因为左开右闭，所以要先 l++;
                sum -= nums[l];
            }
            r++;
        }

        return min_len == INT_MAX ? 0 : min_len;
    }
```

> 时间复杂度：$O(2n)$
>
> 空间复杂度：$O(1)$