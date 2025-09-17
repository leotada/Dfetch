module common.color;

import std.conv : to;

enum Color
{
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    brightBlack = 90,
    brightRed = 91,
    brightGreen = 92,
    brightYellow = 93,
    brightBlue = 94,
    brightMagenta = 95,
    brightCyan = 96,
    brightWhite = 97,
}

string colorize(string text, Color color) @safe
{
    return "\033[" ~ to!string(cast(int)color) ~ "m" ~ text ~ "\033[0m";
}
