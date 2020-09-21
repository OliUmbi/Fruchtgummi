from multiprocessing import Pool
from random import randint
from numpy import matrix

iterations = 1000
combinations = []

for pathLenght in range(6, 31):
    for sweets in range(2, 11):
        combinations.append([pathLenght, sweets])

data = []

def runiterations(path, sweet):
    global data
    win = 0
    avgPlayes = []
    
    for x in range(iterations):
        playes = 0
        position = 0
        castle = [sweet, sweet, sweet, sweet, sweet]
        while True:
            playes = playes + 1
            rd = randint(0, 5)
            if rd == 5:
                position = position + 1
            else:
                castle[rd] = castle[rd] - 1
            if position == path:
                break
            if max(castle) <= 0:
                win = win + 1
                break
        avgPlayes.append(playes)
    
    winRate = 100 / iterations * win
    avg = sum(avgPlayes) / len(avgPlayes)
    data.append([path, sweet, winRate, avg])


#pool = Pool()
#pool.map(runiterations, combinations)

for combination in combinations:
    runiterations(combination[0], combination[1])

data = sorted(data, key=lambda x: x[2], reverse=True)

print(matrix(data))
