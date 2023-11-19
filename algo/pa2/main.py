import sys


class Graph:

	def __init__(self, n_v):
		self.n = n_v
		self.graph = [[0 for column in range(n_v)] for row in range(n_v)]

	def print_mst(self, parent):
		total_weight = 0
		for index in range(1, self.n):
			total_weight += self.graph[index][parent[index]]
		print(total_weight)

	def min_key(self, min_w_e, mst_set):
		min_w = sys.maxsize
		min_w_index = 0
		for index in range(self.n):
			if mst_set[index] is False and min_w_e[index] < min_w:
				min_w_index = index
				min_w = min_w_e[index]
		return min_w_index

	def prims_mst(self):
		int_max = sys.maxsize
		num_v = self.n
		min_w_e = [int_max] * num_v
		min_w_e[0] = 0
		base_mst = [0] * num_v
		base_mst[0] = -1
		mst_set = [False] * num_v
		for index in range(num_v):
			min_dist_v = self.min_key(min_w_e, mst_set)
			mst_set[min_dist_v] = True
			for index_v in range(num_v):
				if mst_set[index_v] is False and 0 < self.graph[min_dist_v][index_v] < min_w_e[index_v]:
					min_w_e[index_v] = self.graph[min_dist_v][index_v]
					base_mst[index_v] = min_dist_v
		self.print_mst(base_mst)


if __name__ == '__main__':
	n, m = list(map(int, input().split()))
	g = Graph(n)
	for i in range(m):
		u, v, w = list(map(int, input().split()))
		g.graph[u-1][v-1] = w
		g.graph[v-1][u-1] = w
	g.prims_mst()
