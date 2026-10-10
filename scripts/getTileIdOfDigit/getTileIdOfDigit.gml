function getTileIdOfDigit(digit){
    digit = int64(digit) mod 10;
    return 32 + digit;
}