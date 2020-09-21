from multiprocessing import Pool, freeze_support
from random import randint
from numpy import matrix

def createcombinations():
    combinations = []
    for pathLenght in range(6, 31):
        for sweets in range(2, 11):
            combinations.append((pathLenght, sweets))
    return combinations

def runiterations(path, sweet):
    iterations = 10000
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
    return [path, sweet, winRate, avg]


def main():
    combinations = createcombinations()
    data = []
    with Pool() as pool:
        data.append(pool.starmap(runiterations, combinations))
    data = data[0]
    data = sorted(data, key=lambda x: x[2], reverse=True)
    print(matrix(data))


if __name__=="__main__":
    freeze_support()
    main()
