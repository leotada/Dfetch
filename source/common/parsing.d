module common.parsing;

@safe:

import std.file : readText;
import std.string : splitLines, startsWith, indexOf, strip;
import std.algorithm : find;
import std.conv : to;
import std.exception : enforce;

string parsePropFile(const string filePath, const string key)
{
    string content = readText(filePath);
    foreach (line; content.splitLines())
    {
        if (line.startsWith(key))
        {
            size_t index = line.indexOf('=');
            enforce(index != -1, "Invalid line in prop file: " ~ line);
            string value = line[index + 1 .. $].strip();
            // Remove quotes if present
            if (value.length >= 2 && value[0] == '"' && value[$-1] == '"')
            {
                return value[1 .. $-1];
            }
            return value;
        }
    }
    enforce(false, "Key not found in prop file: " ~ key);
    assert(0);
}
