class leastCommonSubsequence:
    
    def __init__(self, opt, lenStr1, lenStr2):
        self.opt = opt
        self.lenStr1 = lenStr1
        self.lenStr2 = lenStr2
        
    def findLcsLength(self, string1, string2):
        for pos1 in range(1, self.lenStr1 + 1):
            for pos2 in range(1, self.lenStr2 + 1):
                if string1[pos1 - 1] == string2[pos2 - 1]:
                    self.opt[pos1][pos2] = self.opt[pos1 - 1][pos2 - 1] + 1
                else:
                    self.opt[pos1][pos2] = max(self.opt[pos1 - 1][pos2], self.opt[pos1][pos2 - 1])
        
    def findLcsSequence(self, string1, string2):
        lcsSequence = ""
        itr1, itr2 = self.lenStr1, self.lenStr2
        while itr1 > 0 and itr2 > 0:
            if(string1[itr1 - 1] == string2[itr2 - 1]):
                lcsSequence += string1[itr1 - 1]
                itr1, itr2 = itr1 - 1, itr2 - 1
            elif opt[itr1 - 1][itr2] > opt[itr1][itr2 - 1]:
                itr1 = itr1 - 1
            else:
                itr2 = itr2 - 1
        
        return lcsSequence
    
    def returnSequence(self, lcsSequence):
        sequence = ""
        length = len(lcsSequence) - 1
        while length >= 0:
            sequence += lcsSequence[length]
            length -= 1
        return sequence
                
if __name__ == '__main__':
    string1 = input()
    string2 = input()
    opt = [[0 for i in range(len(string2)+1)] for j in range(len(string1)+1)]
    LCS = leastCommonSubsequence(opt, len(string1), len(string2))
    LCS.findLcsLength(string1, string2)
    lcsSequence = LCS.findLcsSequence(string1, string2)
    sequence = LCS.returnSequence(lcsSequence) 
    print(len(sequence))
    print(sequence)