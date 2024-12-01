from collections import Counter
import numpy as np

ids1, ids2 = np.loadtxt("inputs/day01.txt", dtype=int).T
print(np.sum(np.abs(np.sort(ids1) - np.sort(ids2))))

ids2_counts = Counter(ids2)
print(sum(id * ids2_counts[id] for id in ids1))
