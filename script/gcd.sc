#!/usr/bin/env amm
def gcd(a: Int, b: Int): Int = if (a % b == 0) b else gcd(b, a % b)

@main
def gcds(num: Int*) = num.reduce(gcd)
