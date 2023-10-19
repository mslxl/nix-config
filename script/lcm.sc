#!/usr/bin/env amm

import $file.gcd

def lcm(a: Int, b: Int): Int = (a * b) / gcd.gcd(a, b)

@main
def lcms(num: Int*) = num.reduce(lcm)