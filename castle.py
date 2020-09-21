from random import randint
from numpy import all

combinations = []

for pathLenght in range(2, 11):
    for sweets in range(6, 31):
        combinations.append([pathLenght, sweets])

print(combinations)

won = []


def runiterations(path, sweet):
    global won
    for x in range(100):
        position = 0
        castle = {1: sweet, 2: sweet, 3: sweet, 4: sweet, 5: sweet}
        while True:
            rd = randint(1, 6)
            if rd == 6:
                position = position + 1
            else:
                castle[rd] = castle[rd] - 1
            if position == path:
                won.append("ghost")
                break
            print(castle)
            if all(castle == 0):
                won.append("player")
                break


runiterations(10, 2)

print(won)
