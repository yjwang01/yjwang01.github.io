---
title: "Graph Theory"
description: Leetcode 图论相关题目记录
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

------

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

------

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

------

## 前缀树[![](/icons/link.svg)](https://leetcode.cn/problems/implement-trie-prefix-tree/description/?envType=study-plan-v2&envId=top-100-liked)


**前缀树**是一种树形的数据结构，可以用于自动补全和拼写检查。

在**前缀树**中，每个单词的以字母形式存储在一个节点中，
具有相同前缀的单词在同一个树分支下。

```cpp
class Trie {
private:
    vector<Trie*> children;
    bool isEnd;

    Trie* searchPrefix(string prefix) {
        Trie* node = this;
        for (char ch : prefix) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                return nullptr;
            }
            node = node->children[ch];
        }
        return node;
    }

public:
    Trie() : children(26), isEnd(false) {}

    void insert(string word) {
        Trie* node = this;
        for (char ch : word) {
            ch -= 'a';
            if (node->children[ch] == nullptr) {
                node->children[ch] = new Trie();
            }
            node = node->children[ch];
        }
        node->isEnd = true;
    }

    bool search(string word) {
        Trie* node = this->searchPrefix(word);
        return node != nullptr && node->isEnd;
    }

    bool startsWith(string prefix) {
        return this->searchPrefix(prefix) != nullptr;
    }
};

// 作者：力扣官方题解
// 链接：https://leetcode.cn/problems/implement-trie-prefix-tree/solutions/717239/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/
// 来源：力扣（LeetCode）
// 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

为了避免内存泄漏，还需要添加析构函数：

```cpp
    ~Trie() {
        for (auto &child : this->children) {
            if (child != nullptr) delete child;
        }
    }
```
该析构函数以递归形式删除该节点下的所有子节点。

## 课程表[![](/icons/link.svg)](https://leetcode.cn/problems/course-schedule/description/?envType=study-plan-v2&envId=top-100-liked)

**拓扑排序**: 对于图 $G$ 中的任意一条有向边 $(u,v)$，$u$在排列中都出现在 $v$的前面，可用于判断有向图中是否存在环。

在课程表中，对于课程A的前置课程B，可认为存在一条由B指向A的有向边。

本题可建模成在由课程关系组成的有向图中判断该有向图是否存在环。

可通过寻找拓扑排序来判断是否存在环，如果存在拓扑排序，则表示该课程表可完成修读。

- 深度优先搜索

    我们正在使用DFS搜索该有向图：
    1. 当到达一个节点后，表明当前节点可按照当前深度搜索的路径到达，只要前置节点都符合拓扑排序要求，前置搜索过的节点可标记为【搜索中】；
    2. 当一条深度优先搜索路径到了末端，则表明该节点不会再往深处，造成有环指向该节点的情况，可将该末端节点标记为【已完成】；
    3. 深度优先搜索回溯过程中，表明该节点的后续节点都为【已完成】，因此该回溯节点也可被标记成【已完成】；
    4. 如果在搜索过程中碰到了【未搜索】的节点，则继续DFS；如果碰到了【搜索中】节点，则**表明碰到了环**，因为是从【搜索中】的节点一路DFS回到该节点的，还没有进行回溯；
    5. 每次DFS选择一个未搜索过的节点进行，直到所有节点搜索过，判断是否碰到了环；

```cpp
class Solution {
private:
    vector<vector<int>> edges;
    vector<int> visited;
    bool valid = true;

public:
    void dfs(int u) {
        visited[u] = 1;
        for (int v: edges[u]) {
            if (visited[v] == 0) {
                dfs(v);
                if (!valid) {
                    return;
                }
            }
            else if (visited[v] == 1) {
                valid = false;
                return;
            }
        }
        visited[u] = 2;
    }

    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        edges.resize(numCourses);
        visited.resize(numCourses);
        for (const auto& info: prerequisites) {
            edges[info[1]].push_back(info[0]);
        }
        for (int i = 0; i < numCourses && valid; ++i) {
            if (!visited[i]) {
                dfs(i);
            }
        }
        return valid;
    }
};

// 作者：力扣官方题解
// 链接：https://leetcode.cn/problems/course-schedule/solutions/359392/ke-cheng-biao-by-leetcode-solution/
// 来源：力扣（LeetCode）
// 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```
> **时间复杂度**：$O(n+m)$，其中 $n$ 为课程数，$m$ 为先修课程的要求数。这其实就是对图进行深度优先搜索的时间复杂度。
>
> **空间复杂度**：存储成邻接表的形式，空间复杂度为 $O(n+m)$，最大 $O(n)$的递归栈空间

- 广度优先搜搜

    采用广度优先搜索更像一种模拟选课的方法，更容易理解。

    对于有向图中的节点，每个节点具有入度和出度属性。
    当节点的入度 $indeg == 0$，则表示该节点已无前置节点，即课程的前置要求已经达到。
    将所有入度为 0 的课程先修；
    对于已修课程的邻居节点，可减少其入度，表示有一门前置课程已修。

    直到所有可修的课程都修了之后，判断可修课程数是否等于总课程数。
    若相等，则表明可修课程的顺序为一个拓扑排序；否则，表明有向图中存在环。


