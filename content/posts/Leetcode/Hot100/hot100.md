---
title: "Hot 100"
description: Leetcode 热题100题目记录 
date: 2024-07-15T17:32:01+08:00
slug: 'leetcode-hot100'
tags: ['Leetcode'] 
categories: ['Leetcode']
image: https://raw.githubusercontent.com/yjwang01/img_bed/main/img/202408221444997.png 
math: false
license: false
# hidden: false
comments: true
draft: false
---

# Back Track

## [子集](https://leetcode.cn/problems/subsets/description/?envType=study-plan-v2&envId=top-100-liked)

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


## [电话号码的字母组合](https://leetcode.cn/problems/letter-combinations-of-a-phone-number/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [括号生成](https://leetcode.cn/problems/generate-parentheses/description/?envType=study-plan-v2&envId=top-100-liked)

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

# Binary Tree

## [将有序数组转换为平衡二叉搜索树](https://leetcode.cn/problems/convert-sorted-array-to-binary-search-tree/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [验证二叉搜索树](https://leetcode.cn/problems/validate-binary-search-tree/description/?envType=study-plan-v2&envId=top-100-liked)

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


## [二叉搜索树中第K小的元素](https://leetcode.cn/problems/kth-smallest-element-in-a-bst/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [二叉树展开为链表](https://leetcode.cn/problems/flatten-binary-tree-to-linked-list/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [二叉树中的最大路径和](https://leetcode.cn/problems/binary-tree-maximum-path-sum/description/?envType=study-plan-v2&envId=top-100-liked)

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
# Graph Theory

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

## [岛屿数量](https://leetcode.cn/problems/number-of-islands/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [腐烂的橘子](https://leetcode.cn/problems/rotting-oranges/description/?envType=study-plan-v2&envId=top-100-liked)

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

## [前缀树](https://leetcode.cn/problems/implement-trie-prefix-tree/description/?envType=study-plan-v2&envId=top-100-liked)


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

## [课程表](https://leetcode.cn/problems/course-schedule/description/?envType=study-plan-v2&envId=top-100-liked)

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


# Heap

## [数据流的中位数](https://leetcode.cn/problems/find-median-from-data-stream/description/?envType=study-plan-v2&envId=top-100-liked)

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

# Dynamic Programming
