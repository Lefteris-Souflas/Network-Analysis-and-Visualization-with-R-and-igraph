# Network Analysis & Visualization with R & igraph
Assignment 1 for the Social Network Analysis Course of AUEB's MSc in Business Analytics.

## General Instructions
Your answers should be as concise as possible.  
**Submitting answers:** Prepare a report with your answers on this project in a single PDF file named `p1.pdf`.  
**Submitting code:** Prepare an `.R` file with your code.

## Problem
1. **'A Song of Ice and Fire' Network**  
   Your first task is to create an igraph graph using the network of the characters of 'A Song of Ice and Fire' by George R. R. Martin. A `.csv` file with the list of edges of the network is available online. You should download the file and use columns Source, Target, and Weight to create an undirected weighted graph.

2. **Network Properties**  
   Explore the basic properties of the created igraph graph and print:
   - The number of vertices of the graph
   - The number of edges of the graph
   - The diameter of the graph
   - The number of triangles in the graph
   - The number of edges having weight more than 15
   - The top-10 characters of the network as far as their degree is concerned
   - The top-10 characters of the network as far as their weighted degree is concerned
   - The top-10 characters of the network as far as their local clustering coefficient is concerned
   - The global clustering coefficient of the graph

3. **Subgraph**  
   Plot the entire network and create a subgraph by discarding all vertices that have less than 10 connections in the network. Also, calculate the edge density of the entire graph and the subgraph and provide an explanation of the obtained results.

4. **Centrality**  
   Calculate and print the top-15 nodes according to:
   - closeness centrality
   - betweenness centrality
   Find out where the character Jon Snow is ranked according to the above two measures and provide an explanation of the observations.

5. **Ranking and Visualization**  
   Rank the characters of the network with regard to their PageRank value. Calculate the PageRank values and create a plot of the graph that uses these values to set the nodes' size appropriately.

## References
[A. Beveridge and J. Shan. Network of thrones. Math Horizons Magazine, 23(4):18-22, 2016](https://mathbeveridge.github.io/publication/2016-network-of-thrones)
