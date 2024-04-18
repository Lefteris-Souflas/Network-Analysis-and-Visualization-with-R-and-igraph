# Problem 1: Create ASOIAF Network Graph ######################################

# install.packages("igraph")
library(igraph)
library (readr)

# load comma separated file with the list of edges of the `
# 'A Song of Ice and Fire' network found here: 
# https://github.com/mathbeveridge/asoiaf/blob/master/data/asoiaf-all-edges.csv
urlfile <- paste("https://raw.githubusercontent.com/mathbeveridge/", 
                 "asoiaf/master/data/asoiaf-all-edges.csv", sep = "")
asoiaf <- read_csv(url(urlfile), show_col_types = FALSE)
# alternatively download file locally, un-comment and run the following line
# asoiaf <- read_csv(choose.files(), show_col_types = FALSE)

# use columns source, target, weight
asoiaf.edges <- asoiaf[,c(1,2,5)]

# create an un-directed weighted igraph graph
graph <- graph_from_data_frame(asoiaf.edges, directed = FALSE, vertices = NULL)


# Problem 2: Network Properties ###############################################

# number of vertices
message <- paste("The number of vertices in the network is", vcount(graph))
print(message)

# number of edges
message <- paste("The number of edges in the network is", ecount(graph))
print(message)

# diameter
message <- paste("The diameter of the network is", diameter(graph))
print(message)

# number of triangles
message <- paste("The number of triangles in the network is", 
                 sum(count_triangles(graph))/3)
print(message)

# number of edges having weight more than 15
message <- paste("The number of edges having weight more than 15 is", 
                 sum(edge_attr(graph, 'weight') > 15))
print(message)

# top-10 characters of the network as far as their degree is concerned
message <- paste("The top 10 characters of the network as far as their degree",
                 "in descending order is concerned are:", 
                 paste(names(sort(degree(graph), decreasing = TRUE)[1:10]), 
                       collapse=", "))
print(message)

# top-10 characters of the network as far as their weighted degree is concerned
message <- paste("The top 10 characters of the network as far as their",
                 "weighted degree in descending order is concerned are:", 
             paste(names(sort(graph.strength(graph), decreasing = TRUE)[1:10]),
                   collapse=", "))
print(message)
# if edge attribute is not named 'weight' then use the following equivalent
# names(sort(graph.strength(graph, weights = edge_attr(graph, 'weight')), 
#            decreasing = TRUE)[1:10])

# top-10 characters of the network regarding local clustering coefficient
index <- transitivity(graph, type = 'local')==1
index[is.na(index)] <- FALSE
message <- paste("There exist", sum(index), "characters in the network that",
                 "have local clustering coefficient equal to 1:")
cat(message); cat("\n"); print(as.vector(names(V(graph)))[index])
message <- paste("The top 10 of them in ascending alphabetic order are:", 
                 paste(as.vector(names(V(graph)))[index][1:10], collapse=", "))
print(message)

# global clustering coefficient of the graph
message <- paste("The global clustering coefficient of the graph is", 
                 transitivity(graph, type = 'global'))
print(message)


# Problem 3: Subgraph #########################################################

# plot the graph
plot(graph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1.5, 
     layout = layout_on_sphere(graph))
# Other nice layouts
# plot(graph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1, 
#      layout = layout_on_grid(graph, width = 0, height = 0, dim = 3))
# plot(graph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1, 
#      layout = layout_with_graphopt(graph))
# plot(graph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1, 
#      layout = layout_with_lgl(graph))

# plot entire graph with vertices' edges having at least 10 connections
subgraph <- subgraph(graph, vids = degree(graph) >= 10)
plot(subgraph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1.5, 
     layout = layout_on_sphere(graph))

# plot sub-graph with vertices having at least 10 connections (zoom-in)
plot(subgraph, vertex.label = NA, edge.arrow.width = 1, vertex.size = 1.5, 
     layout = layout_on_sphere(subgraph))

# Edge density of entire and sub graphs
if(any_loop(graph)){ # are there any edge from a vertex to itself?
  graph_density <- edge_density(graph, loops = TRUE)
  subgraph_density <- edge_density(subgraph, loops = TRUE)
} else{
  graph_density <- edge_density(graph, loops = FALSE)
  subgraph_density <- edge_density(subgraph, loops = FALSE)
}
message <- paste0("The edge density of the entire graph is ", graph_density, 
        ", whereas", " the edge density of the subgraph is ", subgraph_density)
print(message)
message <- paste("The subgraph is", round(subgraph_density/graph_density, 1), 
                 "times denser than the entire graph")
print(message)

# Definition of edge density
# edge_density(subgraph, loops = FALSE) == 
#   ecount(subgraph)/(vcount(subgraph)*(vcount(subgraph)-1)/2)

# number of vertices and edges in the subgraph
message <- paste("The number of vertices in the subgraph are", 
               vcount(subgraph), "and the number of edges", ecount(subgraph))
print(message)
message <- paste("In the whole graph exist", 
             round(vcount(graph)/vcount(subgraph),1), "times the number of", 
             "vertices and", round(ecount(graph)/ecount(subgraph),1),
             "times the number of edges found in the subgraph")
print(message)


# Problem 4: Centrality #######################################################

# top 15 nodes according to closeness centrality
closeness_ranking <- sort(closeness(graph), decreasing = TRUE)
message <- paste("The top 15 characters of the network as far as their",
                 "closeness centrality in descending order is concerned are:", 
                 paste(names(closeness_ranking[1:15]), collapse=", "))
print(message)

# top 15 nodes according to betweenness centrality
betweenness_ranking <- sort(betweenness(graph), decreasing = TRUE)
message <- paste("The top 15 characters of the network as far as their",
               "betweenness centrality in descending order is concerned are:", 
               paste(names(betweenness_ranking[1:15]), collapse=", "))
print(message)

# Jon Snow ranking according to closeness and betweenness centrality
# closeness(graph, vids = 'Jon-Snow') # 0.0001118944
# betweenness(graph, v = 'Jon-Snow') # 41698.94
message <- paste("Jon Snow is ranked in position", 
            which(names(closeness_ranking)=='Jon-Snow'), "of the whole set of",
            "characters regarding closeness centrality and in position",
            which(names(betweenness_ranking)=='Jon-Snow'), "regarding",
            "betweenness centrality")
print(message)

# Jon Snow subgraph
# jon_snow_graph <- subgraph(graph, vids = ego(graph, nodes = 'Jon-Snow')[[1]])
# plot(jon_snow_graph, edge.arrow.width = 1, vertex.size = 1,
#    vertex.label = ifelse(names(V(graph))=='Jon-Snow', 'Jon Snow', NA),
#    layout = layout_with_lgl(graph))


# Problem 5: Ranking and Visualization ########################################

# Ranking of characters based on PageRank value
page_ranking <- sort(page.rank(graph)$vector, decreasing = TRUE)

# Creation of a matrix of coordinates file via tkplot interactive handtuning 
# of the vertices placement in order for the labels to be more easily readable  
# tkplot(graph, 
#   vertex.label = ifelse(page.rank(graph)$vector > 0.01, names(V(graph)), NA), 
#   edge.arrow.width = 1, vertex.size = 200*(page.rank(graph)$vector), 
#   vertex.label.cex = 50*(page.rank(graph)$vector), 
#   layout = layout_on_grid(graph))
# coords <- tk_coords(4)
# write.csv(coords, file="coords.txt", row.names=FALSE)

# Create PageRank plot using the coords.txt file
plot(graph, 
   vertex.label = ifelse(page.rank(graph)$vector > 0.01, names(V(graph)), NA), 
   edge.arrow.width = 1, vertex.size = 200*(page.rank(graph)$vector), 
   vertex.label.cex = 50*(page.rank(graph)$vector), 
   layout = as.matrix(read.csv("coords.txt")))
# Alternatively create plot by uncommenting the following block of code
# plot(graph,
#   vertex.label = ifelse(page.rank(graph)$vector > 0.01, names(V(graph)), NA),
#   edge.arrow.width = 1, vertex.size = 200*(page.rank(graph)$vector),
#   vertex.label.cex = 50*(page.rank(graph)$vector),
#   layout = layout_on_grid(graph))
