---
title: "Graph Theory"
description: Leetcode 关于图论相关题目记录
date: 2024-07-15T09:56:22+08:00
slug: 'leetcode_graph_theory'
tags: ['Leetcode','Graph Theory']
categories: ['Leetcode']
image: 'https://pic1.zhimg.com/v2-861048c05e812564557b0a68b584e5ec_r.jpg'
math: false
license: false
# hidden: false
comments: true
draft: false
---

## 图论理论基础

### 图的表示方式

1. 邻接矩阵 `G[N][N]`
- 有多少节点就申请多大的`二维数组`
- `G[i][j]`表示节点`i`到`j`的连接状态
- 稀疏图情况下造成空间浪费
- 寻找节点连接情况时需要遍历整个矩阵 $O(n^2)$
- 检查两节点间的连接情况很快 $O(1)$
2. 邻接表

<div align=center>
    <img src="https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202407151425898.png" title="邻接表" style="zoom:67%">
</div>

- 数组 + 链表表示，根据边的多少申请内存
- 数组表示了节点个数，每一个数组元素为链表的头节点，链表后续元素与该头节点连接的节点
- 检查两个节点间是否存在边需要 $O(V)$

### 图的遍历方式
- DFS
- BFS


## 岛屿数量[![](/icons/link.svg)](https://leetcode.cn/problems/number-of-islands/description/?envType=study-plan-v2&envId=top-100-liked)

- 深度优先搜索

以某个起始节点`'1'`开始进行深度优先搜索，将搜索过的节点标记为`'0'`，
岛屿的数量就是进行搜索的次数

```cpp
class Solution {
public:
    void dfs(vector<vector<char>>& grid, int r, int c) {
        int nr = grid.size();
        int nc = grid[0].size();

        grid[r][c] = '0';
        if (r - 1 >= 0 && grid[r-1][c] == '1') dfs(grid, r - 1, c);
        if (r + 1 < nr && grid[r+1][c] == '1') dfs(grid, r + 1, c);
        if (c - 1 >= 0 && grid[r][c-1] == '1') dfs(grid, r, c - 1);
        if (c + 1 < nc && grid[r][c+1] == '1') dfs(grid, r, c + 1);
    }

    int numIslands(vector<vector<char>>& grid) {
        int Islands_cnt = 0;
        for (int i = 0; i < grid.size(); i++)
        {
            for (int j = 0; j < grid[i].size(); j++)
            {
                if (grid[i][j] == '1')
                {
                    Islands_cnt++;
                    dfs(grid, i, j);
                }
            }
        }
        return Islands_cnt;
    }
};
```
- 并查集

    先了解一下

## 腐烂的橘子[![](/icons/link.svg)](https://leetcode.cn/problems/rotting-oranges/description/?envType=study-plan-v2&envId=top-100-liked)

- 广度优先搜索

将所有腐烂的橘子放到队列`Rotted_oranges`中，记录队列长度，此队列长度则为这一轮腐烂传递过程中需要处理的腐烂橘子数量，将处理后的橘子`pop()`出队列，腐烂传递的橘子`push`到队列中；
直到队列为空，腐烂传递过程结束。

```cpp
class Solution
{
public:
    queue<pair<int, int>> rotted_oranges;
    int fresh_orange_cnt = 0;
    int bfs_count = 0;

    void bfs(vector<vector<int>> &grid)
    {
        static vector<pair<int, int>> dir = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};

        int cnt = rotted_oranges.size(); // 这一次BFS时队列中的元素个数

        if (cnt == 0)
            return;

        for (int i = 0; i < cnt; i++)
        {
            pair<int, int> orange = rotted_oranges.front();
            rotted_oranges.pop(); // 弹出队列
            int r = orange.first, c = orange.second;

            // 四个方向遍历
            for (int _dir = 0; _dir < 4; _dir++)
            {
                int x = r + dir[_dir].first;
                int y = c + dir[_dir].second;
                if (x < 0 || x >= grid.size() || y < 0 || y >= grid[0].size())
                {
                    continue;
                }
                if (grid[x][y] == 1)
                {
                    grid[x][y] = 2;
                    fresh_orange_cnt--;
                    rotted_oranges.emplace(x, y);
                }
            }
        }

        bfs_count++;

        bfs(grid);
    }

    int orangesRotting(vector<vector<int>> &grid)
    {
        int nr = grid.size();
        int nc = grid[0].size();
        int orange_cnt = 0;

        // 将所有烂橘子添加到列表中
        for (int i = 0; i < nr; i++)
        {
            for (int j = 0; j < nc; j++)
            {
                if (grid[i][j] == 2)
                {
                    rotted_oranges.emplace(i, j);
                }
                if (grid[i][j] == 1)
                {
                    fresh_orange_cnt++;
                }
            }
        }

        if (!fresh_orange_cnt)
            return 0;

        bfs(grid);

        return fresh_orange_cnt ? -1 : bfs_count - 1;
    }
};
```

**注意**：当没有任何一个橘子时，即`fresh_orange_cnt == 0`时，此时返回结果应该是`0`


