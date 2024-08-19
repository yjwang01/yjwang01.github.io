---
title: "Heap"
description: Leetcode 堆相关题目记录
date: 2024-07-29T11:48:01+08:00
slug: 'leetcode-heap'
tags: ['Leetcode', 'Heap']
categories: ['Leetcode']
image: "img/default_image.jpg"
math: false
license: false
# hidden: false
comments: true
draft: false
---

## 数据流的中位数[![](/icons/link.svg)](https://leetcode.cn/problems/find-median-from-data-stream/description/?envType=study-plan-v2&envId=top-100-liked)

- 优先队列-大小堆

可采用两个优先队列分别记录大于和小于中位数的数据，
大根堆记录小于中位数的数据，小根堆记录大于中位数的数据，
这样在两个队列的队首即为中位数附近的两个数，
考虑优先队列中数据的奇偶性来计算中位数。

该方法适合数据流式数据输入，
每一步都已知上一步时的中位数，
因而容易将输入数据分解成两个部分的数据。

在输入数据的同时，需要维护两个队列大小的平衡性。

```cpp
class MedianFinder
{
public:
    priority_queue<int, vector<int>, less<int>> queMin;
    priority_queue<int, vector<int>, greater<int>> queMax;

    MedianFinder()
    {
    }

    void addNum(int num)
    {
        if (queMin.empty() || num <= queMin.top())
        {
            queMin.push(num);

            if (queMin.size() > queMax.size() + 1)
            {
                queMax.push(queMin.top());
                queMin.pop();
            }
        }
        else
        {
            queMax.push(num);

            if (queMax.size() > queMin.size())
            {
                queMin.push(queMax.top());
                queMax.pop();
            }
        }
    }

    double findMedian()
    {
        if (queMax.size() == queMin.size())
        {
            return (queMax.top() + queMin.top()) / 2.0;
        }
        else
        {
            return queMin.top();
        }
    }
};
```

> **时间复杂度**：查找中位数 $O(1)$，输入数据 $O(n)$
>
> **空间复杂度** 优先队列开销$O(n)$