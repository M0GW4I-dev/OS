#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from collections import defaultdict
import sys
import re

def main():
    if len(sys.argv) != 2:
        sys.exit()
    f = open(sys.argv[1],'r')
    data = defaultdict(list)
    line = f.readline()
    while line:
        line = f.readline()
        func = getattr(re.match(r'char (?P<hx>.*)', line), 'group', lambda a: None)
        if func('hx'):
            a = func('hx')
            for i in range(16):
                line = f.readline()
                line = line.replace('.', '0')
                line = line.replace('*', '1')
                e = eval('0b'+line)
                data[eval(a)].append(e)
    d = [k for k in data.keys()]
    d.sort()
    print('char hankaku[4096] = {')
    for i in d:
        print(','.join([str(j) for j in data[i]]), end='')
        if i != d[len(d)-1]:
            print(',')
        else:
            print('')
    print('};')





if __name__ == '__main__':
    main()
