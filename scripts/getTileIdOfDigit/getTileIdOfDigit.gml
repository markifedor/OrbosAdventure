function getTileIdOfDigit(digit, isTopHalf=false){
    digit = int64(digit) mod 10;
    if isTopHalf{ digit +=  11; }
    return 32 + digit;
}