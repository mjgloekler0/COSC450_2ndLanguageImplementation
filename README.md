# COSC450_2ndLanguageImplementation

**Route and Path Finder in Python and Prolog**

Mike Gloekler and Annie Martz

**Programming Language Used**
- Prolog

**Compiler/interpreter and version**
- SWI-Prolog version 11.0.0 for x64-win64
- Visual Studio Code

**Required libraries or dependencies**
- SWI-Prolog
- library(heaps) – Used to implement priority queues in Dijkstra's and Greedy Best-First Search.
- library(assoc) – Used to store and update the best-known costs in Dijkstra's Algorithm.
- library(readutil) – Used to read user input in the main program.
- library(lists) – Used for list operations such as finding elements, appending lists, and reversing lists. This is included with SWI-Prolog.

**Instructions for compiling and running the program**
1. Make sure SWI-Prolog is installed and functional by entering "swipl --version" in the terminal, which should return the version of Prolog downloaded (in this case, "SWI-Prolog version 11.0.0 for x64-win64").
2. Next, enter "swipl -s main.pl -g main -t halt" into the terminal.
3. Then, you will be prompted to enter the start and ending computer, ranging from a to f.
4. Once the start and end are entered, the program will calculate the path length, nodes explored, time, and cost of each search algorithm.

**Implemented features**
- Breadth-First Search: explores a network by using a queue to find a path from start to finish
- Depth-First Search: explores one path fully before backtracking and exploring other paths (uses a stack)
- Dijkstra's Algorithm: finds lowest-cost route by considering latency costs between computers in the network
- Greedy Best-First Search: uses heuristic estimates to determine which computer to explore next
- For each algorithm, the program outputs route taken, total path length, number of nodes explored, execution time, and latency cost of the route

**Sample Input and Output**

**Sample Input**

  User enters A as the starting computer and F as the destination computer

**Sample Output**

  Computer Network Search Comparison

  Algorithm | Route | Path Length | Nodes Explored | Time (ms) | Cost (ms)

  BFS | A -> B -> D -> F | 3 | 6 | (varies) | 12

  DFS | A -> C -> E -> F | 3 | 4 | (varies) | 12

  Dijkstra | A -> B -> D -> F | 3 | 6 | (varies) | 12

  Greedy | A -> C -> E -> F | 3 | 4 | (varies) | 12

_Execution times vary depending on hardware and runtime conditions_

**Known Limitations or Incomplete Features**
- Network only has six computers
- Network connections, latency costs, and heuristic values are predefined
- Heuristic values used for Greedy Best-First Search are designed around computer F as the destination
- Execution times vary based on hardware and runtime conditions
